//
//  ExploreCell.swift
//  TikTok_Clone
//
//  Created by 김광준 on 2021/05/02.
//

import Foundation
import UIKit

enum ExploreCell {
    // viewModel과 연관된 각기 다른 cell들을 configure한다 each of these cells
    case banner(viewModel: ExploreBannerViewModel)
    case post(viewModel: ExplorePostViewModel)
    case hashtag(viewModel: ExploreHashtagViewModel)
    case user(viewModel: ExploreUserViewModel)
//    case recommand(viewModel: ExplorePostViewModel)
}
