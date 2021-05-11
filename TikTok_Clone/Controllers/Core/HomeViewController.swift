//
//  ViewController.swift
//  TikTok_Clone
//
//  Created by 김광준 on 2021/04/18.
//

/*
 iOS Academy Viedeo in Creating Scrollable Feed
 - This lecture is about PagingViewController
 */

import UIKit

class HomeViewController: UIViewController {
    
    // closer pattern
    let horizontalScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        return scrollView
    }()
    
    let control: UISegmentedControl = {
        // left : following, right : for you
        let titles = ["Following", "For You"]
        //        MARK: - make own code for segment title color
        // segment title color이 검정색으로 바뀌지 않아 stackoverflow 에서 참고하여 만든 코드 -> let titleTextAttributes
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        let control = UISegmentedControl(items: titles)
        /*
         segment title color이 검정색으로 바뀌지 않아 stackoverflow 에서 참고하여 만든 코드
         -> control.setTitleTextAttributes(titleTextAttributes, for: .normal)
         */
        control.setTitleTextAttributes(titleTextAttributes, for: .normal)
        control.selectedSegmentIndex = 1
        control.backgroundColor = nil
        control.selectedSegmentTintColor = .white
        return control
    }()
    
    // make two PageViewController globaly
    let followingPagingController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .vertical,
        options: [:]
    )
    
    let forYouPagingController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .vertical,
        options: [:]
    )
    
    private var forYouPost = PostModel.mockModel()
    private var followingPosts = PostModel.mockModel()
    
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        view.addSubview(horizontalScrollView)
        horizontalScrollView.delegate = self
        setupFeed()
        // 조절된 content offset을 한정할 것인지에 대한 method
        horizontalScrollView.contentInsetAdjustmentBehavior = .never
        // tiktok에서 앱이 lunch 후 swipe시 처음 left side애서 swipe 되어야 하므로
        horizontalScrollView.contentOffset = CGPoint(x: view.width, y: 0)
        
        // segment controller
        setupHeaderButtons()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        horizontalScrollView.frame = view.bounds
    }
    
    func setupHeaderButtons() {
        control.addTarget(self, action: #selector(didChangeSegmentControl(_:)), for: .valueChanged)
        
        // setup UISegmentControl
        navigationItem.titleView = control
    }
    
    @objc private func didChangeSegmentControl(_ sender: UISegmentedControl) {
        // when segment control is changed view is changed
        horizontalScrollView.setContentOffset(CGPoint(x: view.width * CGFloat(sender.selectedSegmentIndex),
                                                      y: 0),
                                              animated: true)
        
    }
    
    
    /*
     this method have source code about create two pagingviewcontrollers
     - those two pagingControllers managing posts and collection
     */
    private func setupFeed() {
        // make horizontalScrolleViewContent
        horizontalScrollView.contentSize = CGSize(width: view.width * 2, height: view.height)
        
        setupFollowingFeed()
        setupForYouFeed()
        
    }
    
    func setupFollowingFeed() {
        guard let model = followingPosts.first else {
            return
        }
        let vc = PostViewController(model: model)
        vc.delegate = self
        // set primary view controller
        // c.f : primary = 일 순위
        followingPagingController.setViewControllers(
            [vc],
            direction: .forward,
            animated: false,
            completion: nil
        )
        
        followingPagingController.dataSource = self
        
        horizontalScrollView.addSubview(followingPagingController.view)
        followingPagingController.view.frame = CGRect(x: 0,
                                                      y: 0,
                                                      width: horizontalScrollView.width,
                                                      height: horizontalScrollView.height)
        addChild(followingPagingController)
        followingPagingController.didMove(toParent: self)
    }
    
    func setupForYouFeed() {
        guard let model = forYouPost.first else {
            return
        }
        let vc = PostViewController(model: model)
        vc.delegate = self
        // set primary view controller
        // c.f : primary = 일 순위
        forYouPagingController.setViewControllers(
            [vc],
            direction: .forward,
            animated: false,
            completion: nil
        )
        
        forYouPagingController.dataSource = self
        
        horizontalScrollView.addSubview(forYouPagingController.view)
        forYouPagingController.view.frame = CGRect(x: view.width,
                                                   y: 0,
                                                   width: horizontalScrollView.width,
                                                   height: horizontalScrollView.height)
        addChild(forYouPagingController)
        forYouPagingController.didMove(toParent: self)
    }
}

extension HomeViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        // get current user viewing
        // where the scrolling from post
        // cast from PostViewController
        guard let fromPost = (viewController as? PostViewController)?.model else {
            return nil
        }
        
        // where is post comming from: 포스트가 어디서 왔는지 알기위해서
        guard let index = currentPosts.firstIndex(where: {
            $0.identifier == fromPost.identifier
        }) else {
            return nil
        }
        
        if index == 0 {
            return nil
        }
        
        // otherwise get previous model
        let priorIndex = index - 1
        let model = currentPosts[priorIndex]
        let vc = PostViewController(model: model)
        vc.delegate = self
        return vc
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        // 17:15 부터
        // RandomViewController가 아닌 실제 Posting ViewController이 swipe시 보일 수 있도록 하기 위해
        // fromPost: post가 어디서 왔는지 알기위해
        guard let fromPost = (viewController as? PostViewController)?.model else {
            return nil
        }
        
        guard let index = currentPosts.firstIndex(where: {
            // identifier must be unique
            $0.identifier == fromPost.identifier
        }) else {
            return nil
        }
        
        // 실제 Array에서 out of bounds(배열의 요소수 보다 적은 경우) crush가 나는데 그것에 관한 코드?
        // index less than currentPost
        // 마지막 인덱스에 대한 crush 관련 코드
        guard index < (currentPosts.count - 1) else {
            return nil
        }
        
        let nextIndex = index + 1
        let model = currentPosts[nextIndex]
        let vc = PostViewController(model: model)
        vc.delegate = self
        return vc
    }
    
    // computed property
    // check view
    var currentPosts: [PostModel] {
        if horizontalScrollView.contentOffset.x == 0 {
            // Following
            // all the way is left
            return followingPosts
        }
        
        // For You
        return forYouPost
    }
    
    
}

extension HomeViewController: UIScrollViewDelegate {
    // 유저가 segment를 눌러서 뷰를 change 하지 않고 스스로 view를 swipe하여 바꿀 경우 segment도 함께 변하개 하려는 code
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x == 0 || scrollView.contentOffset.x <= (view.width/2){
            control.selectedSegmentIndex = 0
        }
        else if scrollView.contentOffset.x > (view.width/2) {
            // 스크롤 뷰가 반 이상 넘어갈 경우 segment control change 한다.
            control.selectedSegmentIndex = 1
        }
    }
}

extension HomeViewController: PostViewControllerDelegate {
    func postViewController(_ vc: PostViewController, didTapCommentButtonFor post: PostModel) {
        /*
         horizontalScrollView.contentOffset.x == 0
            => this code means following page
         */
        
        /*
         from horizontalScrollView.isScrollEnabled = false to end of else statement code mean
         when tapped commment button the comment vc is present and user can't scroll any view
         */
        horizontalScrollView.isScrollEnabled = false
        if horizontalScrollView.contentOffset.x == 0 {
            // following
            followingPagingController.dataSource = nil
        } else {
            forYouPagingController.dataSource = nil
        }
        
        let vc = CommentsViewController(post: post)
        vc.delegate = self
        addChild(vc)
        vc.didMove(toParent: self)
        view.addSubview(vc.view)
        let frame = CGRect(x: 0, y: view.height, width: view.width, height: view.height * 0.76)
        vc.view.frame =  frame
        UIView.animate(withDuration: 0.2) {
            vc.view.frame = CGRect(x: 0, y: self.view.height - frame.height, width: frame.width, height: frame.height)
        }
    }
    
    func postViewController(_ vc: PostViewController, didTapProfileButtonFor post: PostModel) {
        // 아래의 user property가 vc property의 user로 들어감.
        let user = post.user
        let vc = ProfileViewController(user: user)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeViewController: CommentsViewControllerDelegate {
    func didCloseForComments(with viewController: CommentsViewController) {
        // 1. close comments with animation
        let frame = viewController.view.frame
        UIView.animate(withDuration: 0.2) {
            viewController.view.frame = CGRect(x: 0, y: self.view.height, width: frame.width, height: frame.height)
        } completion: { [weak self] done in
            if done {
                // ui 관련 코드는 main thread 애서 관리하고 처리한다
                DispatchQueue.main.async {
                    // 2. remove comment vc as child
                    viewController.view.removeFromSuperview()
                    viewController.removeFromParent()
                    // 3. allow horizontal and vertical scroll
                    self?.horizontalScrollView.isScrollEnabled = true
                    self?.forYouPagingController.dataSource = self
                    self?.followingPagingController.dataSource = self
                }
            }
        }
    }
}

