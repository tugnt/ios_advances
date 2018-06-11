//
//  Photo.swift
//  500pxMVVM
//
//  Created by t_nguyen on 2018/06/05.
//  Copyright © 2018年 ga-technologies. All rights reserved.
//
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

class User: Mappable {
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
