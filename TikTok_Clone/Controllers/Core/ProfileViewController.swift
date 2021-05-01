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
    
    // 각기 다른 유저의 데이터마다 새로운 vc가 아닌 재사용 vc를 위한 logic
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = user.userName.uppercased()
        self.view.backgroundColor = .systemBackground
    }
    

    }
