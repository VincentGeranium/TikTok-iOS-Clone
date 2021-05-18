//
//  StorageManager.swift
//  TikTok_Clone
//
//  Created by 김광준 on 2021/04/18.
//

import Foundation
import FirebaseStorage

final class StorageManager {
    public static let shared = StorageManager()
    
    private let storageBucket = Storage.storage().reference()
    
    private init() {}
    
    // Public
    
    public func getVideoURL(with identifier: String, completion: (URL) -> Void) {
        
    }
    
    public func uploadVideo(from url: URL, fileName: String, completion: @escaping (Bool) -> Void) {
        // get user name
        guard let userName = UserDefaults.standard.string(forKey: "userName") else {
            return
        }
        // top level folder is videos
        // under is username
        // and follow actuall file name
        storageBucket.child("videos/\(userName)/\(fileName)").putFile(from: url, metadata: nil) { _, error in
            // completion(error == nil) this code means is not error, is success.
            completion(error == nil)
        }
        
    }
    
    // this function is make uniquew video name
    public func generateVideoName() -> String {
        let uuidString = UUID().uuidString
        let number = Int.random(in: 0...1000)
        let unixTimestamp = Date().timeIntervalSince1970
        
        return uuidString + "_\(number)_" + "\(unixTimestamp)" + ".mov"
    }
    
}

