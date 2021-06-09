//
//  CommentTableViewCell.swift
//  TikTok_Clone
//
//  Created by 김광준 on 2021/04/30.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    // cell indentifier
    static let identifier: String = "CommentTableViewCell"

    private let avatarImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.clipsToBounds = true
        // for the cornerRadius
        imageView.layer.masksToBounds = true
        return imageView
    }()

    // user comment
    private let commentLabel: UILabel = {
        let label: UILabel = UILabel()
        label.numberOfLines = 0
        label.textColor = .label
        return label
    }()

    private let dateLabel: UILabel = {
        let label: UILabel = UILabel()
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        return label
    }()

    // MARK: - init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        clipsToBounds = true
        backgroundColor = .secondarySystemBackground
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(avatarImageView)
        contentView.addSubview(commentLabel)
        contentView.addSubview(dateLabel)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        commentLabel.sizeToFit()
        dateLabel.sizeToFit()

        // Assign frames
        // layout actuall cell
        /*
         autolayou을 할 때 코드의 순서가 중요하다, 기준이 되는 것을 잘 확인하고 ui를 그려야한다.
         */
        let imageSize: CGFloat = 44
        avatarImageView.frame = CGRect(
            x: 10,
            y: 5,
            width: imageSize,
            height: imageSize
        )

        let commentLabelHeight = min(contentView.height - dateLabel.top, commentLabel.height)
        commentLabel.frame = CGRect(
            x: avatarImageView.right + 10,
            y: 5,
            width: contentView.width - avatarImageView.right - 10,
            height: commentLabelHeight
        )

        dateLabel.frame = CGRect(
            x: avatarImageView.right + 10,
            y: commentLabel.bottom,
            width: dateLabel.width,
            height: dateLabel.height
        )
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        // for reset
        commentLabel.text = nil
        dateLabel.text = nil
        avatarImageView.image = nil
    }

    // for configure comment
    public func configure(with model: PostComment) {
        commentLabel.text = model.text
        dateLabel.text = .date(with: model.date)

        if let url = model.user.profilePictureURL {
            print(url)
        } else {
            avatarImageView.image = UIImage(systemName: "person.circle")
        }

    }
}
