//
//  DailyViewController.swift
//  WeatherWise
//
//  Created by Mariya Khutornaya on 16.01.23.
//

import UIKit

protocol DailyViewControllerProtocol: AnyObject {
    func show(with dataItems: DailyViewModel)
}

final class DailyViewController: UIViewController {
    private enum Constants {
        static let bubblesSectionIndex: Int = 0
        static let forecastSectionIndex: Int = 1
        static let dayAndNightSectionIndex: Int = 2
        static let headerIdentifier = "header"
        static let separatorIdentifier = "separator"
    }
    
    var interactor: DailyForecastInteractor?
    
    private var viewModel: DailyViewModel?
    private var forecastItems: DailyViewModel.DailyForecastItem?
    
    private var selectedIndex: Int = 0
    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        
        view.backgroundColor = .background
        view.dataSource = self
        view.delegate = self
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.register(DateBubbleCell.self, forCellWithReuseIdentifier: "DateBubbleCell")
        view.register(TimeOfDayCell.self, forCellWithReuseIdentifier: "TimeOfDayCell")
        view.register(DayAndNightCell.self, forCellWithReuseIdentifier: "DayAndNightCell")
        view.register(HeaderCell.self,
                      forSupplementaryViewOfKind: Constants.headerIdentifier,
                      withReuseIdentifier: HeaderCell.reuseIdentifier)
        view.register(SeparatorView.self,
                      forSupplementaryViewOfKind: Constants.separatorIdentifier,
                      withReuseIdentifier: SeparatorView.reuseIdentifier)
        view.allowsMultipleSelection = false
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        interactor?.updateData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.collectionView.selectItem(at: IndexPath(row: selectedIndex, section: Constants.bubblesSectionIndex), animated: true, scrollPosition: .centeredVertically)
        self.collectionView(self.collectionView, didSelectItemAt: IndexPath(item: selectedIndex, section: Constants.bubblesSectionIndex))
    }
    
    private func setUp() {
        view.backgroundColor = .background
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            switch sectionIndex {
            case Constants.bubblesSectionIndex:
                return .bubblesSection
            case Constants.forecastSectionIndex:
                return .forecastSection
            default:
                return .dayAndNightSection
            }
        }
    }
}

// MARK: - UICollectionViewDataSource

extension DailyViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case Constants.bubblesSectionIndex:
            return viewModel?.dailyForecast.count ?? 0
        case Constants.forecastSectionIndex:
            return forecastItems?.timeOfDay.count ?? 0
        case Constants.dayAndNightSectionIndex:
            return forecastItems?.dayAndNight.count ?? 0
        default:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case Constants.bubblesSectionIndex:
            guard let viewModel = viewModel else { return UICollectionViewCell() }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateBubbleCell", for: indexPath) as! DateBubbleCell
            let data = viewModel.dailyForecast[indexPath.row]
            cell.configure(with: DateBubbleModel(date: data.date))
            
            return cell
        case Constants.forecastSectionIndex:
            guard let data = forecastItems?.timeOfDay else { return UICollectionViewCell() }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeOfDayCell", for: indexPath) as! TimeOfDayCell
            cell.configure(with: data[indexPath.row])
            
            return cell
        default:
            guard let data = forecastItems?.dayAndNight else { return UICollectionViewCell() }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DayAndNightCell", for: indexPath) as! DayAndNightCell
            cell.configure(with: data[indexPath.row])
            
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
            case Constants.bubblesSectionIndex:
                header.configure(with: HeaderCellModel(title: "DAILY_TITLE".localized, link: nil))
            case Constants.dayAndNightSectionIndex:
                header.configure(with: HeaderCellModel(title: "SUN_AND_MOON".localized, link: nil))
            default:
                break
            }
            
            return header
            
        case Constants.separatorIdentifier:
            guard let separator = collectionView.dequeueReusableSupplementaryView(
                ofKind: Constants.separatorIdentifier,
                withReuseIdentifier: SeparatorView.reuseIdentifier,
                for: indexPath
            ) as? SeparatorView else {
                return UICollectionReusableView()
            }
            
            switch indexPath.row {
            case 0:
                separator.backgroundColor = .clear
            default:
                separator.backgroundColor = .accent
            }
            
            return separator
        default:
            return UICollectionReusableView()
        }
    }
}

// MARK: - NSCollectionLayoutSection

private extension NSCollectionLayoutSection {
    static let safeArea: CGFloat = 16
    static let headerIdentifier = "header"
    static let separatorIdentifier = "separator"
    
    static let bubblesSection: NSCollectionLayoutSection = {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .zero
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(88), heightDimension: .absolute(36))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: safeArea, leading: safeArea, bottom: safeArea, trailing: safeArea)
        section.orthogonalScrollingBehavior = .continuous
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(22)
        )
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: headerIdentifier,
            alignment: .topTrailing
        )
        section.boundarySupplementaryItems = [header]
        
        return section
        
    }()
    
    static let forecastSection: NSCollectionLayoutSection = {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 0, bottom: safeArea, trailing: 0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(300))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: safeArea, leading: safeArea, bottom: safeArea, trailing: safeArea)
        
        return section
    }()
    
    static let dayAndNightSection: NSCollectionLayoutSection = {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize, supplementaryItems: [separatorItem])
        item.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(120))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: safeArea, leading: safeArea, bottom: safeArea*2, trailing: safeArea)
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(22)
        )
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: headerIdentifier,
            alignment: .topTrailing
        )
        
        section.boundarySupplementaryItems = [header]
        
        return section
    }()
    
    static let separatorItem: NSCollectionLayoutSupplementaryItem = {
        let separatorWidth = 0.5
        let separatorSize = NSCollectionLayoutSize(
            widthDimension: .absolute(separatorWidth),
            heightDimension: .fractionalHeight(1.0)
        )
        let separatorAnchor = NSCollectionLayoutAnchor(
            edges: [.leading],
            absoluteOffset: CGPoint(x: separatorWidth, y: 0)
        )
        let separator = NSCollectionLayoutSupplementaryItem(
            layoutSize: separatorSize,
            elementKind: separatorIdentifier,
            containerAnchor: separatorAnchor
        )
        
        return separator
    }()
}

// MARK: UICollectionViewDelegate

extension DailyViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case Constants.bubblesSectionIndex:
            guard let selectedCell = collectionView.cellForItem(at: indexPath) as? DateBubbleCell else { return }
            selectedCell.setColor(.accent)
            forecastItems = viewModel?.dailyForecast[indexPath.row]
            collectionView.reloadSections([Constants.forecastSectionIndex, Constants.forecastSectionIndex])
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case Constants.bubblesSectionIndex:
            guard let selectedCell = collectionView.cellForItem(at: indexPath) as? DateBubbleCell else { return }
            selectedCell.setColor(.clear)
        default:
            break
        }
    }
}

extension DailyViewController: DailyViewControllerProtocol {
    func show(with dataItems: DailyViewModel) {
        self.viewModel = dataItems
        self.forecastItems = dataItems.dailyForecast[selectedIndex]
        title = viewModel?.locationTitle
        collectionView.reloadData()
    }
}
