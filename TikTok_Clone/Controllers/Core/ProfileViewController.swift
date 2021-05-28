//
//  ProfileViewController.swift
//  TikTok_Clone
//
//  Created by 김광준 on 2021/04/18.
//

/*
 profile vc는 각기 다른 유저마다 계속 사용된다 그러므로 꾸준히 재사용되어야 하는 VC이다.
 각기 다른 유저마가 계속 새로운 profile vc를 만들 필요가 없다.
 */

import UIKit

class ProfileViewController: UIViewController {
    
    // local property
    let user: User
    
    // Primary view is collectionView
    private let collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collection: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .systemBackground
        collection.showsVerticalScrollIndicator = false
        collection.register(
            ProfileHeaderCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: ProfileHeaderCollectionReusableView.identifier
        )
        collection.register(
            UICollectionViewCell.self,
            forCellWithReuseIdentifier: "cell"
        )
        return collection
    }()
    
    // MARK:- Init
    // 각기 다른 유저의 데이터마다 새로운 vc가 아닌 재사용 vc를 위한 logic
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = user.userName.uppercased()
        self.view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let userName = UserDefaults.standard.string(forKey: "userName")?.uppercased() ?? "ME"
        if title == userName {
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                image: UIImage(named: "gear"),
                style: .done,
                target: self,
                action: #selector(didTapSettings)
            )
        }
    }
    
    @objc private func didTapSettings() {
        let vc = SettingViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // collectionView frame have to entire view, so make like this code
        collectionView.frame = view.bounds
    }
}

extension ProfileViewController: UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // one profile
        return 1
    }
    
}

extension ProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // number of post
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // dequeue cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .systemBlue
        return cell
    }
    
    // anonimous somebody tapping post
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        // open the post
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (view.width - 12) / 3
        return CGSize(width: width, height: width * 1.5)
    }
    
    // line spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    // lter item spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: ProfileHeaderCollectionReusableView.identifier,
                for: indexPath
              ) as? ProfileHeaderCollectionReusableView else {
            return UICollectionReusableView()
        }
        header.delegate = self
        // passing one of the viewModel
        let viewModel = ProfileHeaderViewModel(
            avatarImageURL: nil,
            followerCount: 120,
            followeingCount: 200,
            isFollowing: false
        )
        header.configure(with: viewModel)
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.width, height: 300)
    }
    
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    
}

// confirm the protocol
extension ProfileViewController: ProfileHeaderCollectionReusableViewDelegate {
    func profileHeaderCollectionReusableView(_ header: ProfileHeaderCollectionReusableView, didTapPrimaryButtonWith viewModel: ProfileHeaderViewModel) {
        guard let currentUserName = UserDefaults.standard.string(forKey: "userName") else {
            return
        }
        
        if self.user.userName == currentUserName {
            // open Edit Profile
        }
        else {
            // Follow or unfollow current users profile that we are viewing
        }
    }
    
    func profileHeaderCollectionReusableView(_ header: ProfileHeaderCollectionReusableView, didTapfollowersButtonWith viewModel: ProfileHeaderViewModel) {
        
    }
    
    func profileHeaderCollectionReusableView(_ header: ProfileHeaderCollectionReusableView, didTapfollowingButtonWith viewModel: ProfileHeaderViewModel) {
        
    }
    
    
}
