//
//  PostComment.swift
//  TikTok_Clone
//
//  Created by 김광준 on 2021/04/30.
//

import Foundation

struct PostComment {
    let text: String
    let user: User
    let date: Date

    static func mockComment() -> [PostComment] {
        let user = User(
            userName: "Jun",
            profilePictureURL: nil,
            identifier: UUID().uuidString)

        var comments = [PostComment]()

        let text = [
            "This is dummy date",
            "From the Model Folder",
            "And this file name is PostComment.swift",
            "Also this is from mockComment method",
            "In the PostComment Structure"
        ]

        for comment in text {
            comments.append(
                PostComment(text: comment,
                            user: user,
                            date: Date()
                )
            )
        }
        return comments
    }
}
