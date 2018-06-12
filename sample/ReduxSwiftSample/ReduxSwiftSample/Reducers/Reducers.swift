//
//  Reducers.swift
//  ReduxSwiftSample
//
//  Created by t_nguyen on 2018/06/12.
//  Copyright © 2018年 ga-technologies. All rights reserved.
//

import Foundation
import ReSwift
/// Reducers dựa vào action để trả về một state mới dựa vào state hiện tại.

func appReducres(action: Action, state: AppState?) -> AppState {
    
    var state = state ?? AppState()
    switch action {
    case let addTask as AddTask:
        let task = Task(name: addTask.name)
        state.tasks.insert(task, at: 0)
    case let removeTask as DeleteTask:
        state.tasks.remove(at: removeTask.index)
    default:
        return state
    }
    
    return state
}
