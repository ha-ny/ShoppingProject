//
//  WebViewController.swift
//  ShoppingProject
//
//  Created by 김하은 on 2023/09/10.
//

import UIKit
import WebKit

class WebViewController: UIViewController{

    let realmRepository = RealmRepository()
    var data: Item?
    let webView = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let data else { return }
        
        let title = data.title.replacingOccurrences(of: "[<b></b>]", with: "", options: .regularExpression)
        self.title = title

        let url = URL(string: "https://msearch.shopping.naver.com/product/\(data.productId)")
        let request = URLRequest(url: url!)
        
        let filterData = realmRepository.read().filter { $0.productId == data.productId }
        
        let image = filterData.isEmpty ? "heart" : "heart.fill"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: image), style: .plain, target: self, action: #selector(likeButtonTapped))
        navigationItem.rightBarButtonItem?.tintColor = .white
       
        webView.load(request)

        setConfiguration()
        setConstraints()
    }

    func setConfiguration() {
        view.addSubview(webView)
    }
    
    func setConstraints() {
        webView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    @objc func likeButtonTapped() {
        guard let data else { return }

        let filterData = realmRepository.read().filter { $0.productId == data.productId }

        if filterData.isEmpty{
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart.fill")
            let temp = LikeTable(productId: data.productId, imageURL: data.image, mallName: data.mallName, title: data.title, price: data.lprice)
            realmRepository.create(data: temp)
        } else {
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart")
            realmRepository.delete(data: filterData[0])
        }
    }
    
}
