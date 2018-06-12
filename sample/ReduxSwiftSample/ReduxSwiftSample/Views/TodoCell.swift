//
//  TodoCell.swift
//  ReduxSwiftSample
//
//  Created by t_nguyen on 2018/06/12.
//  Copyright © 2018年 ga-technologies. All rights reserved.
//

import UIKit

class TodoCell: UITableViewCell {
    static var identifier: String { return String(describing: self) }
    static var nib: UINib { return UINib(nibName: identifier, bundle: nil)}
    var deleteTaskAction: (() -> Void)?
    @IBOutlet weak var todoNameLabel: UILabel!
    @IBOutlet weak var removeTaskButton: UIButton!
    
    @IBAction func removeDidSelect(_ sender: Any) {
        deleteTaskAction?()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
