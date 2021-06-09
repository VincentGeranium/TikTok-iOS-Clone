//
//  AuthButton.swift
//  TikTok_Clone
//
//  Created by 김광준 on 2021/05/12.
//

import UIKit

/*
 Why make seperatly UIButton ?
 -> for reusable UIButton (in the sign In and sign Up)
 */

class AuthButton: UIButton {
    enum ButtonType {
        case signIn
        case signUp
        case plain

        var title: String {
            switch self {
            case .signIn: return "Sign In"
            case .signUp: return "Sign Up"
            case .plain: return "-"
            }
        }
    }

    private let type: ButtonType

    init(type: ButtonType, title: String?) {
        self.type = type
        // 왜 super.init(frame: .zero)의 frame를 .zero를 주었는지 공부, 이해 필요.
        super.init(frame: .zero)
        // 버튼을 처음 initialized 시 특정한 title를 원하면 그 title로 button title가 된다.
        // 그러나 없을 경우 enum에서 정한 default 값으로 설정된다.
        if let title = title {
            setTitle(title, for: .normal)
        }
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func configureUI() {
        if type != .plain {
            setTitle(type.title, for: .normal)
        }

        switch type {
        case .signIn: backgroundColor = .systemBlue
        case .signUp: backgroundColor = .systemGreen
        case .plain:
            setTitleColor(.link, for: .normal)
            backgroundColor = .clear
        }
        titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        layer.masksToBounds = true
        layer.cornerRadius = 8
    }
}
