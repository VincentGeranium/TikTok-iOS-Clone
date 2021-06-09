//
//  SignInViewController.swift
//  TikTok_Clone
//
//  Created by 김광준 on 2021/04/18.
//
// this framework(SafariServices) is open webView directly in the app

import SafariServices
import UIKit

class SignInViewController: UIViewController, UITextFieldDelegate {

    // logo imageView
    private let logoImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.image = UIImage(named: "logo")
        return imageView
    }()

    // make two different fields (email and password)
    private let emailField: AuthField = AuthField(type: .email)
    private let passwordField: AuthField = AuthField(type: .password)

    // make three different type of buttons (sign In, sign Up, forgot password)
    private let signInButton: AuthButton = AuthButton(type: .signIn, title: nil)
    private let signUpButton: AuthButton = AuthButton(type: .plain, title: "New User? Create Account")
    private let forgotPassword: AuthButton = AuthButton(type: .plain, title: "Forgot Password?")

    public var complition: (() -> Void)?

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Sign In"
        // add all views in SignInViewController by subViews
        addSubViews()
        // configures fields
        configureFields()
        // configures actions of buttons method
        configureButtons()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // view가 붙여지고나서 email field가 first responder가 되어 keyboard가 바로 popup 되게 한다.
        emailField.becomeFirstResponder()
    }

    // organize of view addSubviews method
    func addSubViews() {
        view.addSubview(logoImageView)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(signInButton)
        view.addSubview(signUpButton)
        view.addSubview(forgotPassword)
    }

    func configureFields() {
        emailField.delegate = self
        passwordField.delegate = self

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
    }

    @objc private func didTapKeyboardDone() {
        // make all the textfields are resignFirstResponder
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
    }

    func configureButtons() {
        signInButton.addTarget(self, action: #selector(didTapSignInButton), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(didTapSignUpButton), for: .touchUpInside)
        forgotPassword.addTarget(self, action: #selector(didTapForgotPasswordButton), for: .touchUpInside)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // setup layer all the stuff out
        let imageSize: CGFloat = 100
        logoImageView.frame = CGRect(x: (view.width - imageSize)/2, y: view.safeAreaInsets.top + 5, width: imageSize, height: imageSize)

        emailField.frame = CGRect(x: 20, y: logoImageView.bottom+20, width: view.width-40, height: 55)
        passwordField.frame = CGRect(x: 20, y: emailField.bottom+15, width: view.width-40, height: 55)

        signInButton.frame = CGRect(x: 20, y: passwordField.bottom+20, width: view.width-40, height: 55)
        forgotPassword.frame = CGRect(x: 20, y: signInButton.bottom+40, width: view.width-40, height: 55)
        signUpButton.frame = CGRect(x: 20, y: forgotPassword.bottom+20, width: view.width-40, height: 55)

    }

    // MARK: - Actions of Buttons
    @objc private func didTapSignInButton() {
        didTapKeyboardDone()
        guard let email = emailField.text,
              let password = passwordField.text,
              !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty,
              password.count >= 6
        else {
            // when email and password is empty present alert
            let alert = UIAlertController(title: "Woops", message: "Plz enter a vaild email and password to sign in", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }

        // Action logic
        AuthManager.shared.signIn(with: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    HapticsManager.shared.vibrate(for: .success)
                    // success
                    self?.dismiss(animated: true, completion: nil)
                // c.f (let error) is called "associate value"
                case .failure(let error):
                    HapticsManager.shared.vibrate(for: .error)
                    // fail
                    print(error)
                    let alert = UIAlertController(
                        title: "Sign In Failed",
                        message: "Please check your email and password to try again.",
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                    // password delete automatically when failed to sign in
                    self?.passwordField.text = nil
                    // email delete automatically when failed to sign in
                    self?.emailField.text = nil
                }
            }
        }
    }

    @objc private func didTapSignUpButton() {
        didTapKeyboardDone()
        let vc = SignUpViewController()
        vc.title = "Create Account"
        navigationController?.pushViewController(vc, animated: true)

    }

    @objc private func didTapForgotPasswordButton() {
        didTapKeyboardDone()
        guard let url = URL(string: "https://www.tiktok.com") else {
            return
        }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true, completion: nil)
        // safariService로 webView를 띄울 경우 push 하면 안되고 present 해야한다. -> why??
    }

}
