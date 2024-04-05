//
//  TaskTableViewCell.swift
//  ToDoApp
//
//  Created by Томирис Рахымжан on 03/04/2024.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    
    static let identifier: String = "TaskTableViewCell"

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var priority: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        name.text = nil
        name.numberOfLines = 0
        
        priority.text = nil
        priority.numberOfLines = 1
        
        accessoryType = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        name.text = nil
        priority.text = nil
        accessoryType = .none
    }
    
}
