//
//  PostModel.swift
//  TikTok_Clone
//
//  Created by 김광준 on 2021/04/22.
//

import Foundation

struct PostModel {
    let identifier: String
    
    // create user every time
    let user: User
    
    var fileName: String = ""
    var caption: String = ""
    
    var isLikedByCurrentUsers = false
    
    static func mockModel() -> [PostModel] {
        var posts = [PostModel]()
        for _ in 0...100 {
            let post = PostModel(
                identifier: UUID().uuidString,
                // this is dummy user data
                user: User(
                    userName: "Jun",
                    profilePictureURL: nil,
                    identifier: UUID().uuidString
                )
            )
            posts.append(post)
        }
        return posts
    }
}
