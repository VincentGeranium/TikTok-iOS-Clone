//
//  CaptionViewController.swift
//  TikTok_Clone
//
//  Created by 김광준 on 2021/05/17.
//

import UIKit

class CaptionViewController: UIViewController {
    
    // for vaild url
    
    let videoURL: URL
    
    // MARK:- Lifecycle
    init(videoURL: URL) {
        self.videoURL = videoURL
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add Caption"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post", style: .done, target: self, action: #selector(didTapPost))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    // MARK:- func
    @objc private func didTapPost() {
        
    }
}
