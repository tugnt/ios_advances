//
//  ArticleTableViewCell.swift
//  VIPER Sample
//
//  Created by t_nguyen on 2018/06/08.
//  Copyright © 2018年 ga-technologies. All rights reserved.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {
    static var indentifier: String { return String(describing: self) }
    @IBOutlet weak var arvataImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Init code here
    }
}
