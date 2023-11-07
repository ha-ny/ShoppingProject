//
//  SearchViewController.swift
//  ShoppingProject
//
//  Created by 김하은 on 2023/09/08.
//

import UIKit

class SearchViewController: UIViewController {

    let mainView = SearchView()
    
    let realmRepository = RealmRepository()
    let naverAPIManager = NaverAPIManager.shared
    var searchDataList: NaverSearchData = NaverSearchData(total: 0, start: 0, display: 0, items: []) {
        didSet {
            self.mainView.collectionView.reloadData()
        }
    }
    
    var sort: SortType = .sim
    var startItem = 1
        
    override func loadView() {
        super.loadView()
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "검색"
        settingAction()
    }
    
    func settingAction() {
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
        guard let searchText = mainView.searchBar.text else { return }
        
        if searchText.isEmpty {
            searchDataList.items.removeAll()
            mainView.emptyLabel.isHidden = false
        }else {
            view.endEditing(true)
            mainView.emptyLabel.isHidden = true
            mainView.searchBar.showsCancelButton = false
            
            startItem = 1
            scrollToTop()
            
            naverAPIManager.requestAPI(text: mainView.searchBar.text, start: startItem, sort: sort) { value in
                guard let value else { return }
                self.searchDataList.items.removeAll()
                self.searchDataList.items += value.items
            }
        }
    }
    
    @objc func scrollToTop() {
        if searchDataList.items.count > 1 {
            mainView.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
    }
    
    @objc func sortChange(_ sender: UIButton) {

        [mainView.byAccuracyButton, mainView.byDateButton, mainView.byHighPriceButton, mainView.byLowPriceButton].forEach {
                $0.setTitleColor(.gray, for: .normal)
                $0.backgroundColor = .black
           }
           
        sort = SortType(rawValue: sender.tag) ?? .sim
        sender.setTitleColor(.black, for: .normal)
        sender.backgroundColor = .white
        searchButtonTapped()
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
        
        cell.data = LikeTable(value: searchDataList.items[indexPath.item])
        cell.cellSetting()
        cell.likeButton.tag = indexPath.item
        cell.likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = WebViewController()
        vc.data = LikeTable(value: searchDataList.items[indexPath.item]) 
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func likeButtonTapped(sender: UIButton) {
        let data = realmRepository.read().filter { $0.productId == searchDataList.items[sender.tag].productId }
        
        if data.isEmpty {
            realmRepository.create(data: data[0])
            sender.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            //기존에 있는 productId -> 이미 좋아요 눌린 상태 -> 좋아요 해지
            realmRepository.delete(data: data[0])
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
        mainView.emptyLabel.isHidden = false
        view.endEditing(true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
}

