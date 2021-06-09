//
//  NotificationsPostLikeTableViewCell.swift
//  TikTok_Clone
//
//  Created by 김광준 on 2021/05/21.
//

import UIKit

// make protocol for NotificationsPostLikeTableViewCellDelegate
protocol NotificationsPostLikeTableViewCellDelegate: AnyObject {
    func notificationsPostLikeTableViewCell(_ cell: NotificationsPostLikeTableViewCell,
                                            didTapPostWith identifier: String)
}

class NotificationsPostLikeTableViewCell: UITableViewCell {
    static let identifier: String = "NotificationsPostLikeTableViewCell"

    weak var delegate: NotificationsPostLikeTableViewCellDelegate?

    // This property for in the configure function save the post id
    var postID: String?

    // MARK: - Properties
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

    private let dateLabel: UILabel = {
        let label: UILabel = UILabel()
        label.numberOfLines = 1
        label.textColor = .secondaryLabel
        return label
    }()

    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        contentView.addSubview(postThumbnailImageView)
        contentView.addSubview(label)
        contentView.addSubview(dateLabel)
        selectionStyle = .none

        // make custom tap gesture, added at postThumbnailImageView
        postThumbnailImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapPost))
        postThumbnailImageView.addGestureRecognizer(tap)
    }

    @objc private func didTapPost() {
        guard let id = postID else {
            return
        }
        delegate?.notificationsPostLikeTableViewCell(self,
                                                     didTapPostWith: id)
        print("‼️in postLike - didTapPost is working‼️")
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        postThumbnailImageView.frame = CGRect(
            x: contentView.width - 50,
            y: 3,
            width: 50,
            height: contentView.height - 6
        )

        // labels is appropriate size between avatarImageView and followButton, so not used width and height
        label.sizeToFit()
        dateLabel.sizeToFit()

        let labelSize = label.sizeThatFits(
            CGSize(
                width: contentView.width - 10 - postThumbnailImageView.width - 5,
                height: contentView.height - 40
            )
        )

        label.frame = CGRect(
            x: 10,
            y: 0,
            width: labelSize.width,
            height: labelSize.height
        )

        dateLabel.frame = CGRect(
            x: 10,
            y: label.bottom + 3,
            width: contentView.width - postThumbnailImageView.width,
            height: 40
        )
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        postThumbnailImageView.image = nil
        label.text = nil
        dateLabel.text = nil
    }

    // MARK: - functions
    func configure(with postFileName: String, model: Notification) {
        postThumbnailImageView.image = UIImage(named: "test")
        label.text = model.text
        dateLabel.text = .date(with: model.date)
        // this is how actually gonna do reserve the post from the database
        postID = postFileName
    }
}
