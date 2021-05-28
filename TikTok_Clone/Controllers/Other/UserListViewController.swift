//
//  UserListViewController.swift
//  TikTok_Clone
//
//  Created by 김광준 on 2021/04/18.
//

import UIKit

class UserListViewController: UIViewController {
    
    // tableview is responsable showing followers and following
    let tableView: UITableView = {
        let tableView: UITableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    enum ListType {
        case followers
        case following
    }
    
    let user: User
    let type: ListType
    
    init(type: ListType, user: User) {
        self.type = type
        self.user = user
        /*
         super.init(nibName: nil, bundle: nil)의 위치에 따라 user, type의 프로퍼티가 let, var로 달라진다.
         그 이유가 무엇인지 공부 할 필요가 있다.
         만약 super.init(nibName: nil, bundle: nil)가 self.type = type 과 self.user = user의 위에 위치 할 경우
         var user: User, var type: ListType로 해야한다는 error가 나온다.
         */
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        switch type {
        case .followers: title = "Followers"
        case .following: title = "Following"
        }
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

}

// require functions
// confirm the tableview protocols
extension UserListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                 for: indexPath)
        cell.textLabel?.text = "UserListVC Test"
        return cell
    }
    
    
}
