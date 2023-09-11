//
//  TabBarViewController.swift
//  ShoppingProject
//
//  Created by 김하은 on 2023/09/08.
//

import UIKit

class TabBarViewController: BaseViewController {

    let tabBar = {
        let view = UITabBarController()
        view.tabBar.tintColor = .white
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarDesing()
    }
    
    func tabBarDesing() {
        let searchView = UINavigationController(rootViewController: SearchViewController())
        searchView.tabBarItem = UITabBarItem(title: "검색", image: UIImage(systemName: "magnifyingglass"), tag: 0)
        
        let likeView = UINavigationController(rootViewController: LikeViewController())
        likeView.tabBarItem = UITabBarItem(title: "좋아요", image: UIImage(systemName: "heart"), tag: 1)
        
        tabBar.viewControllers = [searchView, likeView]
    }
    
    override func configuration() {
        view.addSubview(tabBar.view)
    }
    
    override func setConstraints() {
        tabBar.view.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
