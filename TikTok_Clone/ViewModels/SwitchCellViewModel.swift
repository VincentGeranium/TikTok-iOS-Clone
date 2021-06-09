//
//  SwitchCellViewModel.swift
//  TikTok_Clone
//
//  Created by 김광준 on 2021/06/07.
//

import Foundation

struct SwitchCellViewModel {
    // two properties
        // 1. title
        // 2. isOn
    let title: String
    var isOn: Bool

    // mutating func
        // reason of make mutation function -> will gonna mutating these value type the struct in place
    mutating func setOn(_ on: Bool) {
        self.isOn = on
    }
}
