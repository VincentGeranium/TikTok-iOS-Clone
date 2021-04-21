//
//  DatabaseManager.swift
//  TikTok_Clone
//
//  Created by 김광준 on 2021/04/18.
//
// 데이터베이스로 부터 여러 정보를 받아오기 위한 것.


import Foundation
import FirebaseDatabase

final class DatabaseManager {
    public static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
    private init() {}
    
    // Public
    
    public func getAllUsers(completion: ([String]) -> Void) {
        
    }
}
