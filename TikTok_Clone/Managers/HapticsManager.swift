//
//  HapticsManager.swift
//  TikTok_Clone
//
//  Created by 김광준 on 2021/04/18.
//

// haptic is skill about vibrate.

import Foundation
import UIKit

/// Object that deals with haptic feeback
final class HapticsManager {

    /// Shared Singleton instance
    static let shared = HapticsManager()

    /// Private constructor
    private init() {}

    // MARK: - Public

    /// Vibrate for light selection of items., this function is for when user select somthing.
    public func vibrateForSelection() {
        DispatchQueue.main.async {
            let generator = UISelectionFeedbackGenerator()
            generator.prepare()
            generator.selectionChanged()
        }
    }

    /// Trigger that feedback vibration based on event type, this function is for feedback to user
    /// - Parameter type: Success, Error, or Warning type
    public func vibrate(for type: UINotificationFeedbackGenerator.FeedbackType) {
        DispatchQueue.main.async {
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            generator.notificationOccurred(type)
        }
    }

}
