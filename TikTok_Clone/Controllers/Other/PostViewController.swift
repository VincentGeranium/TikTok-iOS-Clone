//
//  PostViewController.swift
//  TikTok_Clone
//
//  Created by 김광준 on 2021/04/18.
//

// AVFoudation : Apple audio and video handling framework
// Work with audiovisual assets, control device cameras, process audio, and configure system audio interactions.

import AVFoundation
import UIKit
import UIKit.UIGestureRecognizerSubclass

protocol PostViewControllerDelegate: AnyObject {
    func postViewController(_ vc: PostViewController, didTapCommentButtonFor post: PostModel)
    func postViewController(_ vc: PostViewController, didTapProfileButtonFor post: PostModel)
}

class PostViewController: UIViewController {
    
    weak var delegate: PostViewControllerDelegate?
    
    // MARK:- PostModel property
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
    
    // avplayer
    var player: AVPlayer?
    
    // Make Video Auto play infinitly, Make Observer pattern
    private var playDidFinishObserver: NSObjectProtocol?
    
    // make hole video view
    private let videoView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = .black
        view.clipsToBounds = true
        return view
    }()
    
    // spinner
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.tintColor = .label
        spinner.hidesWhenStopped = true
        // reason of start animating in here, we want to start right away
        spinner.startAnimating()
        return spinner
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
        view.backgroundColor = .black
        // added videoView on the top layer
        view.addSubview(videoView)
        
        // added spinner in the videoView
        videoView.addSubview(spinner)
        
        // about video method
        // configureVideo 메소드가 view.addSubview 메소드보다 아래에 있을 경우 만들어진 모든 button들이 가려진다.
        // 그러므로 configureVideo method가 먼저 올라가야 한다.
        // about layer
        configureVideo()
        
        // make random background color for test
//        let colors: [UIColor] = [
//            .red, .blue, .systemYellow, .systemPink, .gray, .orange, .green
//        ]
        // MARK:- setup view's random color background for develop
//        view.backgroundColor = colors.randomElement()
        
        setupButtons()
        setupDoubleTapToLikeButton()
        view.addSubview(captionLabel)
        view.addSubview(profileButton)
        
        // actuall profileButton Action Method
        profileButton.addTarget(self, action: #selector(didTapProfileButton), for: .touchUpInside)
        
        // about video method
//        configureVideo()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // give the same size as entire view
        videoView.frame = view.bounds
        
        // wanna spinner show center and frame width and height 100
        spinner.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        spinner.center = videoView.center
        
        
        /*
         실제 autolayout에서 긴 computation을 code로 작업 할 경우 error이 일어나는 경우가 있다
         그래서 너무 긴 computation은 따로 property로 만들어 작업하는 것이 좋다.
         */
        
        // button size
        let size: CGFloat = 40
        
        // tabBarHeight
        /* tabBarHeight를 없앰으로 인해 HomeViewController의 viewDidLoad 안에 만든
         horizontalScrollView.contentInsetAdjustmentBehavior = .never 메소드가 동작하여 이전의 맞지 않았던 scrollView 관련
         bug를 잡을 수 있다.
         
         tabBarHeight을 없애는 이유는 이미 bottom inset이 있어 크기를 조절하는 것을 담당하기 때문에 tabBarHeight를 없애서ui 사이즈가 맞지 않는 것을 해결 할 수 있다.
         
         c.f : tabBarHeight와 묶여 사이즈를 조절하고 담당하던 코드들을 모두 수정해야 한다.
         */
//        let tabBarHeight: CGFloat = (tabBarController?.tabBar.height ?? 0)
//        let tabBarHeight: CGFloat = 0
        
        // y축을 기준으로 버튼들이 움직여야 하므로 다음과 같은 yStart property를 만들고 사용한다.
        let yStart: CGFloat = view.height - (size * 4.0) - 30 - view.safeAreaInsets.bottom
        
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
        
        /*
         captionLabel.frame에서 y를 view.height - 10 - view.safeAreaInsets.bottom - labelSize.height - (tabBarController?.tabBar.height ?? 0)로
         만들었었으나 tabBarHeight가 있으면 Bottom Inset과 함께 동작하여 captionLabel이 위로 떠 있는 듯한 UI가 만들어지므로 tabBarHeight에 관련된 코드를 지워 수정한다.
         */
        captionLabel.frame = CGRect(x: 5,
                                    y: view.height - 10 - view.safeAreaInsets.bottom - labelSize.height,
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
    
    // MARK:- configureVideo()
    //
    private func configureVideo() {
        // 1,2는 mock data
        
        // StorageManger에 만든 video url을 가져오는 method를 이용하여 url을 가져오게한다.
        /*
         ‼️ closure 안에 만든 property는 문법상 명확하게 그 property가 어떤 property인지 알 수 있도록 꼭 self.를 넣어줘야 한다.
         그렇지 않을 경우 syntax error이 나온다.
         */
        
        StorageManager.shared.getDownloadURL(for: model) { [weak self] result in
            // unwrap self as strong self
                // this pattern is fairly pattern
            guard let strongSelf = self else {
                return
            }
            
            // get result back
                // stop animating
            strongSelf.spinner.stopAnimating()
                // remove from hierarchy
            strongSelf.spinner.removeFromSuperview()
            
            DispatchQueue.main.async {
                switch result {
                case .success(let url):
                    // player에 url로 바뀐 video path 넣어서 video 준비
                    strongSelf.player = AVPlayer(url: url)
                    
                    // 3. 준비 된 비디오를 포스팅하는 코드 and video player frame setup
                    let playerLayer = AVPlayerLayer(player: strongSelf.player)
                    playerLayer.frame = strongSelf.view.bounds
                    playerLayer.videoGravity = .resizeAspectFill
                    // added video player
                    // play back layer
                    strongSelf.videoView.layer.addSublayer(playerLayer)
                    strongSelf.player?.volume = 0
                    strongSelf.player?.play()
                case .failure:
                    // this is mock data for first lunched app and show video
                    guard let path = Bundle.main.path(forResource: "mockVideo", ofType: "mp4") else {
                        return
                    }
                    let url = URL(fileURLWithPath: path)
                    strongSelf.player = AVPlayer(url: url)
                    
                    let playerLayer = AVPlayerLayer(player: strongSelf.player)
                    playerLayer.frame = strongSelf.view.bounds
                    playerLayer.videoGravity = .resizeAspectFill
                    strongSelf.videoView.layer.addSublayer(playerLayer)
                    strongSelf.player?.volume = 0
                    strongSelf.player?.play()
                }
            }
        }
        
        
        // player가 optional 이므로 unwrapping 해준다
        guard let player = player  else {
            return
        }
        
        // setup observer for auto video play
        playDidFinishObserver = NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem,
            queue: OperationQueue.main) { _ in
            // trailing closure
            // actually notification handling, complition handle
            player.seek(to: .zero)
            player.play()
        }
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

