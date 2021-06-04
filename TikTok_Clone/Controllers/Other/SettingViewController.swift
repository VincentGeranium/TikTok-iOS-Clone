//
//  SettingViewController.swift
//  TikTok_Clone
//
//  Created by 김광준 on 2021/04/18.
//

// make Sign out ui -> make table view and make sign out button at tableview footer

import UIKit

class SettingViewController: UIViewController {
    
    private let tableView: UITableView = {
        let table: UITableView = UITableView(frame: .zero, style: .grouped)
        table.register(
            UITableViewCell.self,
            forCellReuseIdentifier: "cell"
        )
        return table
    }()
    
    // for configure
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        createFooter()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func createFooter() {
        // make footer view
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: 100))
        
        // make sign out button
            // y = 25 means center
        let button = UIButton(frame: CGRect(x: (view.width - 200)/2, y: 25, width: 200, height: 50))
        button.setTitle("Sign Out", for: .normal)
        button.addTarget(self, action: #selector(didTapSignButton), for: .touchUpInside)
        button.setTitleColor(.systemRed, for: .normal)
        
        // added button in the tableFooterView
        footer.addSubview(button)
        // added footer instance in table view footer
            // c.f : tabelFooterView is instance property of uitableview and tableFooterView's parents is UIView.
        tableView.tableFooterView = footer
    }
    
    @objc private func didTapSignButton() {
        // make action sheet for confirm sign out and show that to user
        let actionSheet = UIAlertController(
            title: "Sign Out",
            message: "Would you like to sign out?",
            preferredStyle: .actionSheet
        )
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { [weak self] _ in
            // used sign out method from AuthManager
            DispatchQueue.main.async {
                AuthManager.shared.signOut { success in
                    if success {
                        // show the log in view(the first view)
                        
                        // 1. read userdefault
                        UserDefaults.standard.setValue(nil, forKey: "userName")
                        UserDefaults.standard.setValue(nil, forKey: "profile_picture_url")
                        
                        // 2. present log in screen
                        let vc = SignInViewController()
                        
                        // 3. wrap the signinVC used by navigationVC
                        let naviVC = UINavigationController(rootViewController: vc)
                        naviVC.modalPresentationStyle = .fullScreen
                        
                        // 4. present used modal
                        self?.present(naviVC, animated: true, completion: nil)
                        
                        // reset all things
                        // index = 0 means back to main feed?
                        self?.navigationController?.popToRootViewController(animated: true)
                        self?.tabBarController?.selectedIndex = 0
                    }
                    else {
                        // failed
                        let alert = UIAlertController(
                            title: "Error !",
                            message: "Something went wrong when signing out. Please try again.",
                            preferredStyle: .alert
                        )
                        
                        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                        self?.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }))
        
        present(actionSheet, animated: true, completion: nil)
    }
    
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Hello World"
        return cell
    }
}
