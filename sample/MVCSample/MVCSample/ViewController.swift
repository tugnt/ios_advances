//
//  ViewController.swift
//  MVCSample
//
//  Created by t_nguyen on 2018/06/08.
//  Copyright © 2018年 ga-technologies. All rights reserved.
//

import UIKit
import RxSwift
import ObjectMapper
import Alamofire

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    private var users: [User] = [User]()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        fetchArticles().subscribe(onNext: { users in
            DispatchQueue.main.async {
                self.users = users
                self.tableView.reloadData()
            }
        }, onError: { error in
            print("Error")
        }).disposed(by: disposeBag)
    }
    
    private func setUpView() {
        self.title = "List User"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
    
    func fetchArticles() -> Observable<[User]> {
        self.activityIndicator.startAnimating()
        return Observable<[User]>.create { observer -> Disposable in
            let request = Alamofire
                .request("https://api.github.com/users?since=1", method: .get)
                .validate()
                .responseArray(completionHandler: { (response: DataResponse<[User]>) in
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    switch response.result {
                    case .success(let users):
                        observer.onNext(users)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
                })
            return Disposables.create(with: {
                request.cancel()
            })
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.identifier, for: indexPath) as? UserTableViewCell else { return UITableViewCell() }
        let user = users[indexPath.row]
        cell.setUpCell(user: user)
        return cell
    }
}
