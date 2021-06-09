//
//  SignUpViewController.swift
//  TikTok_Clone
//
//  Created by 김광준 on 2021/04/18.
//

import SafariServices
import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {
    // logo imageView
    private let logoImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.image = UIImage(named: "logo")
        return imageView
    }()

    // make three different fields (email, password, user name)
    private let userNameField: AuthField = AuthField(type: .userName)
    private let emailField: AuthField = AuthField(type: .email)
    private let passwordField: AuthField = AuthField(type: .password)

    // make three different type of buttons (sign In, sign Up, forgot password)
    private let signUpButton: AuthButton = AuthButton(type: .signUp, title: nil)
    private let termsButton: AuthButton = AuthButton(type: .plain, title: "Terms up Service.")

    public var complition: (() -> Void)?

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Create Account"
        // add all views in SignInViewController by subViews
        addSubViews()
        // configures fields
        configureFields()
        // configures actions of buttons method
        configureButtons()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        userNameField.becomeFirstResponder()
    }

    // MARK: - methods

    // organize of view addSubviews method
    func addSubViews() {
        view.addSubview(logoImageView)
        view.addSubview(userNameField)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(signUpButton)
        view.addSubview(termsButton)
    }

    func configureFields() {
        emailField.delegate = self
        passwordField.delegate = self
        userNameField.delegate = self

        // make keyboard toolBar -> this toolBar in the top of the keyboard
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.width, height: 50))
        toolBar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didTapKeyboardDone))
        ]
        toolBar.sizeToFit()
        // 이 텍스트필드가 firstResponder시 custom accessory view가 display 시키는 instance property.
        emailField.inputAccessoryView = toolBar
        passwordField.inputAccessoryView = toolBar
        userNameField.inputAccessoryView = toolBar
    }

    @objc private func didTapKeyboardDone() {
        // make all the textfields are resignFirstResponder
        userNameField.resignFirstResponder()
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
    }

    func configureButtons() {
        signUpButton.addTarget(self, action: #selector(didTapSignUpButton), for: .touchUpInside)
        termsButton.addTarget(self, action: #selector(didTapTermsButton), for: .touchUpInside)

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // setup layer all the stuff out
        let imageSize: CGFloat = 100
        logoImageView.frame = CGRect(x: (view.width - imageSize)/2, y: view.safeAreaInsets.top + 5, width: imageSize, height: imageSize)

        userNameField.frame = CGRect(x: 20, y: logoImageView.bottom+20, width: view.width-40, height: 55)
        emailField.frame = CGRect(x: 20, y: userNameField.bottom+15, width: view.width-40, height: 55)
        passwordField.frame = CGRect(x: 20, y: emailField.bottom+15, width: view.width-40, height: 55)

        signUpButton.frame = CGRect(x: 20, y: passwordField.bottom+20, width: view.width-40, height: 55)
        termsButton.frame = CGRect(x: 20, y: signUpButton.bottom+40, width: view.width-40, height: 55)

    }

    // MARK: - Actions of Buttons
    @objc private func didTapSignUpButton() {
        didTapKeyboardDone()

        // this guard statement when completly passed -> (it's mean all the cases are correct)
        // call the regist function
        // c.f : guard let statement를 만들 때 case들을 추가 할 수 있다(like if statement)
        guard let userName = userNameField.text,
              let email = emailField.text,
              let password = passwordField.text,
              !userName.trimmingCharacters(in: .whitespaces).isEmpty,
              !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty,
              password.count >= 6,
              !userName.contains(" "),
              !userName.contains(".") else {
            // show alert to user's
            // what kind of alert?
            // -> textFields are empty, number of password is less than 6
            let alert = UIAlertController(
                title: "Woops",
                message: "Please make sure to enter a vaild User Name, Email and Password. Also Your password must be more than 6 characters.",
                preferredStyle: .alert
            )

            let alertAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
            alert.addAction(alertAction)

            present(alert, animated: true, completion: nil)
            return
        }

        // call this regist function
        AuthManager.shared.signUp(with: userName, email: email, password: password) { success in
            //
            DispatchQueue.main.async {
                if success {
                    // ‼️ c.f : haptic is UIView collection so make in the main thread.
                    HapticsManager.shared.vibrate(for: .success)
                    print("Signed Up is Success")

                    // dismiss when is success
                    self.dismiss(animated: true, completion: nil)

                    // MARK: - Strat own my code about alert when sign up success.
                    // if u want to delete the code u can do that.
//                    let alert = UIAlertController(
//                        title: "Sign Up Success",
//                        message: "Welecome to Tiktok!!",
//                        preferredStyle: .alert
//                    )
//
//                    let alertAction = UIAlertAction(title: "Dismiss", style: .cancel) { _ in
//                        self.emailField.text = nil
//                        self.userNameField.text = nil
//                        self.passwordField.text = nil
//
//                    }
//                    alert.addAction(alertAction)
//                    self.present(alert, animated: true, completion: nil)
                    // <- end of own my code
                } else {
                    HapticsManager.shared.vibrate(for: .error)
                    let alert = UIAlertController(
                        title: "Sign Up Failed",
                        message: "Something went wrong when trying to register. Please try again",
                        preferredStyle: .alert
                    )

                    let alertAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
                    alert.addAction(alertAction)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }

    }

    @objc private func didTapTermsButton() {
        didTapKeyboardDone()
        guard let url = URL(string: "https://www.tiktok.com") else {
            return
        }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true, completion: nil)
        // safariService로 webView를 띄울 경우 push 하면 안되고 present 해야한다. -> why??
    }

}
