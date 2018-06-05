//
//  APIService.swift
//  500pxMVVM
//
//  Created by t_nguyen on 2018/06/05.
//  Copyright © 2018年 ga-technologies. All rights reserved.
//

import Foundation
import Alamofire

enum APIError: String, Error {
    case noNetwork = "No network"
    case serverOverload = "Server is overload"
    case permissionDenied = "You do not have permission"
}

protocol APIServiceProtocol {
    func fetchPopularPhoto(complete: @escaping (_ success: Bool, _ users: [User], _ error: APIError?) -> ())
}

class APIService: APIServiceProtocol {
    func fetchPopularPhoto(complete: @escaping (Bool, [User], APIError?) -> ()) {
        DispatchQueue.global().async {
            /// Using alamofire fetch data from 500px
            complete(false, [], .noNetwork)
            let apiUrl = "https://api.github.com/users?since=135"
            Alamofire.request(apiUrl).responseArray { (response: DataResponse<[User]>) in
                if response.error == nil {
                    guard let users = response.result.value else { return }
                    complete(true, users, nil)
                }
            }
        }
    }
}
