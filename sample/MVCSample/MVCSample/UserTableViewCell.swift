//
//  UserTableViewCell.swift
//  MVCSample
//
//  Created by t_nguyen on 2018/06/08.
//  Copyright © 2018年 ga-technologies. All rights reserved.
//

import UIKit
import Kingfisher

class UserTableViewCell: UITableViewCell {
    static var identifier: String { return String(describing: self) }
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userIdLabel: UILabel!
    
    func setUpCell(user: User) {
        guard let name = user.login,
            let id = user.id,
            let imageUrl = user.avatarUrl else { return }
        userNameLabel.text = name
        userIdLabel.text = "\(id)"
        avatarImageView.kf.setImage(with: URL(string: imageUrl))
    }
}
