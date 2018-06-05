//
//  UserListTableViewCell.swift
//  500pxMVVM
//
//  Created by t_nguyen on 2018/06/05.
//  Copyright © 2018年 ga-technologies. All rights reserved.
//

import UIKit

class UserListTableViewCell: UITableViewCell {
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
