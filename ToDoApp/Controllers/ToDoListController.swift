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
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            let priority = priorities[indexPath.section]
//            if var tasks = taskDataSource[priority] {
//                tasks.remove(at: indexPath.row)
//                taskDataSource[priority] = tasks
//                tableView.deleteRows(at: [indexPath], with: .fade)
//                AddTaskController.saveTasks(for: priority, tasks: tasks)
//            }
//        }
//    }
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
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // Swipe to Share button
        let shareAction = UIContextualAction(style: .normal, title: "Share") { [weak self] (_, _, completionHandler) in
        guard let self = self else { return }
        let priority = priorities[indexPath.section]
        let task = self.taskDataSource[priority]?[indexPath.row]
        let activityViewController = UIActivityViewController(activityItems: [task?.name ?? "task name"], applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)
            completionHandler(true)
        }
        
        // Swipe to Archive button
        let archiveAction = UIContextualAction(style: .normal, title: "Archive") { (action, view, completionHandler) in
            let priority = self.priorities[indexPath.section]
            if var tasks = self.taskDataSource[priority], let task = self.taskDataSource[priority]?[indexPath.row]{
                let archivedTasks = ArchiveController.getAllArchivedTasks() + [task]
                ArchiveController.saveArchivedTasks(tasks: archivedTasks)
                tasks.remove(at: indexPath.row)
                self.taskDataSource[priority] = tasks
                tableView.deleteRows(at: [indexPath], with: .fade)
                AddTaskController.saveTasks(for: priority, tasks: tasks)
            }
            completionHandler(true)
        }
            
        // Swipe to Delete button
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            let priority = self.priorities[indexPath.section]
            if var tasks = self.taskDataSource[priority] {
                tasks.remove(at: indexPath.row)
                self.taskDataSource[priority] = tasks
                tableView.deleteRows(at: [indexPath], with: .fade)
                AddTaskController.saveTasks(for: priority, tasks: tasks)
            }
            completionHandler(true)
        }
        
        
        
        
        shareAction.backgroundColor = UIColor(red: 252/256, green: 129/256, blue: 158/256, alpha: 1)


        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, archiveAction, shareAction])
        return configuration
   }
}
