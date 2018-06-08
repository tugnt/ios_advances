//
//  RootRouter.swift
//  VIPER Sample
//
//  Created by t_nguyen on 2018/06/08.
//  Copyright © 2018年 ga-technologies. All rights reserved.
//

import UIKit

class RootRouter {
    func presentArticleScreen(in window: UIWindow) {
        window.makeKeyAndVisible()
        window.rootViewController = ArticleRouter.assembleModule()
    }
}
