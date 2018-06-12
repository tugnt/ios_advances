//
//  AppState.swift
//  ReduxSwiftSample
//
//  Created by t_nguyen on 2018/06/12.
//  Copyright © 2018年 ga-technologies. All rights reserved.
//

import Foundation
import ReSwift

struct AppState: StateType {
    var tasks: [Task] = []
    var detailTask: DetailTask = .show
}

enum DetailTask {
    case show
    case hide
}
