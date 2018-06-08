//
//  ViewController.swift
//  VIPER Sample
//
//  Created by t_nguyen on 2018/06/07.
//  Copyright © 2018年 ga-technologies. All rights reserved.
//

import UIKit
import Kingfisher

/// Protocol dinh nghia view input method
protocol ArticleViewInterface: class {
    func showArticleData(articles: [Article])
    func showNoContentScreen()
}

class ArticlesViewController: UIViewController {
    private var articles: [Article] = [Article]() 
    @IBOutlet weak var tableView: UITableView!
    var presenter: ArticlesPresentation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configView()
        presenter.viewDidLoad()
    }
    
    private func configView() {
        self.title = "List article"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 200
        tableView.tableFooterView = UIView()
    }
}

extension ArticlesViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ArticleTableViewCell.indentifier, for: indexPath) as? ArticleTableViewCell else { return UITableViewCell() }
        let aricle = articles[indexPath.row]
        cell.nameLabel.text = aricle.name
        cell.idLabel.text = "\(aricle.id)"
        cell.imageView?.kf.setImage(with: URL(string: aricle.imageUrl), placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Todo: Mode detail screen
    }
}


extension ArticlesViewController: ArticlesView {
    func showNoContentScreen() {
        print("Show table view placeholder")
    }
    
    

    func showArticlesData(_ articles: [Article]) {
        DispatchQueue.main.async {
            self.articles = articles
            self.tableView.reloadData()
        }
    }
    
    func showActivityIndicator() {
        /// Show indicator
        print("Show indicator")
    }
    
    func hideActivityIndicator() {
        print("Hiden indicator")
    }
}
