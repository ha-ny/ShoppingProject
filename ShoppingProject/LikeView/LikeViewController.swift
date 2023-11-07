//
//  LikeViewController.swift
//  ShoppingProject
//
//  Created by 김하은 on 2023/09/10.
//

import UIKit

class LikeViewController: UIViewController {

    let mainView = LikeView()
    let realmRepository = RealmRepository()
    var data: [LikeTable]? {
        didSet {
            mainView.collectionView.reloadData()
        }
    }

    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = "좋아요 목록"
        
        mainView.searchBar.delegate = self
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        
        mainView.searchBar.searchTextField.addTarget(self, action: #selector(searchButtonTapped), for: .editingDidEndOnExit)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        data = realmRepository.read()
    }
    
    @objc func searchButtonTapped() {
        mainView.searchBar.showsCancelButton = false
        view.endEditing(true)
        scrollToTop()
    }
    
    func scrollToTop() {
        mainView.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
}

extension LikeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let data else { return UICollectionViewCell() }

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as? CollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.data = data[indexPath.item]
        cell.cellSetting()
        cell.likeButton.tag = indexPath.item
        cell.likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let data else { return }
        
        let vc = WebViewController()
        let tempData = data[indexPath.item]
        vc.data = Item(productId: tempData.productId, title: tempData.title, image: tempData.imageURL, mallName: tempData.mallName, lprice: tempData.price)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func likeButtonTapped(sender: UIButton) {
        guard let data else { return }
        guard let filterData = realmRepository.read().filter { $0.productId == data[sender.tag].productId }.first else { return }
        realmRepository.delete(data: filterData)
        self.data = realmRepository.read()
    }

    func numberFormatter(number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        return numberFormatter.string(from: NSNumber(value: number))!
    }
}

extension LikeViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        data = realmRepository.read().filter { $0.title.contains(searchText) }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.showsCancelButton = false
        view.endEditing(true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
}
