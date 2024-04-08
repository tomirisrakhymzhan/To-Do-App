//
//  HistoryController.swift
//  ToDoApp
//
//  Created by Томирис Рахымжан on 02/04/2024.
//

import UIKit

class ArchiveController: UIViewController {
    
    static let archiveKeyString = "archived-tasks"
    @IBOutlet weak var tableView: UITableView!
    
    var archiveDataSource : [Task] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "TaskTableViewCell", bundle: nil), forCellReuseIdentifier: TaskTableViewCell.identifier)
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(updateArchivedTasks), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateArchivedTasks()
    }
    
    @objc func updateArchivedTasks() {
        tableView.refreshControl?.endRefreshing()
        archiveDataSource = ArchiveController.getAllArchivedTasks()
    }
    
    static func getAllArchivedTasks() -> [Task] {
        let userDefaults = UserDefaults.standard
        if let tasksData = userDefaults.object(forKey: ArchiveController.archiveKeyString),
           let tasks = try? JSONDecoder().decode([Task].self, from: tasksData as! Data) {
            return tasks
        } else {return []}
    }
    
    static func saveArchivedTasks(tasks: [Task]) {
        let userDefaults = UserDefaults.standard
        if let tasksData = try? JSONEncoder().encode(tasks) {
            userDefaults.set(tasksData, forKey: ArchiveController.archiveKeyString)
        }
    }
}

extension ArchiveController : UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return archiveDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier, for: indexPath) as! TaskTableViewCell
        let task = archiveDataSource[indexPath.row]
        cell.name.text = task.name
        cell.priority.text = task.priority.rawValue
        cell.accessoryType = task.isDone ? .checkmark : .none
        return cell
    }

}

extension ArchiveController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            archiveDataSource.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            ArchiveController.saveArchivedTasks(tasks: archiveDataSource)
        }
    }
}
