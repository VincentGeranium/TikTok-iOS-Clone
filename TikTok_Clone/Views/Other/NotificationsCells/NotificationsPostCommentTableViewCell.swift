//
//  NotificationsPostCommentTableViewCell.swift
//  TikTok_Clone
//
//  Created by 김광준 on 2021/05/21.
//

import UIKit

class NotificationsPostCommentTableViewCell: UITableViewCell {
    static let identifier: String = "NotificationsPostCommentTableViewCell"
    
    // MARK:- Properties
    private let postThumbnailImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let label: UILabel = {
        let label: UILabel = UILabel()
        label.numberOfLines = 1
        label.textColor = .label
        return label
    }()
    
    // MARK:- Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        
        contentView.addSubview(postThumbnailImageView)
        contentView.addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        postThumbnailImageView.image = nil
        label.text = nil
    }
    
    // MARK:- Functions
    func configure(with postFileName: String) {
        postThumbnailImageView.image = nil
        label.text = nil
    }
}
