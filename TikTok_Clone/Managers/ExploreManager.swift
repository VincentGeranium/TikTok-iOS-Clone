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
    static let shared = ExploreManager()
    
    // get all the models out
    
    // each of different section need to differents viewModel (banner, Trending Posts, Trending hashtags, ect,,,)
        // c.f : ExploreViewController의 configureModels method와 ExploreSection 참고.
    
    
    public func getExploreBanners() -> [ExploreBannerViewModel] {
        // load up and parsing json
        //        parseExploreData()
        guard let explorData = parseExploreData() else {
            return []
        }
        
        return explorData.banners.compactMap({
            ExploreBannerViewModel(
                image: UIImage(named: $0.image),
                title: $0.title) {
                // handler is here
            }
        })
        
    }
    
    // for reuse parsing json, load up json file
    // this method taking data, parsing it, saving it and responsible with json
    private func parseExploreData() -> ExploreResponse? {
        // path which the path of reach at json file.
        // load up json file
        // MARK:- paht of find json file
        guard let path = Bundle.main.path(forResource: "explore", ofType: "json") else {
            print("wrong path")
            return nil
        }
        // do - catch statment
        // for error handling
        
        do {
            // make path ot URL
            // MARK:- Creath of URL used by URL with path
            let url = URL(fileURLWithPath: path)
            
            // creat data with content url code
            // MARK:- Creat of data
            let data = try Data(contentsOf: url)
            // actual cashing this object
            let result = try JSONDecoder().decode(
                ExploreResponse.self,
                from: data
            )
            print("DO statement working")
            return result
            
            // MARK:-  get real data used by jsonCoder(convert logic)
        } catch {
            print(error)
            return nil
        }
        
    }
    
    
    
}


// MARK:- Model for actually codable object, JSONDecode try to decode

struct ExploreResponse: Codable {
    // the key name of each json data
    // c.f : if not matched with key name in json file, JSONdecoder is not working
    let banners: [Banner]
    let trendingPosts: [Post]
    let creators: [Creator]
    let recentPosts: [Post]
    let hashtags: [Hashtag]
    let popular: [Post]
    let recommended: [Post]
    
}

// MARK:- Make sub model of each of keys, and match with Each viewModels
struct Banner: Codable {
    let id: String
    let image: String
    let title: String
    let action: String
}

struct Post: Codable {
    let id: String
    let image: String
    let caption: String
}

struct Hashtag: Codable {
    let image: String
    let tag: String
    let count: Int
}

struct Creator: Codable {
    let id: String
    let image: String
    let username: String
    let followers_count: Int
}
