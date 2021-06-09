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

// can make mutating method but more simple way is make class
// so, structure Notification changed by class
class Notification {
    var identifier = UUID().uuidString
    var isHidden = false
    let text: String
    let type: NotificationType
    let date: Date

    init(text: String, type: NotificationType, date: Date) {
        self.text = text
        self.type = type
        self.date = date
    }

    static func mockData() -> [Notification] {
        let first = Array(0...5).compactMap({
            Notification(
                text: "Something happend: \($0)",
                type: .postLike(postName: "여빈is Like your post"),
                date: Date()
            )
        })

        let second = Array(0...5).compactMap({
            Notification(
                text: "Something happend: \($0)",
                type: .userFollow(userName: "김여빈"),
                date: Date()
            )
        })

        let third = Array(0...5).compactMap({
            Notification(
                text: "Something happend: \($0)",
                type: .postComment(postName: "hello i wanna meet you"),
                date: Date()
            )
        })

        return first + second + third
    }
}
