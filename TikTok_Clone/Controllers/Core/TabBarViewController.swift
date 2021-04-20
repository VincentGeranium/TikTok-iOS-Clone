//
//  TabBarViewController.swift
//  TikTok_Clone
//
//  Created by 김광준 on 2021/04/18.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .systemBackground
        setupControllers()
    }
    
    private func setupControllers() {
        let home = HomeViewController()
        let explore = ExploreViewController()
        let camera = CameraViewController()
        let notification = NotificationsViewController()
        let profile = ProfileViewController()
        
        home.title = "Home"
        explore.title = "Explore"
        notification.title = "Notifications"
        profile.title = "Profile"
        
        let nav1 = UINavigationController(rootViewController: home)
        let nav2 = UINavigationController(rootViewController: explore)
        let nav3 = UINavigationController(rootViewController: notification)
        let nav4 = UINavigationController(rootViewController: profile)
        
        nav1.tabBarItem = UITabBarItem(title: nil, image: UIImage.init(systemName: "house"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: nil, image: UIImage.init(systemName: "network"), tag: 2)
        camera.tabBarItem = UITabBarItem(title: nil, image: UIImage.init(systemName: "camera"), tag: 3)
        nav3.tabBarItem = UITabBarItem(title: nil, image: UIImage.init(systemName: "bell"), tag: 4)
        nav4.tabBarItem = UITabBarItem(title: nil, image: UIImage.init(systemName: "person.circle"), tag: 5)
        
        setViewControllers([nav1, nav2, camera, nav3, nav4], animated: false)
    }
    
}
