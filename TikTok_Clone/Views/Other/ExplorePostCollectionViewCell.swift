//
//  ExplorePostCollectionViewCell.swift
//  TikTok_Clone
//
//  Created by 김광준 on 2021/05/09.
//

import UIKit

class ExplorePostCollectionViewCell: UICollectionViewCell {
    static let identifier: String = "ExplorePostCollectionViewCell"
    
    private let thumbnailImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        return imageView
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
}
