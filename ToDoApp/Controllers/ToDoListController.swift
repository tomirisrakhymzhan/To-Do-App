import UIKit

class ToDoListController: UIViewController {

    var taskDataSource: [Task] = [] 
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "TaskTableViewCell", bundle: nil), forCellReuseIdentifier: TaskTableViewCell.identifier)
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(updateTasks), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateTasks()
    }
    
    @objc func updateTasks() {
        tableView.refreshControl?.endRefreshing()
        taskDataSource = AddTaskController.getAllTasks()
        tableView.reloadData()
    }
    
}

extension ToDoListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskDataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier, for: indexPath) as! TaskTableViewCell
        let task = taskDataSource[indexPath.row]
        cell.name.text = task.name
        cell.priority.text = task.priority.rawValue
        cell.accessoryType = task.isDone ? .checkmark : .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            taskDataSource.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            AddTaskController.saveTasks(tasks: taskDataSource)
        }
    }
}


extension ToDoListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        taskDataSource[indexPath.row].isDone.toggle()
        AddTaskController.saveTasks(tasks: taskDataSource)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

