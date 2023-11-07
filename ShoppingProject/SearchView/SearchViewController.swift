//
//  SearchViewController.swift
//  ShoppingProject
//
//  Created by 김하은 on 2023/09/08.
//

import UIKit
import Alamofire
import RealmSwift

class SearchViewController: UIViewController {

    let mainView = SearchView()
    
    let repository = RealmRepository()
    let naverAPIManager = NaverAPIManager.shared
    var searchDataList: NaverSearchData = NaverSearchData(total: 0, start: 0, display: 0, items: [])
    
    var sort: SortType = .sim
    var startItem = 1
        
    override func loadView() {
        super.loadView()
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "검색"
        
        mainView.searchBar.delegate = self
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        mainView.collectionView.prefetchDataSource = self
        
        mainView.searchBar.becomeFirstResponder()
        mainView.searchBar.searchTextField.addTarget(self, action: #selector(searchButtonTapped), for: .editingDidEndOnExit)
        
        mainView.scrollToTopButton.addTarget(self, action: #selector(scrollToTop), for: .touchUpInside)
        
        mainView.byAccuracyButton.addTarget(self, action: #selector(sortChange), for: .touchUpInside)
        mainView.byDateButton.addTarget(self, action: #selector(sortChange), for: .touchUpInside)
        mainView.byHighPriceButton.addTarget(self, action: #selector(sortChange), for: .touchUpInside)
        mainView.byLowPriceButton.addTarget(self, action: #selector(sortChange), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mainView.collectionView.reloadData()
    }
    
    @objc func searchButtonTapped() {
        
        if mainView.searchBar.text?.isEmpty ?? true {
            searchDataList.items.removeAll()
            mainView.collectionView.reloadData()
            mainView.emptyLabel.isHidden = false
        }else {
            mainView.emptyLabel.isHidden = true
            mainView.searchBar.showsCancelButton = false
            view.endEditing(true)
            
            startItem = 1
            scrollToTop()
            
            naverAPIManager.requestAPI(text: mainView.searchBar.text, start: startItem, sort: sort) { value in
                guard let value else { return }
                self.searchDataList.items.removeAll()
                self.searchDataList.items += value.items
                self.mainView.collectionView.reloadData()
            }
        }
    }
    
    @objc func scrollToTop() {
        if searchDataList.items.count > 1 {
            mainView.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
    }
    
    @objc func sortChange(_ sender: UIButton) {
        
        //버튼 색상 변경(이전에 클릭한 것)
        switch sort {
        case .sim: buttonColorChange(button: mainView.byAccuracyButton, click: false)
        case .date: buttonColorChange(button: mainView.byDateButton, click: false)
        case .dsc: buttonColorChange(button: mainView.byHighPriceButton, click: false)
        case .asc: buttonColorChange(button: mainView.byLowPriceButton, click: false)
        }
        
        //버튼 색상 변경(이번에 클릭한 것)
        switch SortType(rawValue: sender.tag) {
        case .sim: sort = .sim; buttonColorChange(button: mainView.byAccuracyButton, click: true)
        case .date: sort = .date; buttonColorChange(button: mainView.byDateButton, click: true)
        case .dsc: sort = .dsc; buttonColorChange(button: mainView.byHighPriceButton, click: true)
        case .asc: sort = .asc; buttonColorChange(button: mainView.byLowPriceButton, click: true)
        case .none:
            sort = .sim; buttonColorChange(button: mainView.byAccuracyButton, click: true)
        }
        
        searchButtonTapped()
    }
    
    //click - true: 새로 클릭한 버튼 /false: 이전에 클릭한 것 Unclick한 것처럼 바꿔줘야함
    func buttonColorChange(button: UIButton, click: Bool) {
        
        if click {
            button.setTitleColor(.black, for: .normal)
            button.backgroundColor = .white
        }else {
            button.setTitleColor(.gray, for: .normal)
            button.backgroundColor = .black
        }
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        mainView.scrollToTopButton.isHidden = searchDataList.items.count < 1 ? true : false
        return searchDataList.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as? CollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.itemData = searchDataList.items[indexPath.item]
        cell.cellSetting()
        cell.likeButton.tag = indexPath.item
        cell.likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = WebViewController()
        vc.itemData = searchDataList.items[indexPath.item]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func likeButtonTapped(sender: UIButton) {

        if repository.isLikeState(data: searchDataList.items[sender.tag], tableEdit: true) {
            sender.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else{
            sender.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
}

extension SearchViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {

            if searchDataList.items.count - 5 == indexPath.row {
                startItem += 30
                
                naverAPIManager.requestAPI(text: mainView.searchBar.text, start: startItem, sort: sort) { [weak self] value in
                    guard let self, let value else { return }

                    searchDataList.items += value.items
                    mainView.collectionView.reloadData()
                }
            }
        }
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.showsCancelButton = false
        searchDataList.items.removeAll()
        mainView.collectionView.reloadData()
        mainView.emptyLabel.isHidden = false
        view.endEditing(true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
}

