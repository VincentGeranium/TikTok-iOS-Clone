//
//  Notifications.swift
//  TikTok_Clone
//
//  Created by 김광준 on 2021/05/20.
//

import Foundation

enum NotificationType {
    // associated with viewModels, types
    case postLike(postName: String)
    case userFollow(userName: String)
    case postComment(postName: String)
    
    // Reason of why make identifier
        // in datebase stored(postLike, userFollow, postComment) have each of the string
        // that is how to we content out what we wanna put into the actual viewModel and type of notification
    var id: String {
        switch self {
        case .postLike: return "postLike"
        case .userFollow: return "userFollow"
        case .postComment: return "postComment"
        }
    }
}

struct Notification {
    let text: String
    let type: NotificationType
    let date: Date
    
    static func mockData() -> [Notification] {
        return Array(0...100).compactMap({
            Notification(
                text: "Something happend: \($0)",
                type: .userFollow(userName: "Geek Chic Jun"),
                date: Date()
            )
        })
    }
}
