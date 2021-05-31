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

import ProgressHUD
import UIKit

class ProfileViewController: UIViewController {
    
    // two type of picker
    // make by enum
    enum PicturePickerType {
        case camera
        case photoLibrary
    }
    
    // this property for user is current user confirm
    // when checked the user who sign into that function is used over and over(one of the base)
    // so make computed property
    var isCurrentUserProfile: Bool {
        if let userName = UserDefaults.standard.string(forKey: "userName") {
            // user name을 가져올 때 uppper case로 되어있어서 didTapAvatarFor 메소드의 isCurrentUserProfile이후 코드 진행이 안되는 bug가 발생
            // lowercase로 fix
            return user.userName.lowercased() == userName.lowercased()
        }
        return false
    }
    
    
    // local property
    var user: User
    
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
    
    private var posts = [PostModel]()
    
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
        // fetchPost method
        fetchPosts()
    }
    
    func fetchPosts() {
        // get current user
    
        DatabaseManager.shared.getPosts(for: user) { [weak self] postsModel in
            DispatchQueue.main.async {
                self?.posts = postsModel
                self?.collectionView.reloadData()
            }
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
    // delete numberOfSections() -> because 1 by default value
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        // one profile
//        return 1
//    }

}

extension ProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // number of post
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // enth
        let postModel = posts[indexPath.row]
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
        
        let viewModel = ProfileHeaderViewModel(
            avatarImageURL: user.profilePictureURL,
            followerCount: 100,
            followeingCount: 120,
            isFollowing: isCurrentUserProfile ? nil : false
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
    
    func profileHeaderCollectionReusableView(_ header: ProfileHeaderCollectionReusableView, didTapAvatarFor viewModel: ProfileHeaderViewModel) {
        guard isCurrentUserProfile else {
            return
        }
        
        let actionSheet = UIAlertController(title: "Profile Picture", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            DispatchQueue.main.async {
                self.presentProfilePicturePicker(type: .camera)
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { _ in
            self.presentProfilePicturePicker(type: .photoLibrary)
        }))
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    func presentProfilePicturePicker(type: PicturePickerType) {
        let picker = UIImagePickerController()
        picker.sourceType = type == .camera ? .camera : .photoLibrary
        picker.delegate = self
        // info dictionary에서 가져온 이미지를 편집하기 위해
        // c.f : info dic은 extension내에 method에서 찾을 수 있다
            //  didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        
        // progress show, this is not apple own framework
        ProgressHUD.show("Uploading")
        // upload and uopdate UI
        StorageManager.shared.uploadProfilePicture(with: image) { [weak self] result in
            DispatchQueue.main.async {
                // unwrap weak self
                guard let strongSelf = self else {
                    return
                }
                switch result {
                case .success(let downloadURL):
                    //cacheing the downlodUrl for userDefault
                    UserDefaults.standard.setValue(downloadURL.absoluteString, forKey: "profile_picture_url")
                    
                    // reasign the user
                    // reload the actual collectionView for reasign the user
                    // recreate the header -> show new uploaded picture
                    strongSelf.user = User(
                        userName: strongSelf.user.userName,
                        profilePictureURL: downloadURL,
                        identifier: strongSelf.user.userName
                    )
                    strongSelf.collectionView.reloadData()
                    ProgressHUD.showSuccess("Updated!")
                case .failure:
                    ProgressHUD.showError("Failed to upload profile image")
                }
            }
            
        }
    }
}
