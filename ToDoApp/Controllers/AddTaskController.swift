//
//  AddTaskController.swift
//  ToDoApp
//
//  Created by Томирис Рахымжан on 02/04/2024.
//

import UIKit

class AddTaskController: UIViewController {

    let priorities = [Task.Priority.low, Task.Priority.medium, Task.Priority.high]
    var priority : Task.Priority?
    static let taskKeyString = "Tasks"
    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var priorityPickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        priorityPickerView.dataSource = self
        priorityPickerView.delegate = self
    }
    
    
    @IBAction func addTaskBtnPressed(_ sender: Any) {
        
        if let taskName = taskNameTextField.text, let priorityChoice = priority
        {
            let task = Task(name: taskName, priority: priorityChoice, isDone: false)
            let taskList = AddTaskController.getTasks(for: priorityChoice)
            AddTaskController.saveTasks(for: priorityChoice, tasks: taskList + [task])
            showAlert(title: "New task added", message: "Task \(taskName) sucessfuly added to your to-do list")
        }
    }
    
    static func getTasks(for priority: Task.Priority) -> [Task] {
        let userDefaults = UserDefaults.standard
        if let tasksData = userDefaults.data(forKey: priority.rawValue),
           let tasks = try? JSONDecoder().decode([Task].self, from: tasksData) {
            return tasks
        } else {
            return []
        }
    }
    
    static func saveTasks(for priority: Task.Priority, tasks: [Task]) {
        let userDefaults = UserDefaults.standard
        if let tasksData = try? JSONEncoder().encode(tasks) {
            userDefaults.set(tasksData, forKey: priority.rawValue)
        }
    }
    
    
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
extension AddTaskController : UIPickerViewDataSource, UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return priorities.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return priorities[row].rawValue
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        priority = priorities[row]
    }
}
