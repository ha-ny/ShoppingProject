//
//  LikeViewController.swift
//  ShoppingProject
//
//  Created by 김하은 on 2023/09/10.
//

import UIKit
import RealmSwift

class LikeViewController: UIViewController {

    let mainView = LikeView()
    let repository = RealmRepository()
    var tasks: Results<LikeTable>?
    
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
        
        tasks = repository.searchLikeTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mainView.collectionView.reloadData()
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
        guard let tasks = tasks else { return 0 }
        return tasks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as? CollectionViewCell else {
            return UICollectionViewCell()
        }

        guard let tasks = tasks else { return UICollectionViewCell() }
        
        cell.tableData = tasks[indexPath.item]
        cell.cellSetting(isLikeView: true)
        cell.likeButton.tag = indexPath.item
        cell.likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let tasks = tasks else { return }
        
        let vc = WebViewController()
        vc.tableData = tasks[indexPath.item]
        vc.heartBool = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func likeButtonTapped(sender: UIButton) {

        do {
            guard let tasks = tasks else { return }
            
            guard let isProductId = repository.isProductId(productId: tasks[sender.tag].productId) else { return }
            
            if isProductId.count > 0 {
                repository.likeTableDelete(data: isProductId)
                mainView.collectionView.reloadData()
                return
            }else {
                print("error 삭제할 데이터 없음")
            }
        }catch {
            print(error)
        }
        

        sender.setImage(UIImage(systemName: "heart"), for: .normal)
    }
    
    func numberFormatter(number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        return numberFormatter.string(from: NSNumber(value: number))!
    }
}

extension LikeViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        tasks = repository.isItemTitle(title: searchText)
        mainView.collectionView.reloadData()
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
