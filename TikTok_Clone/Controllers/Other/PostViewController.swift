//
//  PostViewController.swift
//  TikTok_Clone
//
//  Created by 김광준 on 2021/04/18.
//

import UIKit

class PostViewController: UIViewController {
    
    var model: PostModel
    
    private let likeButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "heart.fill"), for: .normal)
        // button의 image가 들어갔을 때 이미지가 이상하게 변하지 않도록
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .white
        return button
    }()
    
    private let commentButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "text.bubble.fill"), for: .normal)
        // button의 image가 들어갔을 때 이미지가 이상하게 변하지 않도록
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .white
        return button
    }()
    
    private let shareButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        // button의 image가 들어갔을 때 이미지가 이상하게 변하지 않도록
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .white
        return button
    }()
    
    init(model: PostModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // make random background color for test
        let colors: [UIColor] = [
            .red, .blue, .systemYellow, .systemPink, .gray, .orange, .green
        ]
        
        view.backgroundColor = colors.randomElement()
        
        setupButtons()
        setupDoubleTappedLikeButton()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // button size
        let size: CGFloat = 40
        
        // y축을 기준으로 버튼들이 움직여야 하므로 다음과 같은 yStart property를 만들고 사용한다.
        let yStart: CGFloat = view.height - (size * 4) - 30 - view.safeAreaInsets.bottom - (tabBarController?.tabBar.height ?? 0)
        
        // x좌표의 -10는 padding
        // y좌표의 + (), 괄호 안에 들어가는 것은 giving postion이다
        for (index, button) in [likeButton, commentButton, shareButton].enumerated() {
            button.frame = CGRect(x: view.width-size-10, y: yStart + ((CGFloat(index) + 10) + (CGFloat(index) * size)), width: size, height: size)
            
        }
    }
    
    

    
    func setupButtons() {
        view.addSubview(likeButton)
        view.addSubview(commentButton)
        view.addSubview(shareButton)
        
        likeButton.addTarget(self, action: #selector(didTappedLikeButton(_:)), for: .touchUpInside)
        commentButton.addTarget(self, action: #selector(didTappedCommentButton(_:)), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(didTappedShareButton(_:)), for: .touchUpInside)
    }
    
    @objc private func didTappedLikeButton(_ sender: UIButton) {
        // when like button touched
        // default value 인 false에서 true로 바뀜
        // this code like toggle logic
        model.isLikedByCurrentUsers = !model.isLikedByCurrentUsers
        
        // button을 tapped 시 색이 바뀌게 하는 코드
        // 삼항연산자 사용
        likeButton.tintColor = model.isLikedByCurrentUsers ? .systemRed : .white
    }
    
    @objc private func didTappedCommentButton(_ sender: UIButton) {
        // Present comment tray
        
    }
    
    @objc private func didTappedShareButton(_ sender: UIButton) {
        // when share button tapped, share 관련 UIActivityViewController를 이용하여 method 띄우기.
        guard let url = URL(string: "https://www.tiktok.com") else {
            return
        }
        
        let vc = UIActivityViewController(
            activityItems: [url],
            applicationActivities: []
        )
        present(vc, animated: true, completion: nil)
    }
    
    func setupDoubleTappedLikeButton() {
        // UITapGestureRecognizer를 사용하여 button을 double tapped 할 경우 작동하게 하는 logic
        let tap = UITapGestureRecognizer(target: self, action: #selector(didDoubleTapped(_:)))
        // tap gesture configure
        // have to tapped 2 times
        tap.numberOfTouchesRequired = 2
        // UITapGestureRecognaizer 관련하여 tap을 만들고 그것을 view에 add
        view.addGestureRecognizer(tap)
        // isUserInteractionEnabled 어떤 기능인지 알아보자.
        view.isUserInteractionEnabled = true
    }
    
    // UITapGestureRecognizer를 사용하므로 그에 맞는 parameter와 parameter type인 UITapGestureRecognizer를 준다.
    @objc private func didDoubleTapped(_ gesture: UITapGestureRecognizer) {
        if !model.isLikedByCurrentUsers {
            model.isLikedByCurrentUsers = true
        }
        
        // make animation when double tapped
        // .loction의 parameter인 uiview는 current view
        let touchPoint = gesture.location(in: view)
        
        // image를 Fade-In, Fade-Out 기법을 이용하여 double tap 시 animation으로 작동하게 만들기.
        let imageView = UIImageView(image: UIImage(systemName: "heart.fill"))
        // 각기 다른 tintColor을 준다
        imageView.tintColor = .systemRed
        imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        imageView.center = touchPoint
        imageView.contentMode = .scaleAspectFit
        // alpha = 0 is default value
        imageView.alpha = 0
        view.addSubview(imageView)
        
        // alpha value를 변하게 하므로서 animation을 준다
        UIView.animate(withDuration: 0.2) {
            imageView.alpha = 1
        } completion: { done in
            if done {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    // 실제 Fade out 코드
                    UIView.animate(withDuration: 0.3) {
                        imageView.alpha = 0
                    } completion: { done in
                        if done {
                            imageView.removeFromSuperview()
                        }
                    }
                }
            }
        }
    }
}
