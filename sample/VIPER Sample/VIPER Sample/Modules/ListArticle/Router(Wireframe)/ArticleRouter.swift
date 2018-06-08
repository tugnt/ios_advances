//
//  ListRepoRouter.swift
//  VIPER Sample
//
//  Created by t_nguyen on 2018/06/08.
//  Copyright © 2018年 ga-technologies. All rights reserved.
//

import UIKit

class ArticleRouter: ArticlesWireframe {
    weak var viewController: UIViewController?
    
    static func assembleModule() -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let view = storyboard.instantiateInitialViewController() as? ArticlesViewController
        let presenter = ArticlePresenter()
        let interactor = ArticleInteractor()
        let router = ArticleRouter()
        
        let navigation = UINavigationController(rootViewController: view!)
        view?.presenter = presenter
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        interactor.output = presenter
        router.viewController = view
        return navigation
    }
    
    func presentDetails(forArticle article: Article) {
        /// TODO: Show detail screen
    }
}

protocol ArticlesWireframe: class {
    weak var viewController: UIViewController? { get set }
    func presentDetails(forArticle article: Article)
    
    static func assembleModule() -> UIViewController
}
