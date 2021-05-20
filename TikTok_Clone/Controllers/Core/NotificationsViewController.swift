//
//  NotificationsViewController.swift
//  TikTok_Clone
//
//  Created by 김광준 on 2021/04/18.
//

// interface and protocol is interchangeable use

import UIKit

class NotificationsViewController: UIViewController {
    // make label for no notification
    // hidden to case by case
    private let noNotificationLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = .secondaryLabel
        label.text = "no notification"
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    // explore different type of cell and tableView
    private let tableView: UITableView = {
        let tableView: UITableView = UITableView()
        tableView.isHidden = true
        tableView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: "cell"
        )
        return tableView
    }()
    
    // make spinner used apple own framework
    // but at CaptionVC make spinner useing ProgressHUD(another framework, not apple)
    private let spinner: UIActivityIndicatorView = {
        let spinner: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
        spinner.tintColor = .label
        spinner.startAnimating()
        return spinner
    }()
    
    var notifications = [Notification]()
    
    // MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        view.addSubview(noNotificationLabel)
        view.addSubview(spinner
        )
        self.view.backgroundColor = .systemBackground
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // get all result(label and tableview)
        fetchNotifications()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        
        noNotificationLabel.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        // for calculate??
        noNotificationLabel.center = view.center
        
        spinner.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        spinner.center = view.center
    }
    
    // MARK:- Functions
    
    // why fetch??
        // -> for show spinner to user.
        // user want to know about progressing.
    func fetchNotifications() {
        DatabaseManager.shared.getNotification { [weak self] notifications in
            DispatchQueue.main.async {
                self?.spinner.stopAnimating()
                self?.spinner.isHidden = true
                self?.notifications = notifications
                self?.updateUI()
            }
        }
    }
    
    func updateUI() {
        if notifications.isEmpty {
            noNotificationLabel.isHidden = false
            tableView.isHidden = true
        }
        else {
            noNotificationLabel.isHidden = true
            tableView.isHidden = false
        }
        tableView.reloadData()
    }
    
    
}


// in the lecture delegate and datasource are not make used extension but i made used by extension
extension NotificationsViewController: UITableViewDelegate, UITableViewDataSource {
    // func for tableview
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // get the actual model out
        // indexpath.row = position
        let model = notifications[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = model.text
        return cell
    }
    
    
}
