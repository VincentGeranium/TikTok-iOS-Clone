//
//  ProfileHeaderCollectionReusableView.swift
//  TikTok_Clone
//
//  Created by 김광준 on 2021/05/26.
//

import UIKit

class ProfileHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier: String = "ProfileHeaderCollectionReusableView"
    
    
    // MARK:- Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
