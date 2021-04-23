//
//  PostModel.swift
//  TikTok_Clone
//
//  Created by 김광준 on 2021/04/22.
//

import Foundation

struct PostModel {
    let identifier: String
    
    var isLikedByCurrentUsers = false
    
    static func mockModel() -> [PostModel] {
        var posts = [PostModel]()
        for _ in 0...100 {
            let post = PostModel(identifier: UUID().uuidString)
            posts.append(post)
        }
        return posts
    }
}
