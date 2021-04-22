//
//  PostViewController.swift
//  TikTok_Clone
//
//  Created by 김광준 on 2021/04/18.
//

import UIKit

class PostViewController: UIViewController {
    
    let model: PostModel
    
    init(model: PostModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // make random background color for test
        let colors: [UIColor] = [
            .red, .blue, .white, .systemPink, .gray, .orange, .green
        ]
        
        view.backgroundColor = colors.randomElement()
        
    }
    

    
}
