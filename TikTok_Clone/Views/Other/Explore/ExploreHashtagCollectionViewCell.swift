//
//  ExploreHashtagCollectionViewCell.swift
//  TikTok_Clone
//
//  Created by 김광준 on 2021/05/09.
//

import UIKit

class ExploreHashtagCollectionViewCell: UICollectionViewCell {
    static let idetifier: String = "ExploreHashtagCollectionViewCell"
    
    private let iconImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let hashtagLabel: UILabel = {
        let label: UILabel = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
        contentView.addSubview(iconImageView)
        contentView.addSubview(hashtagLabel)
        contentView.backgroundColor = .systemGray5
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let iconSize: CGFloat = contentView.height/3
        iconImageView.frame = CGRect(
            x: 10,
            y: (contentView.height - iconSize)/2,
            width: iconSize,
            height: iconSize
        ).integral
        
        hashtagLabel.sizeToFit()
        hashtagLabel.frame = CGRect(
            x: iconImageView.right + 10,
            y: 0,
            width: contentView.width - iconImageView.right - 10,
            height: contentView.height
        ).integral
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        hashtagLabel.text = nil
        iconImageView.image = nil
    }
    
    func configure(with viewModel: ExploreHashtagViewModel) {
        iconImageView.image = viewModel.icon
        hashtagLabel.text = viewModel.text
    }
    
    
}
