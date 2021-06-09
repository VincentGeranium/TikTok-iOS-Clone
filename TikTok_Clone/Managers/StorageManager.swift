//
//  StorageManager.swift
//  TikTok_Clone
//
//  Created by 김광준 on 2021/04/18.
//

import Foundation
import FirebaseStorage

/// Manager object that deals with firebase storage
final class StorageManager {
    /// Shared singleton instance
    public static let shared = StorageManager()

    /// Storage bucket reference
    private let storageBucket = Storage.storage().reference()

    /// Private constructor
    private init() {}

    // Public

    /// Upload a new user video to firebase
    /// - Parameters:
    ///   - url: Local file url to video
    ///   - fileName: Desired video file upload name
    ///   - completion: Async callback result closure
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

    /// Upload new profile picture
    /// - Parameters:
    ///   - image: New image to upload
    ///   - completion: Async callback of result
    public func uploadProfilePicture(with image: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
        // this function is upload actual image
        // URL is point to the actual download url that new uploaded image
        guard let userName = UserDefaults.standard.string(forKey: "userName") else {
            return
        }

        // convert to png format
        // c.f : UIImage.pngData() -> "Returns a data object that contains the specified image in PNG format."
        guard let imageData = image.pngData() else {
            return
        }

        let path = "profile_pictures/\(userName)/picture.png"

        // child("profile_pictures/") -> root directory create
        storageBucket.child(path).putData(imageData, metadata: nil) { _, error in
            if let error = error {
                completion(.failure(error))
            } else {
                self.storageBucket.child(path).downloadURL { url, error in
                    guard let url = url else {
                        if let error = error {
                            completion(.failure(error))
                        }
                        return
                    }
                    completion(.success(url))
                }
            }
        }
    }

    /// Generates a new file name, this function is make unique video name
    /// - Returns: Return a unique generated file name
    public func generateVideoName() -> String {
        let uuidString = UUID().uuidString
        let number = Int.random(in: 0...1000)
        let unixTimestamp = Date().timeIntervalSince1970

        return uuidString + "_\(number)_" + "\(unixTimestamp)" + ".mov"
    }

    /// Get download url of video post, this function is download video fileName from the firebase storage
    /// - Parameters:
    ///   - post: Post model to get url for
    ///   - completion: Async callback resutl
    public func getDownloadURL(for post: PostModel, completion: @escaping (Result<URL, Error>) -> Void) {
        storageBucket.child(post.videoChildPath).downloadURL { url, error in
            if let error = error {
                completion(.failure(error))
            } else if let url = url {
                completion(.success(url))
            }
        }
    }
}
