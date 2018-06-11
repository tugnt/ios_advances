//
//  UserListViewModel.swift
//  500pxMVVM
//
//  Created by t_nguyen on 2018/06/05.
//  Copyright © 2018年 ga-technologies. All rights reserved.
//

import Foundation

class UserListViewModel {
    let apiService: APIServiceProtocol
    var reloadTableViewClosure: (()->())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    
    private var users: [User] = [User]()
    
    private var cellViewModel: [UserListCellModel] = [UserListCellModel]() {
        didSet {
            self.reloadTableViewClosure?()
        }
    }
    
    var alertMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }
    
    var isLoading = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    var numberOffCells: Int {
        return users.count
    }
    
    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }
    
    func initFetchData() {
        self.isLoading = true
        apiService.fetchPopularPhoto(complete: { [weak self] (success, user, error) in
            self?.isLoading = false
            if let _ = error {
                self?.showAlertClosure?()
            } else {
                self?.processFetchedUser(users: user)
            }
        })
    }
    
    func getCellModel(at indextPath: IndexPath) -> UserListCellModel {
        return cellViewModel[indextPath.row]
    }
    
    func createCellModel(user: User) -> UserListCellModel {
        let name = user.login ?? ""
        let id = user.id ?? 0
        let avatarUrl = user.avatarUrl ?? ""
        return UserListCellModel(nameText: name,
                                 idText: id,
                                 imageUrlText: avatarUrl)
    }
    
    private func processFetchedUser(users: [User]) {
        self.users = users
        var tmpCellModel = [UserListCellModel]()
        users.forEach { tmpCellModel.append(createCellModel(user: $0)) }
        self.cellViewModel = tmpCellModel
    }
}

struct UserListCellModel {
    let nameText: String
    let idText: Int
    let imageUrlText: String
    init(nameText: String , idText: Int, imageUrlText: String) {
        self.nameText = nameText
        self.idText = idText
        self.imageUrlText = imageUrlText
    }
}
