//
//  NotificationsUserFollowTableViewCell.swift
//  TikTok_Clone
//
//  Created by 김광준 on 2021/05/21.
//

import UIKit

class NotificationsUserFollowTableViewCell: UITableViewCell {
    static let identifier: String = "NotificationsUserFollowTableViewCell"
    
    // MARK:- Properties
    // avatar, label, follow button
    private let avatarImageView: UIImageView = {
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
    
    private let followButton: UIButton = {
        let button: UIButton = UIButton()
        button.setTitle("Follow", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 6
        return button
    }()
    
    // MARK:- Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        
        contentView.addSubview(avatarImageView)
        contentView.addSubview(label)
        contentView.addSubview(followButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        avatarImageView.image = nil
        label.text = nil
    }
    
    // MARK:- functions
    func configure(with userName: String) {
        avatarImageView.image = nil
        label.text = nil
    }
}
