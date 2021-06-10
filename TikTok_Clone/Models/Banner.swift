//
//  Banner.swift
//  TikTok_Clone
//
//  Created by 김광준 on 2021/06/10.
//

import Foundation

// It's not exactly same with each viewModels structure but have to match with json data
// banners's sub model structure
struct Banners: Codable {
    let id: String
    let image: String
    let title: String
    let action: String
}
