//
//  SearchCollectionViewCell.swift
//  ShoppingProject
//
//  Created by 김하은 on 2023/09/08.
//

import UIKit

class SearchCollectionViewCell: BaseCollectionViewCell {
    
    var data: [Item]?
    
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
    
    override func configuration() {
        contentView.addSubview(imageView)
        contentView.addSubview(likeButton)
        contentView.addSubview(mallNameLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
    }
    
    override func setConstraints() {
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
        
        guard let data = data else { return }
        
        imageView.kf.setImage(with: URL(string: data[0].image))
        mallNameLabel.text = "[\(data[0].mallName)]"
        titleLabel.text = data[0].title
        priceLabel.text = numberFormatter(number: Int(data[0].lprice)!)

        if isLike(data: data) {
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else{
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
    
    override func prepareForReuse() {
        guard let data = data else { return }
        print(data)
        if isLike(data: data) {
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else{
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
}
