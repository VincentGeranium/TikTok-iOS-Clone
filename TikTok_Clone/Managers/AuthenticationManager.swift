//
//  AuthenticationManager.swift
//  TikTok_Clone
//
//  Created by 김광준 on 2021/04/18.
//

import Foundation
import FirebaseAuth

/// Manager responsible for signing in, up and out
final class AuthManager {

    /// Singleton instance of the Manager
    public static let shared = AuthManager()

    /// Private constructor
    private init() {}

    /// Represents method to sign in
    enum SignInMethod {
        /// Email and password method
        case email
        /// Facebook method
        case facebook
        /// Google Account method
        case google
    }

    /// Represents error that can occur in auth flows
    enum AuthError: Error {
        case signInFailed
    }

    // MARK: - Public

    // user가 가입 되어 있는지 없는지 확인하기 위한 bool (User Sign-in Vaildation)

    /// Represent if user is signed in, This property is computed property
    public var isSignedIn: Bool {
        // if return value is true -> User is Signed in
        // if return value is false -> User is not Signed in
        return Auth.auth().currentUser != nil
    }

    /// Attempt to sign in
    /// - Parameters:
    ///   - email: User email
    ///   - password: User password
    ///   - completion: Async result callback
    public func signIn(
        // when user sign-in, the info is cacheing.
        with email: String,
        password: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        // implement body
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            guard result != nil, error == nil else {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.failure(AuthError.signInFailed))
                }
                return
            }

            // to get current user name from database, with giving url, email
            // when every time users sign - in
            DatabaseManager.shared.getUserName(for: email) { userName in
                if let userName = userName {
                    // important things, if u make "UserDefaults.standard.setValue(userName, forKey: "userName")" code at sign in
                    // is same things write at sign out
                    UserDefaults.standard.setValue(userName, forKey: "userName")
                    // cashing
                    print("Got user name: \(userName)")
                }
            }

            // Successful sign in
            completion(.success(email))
        }
    }

    /// Attempt to sign up
    /// - Parameters:
    ///   - userName: Desired user name
    ///   - email: User email
    ///   - password: User password
    ///   - completion: Async reslut callback
    public func signUp(
        with userName: String,
        email: String,
        password: String,
        completion: @escaping (Bool) -> Void
    ) {
        // implement body
        // user's data를 authentication libray 뿐만 아니라 우리의 database 내에도 저장하기 위한 logic과 code
        // c.f : user data -> user name, user email but not password because not secure

        // Make sure entered user name is available

        // User regist code
        // c.f : guard statement is same function with if statement (not a "guard let")
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            guard result != nil, error == nil else {
                completion(false)
                return
            }
            // setValue of UserDefaults standard
            UserDefaults.standard.setValue(userName, forKey: "userName")
            // success sign up, saved to user data in database
            DatabaseManager.shared.insertUser(with: email, userName: userName, completion: completion)
        }

    }

    // completion is why bool??
    // call signOut method will Bool Value, if true value into signOut method, it means user signout else user not signOut -> error

    /// Attempt sign out
    /// - Parameter completion: Async callback of sign out result
    public func signOut(completion: (Bool) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(true)
        } catch {
            print(error)
            completion(false)
        }
    }

}
