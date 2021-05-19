//
//  TabBarViewController.swift
//  TikTok_Clone
//
//  Created by 김광준 on 2021/04/18.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    private var signInPresented = false

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .systemBackground
        setupControllers()
    }
    
    // user 의 sign in, sign up 관련하여 tabBarController가 SignInVC, SignUpVC를 관리하고 띄워야 하므로 viewDidAppear에 관련된 로직, 코드를 작성한다.
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !signInPresented {
            presentSignInIfNeeded()
        }
    }
    
    private func presentSignInIfNeeded() {
        // user sign in validation이 false일 경우 sign in vc를 띄운다.
        if !AuthManager.shared.isSignedIn {
            signInPresented = true
            let vc = SignInViewController()
            // dismiss 하기 위한 comlition을 만들고 그에 대한 logic을 짜서 넣는다.
            // user가 sign in 이 되어 있다면 아에 띄우지 않는다.
            vc.complition = { [weak self] in
                self?.signInPresented = false
            }
            let naviVC = UINavigationController(rootViewController: vc)
            naviVC.modalPresentationStyle = .fullScreen
            present(naviVC, animated: false, completion: nil)
        }
    }
    
    private func setupControllers() {
        let home = HomeViewController()
        let explore = ExploreViewController()
        let camera = CameraViewController()
        let notification = NotificationsViewController()
        let profile = ProfileViewController(
            user: User(userName: "self",
                       profilePictureURL: nil,
                       identifier: "abc123"
            ))
        
        
        notification.title = "Notifications"
        profile.title = "Profile"
        
        let nav1 = UINavigationController(rootViewController: home)
        let nav2 = UINavigationController(rootViewController: explore)
        let nav3 = UINavigationController(rootViewController: notification)
        let nav4 = UINavigationController(rootViewController: profile)
        let cameraNav = UINavigationController(rootViewController: camera)
        
        
        // segmentcontrol이 있는 상단 부분을 약간의 트릭으로 투명하게 만드는 로직.
        nav1.navigationBar.backgroundColor = .clear
        nav1.navigationBar.setBackgroundImage(UIImage(), for: .default)
        nav1.navigationBar.shadowImage = UIImage()
        
        // setup cameraNav
        cameraNav.navigationBar.backgroundColor = .clear
        cameraNav.navigationBar.setBackgroundImage(UIImage(), for: .default)
        cameraNav.navigationBar.shadowImage = UIImage()
        cameraNav.navigationBar.tintColor = .white
        
        nav1.tabBarItem = UITabBarItem(title: nil, image: UIImage.init(systemName: "house"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: nil, image: UIImage.init(systemName: "network"), tag: 2)
        camera.tabBarItem = UITabBarItem(title: nil, image: UIImage.init(systemName: "camera"), tag: 3)
        nav3.tabBarItem = UITabBarItem(title: nil, image: UIImage.init(systemName: "bell"), tag: 4)
        nav4.tabBarItem = UITabBarItem(title: nil, image: UIImage.init(systemName: "person.circle"), tag: 5)
        
        setViewControllers([nav1, nav2, cameraNav, nav3, nav4], animated: false)
    }
    
}
