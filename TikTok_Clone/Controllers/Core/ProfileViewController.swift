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
            PostCollectionViewCell.self,
            forCellWithReuseIdentifier: PostCollectionViewCell.identifier
        )
        return collection
    }()

    // MARK: - initialize posts property.
        // init by [PostModel] -> PostModel array
    private var posts = [PostModel]()

    // MARK: - initialize followers and following property.
        // init by [String] -> String array
    private var following = [String]()
    private var followers = [String]()

    private var isFollower: Bool = false

    // MARK: - Init
    // 각기 다른 유저의 데이터마다 새로운 vc가 아닌 재사용 vc를 위한 logic
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - Lifecycle
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
                /*
                 ‼️ UIImage의 initializer 중 named와 systemName은 완전히 다르다
                 "gear"를 named initializer로 만들었더니 계속 안보이는 bug가 발생했엇다.
                 systemName으로 바꿔 bug를 fix함
                 */
                image: UIImage(systemName: "gear"),
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


// MARK:- Extension : UICollectionViewDataSource
extension ProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // number of post
        return posts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // enth
        let postModel = posts[indexPath.row]
        // dequeue cell
        // c.f : reason of cast PostCollectionViewCell, want used configure function add on to it
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PostCollectionViewCell.identifier,
            for: indexPath
        ) as? PostCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: postModel)
        return cell
    }

    // anonymous somebody tapping post
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        // open the post

        // this haptic function is not aggressive vibration it's very common settle vibration
        // when user tap post for open the post, play vibartion
        HapticsManager.shared.vibrateForSelection()
            // get the post out of post collection here
        let post = posts[indexPath.row]

        // create postVC and passing in the Model for the post
        let vc = PostViewController(model: post)
        vc.delegate = self
        vc.title = "Video"
        navigationController?.pushViewController(vc, animated: true)
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

        // MARK: - DispatchGroup
            // concurrent, make two request by notify block -> network call, syncronized
        let group = DispatchGroup()

        // action twice (followers and following)
        group.enter()
        group.enter()
        group.enter()

        // setup getRelationships function call to the databaseManager
            // [weak self] is for retain cycle (don't want leak memory)
            // c.f : all of object have default value by strong.
        DatabaseManager.shared.getRelationships(for: user, type: .followers) { [weak self] followers in
            // defer is closure
                // defer is acting when before finished function
            defer {
                group.leave()
            }
            // retain these users
            self?.followers = followers
        }

        DatabaseManager.shared.getRelationships(for: user, type: .following) { [weak self] following in
            // defer is closure
                // defer is acting when before finished function
            defer {
                group.leave()
            }
            // retain these users
            self?.following = following
        }

        // Extend DispatchGroup here

        // user parameter value is who own this profile
        DatabaseManager.shared.isValidRelationship(
            for: user,
            type: .followers
        ) { [weak self] isFollower in
            defer {
                group.leave()
            }
            self?.isFollower = isFollower
        }

        // most important part of dispatch group is notify
        group.notify(queue: .main) {
            // excute after all this closure done?
            let viewModel = ProfileHeaderViewModel(
                avatarImageURL: self.user.profilePictureURL,
                followerCount: self.followers.count,
                followeingCount: self.following.count,
                // if "isFollowing" is false show to follow button and if is true show unfollow button
                isFollowing: self.isCurrentUserProfile ? nil : self.isFollower
            )

            header.configure(with: viewModel)

        }

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

        // this haptic function is not aggressive vibration it's very common settle vibration
        // when user tap edit button, play vibartion
        HapticsManager.shared.vibrateForSelection()
        // ‼️ have to check user name is lowercase or uppercase
        // when user name is lowercase or uppercae, different return value
        if isCurrentUserProfile {
            // open Edit Profile
            // present Edit Profile ViewController
            let vc = EditProfileViewController()
            let naviVC = UINavigationController(rootViewController: vc)
            self.present(naviVC, animated: true, completion: nil)
        } else {
            // Follow or unfollow current users profile that we are viewing
            if self.isFollower {
                // Unfollower
                DatabaseManager.shared.updateRelationship(for: user, follow: false) { [weak self] success in
                    if success {
                        DispatchQueue.main.async {
                            self?.isFollower = false
                            self?.collectionView.reloadData()
                        }
                    } else {
                        // if not success
                    }
                }
            } else {
                // Follower
                DatabaseManager.shared.updateRelationship(for: user, follow: true) { [weak self] success in
                    if success {
                        DispatchQueue.main.async {
                            self?.isFollower = true
                            self?.collectionView.reloadData()
                        }
                    } else {
                        // if not success
                    }
                }
            }
        }
    }

    func profileHeaderCollectionReusableView(_ header: ProfileHeaderCollectionReusableView, didTapfollowersButtonWith viewModel: ProfileHeaderViewModel) {
        // this haptic function is not aggressive vibration it's very common settle vibration
        // when user tap follow button, play vibartion
        HapticsManager.shared.vibrateForSelection()
        // setup originaly UserListViewController
        // type parameter is .followers and user parameter is give to current user of profile
        let vc = UserListViewController(type: .followers, user: user)
        vc.users = followers
        // push viewcontroller on to the stack with push call
        navigationController?.pushViewController(vc, animated: true)

    }

    func profileHeaderCollectionReusableView(_ header: ProfileHeaderCollectionReusableView, didTapfollowingButtonWith viewModel: ProfileHeaderViewModel) {
        // this haptic function is not aggressive vibration it's very common settle vibration
        // when user tap following button, play vibartion
        HapticsManager.shared.vibrateForSelection()
        // setup originaly UserListViewController
        // type parameter is .following and user parameter is give to current user of profile
        let vc = UserListViewController(type: .following, user: user)
        vc.users = following
        // push viewcontroller on to the stack with push call
        navigationController?.pushViewController(vc, animated: true)

    }

    func profileHeaderCollectionReusableView(_ header: ProfileHeaderCollectionReusableView, didTapAvatarFor viewModel: ProfileHeaderViewModel) {
        guard isCurrentUserProfile else {
            return
        }
        // this haptic function is not aggressive vibration it's very common settle vibration
        // did tap avatar function here
        HapticsManager.shared.vibrateForSelection()

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

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
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
                    // cacheing the downlodUrl for userDefault
                    UserDefaults.standard.setValue(downloadURL.absoluteString, forKey: "profile_picture_url")
                    // this haptic for success for update the profile image
                        // this is success case haptic
                    HapticsManager.shared.vibrate(for: .success)

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
                    // this haptic for failure for update the profile image
                        // this is failure case haptic
                    HapticsManager.shared.vibrate(for: .error)
                    ProgressHUD.showError("Failed to upload profile image")
                }
            }

        }
    }
}

// handel all the action
extension ProfileViewController: PostViewControllerDelegate {
    func postViewController(_ vc: PostViewController, didTapCommentButtonFor post: PostModel) {
        // present comments
    }

    func postViewController(_ vc: PostViewController, didTapProfileButtonFor post: PostModel) {
        // push another profile
    }

}
