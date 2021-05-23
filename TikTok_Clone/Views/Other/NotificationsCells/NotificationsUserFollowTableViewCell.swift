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
    
    private let dateLabel: UILabel = {
        let label: UILabel = UILabel()
        label.numberOfLines = 1
        label.textColor = .secondaryLabel
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
        contentView.addSubview(dateLabel)
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // icon size == size of avatar
        let iconSize: CGFloat = 50
        
        // c.f :  y is verticaly center -> why (contentView.height - iconSize) / 2 is vertically center??
            // have to study about that
        avatarImageView.frame = CGRect(
            x: 10,
            y: 3,
            width: iconSize,
            height: iconSize
        )
        avatarImageView.layer.masksToBounds = true
        avatarImageView.layer.cornerRadius = 25
        
        // make follow button, all the way to the right
        followButton.sizeToFit()
        followButton.frame = CGRect(
            x: (contentView.width - 110),
            y: 10,
            width: 100,
            height: 30
        )
        
        // labels is appropriate size between avatarImageView and followButton, so not used width and height
        label.sizeToFit()
        dateLabel.sizeToFit()
        
        let labelSize = label.sizeThatFits(
            CGSize(
                width: contentView.width - 30 - followButton.width - iconSize,
                height: contentView.height - 40
            )
        )
        
        label.frame = CGRect(
            x: avatarImageView.right + 10,
            y: 0,
            width: labelSize.width,
            height: labelSize.height
        )
        
        dateLabel.frame = CGRect(
            x: avatarImageView.right + 10,
            y: label.bottom + 3,
            width: contentView.width - avatarImageView.width - followButton.width,
            height: 40
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImageView.image = nil
        label.text = nil
        dateLabel.text = nil
    }
    
    // MARK:- functions
    func configure(with userName: String, model: Notification) {
        avatarImageView.image = UIImage(named: "test")
        label.text = model.text
        dateLabel.text = .date(with: model.date)
    }
}
