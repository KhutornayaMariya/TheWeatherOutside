//
//  MainForecastViewController.swift
//  WeatherWise
//
//  Created by Mariya Khutornaya on 09.01.23.
//

import UIKit

class MainForecastViewController: UIViewController {
    
    private enum Constants {
        static let currentForecastSectionIndex: Int = 0
        static let hourlyForecastSectionIndex: Int = 1
        static let headerIdentifier = "header"
    }
    
    private var dataItems: MetaInfo
    let index: Int
    
    init(dataItems: MetaInfo, index: Int) {
        self.index = index
        self.dataItems = dataItems
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        
        view.dataSource = self
        view.delegate = self
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.register(CurrentForecastViewCell.self, forCellWithReuseIdentifier: "CurrentForecastViewCell")
        view.register(HourlyForecastViewCell.self, forCellWithReuseIdentifier: "HourlyForecastViewCell")
        view.register(HeaderCell.self, forSupplementaryViewOfKind: Constants.headerIdentifier, withReuseIdentifier: HeaderCell.reuseIdentifier)

        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
        let navBar: UINavigationBar? = navigationController?.navigationBar
        navBar?.topItem?.title = dataItems.locationTitle
    }
    
    private func setUp() {
        view.backgroundColor = .white
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
                return nil
            }
        }
    }
    
    @objc
    private func openHourlyForecast() {
        self.navigationController?.pushViewController(SettingsViewController(), animated: true)
    }
    
    @objc
    private func openDailyForecast() {
        self.navigationController?.pushViewController(SettingsViewController(), animated: true)
    }
}

// MARK: - UICollectionViewDataSource

extension MainForecastViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case Constants.currentForecastSectionIndex:
            return 1
        default:
            return dataItems.hourly?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case Constants.currentForecastSectionIndex:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "CurrentForecastViewCell", for: indexPath) as! CurrentForecastViewCell
            guard let currentWeather = dataItems.current,
                  let timeZone = dataItems.timeZone
            else { return UICollectionViewCell() }
            cell.configure(with: CurrentForecastModel(currentForecast: currentWeather, timeZone: timeZone))
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "HourlyForecastViewCell", for: indexPath) as! HourlyForecastViewCell
            guard let forecast = dataItems.hourly,
                  let timeZone = dataItems.timeZone
            else { return UICollectionViewCell() }
            let data = Array(forecast)[indexPath.row]
            cell.configure(with: HourlyForecastModel(data: data as! Hourly, timeZone: timeZone))
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
            case 1:
                header.configure(with: HeaderCellModel(title: nil, link: "DAY".localized))
                header.onLinkTapHandler = openHourlyForecast
            case 2:
                header.configure(with: HeaderCellModel(title: "DAILY_TITLE".localized, link: "DAILY".localized))
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

// MARK: - NSCollectionLayoutSection

private extension NSCollectionLayoutSection {
    static let safeArea: CGFloat = 16
    
    static let currentForecastSection: NSCollectionLayoutSection = {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(CurrentForecastViewCell().viewHeight()))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 22, leading: safeArea, bottom: 20, trailing: safeArea)
        
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
            elementKind: "header",
            alignment: .topTrailing
        )
        header.contentInsets = .init(top: 20, leading: 0, bottom: 0, trailing: 0)
        section.boundarySupplementaryItems = [header]
        
        return section
    }()
}

extension MainForecastViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //
    }
}
