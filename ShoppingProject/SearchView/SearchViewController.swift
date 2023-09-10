//
//  SearchViewController.swift
//  ShoppingProject
//
//  Created by 김하은 on 2023/09/08.
//

import UIKit
import Alamofire
import Kingfisher

class SearchViewController: BaseViewController {
    
    var searchDataList: NaverSearchData = NaverSearchData(total: 0, start: 0, display: 0, items: [])
    var sort: SortData = .sim
    let display = 30
    var startItem = 1
    
    lazy var searchBar = {
        let view = UISearchBar()
        view.placeholder = "검색어를 입력해주세요"
        view.setValue("취소", forKey: "cancelButtonText")
        view.showsCancelButton = true
        view.tintColor = .white
        view.delegate = self
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
        view.tag = SortData.sim.rawValue
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
        view.tag = SortData.date.rawValue
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
        view.tag = SortData.dsc.rawValue
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
        view.tag = SortData.asc.rawValue
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
        view.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: "SearchCollectionViewCell")
        view.collectionViewLayout = collectionViewLayout()
        view.delegate = self
        view.dataSource = self
        view.prefetchDataSource = self
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
        title = "검색"
        searchBar.becomeFirstResponder()
        searchBar.searchTextField.addTarget(self, action: #selector(searchButtonTapped), for: .editingDidEndOnExit)
        scrollToTopButton.addTarget(self, action: #selector(scrollToTop), for: .touchUpInside)
        byAccuracyButton.addTarget(self, action: #selector(sortChange), for: .touchUpInside)
        byDateButton.addTarget(self, action: #selector(sortChange), for: .touchUpInside)
        byHighPriceButton.addTarget(self, action: #selector(sortChange), for: .touchUpInside)
        byLowPriceButton.addTarget(self, action: #selector(sortChange), for: .touchUpInside)
    }
    
    @objc func searchButtonTapped() {
        view.endEditing(true)
        
        startItem = 1
        scrollToTop()
        requestAPI { value in
            guard let value else { return }
            self.searchDataList.items.removeAll()
            self.searchDataList.items += value.items
            self.collectionView.reloadData()
        }
    }
    
    @objc func scrollToTop() {
        if searchDataList.items.count > 1 {
            collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
    }
    
    @objc func sortChange(_ sender: UIButton) {
        
        //버튼 색상 변경(이전에 클릭한 것)
        switch sort {
        case .sim: buttonColorChange(button: byAccuracyButton, click: false)
        case .date: buttonColorChange(button: byDateButton, click: false)
        case .dsc: buttonColorChange(button: byHighPriceButton, click: false)
        case .asc: buttonColorChange(button: byLowPriceButton, click: false)
        }
        
        //버튼 색상 변경(이번에 클릭한 것)
        switch SortData(rawValue: sender.tag) {
        case .sim: sort = .sim; buttonColorChange(button: byAccuracyButton, click: true)
        case .date: sort = .date; buttonColorChange(button: byDateButton, click: true)
        case .dsc: sort = .dsc; buttonColorChange(button: byHighPriceButton, click: true)
        case .asc: sort = .asc; buttonColorChange(button: byLowPriceButton, click: true)
        case .none:
            sort = .sim; buttonColorChange(button: byAccuracyButton, click: true)
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
    
    override func configuration() {
        view.addSubview(searchBar)
        view.addSubview(byAccuracyButton)
        view.addSubview(byDateButton)
        view.addSubview(byHighPriceButton)
        view.addSubview(byLowPriceButton)
        view.addSubview(collectionView)
        view.addSubview(scrollToTopButton)
    }
    
    override func setConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
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
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        scrollToTopButton.snp.makeConstraints { make in
            make.bottom.right.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }
}
//API
extension SearchViewController {

//    func requestAPI() {
//           let text = searchBar.text?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
//           let url = "https://openapi.naver.com/v1/search/shop.json?query=\(text)&start=\(page)&display=30&sort=\(sort)"
//           print(url)
//           AF.request(url, headers: ["X-Naver-Client-Id": APIKey.NaverClientID, "X-Naver-Client-Secret": APIKey.NaverClientSecret]).validate().responseDecodable(of: NaverSearchData.self) { response in
//               switch response.result{
//               case .success(let value):
//                   self.searchDataList.items += value.items
//                   self.collectionView.reloadData()
//               case .failure(let error):
//                   print(error)
//               }
//           }
//       }
        
    func requestAPI(completion: @escaping (NaverSearchData?) -> ()) {
        guard let text = searchBar.text?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        
        let url = "https://openapi.naver.com/v1/search/shop.json?query=\(text)&start=\(startItem)&display=\(display)&sort=\(sort)"
        print(url)
        
        AF.request(url, headers: ["X-Naver-Client-Id": APIKey.NaverClientID, "X-Naver-Client-Secret": APIKey.NaverClientSecret]).validate().responseDecodable(of: NaverSearchData.self) { response in
            switch response.result{
            case .success(let value):
                completion(value)
            case .failure(let error):
                print(error)
                completion(nil)
            }
        }
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        scrollToTopButton.isHidden = searchDataList.items.count < 1 ? true : false
        return searchDataList.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCollectionViewCell", for: indexPath) as? SearchCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let data = searchDataList.items[indexPath.row]
        
        cell.imageView.kf.setImage(with: URL(string: data.image))
        cell.mallNameLabel.text = "[\(data.mallName)]"
        cell.titleLabel.text = data.title
        cell.priceLabel.text = numberFormatter(number: Int(data.lprice)!)
        
        return cell
    }
    
    func numberFormatter(number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        return numberFormatter.string(from: NSNumber(value: number))!
    }
}

extension SearchViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            
            print("아이템 총 개수: \(searchDataList.total)")
            guard searchDataList.total <= startItem + display else {
                print("아이템 끝? \(startItem + display)")
                return
            }
            
            if searchDataList.items.count - 5 == indexPath.row {
                startItem += display
                
                requestAPI { value in
                    guard let value else { return }
                    self.searchDataList.items += value.items
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        view.endEditing(true)
    }
}

