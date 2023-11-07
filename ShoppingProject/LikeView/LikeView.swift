//
//  LikeView.swift
//  ShoppingProject
//
//  Created by 김하은 on 2023/11/07.
//

import UIKit

class LikeView: BaseView {

    let searchBar = {
        let view = UISearchBar()
        view.placeholder = "검색어를 입력해주세요"
        view.setValue("취소", forKey: "cancelButtonText")
        view.tintColor = .white
        return view
    }()

    lazy var collectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        view.register(CollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        view.collectionViewLayout = collectionViewLayout()
        return view
    }()
    
    func collectionViewLayout() -> UICollectionViewFlowLayout{
        let layout = UICollectionViewFlowLayout()
        let size = UIScreen.main.bounds.width - 35
        layout.itemSize = CGSize(width: size/2 , height: size/1.3)
        return layout
    }
    
    override func setConfiguration() {
        addSubview(searchBar)
        addSubview(collectionView)
    }
    
    override func setConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
        }

        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(searchBar).inset(8)
            make.top.equalTo(searchBar.snp.bottom).offset(10)
            make.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
