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
    
    public func insertUser(with email: String, userName: String, completion: @escaping (Bool) -> Void) {
        /*
         schema of user data
         
         users : {
            "userName" : {
                email,
                posts : []
            }
         }
         */
        
        // get current users key
        // insert new entry
        // create root user
        // enter new one
        database.child("users").observeSingleEvent(of: .value) { [weak self] snapshot in
            // for debugging what is in the value
//            print(snapshot.value)
            
            guard var userDictionary = snapshot.value as? [String : Any] else {
                
                self?.database.child("users").setValue(
                    [
                        userName : [
                            "email" : email
                        ]
                    ]
                ) { error, _ in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    completion(true)
                }
                return
            }
            
            userDictionary[userName] = ["email" : email]
            
            // save new users object
            self?.database.child("users").setValue(userDictionary, withCompletionBlock: { error, _ in
                guard error == nil else {
                    completion(false)
                    return
                }
                completion(true)
            })
            
        }
        
    }
    
    public func getAllUsers(completion: ([String]) -> Void) {
        
    }
}
