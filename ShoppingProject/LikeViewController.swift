//
//  LikeViewController.swift
//  ShoppingProject
//
//  Created by 김하은 on 2023/09/10.
//

import UIKit
import RealmSwift

class LikeViewController: BaseViewController {

    let realm = try! Realm()
    var tasks: Results<LikeTable>!
    
    lazy var searchBar = {
        let view = UISearchBar()
        view.placeholder = "검색어를 입력해주세요"
        view.setValue("취소", forKey: "cancelButtonText")
        view.tintColor = .white
        view.delegate = self
        return view
    }()

    lazy var collectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        view.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: "SearchCollectionViewCell")
        view.collectionViewLayout = collectionViewLayout()
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    func collectionViewLayout() -> UICollectionViewFlowLayout{
        let layout = UICollectionViewFlowLayout()
        let size = UIScreen.main.bounds.width - 35
        layout.itemSize = CGSize(width: size/2 , height: size/1.3)
        return layout
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = "좋아요 목록"
        searchBar.searchTextField.addTarget(self, action: #selector(searchButtonTapped), for: .editingDidEndOnExit)
        
        tasks = realm.objects(LikeTable.self)
    }
    
    @objc func searchButtonTapped() {
        searchBar.showsCancelButton = false
        view.endEditing(true)
        scrollToTop()
    }
    
    func scrollToTop() {
        collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
    
    override func configuration() {
        view.addSubview(searchBar)
        view.addSubview(collectionView)
    }
    
    override func setConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }

        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(searchBar).inset(8)
            make.top.equalTo(searchBar.snp.bottom).offset(10)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension LikeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCollectionViewCell", for: indexPath) as? SearchCollectionViewCell else {
            return UICollectionViewCell()
        }

        let data = tasks[indexPath.item]
        
        cell.imageView.kf.setImage(with: URL(string: data.imageURL))
        cell.mallNameLabel.text = data.mallName
        cell.titleLabel.text = data.title
        cell.priceLabel.text = numberFormatter(number: Int(data.price)!)
        
        return cell
    }
    
    func numberFormatter(number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        return numberFormatter.string(from: NSNumber(value: number))!
    }
}

extension LikeViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.showsCancelButton = false
        view.endEditing(true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
}
