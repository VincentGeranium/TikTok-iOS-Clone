//
//  NotificationsUserFollowTableViewCell.swift
//  TikTok_Clone
//
//  Created by 김광준 on 2021/05/21.
//

import UIKit

// make protocol
protocol NotificationsUserFollowTableViewCellDelegate: AnyObject {
    func notificationsUserFollowTableViewCell(_ cell: NotificationsUserFollowTableViewCell,
                                              didTapFollowFor userName: String)
    func notificationsUserFollowTableViewCell(_ cell: NotificationsUserFollowTableViewCell,
                                              didTapAvatarFor userName: String)
}

class NotificationsUserFollowTableViewCell: UITableViewCell {
    static let identifier: String = "NotificationsUserFollowTableViewCell"
    
    // create the delegate optional
    weak var delegate: NotificationsUserFollowTableViewCellDelegate?
    
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
    
    var userName: String?
    
    // MARK:- Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        contentView.addSubview(avatarImageView)
        contentView.addSubview(label)
        contentView.addSubview(followButton)
        contentView.addSubview(dateLabel)
        selectionStyle = .none
        followButton.addTarget(self, action: #selector(didTapFollow), for: .touchUpInside)
        
        // for custom tap gesture
        avatarImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapAvatar))
        avatarImageView.addGestureRecognizer(tap)
    }
    
    @objc private func didTapAvatar() {
        guard let userName = userName else {
            return
        }
        delegate?.notificationsUserFollowTableViewCell(
            self,
            didTapAvatarFor: userName
        )
        print("‼️in userFollowCell - didTapAvatar is working‼️")
    }
    
    
    @objc private func didTapFollow() {
        guard let userName = userName else {
            return
        }
        
        // update follow button ui code
        followButton.setTitle("Following", for: .normal)
        followButton.backgroundColor = .clear
        followButton.setTitleColor(.label, for: .normal)
        followButton.layer.borderWidth = 1
        followButton.layer.borderColor = UIColor.lightGray.cgColor
        
        delegate?.notificationsUserFollowTableViewCell(
            self,
            didTapFollowFor: userName
        )
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
        
        // follow button ui
        followButton.setTitle("Follow", for: .normal)
        followButton.backgroundColor = .systemBlue
        followButton.layer.borderWidth = 0
        followButton.layer.borderColor = nil
    }
    
    // MARK:- functions
    func configure(with userName: String, model: Notification) {
        self.userName = userName
        avatarImageView.image = UIImage(named: "test")
        label.text = model.text
        dateLabel.text = .date(with: model.date)
    }
}
