//
//  ProfileHeaderCollectionReusableView.swift
//  TikTok_Clone
//
//  Created by 김광준 on 2021/05/26.
//

import SDWebImage
import UIKit

protocol ProfileHeaderCollectionReusableViewDelegate: AnyObject {
    func profileHeaderCollectionReusableView(_ header: ProfileHeaderCollectionReusableView,
                                             didTapPrimaryButtonWith viewModel: ProfileHeaderViewModel)
    func profileHeaderCollectionReusableView(_ header: ProfileHeaderCollectionReusableView,
                                             didTapfollowersButtonWith viewModel: ProfileHeaderViewModel)
    func profileHeaderCollectionReusableView(_ header: ProfileHeaderCollectionReusableView,
                                             didTapfollowingButtonWith viewModel: ProfileHeaderViewModel)
    func profileHeaderCollectionReusableView(_ header: ProfileHeaderCollectionReusableView,
                                             didTapAvatarFor viewModel: ProfileHeaderViewModel)
}

class ProfileHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier: String = "ProfileHeaderCollectionReusableView"
    
    weak var delegate: ProfileHeaderCollectionReusableViewDelegate?
    
    // viewModel
    var viewModel: ProfileHeaderViewModel?
    
    // MARK: - Subviews
    private let avatarImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .secondarySystemBackground
        return imageView
    }()
    
    // MARK: - Follow or Edit Profile
    private let primaryButton: UIButton = {
        let button: UIButton = UIButton()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 6
        // give to default title
        button.setTitle("Follow", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .systemPink
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        return button
    }()
    
    private let followersButton: UIButton = {
        let button: UIButton = UIButton()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 6
        // default title of followersButton
        button.setTitle("0\nFollowers", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.numberOfLines = 2
        button.backgroundColor = .secondarySystemBackground
        return button
    }()
    
    private let followingButton: UIButton = {
        let button: UIButton = UIButton()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 6
        // set the following button default title
        button.setTitle("0\nFollowing", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.numberOfLines = 2
        button.backgroundColor = .secondarySystemBackground
        return button
    }()
    
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        backgroundColor = .systemBackground
        // add SubViews
        addedSubviews()
        configureButtons()
        
        // MARK:- UITapGestureRecognize
        // give the tap gesture to avatarImageView
        // c.f : two methods are different, between "UIGestureRecognizer" and "UITapGestureRecognizer"
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapAvatar))
        avatarImageView.isUserInteractionEnabled = true
        avatarImageView.addGestureRecognizer(tap)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    @objc private func didTapAvatar() {
        guard let viewModel = viewModel else {
            return
        }
        delegate?.profileHeaderCollectionReusableView(self,
                                                      didTapAvatarFor: viewModel)
    }
    
    // MARK:- addSubviews function
    // addSubview all the objects
    private func addedSubviews() {
        addSubview(avatarImageView)
        addSubview(primaryButton)
        addSubview(followersButton)
        addSubview(followingButton)
    }
    
    // MARK:- configure buttons
    // hook up the action all buttons
    private func configureButtons() {
        primaryButton.addTarget(self, action: #selector(didTapPrimaryButton), for: .touchUpInside)
        followersButton.addTarget(self, action: #selector(didTapFollowersButton), for: .touchUpInside)
        followingButton.addTarget(self, action: #selector(didTapFollowingButton), for: .touchUpInside)
    }
    
    // MARK: - View layout Methods
    override func layoutSubviews() {
        super.layoutSubviews()
        setupAvatarImageView()
        setupFollowersAndFollowingButton()
        setupPrimaryButton()
    }
    
    private func setupAvatarImageView() {
        // give size of imageView
        // we know the height of header is 300
        // so, made hard code value
        
        // one by one aspectRatio
        let avatarSize: CGFloat = 130
        
        // c.f : value of x will be center
        avatarImageView.frame = CGRect(
            x: (width - avatarSize) / 2,
            y: 5,
            width: avatarSize,
            height: avatarSize
        )
        
        avatarImageView.layer.cornerRadius = avatarImageView.height / 2
    }
    
    private func setupFollowersAndFollowingButton() {
        followersButton.frame = CGRect(x: (width - 210) / 2, y: avatarImageView.bottom + 10, width: 100, height: 70)
        followingButton.frame = CGRect(x: followersButton.right + 10, y: avatarImageView.bottom + 10, width: 100, height: 70)
    }
    
    private func setupPrimaryButton() {
        // c.f : iOS button average height size is 44
        primaryButton.frame = CGRect(x: (width - 220) / 2, y: followingButton.bottom + 15, width: 220, height: 44)
    }
    
    // MARK:- All the buttons action functions
    // hook up delegate
    @objc private func didTapPrimaryButton() {
        guard let viewModel = self.viewModel else {
            return
        }
        delegate?.profileHeaderCollectionReusableView(self,
                                                      didTapPrimaryButtonWith: viewModel)
    }
    
    @objc private func didTapFollowersButton() {
        guard let viewModel = self.viewModel else {
            return
        }
        delegate?.profileHeaderCollectionReusableView(self,
                                                      didTapfollowersButtonWith: viewModel)
        
    }
    
    @objc private func didTapFollowingButton() {
        guard let viewModel = self.viewModel else {
            return
        }
        delegate?.profileHeaderCollectionReusableView(self,
                                                      didTapfollowingButtonWith: viewModel)
    }
    
    // MARK: - confiure viewModel(ProfileHeaderViewModel)
    // about configure viewModel functions
    func configure(with viewModel: ProfileHeaderViewModel) {
        // retain the viewModel code
        self.viewModel = viewModel
        
        // set up our header
        // configure stuff
        followersButton.setTitle("\(viewModel.followerCount)\nFollowers", for: .normal)
        followingButton.setTitle("\(viewModel.followeingCount)\nFollowing", for: .normal)
        
        if let avatarURL = viewModel.avatarImageURL {
            // downloaded image and asign it
            // SDWebImage actually take care of all the cacheing image, good stuff for us
            avatarImageView.sd_setImage(with: avatarURL, completed: nil)
        }
        else {
            avatarImageView.image = UIImage(named: "test")
        }
        
        if let isFollowing = viewModel.isFollowing {
            // isFollowing valuse is not nil
            primaryButton.backgroundColor = isFollowing ? .secondarySystemBackground : .systemPink
            // if isFollowing value is true title is "Unfollow" else false "Follow"
            primaryButton.setTitle(isFollowing ? "Unfollow" : "Follow", for: .normal)
        }
        else {
            // isFollowing valuse is nil
            primaryButton.backgroundColor = .secondarySystemBackground
            primaryButton.setTitle("Edit Profile", for: .normal)
        }
    }
    
}
