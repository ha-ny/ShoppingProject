//
//  WebViewController.swift
//  ShoppingProject
//
//  Created by 김하은 on 2023/09/10.
//

import UIKit
import WebKit
import RealmSwift

class WebViewController: BaseViewController, WKUIDelegate,WKNavigationDelegate {

    let repository = RealmRepository()
    
    var itemData: Item?
    var tableData: LikeTable?
    var heartBool = false
    var isLikeView = false
    
    let webView = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //초기 heartBool = true -> likeView
        if heartBool{
            isLikeView = true
        }
        
        if isLikeView {
            guard let data = tableData else { return }
            
            let title = data.title.replacingOccurrences(of: "[<b></b>]", with: "", options: .regularExpression)
            self.title = title
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "heart.fill"), style: .plain, target: self, action: #selector(likeButtonTapped))
            navigationItem.rightBarButtonItem?.tintColor = .white
            
            let url = URL(string: "https://msearch.shopping.naver.com/product/\(data.productId)")
            let request = URLRequest(url: url!)
            webView.load(request)
            
        }else {
            guard let data = itemData else { return }
            let title = data.title.replacingOccurrences(of: "[<b></b>]", with: "", options: .regularExpression)
            self.title = title
            
            heartBool = repository.isLikeState(data: data)
            let image = heartBool ? "heart.fill" : "heart"
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: image), style: .plain, target: self, action: #selector(likeButtonTapped))
            navigationItem.rightBarButtonItem?.tintColor = .white
            
            let url = URL(string: "https://msearch.shopping.naver.com/product/\(data.productId)")
            let request = URLRequest(url: url!)
            webView.load(request)
        }
    }

    override func configuration() {
        view.addSubview(webView)
    }
    
    override func setConstraints() {
        webView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    @objc func likeButtonTapped() {
        if isLikeView {
            guard let data = tableData else { return }
            if let table = repository.isResultsConvert(table: data){
                repository.likeTableDelete(data: table)
            }
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart")
            heartBool.toggle()
            navigationItem.rightBarButtonItem?.tintColor = .white
        }else {
            guard let data = itemData else { return }
            
            heartBool = repository.isLikeState(data: data, tableEdit: true)
            let image = heartBool ? "heart.fill" : "heart"
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: image)
            heartBool.toggle()

        }
    }
    
}
