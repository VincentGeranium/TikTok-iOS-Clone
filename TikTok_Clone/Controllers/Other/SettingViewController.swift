//
//  SettingViewController.swift
//  TikTok_Clone
//
//  Created by 김광준 on 2021/04/18.
//

import Appirater
// make Sign out ui -> make table view and make sign out button at tableview footer
import SafariServices
import UIKit

class SettingViewController: UIViewController {

    private let tableView: UITableView = {
        let table: UITableView = UITableView(frame: .zero, style: .grouped)
        table.register(
            UITableViewCell.self,
            forCellReuseIdentifier: "cell"
        )
        table.register(
            SwitchTableViewCell.self,
            forCellReuseIdentifier: SwitchTableViewCell.identifire
        )
        return table
    }()

    var sections = [SettingsSection]()

    // for configure
    override func viewDidLoad() {
        super.viewDidLoad()

        sections = [
            SettingsSection(
                title: "Preferences",
                options: [
                    SettingsOption(title: "Save Videos", handler: {})
                ]
            ),
            SettingsSection(
                title: "Enjoying the app?",
                options: [
                    SettingsOption(title: "Rate App", handler: { [weak self] in
                        DispatchQueue.main.async {
                            // this is for show prompt
                            // because we are not published app yet
                            // actually this can be saying to mock data
                            Appirater.tryToShowPrompt()
//                            Appirater.tryToShowPrompt()
                            // url -> put in publish app url
//                            UIApplication.shared.open(URL(string: ""), options: [:], completionHandler: nil)
                        }

                    }),
                    SettingsOption(title: "Share App", handler: { [weak self] in
                        DispatchQueue.main.async {
                            // Actually when developer published app and get the URL Directly and Share the app
                            // But we aren't published, so make share function another way.
                            guard let url = URL(string: "https://www.facebook.com") else {
                                return
                            }
                            
                            let vc = UIActivityViewController(
                                activityItems: [url],
                                applicationActivities: []
                            )
                            
                            self?.present(vc, animated: true, completion: nil)
                        }
                        
                    })
                ]
            ),
            SettingsSection(
                title: "Information",
                options: [
                    SettingsOption(title: "Terms of Service", handler: { [weak self] in
                        DispatchQueue.main.async {
                            guard let url = URL(string: "https://www.tiktok.com/legal/terms-of-service") else {
                                return
                            }
                            let vc = SFSafariViewController(url: url)
                            self?.present(vc, animated: true, completion: nil)
                        }
                    }),
                    SettingsOption(title: "Privacy Policy", handler: { [weak self] in
                        DispatchQueue.main.async {
                            guard let url = URL(string: "https://www.tiktok.com/legal/privacy-policy") else {
                                return
                            }
                            let vc = SFSafariViewController(url: url)
                            self?.present(vc, animated: true, completion: nil)
                        }
                    })
                ]
            )
        ]

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
                    } else {
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

// MARK: - SettingViewController Extension about TableViewDelegate, TableViewDataSource
extension SettingViewController: UITableViewDelegate, UITableViewDataSource {

    // return the number of section in the table view
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    // return number of rows in a given section of a table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].options.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = sections[indexPath.section].options[indexPath.row]

        // c.f : model title과 미리 만들어 둔 Setting Option's title이 다르면 원하는 Switch가 나타나지 않는다. 주의!!
        if model.title == "Save Videos" {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SwitchTableViewCell.identifire,
                for: indexPath
            ) as? SwitchTableViewCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            cell.configure(with: SwitchCellViewModel(title: model.title, isOn: UserDefaults.standard.bool(forKey: "save_video")))
            return cell
        }

        let cell = tableView.dequeueReusableCell(
            withIdentifier: "cell",
            for: indexPath
        )

        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = model.title
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = sections[indexPath.section].options[indexPath.row]
        model.handler()
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
}

extension SettingViewController: SwitchTableViewCellDelegate {
    func switchTableViewCell(_ cell: SwitchTableViewCell, didUpdateSwitchTo isOn: Bool) {
        // haptic call when switch button
        HapticsManager.shared.vibrateForSelection()
//        print(isOn)

        UserDefaults.standard.setValue(isOn, forKey: "save_video")
    }

}
