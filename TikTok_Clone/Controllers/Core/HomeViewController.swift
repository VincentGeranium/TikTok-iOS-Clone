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
    private let horizontalScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .red
        scrollView.bounces = false
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
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
    
    
    
    // MARK : -Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        view.addSubview(horizontalScrollView)
        setupFeed()
        // tiktok에서 앱이 lunch 후 swipe시 처음 left side애서 swipe 되어야 하므로
        horizontalScrollView.contentOffset = CGPoint(x: view.width, y: 0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        horizontalScrollView.frame = view.bounds
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
        let vc = UIViewController()
        vc.view.backgroundColor = .blue
        
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
        let vc = UIViewController()
        vc.view.backgroundColor = .blue
        
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
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        // 17:15 부터
        // RandomViewController가 아닌 실제 Posting ViewController이 swipe시 보일 수 있도록 하기 위해
        
        let vc = UIViewController()
        vc.view.backgroundColor = [UIColor.red, UIColor.blue, UIColor.green, UIColor.systemPink].randomElement()
        return vc
    }
    
    
}

