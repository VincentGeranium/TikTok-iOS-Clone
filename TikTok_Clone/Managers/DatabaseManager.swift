//
//  DatabaseManager.swift
//  TikTok_Clone
//
//  Created by 김광준 on 2021/04/18.
//
// 데이터베이스로 부터 여러 정보를 받아오기 위한 것.


import Foundation
import FirebaseDatabase

/// Manager to interact with Database
final class DatabaseManager {
    /// Singleton instance of DatabaseManager
    public static let shared = DatabaseManager()
    
    /// Database reference
    private let database = Database.database().reference()
    
    /// Private constructor
    private init() {}
    
    // Public
    
    /// insert a new User
    /// - Parameters:
    ///   - email: User email
    ///   - userName: User name
    ///   - completion: Async result callback
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
    
    /// Get User name for a given email
    /// - Parameters:
    ///   - email: Email to query
    ///   - completion: Async result callback
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
    
    /// Insert new post
    /// - Parameters:
    ///   - fileName: File name to insert for
    ///   - caption: Caption to insert for
    ///   - completion: Async result callback
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
    
    /// Get a current users notifications
    /// - Parameter completion: Result callback of method
    public func getNotification(completion: @escaping([Notification]) -> Void) {
        completion(Notification.mockData())
    }
    
    /// Mark a notification has hidden
    /// - Parameters:
    ///   - notificationID: Notification Indentifier
    ///   - completion: Async result  callback
    public func markNotification(notificationID: String, completion: @escaping (Bool) -> Void) {
        completion(true)
    }
    

    
    // highly reuseable function
    /// Get posts for a given user
    /// - Parameters:
    ///   - user: User to get posts for
    ///   - completion: Async result callback
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
    
    /// Get relationship status for current and target user
    /// - Parameters:
    ///   - user: Target user to check following status for
    ///   - type: Type to be checked
    ///   - completion: Async result callback
    public func getRelationships(
        for user: User,
        type: UserListViewController.ListType,
        completion: @escaping ([String]) -> Void
    ) {
        // make follwers and following path
        let path = "users/\(user.userName.lowercased())/\(type.rawValue)"
        
        // for debugging
        print("Fetching path : \(path)")
        
        database.child(path).observeSingleEvent(of: .value) { snapshot in
            guard let userNameColletion = snapshot.value as? [String] else {
                completion([])
                return
            }
            
            completion(userNameColletion)
        }
    }
    
    /// Check if a relataionship is vaild
    /// - Parameters:
    ///   - user: Target user to check
    ///   - type: Type to check
    ///   - completion: Result callback
    public func isValidRelationship(
        for user: User,
        type: UserListViewController.ListType,
        completion: @escaping (Bool) -> Void
    ) {
        guard let currentUserUserName = UserDefaults.standard.string(forKey: "userName")?.lowercased() else {
            return
        }
        
        let path = "users/\(user.userName.lowercased())/\(type.rawValue)"
        
        database.child(path).observeSingleEvent(of: .value) { snapshot in
            guard let userNameCollection = snapshot.value as? [String] else {
                completion(false)
                return
            }
            
            completion(userNameCollection.contains(currentUserUserName))
        }
    }
    
    /// Update follow status for user
    /// - Parameters:
    ///   - user: Target user
    ///   - follow: Follow or Unfollow status
    ///   - completion: Result callback
    public func updateRelationship(
        for user: User,
        follow: Bool,
        completion: @escaping (Bool) -> Void
    ) {
        guard let currentUserUserName = UserDefaults.standard.string(forKey: "userName")?.lowercased() else {
            return
        }
        
        if follow {
            // Follow
            
            // 1. insert in current user's following (cause we are folloing somebody else)
            let followingPath = "users/\(currentUserUserName)/following"
            database.child(followingPath).observeSingleEvent(of: .value) { (snapshot) in
                let userNameToInsert = user.userName.lowercased()
                if var current = snapshot.value as? [String] {
                    current.append(userNameToInsert)
                    self.database.child(followingPath).setValue(current) { error, _ in
                        completion(error == nil)
                    }
                }
                else {
                    self.database.child(followingPath).setValue([userNameToInsert]) { error, _ in
                        completion(error == nil)
                    }
                }
            }
            
            // 2. insert in the target user's followers
            let followersPath = "users/\(user.userName.lowercased())/followers"
            database.child(followersPath).observeSingleEvent(of: .value) { (snapshot) in
                let userNameToInsert = currentUserUserName.lowercased()
                if var current = snapshot.value as? [String] {
                    current.append(userNameToInsert)
                    self.database.child(followersPath).setValue(current) { error, _ in
                        completion(error == nil)
                    }
                }
                else {
                    self.database.child(followersPath).setValue([userNameToInsert]) { error, _ in
                        completion(error == nil)
                    }
                }
            }
        }
        else {
            // Unfollow
            
            // reverse with follow
            
            // 1. Remove from current user following
            let followingPath = "users/\(currentUserUserName)/following"
            database.child(followingPath).observeSingleEvent(of: .value) { (snapshot) in
                let userNameToRemove = user.userName.lowercased()
                if var current = snapshot.value as? [String] {
                    // $0 means => elements
                    current.removeAll(where: {$0 == userNameToRemove})
                    self.database.child(followingPath).setValue(current) { error, _ in
                        completion(error == nil)
                    }
                }
            }
            
            // 2. Remove in the target user's followers
            let followersPath = "users/\(user.userName.lowercased())/followers"
            database.child(followersPath).observeSingleEvent(of: .value) { (snapshot) in
                let userNameToRemove = currentUserUserName.lowercased()
                if var current = snapshot.value as? [String] {
                    current.removeAll(where: {$0 == userNameToRemove})
                    self.database.child(followersPath).setValue(current) { error, _ in
                        completion(error == nil)
                    }
                }
            }
        }
    }
    
}
