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

protocol ExploreManagerDelegate: AnyObject {
    func pushViewController(_ vc: UIViewController)
    func didTapHashtag(_ hashtag: String)
}

final class ExploreManager {
    // MARK: - Public
    static let shared = ExploreManager()
    
    weak var delegate: ExploreManagerDelegate?
    
    enum BannerAction: String {
        case post
        case hashtag
        case user
    }
    
    // getExploreBanners method
    public func getExploreBanners() -> [ExploreBannerViewModel] {
        guard let exploreData = parseExploreData() else {
            print("⭕️ : exploreData is not working in getExploreBanners")
            return []
        }
        /*
         exploreData.banners.compactMap 내부에 print문으로 이미지가 어떤 것들이 들어가는 지 debugging을 원한다면 다음과 같은 코드로 해야한다.
         
         return exploreData.banners.compactMap({
         print($0.image)
         return ExploreBannerViewModel(
         image: UIImage(named: $0.image),
         title: $0.title) {
         }
         })
         
         그러면 print문으로 banner의 image들의 name이 나타난다.
         
         c.f : Explore 섹션의 Parsing JSON Data 강의 중 27:00 초 부터 보면 이미지가 나타나지 않고 debugging 하는 내용이 나타난다 참고하길.
         */
        
        let result = exploreData.banners.compactMap({ model in
            ExploreBannerViewModel(
                image: UIImage(named: model.image),
                title: model.title) {
                // [weak self] 사용 이유 : don't want retain cycle
                [weak self] in
                guard let action = BannerAction(rawValue: model.action) else {
                    return
                }
                // UI 관련 코드는 항상 Main thread 에서 처리한다.
                DispatchQueue.main.async {
                    // for test during developing
                    let vc: UIViewController = UIViewController()
                    vc.view.backgroundColor = .systemBackground
                    vc.title = action.rawValue.uppercased()
                    self?.delegate?.pushViewController(vc)
                }
                
                switch action {
                case .user:
                    // profile
                    break
                case .hashtag:
                    // search for hashtag
                break
                case .post:
                    // post
                break
                }
            }
        })
        print("⭕️getExploreBanners Result⭕️ : \(result)")
        return result
    }
    
    // getExploreCreators method
    public func getExploreCreators() -> [ExploreUserViewModel] {
        guard let exploreData = parseExploreData() else {
            print("⭕️ : exploreData is not working in getExploreCreators")
            return []
        }
        
        let result = exploreData.creators.compactMap({ model in
            ExploreUserViewModel(
                profilePicture: UIImage(named: model.image),
                userName: model.username,
                followerCount: model.followers_count
            ) { [weak self] in
                DispatchQueue.main.async {
                    let userId = model.id
                    //Fetch user object from firebase
                    let vc = ProfileViewController(user: User(userName: "jun", profilePictureURL: nil, identifier: userId))
                    self?.delegate?.pushViewController(vc)
                }
            }
        })
        print("⭕️getExploreCreators Result⭕️ : \(result)")
        return result
    }
    
    public func getExploreHashtags() -> [ExploreHashtagViewModel] {
        guard let exploreData = parseExploreData() else {
            print("⭕️ : exploreData is not working in getExploreHashtags")
            return []
        }
        
        /*
         result 내의 compactMap을 사용하는데 $0가 아닌 model을 사용하는 이유 : compactMap과 ExploreHashtagViewModel 클로저는 각기 다른 클로저이므로
         같은 object를 가리키기 위해서는 아래와 같이 해야 한다.
         */
        
        let result = exploreData.hashtags.compactMap({ model in
            ExploreHashtagViewModel(
                text: model.tag,
                icon: UIImage(systemName: model.image),
                count: model.count
            ) { [weak self] in
                DispatchQueue.main.async {
                    self?.delegate?.didTapHashtag(model.tag)
                }
            }
        })
        print("⭕️getExploreHashtags Result⭕️ : \(result)")
        return result
    }
    
    public func getExploreTrendingPosts() -> [ExplorePostViewModel] {
        guard let exploreData = parseExploreData() else {
            print("⭕️ : exploreData is not working in getExploreTrendingPosts")
            return []
        }
        
        let result = exploreData.trendingPosts.compactMap({ model in
            ExplorePostViewModel(
                thumbnailImage: UIImage(named: model.image),
                caption: model.caption
            ) { [weak self] in
                DispatchQueue.main.async {
                    let postID = model.id
                    let vc = PostViewController(model: PostModel(identifier: postID))
                    self?.delegate?.pushViewController(vc)
                }
            }
        })
        print("⭕️getExploreTrendingPosts Result⭕️ : \(result)")
        return result
    }
    
    public func getExploreRecentPosts() -> [ExplorePostViewModel] {
        guard let exploreData = parseExploreData() else {
            print("⭕️ : exploreData is not working in getExploreRecentPosts")
            return []
        }
        
        let result = exploreData.recentPosts.compactMap({ model in
            ExplorePostViewModel(
                thumbnailImage: UIImage(named: model.image),
                caption: model.caption
            ) { [weak self] in
                DispatchQueue.main.async {
                    let postID = model.id
                    let vc = PostViewController(model: PostModel(identifier: postID))
                    self?.delegate?.pushViewController(vc)
                }
            }
        })
        print("⭕️getExploreRecentPosts Result⭕️ : \(result)")
        return result
    }
    
    public func getExplorePopularPosts() -> [ExplorePostViewModel] {
        guard let exploreData = parseExploreData() else {
            print("⭕️ : exploreData is not working in getPopularPosts")
            return []
        }
        
        let result = exploreData.popular.compactMap({ model in
            ExplorePostViewModel(
                thumbnailImage: UIImage(named: model.image),
                caption: model.caption
            ) { [weak self] in
                DispatchQueue.main.async {
                    let postID = model.id
                    let vc = PostViewController(model: PostModel(identifier: postID))
                    self?.delegate?.pushViewController(vc)
                }
            }
        })
        print("⭕️getPopularPosts Result⭕️ : \(result)")
        return result
    }
    
    public func getExploreRecommended() -> [ExplorePostViewModel] {
        guard let exploreData = parseExploreData() else {
            print("⭕️ : exploreData is not working in getExploreRecommended")
            return []
        }
        
        let result = exploreData.recommended.compactMap({ model in
            ExplorePostViewModel(
                thumbnailImage: UIImage(named: model.image),
                caption: model.caption
            ) { [weak self] in
                DispatchQueue.main.async {
                    let postID = model.id
                    let vc = PostViewController(model: PostModel(identifier: postID))
                    self?.delegate?.pushViewController(vc)
                }
            }
        })
        
        print("⭕️getExploreRecommended Result⭕️ : \(result)")
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
