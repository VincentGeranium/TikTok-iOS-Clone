//
//  Extensions.swift
//  TikTok_Clone
//
//  Created by 김광준 on 2021/04/21.
//

import Foundation
import UIKit

/*
 This extension is help to make view more easily
 handy to make views
 */
extension UIView {
    // computed property for width size
    var width: CGFloat {
        return frame.size.width
    }

    var height: CGFloat {
        return frame.size.height
    }

    var left: CGFloat {
        return frame.origin.x
    }

    var right: CGFloat {
        return left + width
    }

    var top: CGFloat {
        return frame.origin.y
    }

    var bottom: CGFloat {
        return top + height
    }

}

extension DateFormatter {
    static let defaultFormatter: DateFormatter = {
        let formatter: DateFormatter = DateFormatter()
        // current users timezone, locale
        formatter.timeZone = .current
        formatter.locale = .current
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
}

extension String {
    // Date를 String으로 format하기 위한 extension
    static func date(with date: Date) -> String {
        return DateFormatter.defaultFormatter.string(from: date)
    }
}
