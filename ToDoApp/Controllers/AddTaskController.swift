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
    let taskKeyString = "Tasks"
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
            let task = Task(name: taskName, priority: priorityChoice)
            let taskList = getAllTasks()
            do {
                    let encoder = JSONEncoder()
                    let encodedData = try encoder.encode(taskList + [task])
                    UserDefaults.standard.set(encodedData, forKey: taskKeyString)
                    print("Task saved to UserDefaults.")
            } catch {
                print("Error saving task to UserDefaults: \(error.localizedDescription)")
            }
        }
    }
    
    func getAllTasks() -> [Task]{
        var result : [Task] = []
        let userDefaults = UserDefaults.standard
        if let data = userDefaults.object(forKey: taskKeyString) as? Data {
            
            do {
                let decoder = JSONDecoder()
                result = try decoder.decode([Task].self, from: data)
                
            } catch {
                print("could'n decode given data to [Contact] with error: \(error.localizedDescription)")
            }
            
        }
        
        return result
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension AddTaskController : UIPickerViewDataSource, UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return priorities.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        print("priorities[row].rawValue : \(priorities[row].rawValue), row: \(row)" )
        return priorities[row].rawValue
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        priority = priorities[row]
    }
}
