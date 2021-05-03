//
//  ExploreBannerViewModel.swift
//  TikTok_Clone
//
//  Created by 김광준 on 2021/05/02.
//

import Foundation
import UIKit

// ExploreCell 각각의 case 별로 필수적 요소를 property로 만들어 담아 structure로 만든다.
struct ExploreBannerViewModel {
    let image: UIImage?
    let title: String
    // cell을 tap했을 때 생기는 일을 위한 handler
    let handler: (() -> Void)
}
