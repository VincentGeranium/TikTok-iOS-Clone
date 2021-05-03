//
//  ExploreSection.swift
//  TikTok_Clone
//
//  Created by 김광준 on 2021/05/02.
//

import Foundation

// this model is important
// how to represent all the data => answer is through model

struct ExploreSection {
    let type: ExploreSectionType
    let cells: [ExploreCell]
}

