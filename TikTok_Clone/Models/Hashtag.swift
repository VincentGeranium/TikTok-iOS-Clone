//
//  Hashtag.swift
//  TikTok_Clone
//
//  Created by 김광준 on 2021/06/10.
//

import Foundation

// hastags sub model structure
struct Hashtag: Codable {
    let image: String
    let tag: String
    let count: Int
}
