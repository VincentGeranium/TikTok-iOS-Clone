//
//  AuthField.swift
//  TikTok_Clone
//
//  Created by 김광준 on 2021/05/12.
//

import UIKit

/*
 Why make seperatly UITextField?
 -> for reusable textfield (in the sign In and sign Up)
 */

class AuthField: UITextField {

    // enum is for textfield make differently by each of types
    enum FieldType {
        case userName
        case email
        case password

        // computed property must have accessors specified
        var title: String {
            switch self {
            case .userName: return "User Name"
            case .email: return "Email Address"
            case .password: return "Password"
            }
        }
    }

    // fieldType have to immutable so, make constant property
    private let type: FieldType

    init(type: FieldType) {
        self.type = type
        // this super.init is default
        super.init(frame: .zero)

        // For basically configure UI
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func configureUI() {
        // don't auto capitalize
        autocapitalizationType = .none

        // make field dynamically. so, make Placeholder code like "placeholder = type.title"
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 8
        layer.masksToBounds = true
        placeholder = type.title
        // make left padding
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: height))
        leftViewMode = .always
        // return key type instance method
        returnKeyType = .done
        // 자동완성
        autocorrectionType = .no

        // organize between each field type(password and email)
        if type == .password {
            // password textfield에 password를 user가 입력시 어떤 content type으로 configure 할 것인지 정하는 code
            textContentType = .oneTimeCode
            // 텍스트 필드에 쓰이는 텍스트를 가리는 인스턴스 메소드.
            isSecureTextEntry = true
        } else if type == .email {
            keyboardType = .emailAddress
            textContentType = .emailAddress
        }
    }

}
