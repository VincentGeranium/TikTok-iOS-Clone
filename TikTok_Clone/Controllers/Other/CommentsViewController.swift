//
//  CommentsViewController.swift
//  TikTok_Clone
//
//  Created by 김광준 on 2021/04/30.
//

import UIKit

protocol CommentsViewControllerDelegate: AnyObject {
    func didCloseForComments(with viewController: CommentsViewController)
}

class CommentsViewController: UIViewController {

    // weak로 하는 이유 :  retain cycle 때문에
    weak var delegate: CommentsViewControllerDelegate?

    private var comments = [PostComment]()

    // tableView를 사용하여 comment를 구성할 것이다.
    private let tableView: UITableView = {
        let tableView: UITableView = UITableView()
        tableView.backgroundColor = .secondarySystemBackground
        tableView.register(
            CommentTableViewCell.self,
            forCellReuseIdentifier: CommentTableViewCell.identifier
        )
        return tableView
    }()

    private let closeButton: UIButton = {
        let button: UIButton = UIButton()
        button.setBackgroundImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .label
        return button
    }()

    private let post: PostModel

    init(post: PostModel) {
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("⭕️ : present CommentsVC")
        view.addSubview(closeButton)
        closeButton.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
        view.backgroundColor = .secondarySystemBackground
        fetchPostComment()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        /*
         viewDidLayoutSubviews에 closeButton.frame 코드를 안올렸더니 closeButton의 ui가 안보였다.
         옮기고 나니 정상작동.
         */
        closeButton.frame = CGRect(x: view.width - 45, y: 10, width: 35, height: 35)
        tableView.frame = CGRect(x: 0,
                                 y: closeButton.bottom,
                                 width: view.width,
                                 height: view.width - closeButton.bottom)
    }

    @objc private func didTapClose() {
        // close tring to close current CommentsViewController
        print("⭕️ : didTapClose method is working")
        delegate?.didCloseForComments(with: self)
    }

    func fetchPostComment() {
        // DatabaseManager.shared.fetchComment
        self.comments = PostComment.mockComment()
    }
}

extension CommentsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let comments = self.comments[indexPath.row]

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CommentTableViewCell.identifier,
            for: indexPath
        ) as? CommentTableViewCell else {
            return UITableViewCell()
        }

        cell.configure(with: comments)

        return cell
    }

    // 실제 테이블 뷰의 셀 높이를 조절하기 위한 method
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
