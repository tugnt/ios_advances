//
//  ArticlesPresenter.swift
//  VIPER Sample
//
//  Created by t_nguyen on 2018/06/08.
//  Copyright © 2018年 ga-technologies. All rights reserved.
//

import Foundation



class ArticlePresenter: ArticlesPresentation {
    weak var view: ArticlesView?
    var interactor: ArticlesUseCase!
    
    var router: ArticlesWireframe!
    
    private var articles: [Article] = [] {
        didSet {

            if articles.isEmpty {
                view?.showNoContentScreen()
            } else {
                view?.showArticlesData(articles)
            }
        }
    }
    
    func viewDidLoad() {
        interactor.fetchArticles()
        view?.showActivityIndicator()
    }
    
    func didClickSortButton() {
        // Todo: Do something
    }
    
    func didSelectArticle(_ article: Article) {
        // Todo: Move detail screen
    }
}

extension ArticlePresenter: ArticleInteractorOutput {
    func articleFetchFailed() {
        view?.showNoContentScreen()
        view?.hideActivityIndicator()
    }
    
    func articleFetched(articles: [Article]) {
        view?.hideActivityIndicator()
        self.articles = articles
    }
}
