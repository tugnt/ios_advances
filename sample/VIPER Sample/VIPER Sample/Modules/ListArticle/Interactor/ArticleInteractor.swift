//
//  ArticleInteractor.swift
//  VIPER Sample
//
//  Created by t_nguyen on 2018/06/08.
//  Copyright © 2018年 ga-technologies. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

class ArticleInteractor: ArticlesUseCase {
    private var disposeBag = DisposeBag()
    weak var output: ArticleInteractorOutput!
    
    func fetchArticles() {
        ArticleApiService
            .fetchArticles()
            .subscribe(onNext: { articles in
                self.output.articleFetched(articles: articles)
            }).disposed(by: disposeBag)
    }
}

class ArticleApiService {
    static func fetchArticles() -> Observable<[Article]> {
        /// Tạo một function trả về một danh sách article có thể lắng nghe.
        return Observable<[Article]>.create { observer -> Disposable in
            let request = Alamofire
                .request("https://api.github.com/users?since=1", method: .get)
                .validate()
                .responseArray(completionHandler: { (response: DataResponse<[ArticleModel]>) in
                    switch response.result {
                    case .success(let articlesModel):
                        var articles = [Article]()
                        let _ = articlesModel.map { articles.append(Article(name: $0.login!, imageUrl: $0.avatarUrl!, id: $0.id!)) }
                        observer.onNext(articles)
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

