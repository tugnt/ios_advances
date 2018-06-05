//
//  ViewController.swift
//  500pxMVVM
//
//  Created by t_nguyen on 2018/06/05.
//  Copyright © 2018年 ga-technologies. All rights reserved.
//

import UIKit

class ViewController: UIViewController { 
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    var viewModel: UserListViewModel = UserListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initViewModel()
    }
    
    private func initView() {
        self.title = "List User"
        tableView.estimatedRowHeight = 150
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    private func initViewModel() {
        viewModel.updateLoadingStatus = { [weak self] in
            DispatchQueue.main.async {
                let isLoading = self?.viewModel.isLoading ?? false
                if isLoading {
                    self?.indicatorView.startAnimating()
                    UIView.animate(withDuration: 0.2, animations: {
                        self?.tableView.alpha = 0.0
                    })
                }else {
                    self?.indicatorView.stopAnimating()
                    UIView.animate(withDuration: 0.2, animations: {
                        self?.tableView.alpha = 1.0
                    })
                }
            }
        }
        
        viewModel.reloadTableViewClosure = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        viewModel.initFetchData()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(viewModel.numberOffCells)
        return viewModel.numberOffCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? UserListTableViewCell else {
            return UITableViewCell() }
        let model = viewModel.getCellModel(at: indexPath)
        cell.id.text  = "\(model.idText)"
        cell.name.text = model.nameText
        return cell
    }
}

