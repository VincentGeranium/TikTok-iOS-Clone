//
//  User.swift
//  TikTok_Clone
//
//  Created by 김광준 on 2021/04/30.
//

import Foundation

// user를 대표하는 것 이므로 user 관련된 인스턴스들을 만들어 struct 안에 넣어주어야 함.
struct User {
    let userName: String
    let profilePictureURL: URL?
    let identifier: String
}
