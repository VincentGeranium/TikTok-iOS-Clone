//
//  AuthenticationManager.swift
//  TikTok_Clone
//
//  Created by 김광준 on 2021/04/18.
//

import Foundation
import FirebaseAuth

final class AuthManager {
    public static let shared = AuthManager()
    
    private init() {}
    
    enum SignInMethod {
        case email
        case facebook
        case google
    }
    
    //MARK:- Public
    
    // user가 가입 되어 있는지 없는지 확인하기 위한 bool (User Sign-in Vaildation)
    public var isSignedIn: Bool {
        // if return value is true -> User is Signed in
        // if return value is false -> User is not Signed in
        return Auth.auth().currentUser != nil
    }
    
    public func signIn(with email: String, password: String, completion: @escaping (Bool) -> Void) {
        
    }
    
    // completion is why bool??
    // call signOut method will Bool Value, if true value into signOut method, it means user signout else user not signOut -> errro
    public func signOut(completion: (Bool) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(true)
        }
        catch {
            print(error)
            completion(false)
        }
    }
    
    
}


