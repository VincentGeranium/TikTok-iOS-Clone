//
//  SignInViewController.swift
//  TikTok_Clone
//
//  Created by 김광준 on 2021/04/18.
//

import UIKit

class SignInViewController: UIViewController, UITextFieldDelegate {
    
    // logo imageView
    private let logoImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.image = UIImage(named: "loge")
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
        addSubViews()
        
        emailField.delegate = self
        passwordField.delegate = self
        
        // configures actions of buttons method
        configureButtons()
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
        
    }
    
    @objc private func didTapSignUpButton() {
        
    }
    
    @objc private func didTapForgotPasswordButton() {
        
    }

}
