//
//  Notifications.swift
//  TikTok_Clone
//
//  Created by 김광준 on 2021/05/20.
//

import Foundation

struct Notification {
    let text: String
    let date: Date
    
    static func mockData() -> [Notification] {
        return Array(0...100).compactMap({
            Notification(text: "Something happend: \($0)", date: Date())
        })
    }
}
