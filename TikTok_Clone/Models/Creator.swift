//
//  Creator.swift
//  TikTok_Clone
//
//  Created by 김광준 on 2021/06/10.
//

import Foundation

// creators sub model structure
struct Creator: Codable {
    let id: String
    let image: String
    let username: String
    let followers_count: Int
}
