//
//  ExploreViewController.swift
//  TikTok_Clone
//
//  Created by ê¹ê´ì¤ on 2021/04/18.
//

import UIKit

// this ViewController is compotional colletcionView
// make colletcionView but different layout section

/// Holding a Collection View with Composition layout.
class ExploreViewController: UIViewController {

    // make property searchBar global space
    private let searchBar: UISearchBar = {
        let searchBar: UISearchBar = UISearchBar()
        searchBar.placeholder = "Search..."
        searchBar.layer.masksToBounds = true
        searchBar.layer.cornerRadius = 8
        return searchBar
    }()

    // collection section
    // ExploreSection Object
    private var sections = [ExploreSection]()

    /*
     ð
     ìµìëì¸ ì´ì 
     1. configure(íê²½ì¤ì )ì ìì ì ìí´
     2. ê°ê¸° ë¤ë¥¸ collection layoutì custom íê² ë§ë¤ê¸° ìí´
     */
    // primary view for collectionView
    // the drive explore page
    private var colletcionView: UICollectionView?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        ExploreManager.shared.delegate = self
        configureModels()
        setUpSearchBar()
        setUpCollectionView()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // for setuo colletcionView frame
        colletcionView?.frame = view.bounds
    }

    // MARK: - SetUp SearchBar
    func setUpSearchBar() {
        // Attach in view used by navigationItem, Display in view
        navigationItem.titleView = searchBar
        searchBar.delegate = self
    }

    // MARK: - Configure Models // 29:30
    private func configureModels() {
        // configure the each sections
// 15:30        // configure the each sections

// MARK: - Creat all model of cases
        // Banner
        sections.append(
            ExploreSection(
                type: .banner,
                // to convert them to ExploreCell.banner(viewModel: $0) -> cell type of banner passing in the element which each viewModel
                cells: ExploreManager.shared.getExploreBanners().compactMap({
                    return ExploreCell.banner(viewModel: $0)
                })
            )
        )

        // Trending Posts
        sections.append(
            ExploreSection(
                type: .trendingPosts,
                cells: ExploreManager.shared.getExploreTrendingPosts().compactMap({
                    return ExploreCell.post(viewModel: $0)
                })
            )
        )

        // Users
        sections.append(
            ExploreSection(
                type: .users,
                cells: ExploreManager.shared.getExploreCreators().compactMap({
                    return ExploreCell.user(viewModel: $0)
                })
            )
        )

        // Trending hashtags
        sections.append(
            ExploreSection(
                type: .trendingHashtags,
                cells: ExploreManager.shared.getExploreHashtags().compactMap({
                    return ExploreCell.hashtag(viewModel: $0)
                })
            )
        )

        // Popular
        sections.append(
            ExploreSection(
                type: .popular,
                cells: ExploreManager.shared.getExplorePopularPosts().compactMap({
                    return ExploreCell.post(viewModel: $0)
                })
            )
        )

        // new
        sections.append(
            ExploreSection(
                type: .new,
                cells: ExploreManager.shared.getExploreRecentPosts().compactMap({
                    return ExploreCell.post(viewModel: $0)
                })
            )
        )
    }

    // MARK: - SetUp CollectionViewLayout, setUpCollectionView method
    func setUpCollectionView() {
        let layout: UICollectionViewCompositionalLayout = UICollectionViewCompositionalLayout { section, _ -> NSCollectionLayoutSection? in
            // return layout each every section
            // make dynamically
            return self.layout(for: section)

        }

        let collectionView = UICollectionView(
            frame: .zero,
            // collectionViewLayoutìì ê°ì¥ ì¤ìí parameter
            collectionViewLayout: layout
        )
        // basic collectionView register
        collectionView.register(
            UICollectionViewCell.self,
            forCellWithReuseIdentifier: "cell"
        )

        // collectionView regist the ExploreBannerCollectionViewCell.
        collectionView.register(
            ExploreBannerCollectionViewCell.self,
            forCellWithReuseIdentifier: ExploreBannerCollectionViewCell.identifier
        )

        // collectionView regist the ExploreUserCollectionViewCell
        collectionView.register(
            ExploreUserCollectionViewCell.self,
            forCellWithReuseIdentifier: ExploreUserCollectionViewCell.identifier
        )

        // collectionView regist the ExploreHashtagCollectionViewCell.
        collectionView.register(
            ExploreHashtagCollectionViewCell.self,
            forCellWithReuseIdentifier: ExploreHashtagCollectionViewCell.idetifier
        )

        // collectionView regist the ExplorePostCollectionViewCell
        collectionView.register(
            ExplorePostCollectionViewCell.self,
            forCellWithReuseIdentifier: ExplorePostCollectionViewCell.identifier
        )

        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self

        view.addSubview(collectionView)

        self.colletcionView = collectionView
    }
}

// MARK: - extension
// colletcionViewë¥¼ ìí extenstion
extension ExploreViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    /*
     two require function
     1. collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
     2. collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
     */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // number of item return
        // sectionsì ì£¼ì´ì§ sectionì cell ê°¯ì ë§í¼ ë°í
        return sections[section].cells.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        /*
         how we gonna be return differents cells, each of cell types
         in this case model is each sections of cells, actually enum value
         so, make switch statment
         */

        // model for the cell
        // ExploreSectionì ê°ë¦¬í¤ê³  -> ê·¸ ìì cellsì ê°ë¦¬í¤ê³  -> ë§ì§ë§ì ExploreCell enumì ê°ë¦¬í¨ë¤.
        let model = sections[indexPath.section].cells[indexPath.row]

        switch model {
        // bring all differents types here (banner, post, hashtag, user)
        // dequeue all this differents cells
        case .banner(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: ExploreBannerCollectionViewCell.identifier,
                    for: indexPath
            ) as? ExploreBannerCollectionViewCell else {
                return collectionView.dequeueReusableCell(
                    withReuseIdentifier: "cell",
                    for: indexPath
                )
            }
            cell.configure(with: viewModel)
            return cell

        case .post(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ExplorePostCollectionViewCell.identifier,
                    for: indexPath
            ) as? ExplorePostCollectionViewCell else {
                return collectionView.dequeueReusableCell(
                    withReuseIdentifier: "cell",
                    for: indexPath
                )
            }
            cell.configure(with: viewModel)
            return cell

        case .hashtag(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ExploreHashtagCollectionViewCell.idetifier,
                    for: indexPath
            ) as? ExploreHashtagCollectionViewCell else {
                return collectionView.dequeueReusableCell(
                    withReuseIdentifier: "cell",
                    for: indexPath
                )
            }
            cell.configure(with: viewModel)
            return cell

        case .user(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ExploreUserCollectionViewCell.identifier,
                for: indexPath
            ) as? ExploreUserCollectionViewCell else {
                return collectionView.dequeueReusableCell(
                    withReuseIdentifier: "cell",
                    for: indexPath
                )
            }
            cell.configure(with: viewModel)
            return cell
        }

        // actual return the colletcion view item
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "cell",
            for: indexPath
        )

        // this backgroundColor is for developing, test color
        cell.backgroundColor = .red
        return cell
    }

    // collectionViewì cellì ì íì ì§íëë ì½ë.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        HapticsManager.shared.vibrateForSelection()

        let model = sections[indexPath.section].cells[indexPath.row]

        // handlerë viewController ê° push ë ë¤ì ì¤íì´ëë¤.
        switch model {
        case .banner(viewModel: let viewModel):
            viewModel.handler()
        case .post(viewModel: let viewModel):
            viewModel.handler()
        case .hashtag(viewModel: let viewModel):
            viewModel.handler()
        case .user(viewModel: let viewModel):
            viewModel.handler()
        }
    }

}

// serchBarë¥¼ ìí extension
extension ExploreViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        // make Cancel button and keyboard dismissed + all text is deleted
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(didTapCancel))
    }

    @objc private func didTapCancel() {
        // Cancel button delete code
        navigationItem.rightBarButtonItem = nil

        searchBar.text = nil
        searchBar.resignFirstResponder()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Cancel button delete code
        navigationItem.rightBarButtonItem = nil
        // keyboard is missing, dismiss
        searchBar.resignFirstResponder()
    }
}

// MARK: - extension about Section Layout
extension ExploreViewController {
    // layout(for section:) method
    // layout argument is most important pices this
    // make model for which section in and how to layout
    // this function is make different each of section layout and return it
    func layout(for section: Int) -> NSCollectionLayoutSection {
        let sectionType = sections[section].type
        switch sectionType {
        // bring all differents cases
        case .banner:
            // what is layout consist of ??
            // 1. Item
            // three different way to various of component
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    // fractionalHeight is percent of height
                    // fractionalWidth is percent of width
                    // c.f : when using fractional, 1 is means 100%
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )

            // apply contentInsets of item
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)

            // 2. Group (items are going)
            // cell will be scroller so selected horizontal(layoutSize:, subitems:) method
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.90),
                    heightDimension: .absolute(200)
                ),
                subitems: [item]
            )

            // 3. Section layout
            let sectionLayout = NSCollectionLayoutSection(group: group)
            // sectionLayoutì horizontalíê² scroll íê¸° ìí method
            sectionLayout.orthogonalScrollingBehavior = .groupPaging

            // 4. Return set section layout
            return sectionLayout

        case .users:
            // 1. Item
            // three different way to various of component
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    // fractionalHeight is percent of height
                    // fractionalWidth is percent of width
                    // c.f : when using fractional, 1 is means 100%
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )

            // apply contentInsets of item
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)

            // 2. Group (items are going)
            // cell will be scroller so selected horizontal(layoutSize:, subitems:) method
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(200),
                    heightDimension: .absolute(200)
                ),
                subitems: [item]
            )

            // 3. Section layout
            let sectionLayout = NSCollectionLayoutSection(group: group)
            // sectionLayoutì horizontalíê² scroll íê¸° ìí method
            sectionLayout.orthogonalScrollingBehavior = .continuous

            // 4. Return set section layout
            return sectionLayout

        // trending hastag layout is make vertical three group of time
        case .trendingHashtags:
            // 1. Item
            // three different way to various of component
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    // fractionalHeight is percent of height
                    // fractionalWidth is percent of width
                    // c.f : when using fractional, 1 is means 100%
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )

            // apply contentInsets of item
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)

            // 2. Group (items are going)
            // cell will be scroller so selected horizontal(layoutSize:, subitems:) method
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(60)
                ),
                subitems: [item]
            )

            // 3. Section layout
            let sectionLayout = NSCollectionLayoutSection(group: verticalGroup)

            // 4. Return set section layout
            return sectionLayout

        // trendind post ,popular, recommended and new is same style layout so code is like this used by switch statement
        case .trendingPosts, .recommended, .new:
            // 1. Item
            // three different way to various of component
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    // fractionalHeight is percent of height
                    // fractionalWidth is percent of width
                    // c.f : when using fractional, 1 is means 100%
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )

            // apply contentInsets of item
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)

            // 2. Group (items are going)
            // cell will be scroller so selected horizontal(layoutSize:, subitems:) method
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(100),
                    heightDimension: .absolute(240)
                ),
                subitem: item,
                count: 2
            )

            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(110),
                    heightDimension: .absolute(240)
                ),
                subitems: [verticalGroup]
            )

            // 3. Section layout
            let sectionLayout = NSCollectionLayoutSection(group: group)
            // sectionLayoutì horizontalíê² scroll íê¸° ìí method
            sectionLayout.orthogonalScrollingBehavior = .continuous

            // 4. Return set section layout
            return sectionLayout

        case .popular:
            // 1. Item
            // three different way to various of component
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    // fractionalHeight is percent of height
                    // fractionalWidth is percent of width
                    // c.f : when using fractional, 1 is means 100%
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )

            // apply contentInsets of item
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)

            // 2. Group (items are going)
            // cell will be scroller so selected horizontal(layoutSize:, subitems:) method

            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(110),
                    heightDimension: .absolute(200)
                ),
                subitems: [item]
            )

            // 3. Section layout
            let sectionLayout = NSCollectionLayoutSection(group: group)
            // sectionLayoutì horizontalíê² scroll íê¸° ìí method
            sectionLayout.orthogonalScrollingBehavior = .continuous

            // 4. Return set section layout
            return sectionLayout

        }
    }
}

// MARK: - extension about ExploreManagerDelegate
extension ExploreViewController: ExploreManagerDelegate {
    func pushViewController(_ vc: UIViewController) {
        // this haptic function is not aggressive vibration it's very common settle vibration
        // when user push viewController, play hpatic.
        HapticsManager.shared.vibrateForSelection()
        //
        navigationController?.pushViewController(vc, animated: true)
    }

    func didTapHashtag(_ hashtag: String) {
        // this haptic function is not aggressive vibration it's very common settle vibration
        // when user tap hashtag play haptic
        HapticsManager.shared.vibrateForSelection()
        // update used by search bar text
        searchBar.text = hashtag
        searchBar.becomeFirstResponder()
    }
}
