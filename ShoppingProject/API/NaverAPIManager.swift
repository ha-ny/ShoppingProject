//
//  NaverAPIManager.swift
//  ShoppingProject
//
//  Created by 김하은 on 2023/09/11.
//

import Foundation
import Alamofire

class NaverAPIManager{
    
    static let shared = NaverAPIManager()
    
    private init() { }
    
    func requestAPI(text: String?, start: Int, sort: SortType, completion: @escaping (NaverSearchData?) -> ()) {
        guard let text = text?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        
        let url = "https://openapi.naver.com/v1/search/shop.json?query=\(text)&start=\(start)&display=30&sort=\(sort)"
        
        AF.request(url, headers: ["X-Naver-Client-Id": APIKey.NaverClientID, "X-Naver-Client-Secret": APIKey.NaverClientSecret]).validate().responseDecodable(of: NaverSearchData.self) { response in
            switch response.result{
            case .success(let value):
                completion(value)
            case .failure(let error):
                completion(nil)
            }
        }
    }
    
    func requestWebView(text: String?, start: Int, sort: SortType, completion: @escaping (NaverSearchData?) -> ()) {
        guard let text = text?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        
        let url = "https://openapi.naver.com/v1/search/shop.json?query=\(text)&start=\(start)&display=30&sort=\(sort)"
        
        AF.request(url, headers: ["X-Naver-Client-Id": APIKey.NaverClientID, "X-Naver-Client-Secret": APIKey.NaverClientSecret]).validate().responseDecodable(of: NaverSearchData.self) { response in
            switch response.result{
            case .success(let value):
                completion(value)
            case .failure(let error):
                completion(nil)
            }
        }
    }
}
