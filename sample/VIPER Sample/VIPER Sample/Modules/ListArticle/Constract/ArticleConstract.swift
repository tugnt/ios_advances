//
//  ArticleConstract.swift
//  VIPER Sample
//
//  Created by t_nguyen on 2018/06/08.
//  Copyright © 2018年 ga-technologies. All rights reserved.
//

import Foundation

/// Protocol define command for all Controller
protocol IndicatableView: class {
    func showActivityIndicator()
    func hideActivityIndicator()
}

/// Define user case
protocol ArticlesUseCase: class {
    weak var output: ArticleInteractorOutput! { get set }
    func fetchArticles()
}

///  Viewが変わるために、 funcを宣言する
///
protocol ArticlesView: IndicatableView {
    var presenter: ArticlesPresentation! { get set }
    func showNoContentScreen()
    func showArticlesData(_ articles: [Article])
}

/// Tap hop nhung lenh duoc gui tu view -> Presenter
protocol ArticleModuleInterface: class {
    func updateView()
    func showDetailArticle(article: Article)
}


///  Interactorから Presenterに functionを宣言する
protocol ArticleInteractorOutput: class {
    func articleFetched(articles: [Article])
    func articleFetchFailed()
}

///  VIPERには一番大切ところはPresenterです、 Brigeみたです。
protocol ArticlesPresentation: class {
    weak var view: ArticlesView? { get set }
    var interactor: ArticlesUseCase! { get set }
    var router: ArticlesWireframe! { get set }
    
    func viewDidLoad()
    func didClickSortButton()
    func didSelectArticle(_ article: Article)
}
