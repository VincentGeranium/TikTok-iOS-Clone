//
//  ExploreSectionType.swift
//  TikTok_Clone
//
//  Created by 김광준 on 2021/05/02.
//

import Foundation
/*
 ⭕️ : for loop으로 case를 사용하기 위해 CaseIterable를 상속받는다.
 */
enum ExploreSectionType: CaseIterable {
    case banner
    case trendingPosts
    case users
    case trendingHashtags
    case recommended
    case popular
    case new

    // title와 연관돤 property
    // 각 case 별 title를 return한다.
    var title: String {
        switch self {
        case .banner:
            return "Feature"
        case .trendingPosts:
            return  "Trending Videos"
        case .users:
            return "Popular Creators"
        case .trendingHashtags:
            return "Hastags"
        case .recommended:
            return "Recommended"
        case .popular:
            return "Popular"
        case .new:
            return "Recently Posted"

        }
    }
}
