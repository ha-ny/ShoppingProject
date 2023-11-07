//
//  CollectionViewCell.swift
//  ShoppingProject
//
//  Created by 김하은 on 2023/09/08.
//

import UIKit
import SnapKit
import Kingfisher

class CollectionViewCell: UICollectionViewCell {
    
    let realmRepository = RealmRepository()
    var data: LikeTable?
    
    let imageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    
    let likeButton = {
        let view = UIButton()
        view.backgroundColor = .white
        view.setImage(UIImage(systemName: "heart"), for: .normal)
        view.tintColor = .black
        view.layer.cornerRadius = 16
        return view
    }()
    
    let mallNameLabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 13)
        view.textColor = .gray
        return view
    }()
    
    let titleLabel = {
        let view = UILabel()
        view.numberOfLines = 2
        view.font = .systemFont(ofSize: 13)
        return view
    }()
    
    let priceLabel = {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: 17)
        return view
    }()
    
    func setting() {
        configuration()
        setConstraints()
    }
    
    func configuration() {
        contentView.addSubview(imageView)
        contentView.addSubview(likeButton)
        contentView.addSubview(mallNameLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
    }
    
    func setConstraints() {
        imageView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top)
            make.width.equalTo(contentView)
            make.height.equalTo(contentView.snp.width)
        }
        
        likeButton.snp.makeConstraints { make in
            make.bottom.equalTo(imageView.snp.bottom).inset(10)
            make.trailing.equalTo(imageView).inset(10)
            make.size.equalTo(32)
        }
        
        mallNameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(4)
            make.leading.trailing.equalTo(imageView)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(mallNameLabel.snp.bottom)
            make.leading.trailing.equalTo(mallNameLabel)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.trailing.equalTo(titleLabel)
        }
    }
    
    func cellSetting() {
        setting()
        guard let data else { return }
        
        imageView.kf.setImage(with: URL(string: data.imageURL))
        mallNameLabel.text = "[\(data.mallName)]"
        let title = data.title.replacingOccurrences(of: "[<b></b>]", with: "", options: .regularExpression)
        titleLabel.text = title
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let price = numberFormatter.string(from: NSNumber(value: Int(data.price) ?? 0))
        priceLabel.text = price
        
        let filterData = realmRepository.read().filter { $0.productId == data.productId }
        let image = filterData.isEmpty ? "heart" : "heart.fill"
        likeButton.setImage(UIImage(systemName: image), for: .normal)
    }
    
    override func prepareForReuse() {
        guard let data else { return }
        
        let filterData = realmRepository.read().filter { $0.productId == data.productId }
        let imageStr = filterData.isEmpty ? "heart.fill" : "heart"
        likeButton.setImage(UIImage(systemName: imageStr), for: .normal)
    }
}
