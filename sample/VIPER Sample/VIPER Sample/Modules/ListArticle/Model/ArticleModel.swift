//
//  ArticleModel.swift
//  VIPER Sample
//
//  Created by t_nguyen on 2018/06/08.
//  Copyright © 2018年 ga-technologies. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import AlamofireObjectMapper

class ArticleModel : Mappable {
    var id: Int?
    var login: String?
    var avatarUrl: String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        login <- map["login"]
        avatarUrl <- map["avatar_url"]
    }
}

