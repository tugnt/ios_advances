//
//  Actions.swift
//  ReduxSwiftSample
//
//  Created by t_nguyen on 2018/06/12.
//  Copyright © 2018年 ga-technologies. All rights reserved.
//

import Foundation
import ReSwift

struct AddTask: Action {
    var name: String
}

struct DeleteTask: Action {
    var index: Int
}
