//
//  PostViewController.swift
//  TikTok_Clone
//
//  Created by 김광준 on 2021/04/18.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

protocol PostViewControllerDelegate: AnyObject {
    func postViewController(_ vc: PostViewController, didTapCommentButtonFor post: PostModel)
    func postViewController(_ vc: PostViewController, didTapProfileButtonFor post: PostModel)
}

class PostViewController: UIViewController {
    
    weak var delegate: PostViewControllerDelegate?
    
    var model: PostModel
    
    private let likeButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "heart.fill"), for: .normal)
        // button의 image가 들어갔을 때 이미지가 이상하게 변하지 않도록 상황에 따라 다른 contentMode 값을 줘야 함
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .white
        return button
    }()
    
    private let commentButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "text.bubble.fill"), for: .normal)
        // button의 image가 들어갔을 때 이미지가 이상하게 변하지 않도록 상황에 따라 다른 contentMode 값을 줘야 함
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .white
        return button
    }()
    
    private let shareButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        // button의 image가 들어갔을 때 이미지가 이상하게 변하지 않도록 상황에 따라 다른 contentMode 값을 줘야 함
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .white
        return button
    }()
    
    private let profileButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "test"), for: .normal)
        button.layer.masksToBounds = true
        // button의 image가 들어갔을 때 이미지가 이상하게 변하지 않도록 상황에 따라 다른 contentMode 값을 줘야 함
        button.imageView?.contentMode = .scaleAspectFill
        button.tintColor = .white
        return button
    }()
    
    
    
    // 모든 post는 caption이다
    private let captionLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textAlignment = .left
        // numberOfLines를 0으로 만들면 label의 라인이 0이므로 unlimit한 라인 레이블이 된다. 즉, 무제한 라인.
        label.numberOfLines = 0
        label.text = "This is dummy label text #thisIsTest #Ihope #IWannaGoodJob #GiveMeJob"
        // bump up the label size used by font size
        label.font = UIFont.systemFont(ofSize: 24)
        label.textColor = .white
        return label
    }()
    
    // MARK: - Init
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
        setupDoubleTapToLikeButton()
        view.addSubview(captionLabel)
        view.addSubview(profileButton)
        
        // actuall profileButton Action Method
        profileButton.addTarget(self, action: #selector(didTapProfileButton), for: .touchUpInside)
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
            button.frame = CGRect(x: view.width-size-10, y: yStart + ((CGFloat(index) * 10) + (CGFloat(index) * size)), width: size, height: size)
        }
        
        // setup captionLabel frame code
        // captionLabel.sizeToFit() => Autometic resizing code but not correct
        captionLabel.sizeToFit()
        // size of label
        let labelSize = captionLabel.sizeThatFits(CGSize(width: view.width - size - 12, height: view.height))
        // height is dynamic format
        // width is basically entire screen width(view.width) and subtract size of button(size), -12 is padding
        captionLabel.frame = CGRect(x: 5,
                                    y: view.height - 10 - view.safeAreaInsets.bottom - labelSize.height - (tabBarController?.tabBar.height ?? 0),
                                    width: view.width - size - 12,
                                    height: labelSize.height
        )
        
        // setup profile button frame
        profileButton.frame = CGRect(x: likeButton.left,
                                     y: likeButton.top - 10 - size,
                                     width: size,
                                     height: size
        )
        
        // for make profile circular shape button
        profileButton.layer.cornerRadius = size / 2
    }
    
    // profile vc를 call 하는 것은 comment tray를 call 하는 것과 비슷하다 => protocol을 이용한다
    @objc func didTapProfileButton() {
        // delegate, 즉 이 프로토콜을 confirming 하려면 HomeViewController의 extension에서 protocol을 받아줘야 한다.
        delegate?.postViewController(self, didTapProfileButtonFor: model)
    }
    
    
    func setupButtons() {
        view.addSubview(likeButton)
        view.addSubview(commentButton)
        view.addSubview(shareButton)
        
        likeButton.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
        commentButton.addTarget(self, action: #selector(didTapCommentButton), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(didTapShareButton), for: .touchUpInside)
    }
    
    @objc private func didTapLikeButton() {
        // when like button touched
        // default value 인 false에서 true로 바뀜
        // this code like toggle logic
        // inverse isLinkedByCurrentUsers
        model.isLikedByCurrentUsers = !model.isLikedByCurrentUsers
        
        
        // button을 tapped 시 색이 바뀌게 하는 코드
        // 삼항연산자 사용
        // likeButton update logic code
        likeButton.tintColor = model.isLikedByCurrentUsers ? .systemRed : .white
    }
    
    @objc private func didTapCommentButton() {
//        (parent as? UIPageViewController)?.view?.isUserInteractionEnabled = false
//        let vc = CommentsViewController(post: model)
//        addChild(vc)
//        vc.didMove(toParent: self)
//        view.addSubview(vc.view)
//        let frame = CGRect(x: 0, y: view.height, width: view.width, height: view.height * 0.76)
//        vc.view.frame =  frame
//        UIView.animate(withDuration: 0.2) {
//            vc.view.frame = CGRect(x: 0, y: self.view.height - frame.height, width: frame.width, height: frame.height)
//        }
        delegate?.postViewController(self, didTapCommentButtonFor: model)
    }
    
    @objc private func didTapShareButton() {
        // when share button tapped, share 관련 UIActivityViewController를 이용하여 method 띄우기.
        guard let url = URL(string: "https://www.tiktok.com") else {
            // this is dummy url as for develop app and test
            return
        }
        
        let vc = UIActivityViewController(
            activityItems: [url],
            applicationActivities: []
        )
        present(vc, animated: true, completion: nil)
    }
    
    func setupDoubleTapToLikeButton() {
        // UITapGestureRecognizer를 사용하여 button을 double tapped 할 경우 작동하게 하는 logic
        let tap = UITapGestureRecognizer(target: self, action: #selector(didDoubleTapped(_:)))
        // tap gesture configure
        // have to tapped 2 times
        //        tap.numberOfTouchesRequired = 2 -> 2손가락으로 터치시 동작하는 코드
        // 2번의 탭을 해야 동작하는 코드
        tap.numberOfTapsRequired = 2
        // UITapGestureRecognaizer 관련하여 tap을 만들고 그것을 view에 add
        view.addGestureRecognizer(tap)
        // isUserInteractionEnabled 어떤 기능인지 알아보자.
        view.isUserInteractionEnabled = true
        
        
    }
    
    // UITapGestureRecognizer를 사용하므로 그에 맞는 parameter와 parameter type인 UITapGestureRecognizer를 준다.
    @objc private func didDoubleTapped(_ gesture: UITapGestureRecognizer) {
        
        //        print("🛑 : Double Tapped is Worked")
        // 더블 탭 했을 때 데이터 베이스에서 한 번으로 인식하고 그에 대한 결과값을 돌려주기 위해?
        if !model.isLikedByCurrentUsers {
            print("🛑 : Double Tapped is Worked")
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
                DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
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

