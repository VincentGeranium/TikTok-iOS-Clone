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
    
    public func getUserName(for email: String, completion: @escaping (String?) -> Void) {
        // from database get child "users"
        // "users" is dictionary, so have to casting
        database.child("users").observeSingleEvent(of: .value) { snapshot in
            guard let users = snapshot.value as? [String : [String : Any]] else {
                completion(nil)
                return
            }
            // key: user name, value: email
            for (userName, value) in users {
                if value["email"] as? String == email {
                    completion(userName)
                    break
                }
            }
        }
    }
    
    public func insertPost(fileName: String, caption: String, completion: @escaping (Bool) -> Void) {
        guard let userName = UserDefaults.standard.string(forKey: "userName") else {
            completion(false)
            return
        }
        
        // get user name from database directly
        // not using for loop
        database.child("users").child(userName).observeSingleEvent(of: .value) { [weak self] snapshot in
            // add our post
            // c.f : user name is pointing dictionary
            
            guard var value = snapshot.value as? [String : Any] else {
                // failed
                completion(false)
                return
            }
            
            let newEntry = [
                "name" : fileName,
                "caption" : caption,
            ]
            
            // validating of posts, is same name or not
            // if is not in posts Array -> Append
            // if not -> create new posts
            if var posts = value["posts"] as? [[String : Any]] {
                posts.append(newEntry)
                
                // update at database
                value["posts"] = posts
                self?.database.child("users").child(userName).setValue(value) { error, _ in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    completion(true)
                }
            }
            else {
                // create new posts, basically array
                value["posts"] = [newEntry]
                self?.database.child("users").child(userName).setValue(value) {error, _ in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    completion(true)
                }
            }
        }
    }
    
    public func getNotification(completion: @escaping([Notification]) -> Void) {
        completion(Notification.mockData())
    }
    
    public func markNotification(notificationID: String, completion: @escaping (Bool) -> Void) {
        completion(true)
    }
    
    public func follow(userName: String, completion: @escaping (Bool) -> Void) {
        completion(true)
    }
    
    public func getAllUsers(completion: ([String]) -> Void) {
        
    }
    
    // highly reuseable function
    public func getPosts(for user: User, completion: @escaping ([PostModel]) -> Void) {
        // path가 정확한지 항상 firebase와 비교해야함.
        let path = "users/\(user.userName.lowercased())/posts"
        
        database.child(path).observeSingleEvent(of: .value) { snapshot in
            // dictionary is caption and name
            guard let posts = snapshot.value as? [[String : String]] else {
                completion([])
                return
            }
            
            // otherwise take all the post, convert into a postModel
            let models: [PostModel] = posts.compactMap({
                // return postModel
                // construct
               var model = PostModel(identifier: UUID().uuidString, user: user)
                // whatever reason if value is nil, give to default value ""
                // asign "fileName"
                model.fileName = $0["name"] ?? ""
                // asign "caption"
                model.caption = $0["caption"] ?? ""
                return model
            })
            completion(models)
        }
        
    }
}
