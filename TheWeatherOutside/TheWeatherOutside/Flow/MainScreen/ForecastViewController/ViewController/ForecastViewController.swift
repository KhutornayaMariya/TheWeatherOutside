//
//  ForecastViewController.swift
//  WeatherWise
//
//  Created by Mariya Khutornaya on 09.01.23.
//

import UIKit

class ForecastViewController: UIViewController {
    private enum Constants {
        static let currentForecastSectionIndex: Int = 0
        static let hourlyForecastSectionIndex: Int = 1
        static let dailyForecastSectionIndex: Int = 2
        static let headerIdentifier = "header"
    }
    
    private var viewModel: ForecastViewModel
    let index: Int
    
    init(viewModel: ForecastViewModel, index: Int) {
        self.index = index
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        
        view.backgroundColor = .background
        view.dataSource = self
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.register(CurrentForecastViewCell.self, forCellWithReuseIdentifier: "CurrentForecastViewCell")
        view.register(HourlyForecastViewCell.self, forCellWithReuseIdentifier: "HourlyForecastViewCell")
        view.register(DailyForecastViewCell.self, forCellWithReuseIdentifier: "DailyForecastViewCell")
        view.register(HeaderCell.self, forSupplementaryViewOfKind: Constants.headerIdentifier, withReuseIdentifier: HeaderCell.reuseIdentifier)
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let navBar: UINavigationBar? = navigationController?.navigationBar
        navBar?.topItem?.title = viewModel.locationTitle
    }
    
    private func setUp() {
        view.backgroundColor = .background
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            switch sectionIndex {
            case Constants.currentForecastSectionIndex:
                return .currentForecastSection
            case Constants.hourlyForecastSectionIndex:
                return .hourlyForecastSection
            default:
                return .dailyForecastSection
            }
        }
    }
    
    @objc
    private func openHourlyForecast() {
        let viewController = HourlyForecastBuilder().build(with: viewModel.locationTitle)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc
    private func openDailyForecast() {
        let viewController = DailyForecastBuilder().build(with: viewModel.locationTitle)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - NSCollectionLayoutSection

private extension NSCollectionLayoutSection {
    static let safeArea: CGFloat = 16
    static let headerIdentifier = "header"
    
    static let currentForecastSection: NSCollectionLayoutSection = {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(CurrentForecastViewCell().viewHeight()))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: safeArea, leading: safeArea, bottom: safeArea, trailing: safeArea)
        
        return section
    }()
    
    static let hourlyForecastSection: NSCollectionLayoutSection = {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: safeArea, bottom: 0, trailing: 0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(70), heightDimension: .absolute(84))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: safeArea, leading: 0, bottom: safeArea, trailing: safeArea)
        section.orthogonalScrollingBehavior = .continuous
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(20)
        )
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: headerIdentifier,
            alignment: .topTrailing
        )
        section.boundarySupplementaryItems = [header]
        
        return section
    }()
    
    static let dailyForecastSection: NSCollectionLayoutSection = {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 0, bottom: safeArea, trailing: 0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(70))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: safeArea, leading: safeArea, bottom: safeArea, trailing: safeArea)
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(20)
        )
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: headerIdentifier,
            alignment: .topTrailing
        )
        section.boundarySupplementaryItems = [header]
        
        return section
    }()
}

// MARK: - UICollectionViewDataSource

extension ForecastViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case Constants.currentForecastSectionIndex:
            return 1
        case Constants.hourlyForecastSectionIndex:
            return viewModel.hourlyForecast.count
        default:
            return viewModel.dailyForecast.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case Constants.currentForecastSectionIndex:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "CurrentForecastViewCell", for: indexPath) as! CurrentForecastViewCell
            cell.configure(with: viewModel.currentForecast)
            return cell
        case Constants.hourlyForecastSectionIndex:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "HourlyForecastViewCell", for: indexPath) as! HourlyForecastViewCell
            cell.configure(with: viewModel.hourlyForecast[indexPath.row])
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "DailyForecastViewCell", for: indexPath) as! DailyForecastViewCell
            cell.configure(with: viewModel.dailyForecast[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case Constants.headerIdentifier:
            guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: Constants.headerIdentifier,
                withReuseIdentifier: HeaderCell.reuseIdentifier,
                for: indexPath
            ) as? HeaderCell else {
                return UICollectionReusableView()
            }
            
            switch indexPath.section {
            case Constants.hourlyForecastSectionIndex:
                header.configure(with: viewModel.hourlySectionTitle)
                header.onLinkTapHandler = openHourlyForecast
            case Constants.dailyForecastSectionIndex:
                header.configure(with: viewModel.dailySectionTitle)
                header.onLinkTapHandler = openDailyForecast
            default:
                break
            }
            return header
        default:
            return UICollectionReusableView()
        }
    }
}
