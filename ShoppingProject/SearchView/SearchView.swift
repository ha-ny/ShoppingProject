//
//  SearchView.swift
//  ShoppingProject
//
//  Created by 김하은 on 2023/11/07.
//

import UIKit

class SearchView: BaseView {
    
    let searchBar = {
        let view = UISearchBar()
        view.placeholder = "검색어를 입력해주세요"
        view.setValue("취소", forKey: "cancelButtonText")
        view.tintColor = .white
        return view
    }()
    
    let byAccuracyButton = {
        let view = UIButton()
        view.setTitle(" 정확도 ", for: .normal)
        view.layer.borderWidth = 0.7
        view.layer.cornerRadius = 5
        view.layer.borderColor = UIColor.gray.cgColor
        view.setTitleColor(.black, for: .normal)
        view.backgroundColor = .white
        view.titleLabel?.font = .systemFont(ofSize: 14)
        view.tag = SortType.sim.rawValue
        return view
    }()
    
    let byDateButton = {
        let view = UIButton()
        view.setTitle(" 날짜순 ", for: .normal)
        view.layer.borderWidth = 0.7
        view.layer.cornerRadius = 5
        view.layer.borderColor = UIColor.gray.cgColor
        view.titleLabel?.font = .systemFont(ofSize: 14)
        view.setTitleColor(.gray, for: .normal)
        view.tag = SortType.date.rawValue
        return view
    }()
    
    let byHighPriceButton = {
        let view = UIButton()
        view.setTitle(" 가격높은순 ", for: .normal)
        view.layer.borderWidth = 0.7
        view.layer.cornerRadius = 5
        view.layer.borderColor = UIColor.gray.cgColor
        view.titleLabel?.font = .systemFont(ofSize: 14)
        view.setTitleColor(.gray, for: .normal)
        view.tag = SortType.dsc.rawValue
        return view
    }()
    
    let byLowPriceButton = {
        let view = UIButton()
        view.setTitle(" 가격낮은순 ", for: .normal)
        view.layer.borderWidth = 0.7
        view.layer.cornerRadius = 5
        view.layer.borderColor = UIColor.gray.cgColor
        view.titleLabel?.font = .systemFont(ofSize: 14)
        view.setTitleColor(.gray, for: .normal)
        view.tag = SortType.asc.rawValue
        return view
    }()
    
    let scrollToTopButton = {
        let view = UIButton()
        let image = UIImage(systemName: "arrow.up.square.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 40))
        view.setImage(image, for: .normal)
        view.tintColor = .white
        view.backgroundColor = .darkGray
        view.layer.cornerRadius = 40
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
    
    let emptyLabel = {
        let view = UILabel()
        view.text = "검색 결과가 없습니다"
        view.font = .systemFont(ofSize: 16)
        view.textAlignment = .center
        return view
    }()
    
    
    override func setConfiguration() {
        addSubview(searchBar)
        addSubview(byAccuracyButton)
        addSubview(byDateButton)
        addSubview(byHighPriceButton)
        addSubview(byLowPriceButton)
        addSubview(collectionView)
        addSubview(scrollToTopButton)
        addSubview(emptyLabel)
    }
    
    override func setConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
        }
        
        byAccuracyButton.snp.makeConstraints { make in
            make.leading.equalTo(searchBar).offset(8)
            make.top.equalTo(searchBar.snp.bottom).offset(8)
        }
        
        byDateButton.snp.makeConstraints { make in
            make.left.equalTo(byAccuracyButton.snp.right).offset(8)
            make.top.equalTo(byAccuracyButton)
        }
        
        byHighPriceButton.snp.makeConstraints { make in
            make.left.equalTo(byDateButton.snp.right).offset(8)
            make.top.equalTo(byAccuracyButton)
        }
        
        byLowPriceButton.snp.makeConstraints { make in
            make.left.equalTo(byHighPriceButton.snp.right).offset(8)
            make.top.equalTo(byAccuracyButton)
        }
        
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(searchBar).inset(8)
            make.top.equalTo(byAccuracyButton.snp.bottom).offset(10)
            make.bottom.equalTo(self.safeAreaLayoutGuide)
        }
        
        scrollToTopButton.snp.makeConstraints { make in
            make.bottom.right.equalTo(self.safeAreaLayoutGuide).inset(16)
        }
        
        emptyLabel.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
