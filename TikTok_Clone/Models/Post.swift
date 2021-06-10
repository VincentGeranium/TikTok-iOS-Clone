//
//  Post.swift
//  TikTok_Clone
//
//  Created by 김광준 on 2021/06/10.
//

import Foundation

// trendingPosts, recentPosts, popular, recommended are sub model structure
struct Post: Codable {
    let id: String
    let image: String
    let caption: String
}
