//
//  TikTok_CloneTests.swift
//  TikTok_CloneTests
//
//  Created by 김광준 on 2021/06/10.
//

// c.f command + u  is play unit test -> short command

import XCTest

// first of all install "TikTok_CloneTests" podfile same things with original app.
// and we have to import module what we wanna testing.
@testable import TikTok_Clone

class TikTok_CloneTests: XCTestCase {
    // Write the Basic code in down here
    
    // this is very basic unit test code
    func testPostModel() {
        // we are gonna test the videoChildPath of postModel
        let id = UUID().uuidString
        let user = User(
            userName: "Hollys",
            profilePictureURL: nil,
            identifier: "123"
        )
        var post = PostModel(
            identifier: id,
            user: user
        )
        // XCTAssert have lots of testing method. so, read the document and find, select what u want.
        XCTAssertTrue(post.caption.isEmpty)
        post.caption = "Can u give your number?"
        XCTAssertFalse(post.caption.isEmpty)
        XCTAssertEqual(post.caption, "Can u give your number?")
        
        XCTAssertEqual(post.videoChildPath, "videos/hollys/")
    }
}
