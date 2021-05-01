//
//  PostModel.swift
//  TikTok_Clone
//
//  Created by 김광준 on 2021/04/22.
//

import Foundation

struct PostModel {
    let identifier: String
    
    // mock user data
    let user: User = User(
        userName: "Jun",
        profilePictureURL: nil,
        identifier: UUID().uuidString
    )
    
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
