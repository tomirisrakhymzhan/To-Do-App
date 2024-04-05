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
            let taskList = AddTaskController.getAllTasks()
            AddTaskController.saveTasks(tasks: taskList + [task])
            showAlert(title: "New task added", message: "Task \(taskName) sucessfuly added to your to-do list")
        }
    }
    
    static func getAllTasks() -> [Task]{
        var result : [Task] = []
        if let data = UserDefaults.standard.object(forKey: AddTaskController.taskKeyString) as? Data {
            
            do {
                let decoder = JSONDecoder()
                result = try decoder.decode([Task].self, from: data)
                print("GETALLTASKS: RESULT \(result)")
            } catch {
                print("could'n decode given data to [Task] with error: \(error.localizedDescription)")
            }
        }
        return result
    }
    
    static func saveTasks(tasks: [Task]) {
        do {
            let encoder = JSONEncoder()
            let encodedData = try encoder.encode(tasks)
            UserDefaults.standard.setValue(encodedData, forKey: AddTaskController.taskKeyString)
            print("SAVETASKS: RESULT \(encodedData)")

        }catch{
            print("could'n encode given [Task] data with error: \(error.localizedDescription)")
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
