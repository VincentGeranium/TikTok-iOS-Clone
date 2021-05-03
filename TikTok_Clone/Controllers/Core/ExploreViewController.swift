//
//  ExploreViewController.swift
//  TikTok_Clone
//
//  Created by 김광준 on 2021/04/18.
//

import UIKit

// this ViewController is compotional colletcionView
// make colletcionView but different layout section

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
     🛑
     옵셔널인 이유
     1. configure(환경설정)시 안정을 위해
     2. 각기 다른 collection layout을 custom 하게 만들기 위해
     */
    // primary view for collectionView
    // the drive explore page
    private var colletcionView: UICollectionView?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        configureModels()
        setUpSearchBar()
        setUpCollectionView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // for setuo colletcionView frame
        colletcionView?.frame = view.bounds
    }
    
    // MARK:-  SetUp SearchBar
    func setUpSearchBar() {
        //Attach in view used by navigationItem, Display in view
        navigationItem.titleView = searchBar
        searchBar.delegate = self
    }
    
    // MARK:- Configure Models // 29:30
    func configureModels() {
        // configure the each sections
        var cells = [ExploreCell]()
        
        for x in 0...1000 {
            let cell = ExploreCell.banner(
                viewModel: ExploreBannerViewModel(
                    image: nil,
                    title: "Foo",
                    handler: {
                    }
                )
            )
            cells.append(cell)
        }
        
        
        
        sections.append(
            ExploreSection(
                type: .banner,
                cells: cells
            )
        )
    }
    
    // MARK:- SetUp CollectionView
    func setUpCollectionView() {
        let layout: UICollectionViewCompositionalLayout = UICollectionViewCompositionalLayout { section, _ -> NSCollectionLayoutSection? in
            // return layout each every section
            // make dynamically
            return self.layout(for: section)
            
        }
        
        let collectionView = UICollectionView(
            frame: .zero,
            // collectionViewLayout에서 가장 중요한 parameter
            collectionViewLayout: layout
        )
        // collectionView register
        collectionView.register(
            UICollectionViewCell.self,
            forCellWithReuseIdentifier: "cell"
        )
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.addSubview(collectionView)
        
        self.colletcionView = collectionView
    }
    
    // layout argument is most important pices this
    // make model for which section in and how to layout
    // this function is make different each of section layout and return it
    func layout(for section: Int) -> NSCollectionLayoutSection {
        let sectionType = sections[section].type
        switch sectionType {
        // bring all differents cases
        case .banner:
            break
        case .trendingPosts:
            break
        case .users:
            break
        case .trendingHashtags:
            break
        case .recommended:
            break
        case .popular:
            break
        case .new:
            break
        }
        
        // MARK:- item (NSCollectionLayoutItem)
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
        
        
        // MARK:- group (NSCollectionLayoutItem)
        // 2. Group (items are going)
        // banner cell will be scroller so selected horizontal(layoutSize:, subitems:) method
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.90),
                heightDimension: .absolute(200)
            ),
            subitems: [item]
        )
        
        // MARK:- sectionLayout (NSCollectionLayoutItem)
        // 3. Section layout
        let sectionLayout = NSCollectionLayoutSection(group: group)
        // sectionLayout을 horizontal하게 scroll 하기 위한 method
        sectionLayout.orthogonalScrollingBehavior = .groupPaging
        
        // 4. Return set section layout
        return sectionLayout
    }
    
    
}

// colletcionView를 위한 extenstion
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
        // sections의 주어진 section의 cell 갯수 만큼 반환
        return sections[section].cells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // model for the cell
        // ExploreSection을 가리키고 -> 그 안에 cells을 가리키고 -> 마지막은 ExploreCell enum을 가리킨다.
        let model = sections[indexPath.section].cells[indexPath.row]
        // actual return the colletcion view item
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "cell",
            for: indexPath
        )
        
        // this backgroundColor is for developing, test color
        cell.backgroundColor = .red
        return cell
    }
    
    
}

// serchBar를 위한 extension
extension ExploreViewController: UISearchBarDelegate {
    
}
