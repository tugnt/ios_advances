//
//  ViewController.swift
//  ReduxSwiftSample
//
//  Created by t_nguyen on 2018/06/11.
//  Copyright © 2018年 ga-technologies. All rights reserved.
//

import UIKit
import ReSwift

class ViewController: UIViewController, StoreSubscriber {
    typealias StoreSubscriberStateType = AppState
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(TodoCell.nib, forCellReuseIdentifier: TodoCell.identifier)
            tableView.estimatedRowHeight = 200
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.tableFooterView = UIView()
        }
    }
    
    var tasks: [Task] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "List Task"
        addButtonBar()
        store.subscribe(self)
    }
    
    private func addButtonBar() {
        let buttonBar = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addNewTask))
        self.navigationItem.setRightBarButton(buttonBar, animated: false)
    }
    
    @objc private func addNewTask() {
        showAddDialog() { (input:String?) in
            guard let taskName = input else {
                return
            }
            let addTaskAction = AddTask(name: taskName)
            // https://redux.js.org/api-reference/store
            store.dispatch(addTaskAction)
        }
    }
    
    func newState(state: AppState) {
        self.tasks = store.state.tasks
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TodoCell.identifier, for: indexPath) as? TodoCell else { return UITableViewCell() }
        cell.todoNameLabel.text = tasks[indexPath.row].name
        cell.deleteTaskAction = {
            let deleteTaskAction = DeleteTask(index: indexPath.row)
            store.dispatch(deleteTaskAction)
        }
        return cell
    }
}


extension UIViewController {
    func showAddDialog(actionHandler: ((_ text: String?) -> Void)? = nil) {
        let alert = UIAlertController(title: "Add Task", message: "Please enter the name below.", preferredStyle: .alert)
        alert.addTextField { (textField:UITextField) in
            textField.placeholder = "Task name"
        }
        alert.addAction(UIAlertAction(title: "Add new task", style: .destructive, handler: { (action:UIAlertAction) in
            guard let textField =  alert.textFields?.first else {
                actionHandler?(nil)
                return
            }
            actionHandler?(textField.text)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
