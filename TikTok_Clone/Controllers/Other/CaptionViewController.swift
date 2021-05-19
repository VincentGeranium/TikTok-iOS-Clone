//
//  CaptionViewController.swift
//  TikTok_Clone
//
//  Created by 김광준 on 2021/05/17.
//

// this framwork is not apple basic framework
// this framework for make spiner for simple code.
import ProgressHUD

import UIKit

class CaptionViewController: UIViewController {
    
    // for vaild url
    let videoURL: URL
    
    private let captionTextView: UITextView = {
        let textView  = UITextView()
        textView.contentInset = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        textView.backgroundColor = .secondarySystemBackground
        textView.layer.masksToBounds = true
        textView.layer.cornerRadius = 8
        return textView
    }()
    
    // MARK:- init
    init(videoURL: URL) {
        self.videoURL = videoURL
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add Caption"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post", style: .done, target: self, action: #selector(didTapPost))
        
        // added textView in view hierarchy.
        view.addSubview(captionTextView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // textView frame
        captionTextView.frame = CGRect(x: 5, y: view.safeAreaInsets.top+5, width: view.width-10, height: 150).integral
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // pop up the keyboard by default
        captionTextView.becomeFirstResponder()
    }
    
    // MARK:- func
    @objc private func didTapPost() {
        captionTextView.resignFirstResponder()
        
        let caption = captionTextView.text ?? ""
        
        // Generate a video name that is unique based on id
        let newVideoName = StorageManager.shared.generateVideoName()
        
        // if user hit the post button, show progress spiner
        ProgressHUD.show("Posting")
        
        // Upload the video
        StorageManager.shared.uploadVideo(from: videoURL, fileName: newVideoName) { [weak self] success in
            DispatchQueue.main.async {
                if success {
                    // Updata Database
                    DatabaseManager.shared.insertPost(fileName: newVideoName, caption: caption) { databaseUpdated in
                        if databaseUpdated {
                            // Vibrate when post is success
                            HapticsManager.shared.vibrate(for: .success)
                            
                            // Dismiss ProgressHUD when is success
                            ProgressHUD.dismiss()
                            
                            // after success update
                            // Reset camera and Switch to feed
                            self?.navigationController?.popToRootViewController(animated: true)
                            // dismiss CaptionViewController also go ahead changed tab back to the first tab.
                            self?.tabBarController?.selectedIndex = 0
                            // unhide tabBar
                            self?.tabBarController?.tabBar.isHidden = false
                        }
                        else {
                            // Vibrate when post is error
                            HapticsManager.shared.vibrate(for: .error)
                            
                            // Dismiss ProgressHUD when is error(database)
                            ProgressHUD.dismiss()
                            // alert
                            let alert = UIAlertController(
                                title: "Woops",
                                message: "We were unable to upload your video. Please try again.",
                                preferredStyle: .alert
                            )
                            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                            self?.present(alert, animated: true, completion: nil)
                        }
                    }
                }
                else {
                    // Vibrate when post is error
                    HapticsManager.shared.vibrate(for: .error)
                    
                    // Dismiss ProgressHUD when is error(storage)
                    ProgressHUD.dismiss()
                    // alert
                    let alert = UIAlertController(
                        title: "Woops",
                        message: "We were unable to upload your video. Please try again.",
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
}
