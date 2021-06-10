//
//  ExploreResponse.swift
//  TikTok_Clone
//
//  Created by 김광준 on 2021/06/10.
//

import Foundation

// top level keys of json data
// have to match with top level key with json data
struct ExploreResponse: Codable {
    let banners: [Banners]
    let trendingPosts: [Post]
    let creators: [Creator]
    let recentPosts: [Post]
    let hashtags: [Hashtag]
    let popular: [Post]
    let recommended: [Post]
}
