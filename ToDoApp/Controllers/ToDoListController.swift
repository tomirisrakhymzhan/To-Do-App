import UIKit

class ToDoListController: UIViewController {

    var taskDataSource: [Task.Priority: [Task]] = [:]
    var priorities: [Task.Priority] = [.high, .medium, .low]
    
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
        taskDataSource.removeAll()
        for priority in priorities {
            taskDataSource[priority] = AddTaskController.getTasks(for: priority)
        }
        tableView.reloadData()
    }
    
}

extension ToDoListController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return priorities.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return priorities[section].rawValue
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let priority = priorities[section]
        return taskDataSource[priority]?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier, for: indexPath) as! TaskTableViewCell
        let priority = priorities[indexPath.section]
        if let tasks = taskDataSource[priority] {
            let task = tasks[indexPath.row]
            cell.name.text = task.name
            cell.priority.text = task.priority.rawValue
            cell.accessoryType = task.isDone ? .checkmark : .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let priority = priorities[indexPath.section]
            if var tasks = taskDataSource[priority] {
                tasks.remove(at: indexPath.row)
                taskDataSource[priority] = tasks
                tableView.deleteRows(at: [indexPath], with: .fade)
                AddTaskController.saveTasks(for: priority, tasks: tasks)
            }
        }
    }
}

extension ToDoListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let priority = priorities[indexPath.section]
        if var tasks = taskDataSource[priority] {
            tasks[indexPath.row].isDone.toggle()
            taskDataSource[priority] = tasks
            AddTaskController.saveTasks(for: priority, tasks: tasks)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
}
