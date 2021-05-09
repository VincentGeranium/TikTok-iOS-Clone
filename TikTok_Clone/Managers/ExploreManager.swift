//
//  ExploreManager.swift
//  TikTok_Clone
//
//  Created by 김광준 on 2021/05/04.
//

// this object is responsible with getting infomation
// to update Explore screen

import Foundation
import UIKit

final class ExploreManager {
    // MARK: - Public
    static let shared = ExploreManager()
    
    // getExploreBanners method
    public func getExploreBanners() -> [ExploreBannerViewModel] {
        guard let exploreData = parseExploreData() else {
            print("⭕️ : getExploreCreators not working")
            return []
        }
        let result = exploreData.banners.compactMap({
            ExploreBannerViewModel(
                image: UIImage(named: $0.image),
                title: $0.title) {
                // empty
            }
        })
        print("⭕️ExploreBannerViewModel Result⭕️ : \(result)")
        return result
    }
    
    // getExploreCreators method
    public func getExploreCreators() -> [ExploreUserViewModel] {
        guard let exploreData = parseExploreData() else {
            print("⭕️ : getExploreCreators not working")
            return []
        }
        
        let result = exploreData.creators.compactMap({
            ExploreUserViewModel(
                profilePicture: UIImage(named: $0.image),
                userName: $0.username,
                followerCount: $0.followers_count) {
                //
            }
        })
        print("⭕️ExploreUserViewModel Result⭕️ : \(result)")
        return result
    }
    
    public func getExploreHashtags() -> [ExploreHashtagViewModel] {
        guard let exploreData = parseExploreData() else {
            print("⭕️ : getExploreHashtags not working")
            return []
        }
        
        let result = exploreData.hashtags.compactMap({
            ExploreHashtagViewModel(
                text: $0.tag,
                icon: UIImage(systemName: $0.image),
                count: $0.count) {
                // empty now
            }
        })
        print("⭕️ExploreHashtagViewModel Result⭕️ : \(result)")
        return result
    }
    
    // MARK: - Private
    private func parseExploreData() -> ExploreResponse? {
        guard let path = Bundle.main.path(forResource: "explore", ofType: "json") else {
            return nil
        }
        
        do {
            let url = URL(fileURLWithPath: path)
            let data = try Data(contentsOf: url)
            let decodeResult = try JSONDecoder().decode(
                ExploreResponse.self,
                from: data
            )
            print("⭕️decodeResult of parseExploreData(JSON)⭕️ : \(decodeResult)")
            return decodeResult
        }
        catch {
            print(error)
            return nil
        }
    }
}

// top level keys of json data
// have to match with top level key with json data
struct ExploreResponse: Codable {
    let banners: [Banners]
    let trendingPosts: [Post]
    let creators: [Creator]
    let recentPosts: [Post]
    let hashtags: [Hashtag]
    let popular: [Post]
    let recommended: [Post]
}

// It's not exactly same with each viewModels structure but have to match with json data
// banners's sub model structure
struct Banners: Codable {
    let id: String
    let image: String
    let title: String
    let action: String
}

// trendingPosts, recentPosts, popular, recommended are sub model structure
struct Post: Codable {
    let id: String
    let image: String
    let caption: String
}

// creators sub model structure
struct Creator: Codable {
    let id: String
    let image: String
    let username: String
    let followers_count: Int
}

// hastags sub model structure
struct Hashtag: Codable {
    let image: String
    let tag: String
    let count: Int
}
