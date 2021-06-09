//
//  RecordButton.swift
//  TikTok_Clone
//
//  Created by 김광준 on 2021/05/17.
//

import UIKit

class RecordButton: UIButton {

    // make button circular white line

    override init(frame: CGRect) {
        super.init(frame: frame)
        // no background color
        backgroundColor = nil
        // masksToBounds is true
            // why? for make button circular and cornerRadius
        layer.masksToBounds = true
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 2.5
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = height/2
    }

    enum State {
        case recording
        case notRecording
    }

    // toggle func fot to recording state and not recording state
    // paramter "State" is enum
    public func toggle(for state: State) {
        switch state {
        case .recording:
            backgroundColor = .systemRed
        case .notRecording:
            backgroundColor = nil
        }
    }

}
