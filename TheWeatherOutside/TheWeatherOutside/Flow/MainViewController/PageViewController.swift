//
//  PageViewController.swift
//  TheWeatherOutside
//
//  Created by m.khutornaya on 06.12.2022.
//

import UIKit

final class PageViewController: UIViewController {
    
    private var pageController: UIPageViewController?
    
    private let repository = ForecastRepository()
    
    private var dataItems: [MetaInfo] {
        CoreDataManager.defaultManager.metaInfo
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        setUpNavigationBar()
        setupPageController()
        fetchForecast()
    }
    
    private func fetchForecast() {
        repository.fetchData {
            self.updateViewControllers()
        }
    }
    
    private func updateViewControllers() {
        var viewControllers: [UIViewController]
        if self.dataItems.isEmpty {
            viewControllers = [EmptyViewController()]
        } else {
            viewControllers = [MainForecastViewController(dataItems: self.dataItems[0], index: 0)]
        }
        self.pageController?.setViewControllers(viewControllers, direction: .forward, animated: true, completion: nil)
    }
    
    private func setUpNavigationBar() {
        let navBar: UINavigationBar? = navigationController?.navigationBar
        navBar?.isHidden = false
        navBar?.backgroundColor = .background
        navBar?.tintColor = .icon
        
        let menuButtonItem = UIBarButtonItem(
            image: UIImage(named: "burgerMenu"),
            style: UIBarButtonItem.Style.plain,
            target: self,
            action: #selector(openAppSettings)
        )
        
        let locationButtonItem = UIBarButtonItem(
            image: UIImage(named: "location"),
            style: UIBarButtonItem.Style.plain,
            target: self,
            action: #selector(addLocation)
        )
        
        navigationItem.rightBarButtonItem = locationButtonItem
        navigationItem.leftBarButtonItem = menuButtonItem
    }
    
    private func setupPageController() {
        pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        guard let pageController = pageController else { return }
        pageController.dataSource = self
        pageController.view.backgroundColor = .clear
        pageController.view.frame = CGRect(x: 0,y: 0,width: self.view.frame.width,height: self.view.frame.height)
        addChild(pageController)
        view.addSubview(pageController.view)
        pageController.didMove(toParent: self)
    }
    
    @objc
    private func openAppSettings() {
        self.navigationController?.pushViewController(SettingsViewController(), animated: true)
    }
    
    @objc
    private func addLocation() {
        let alertController = UIAlertController(title: "ALERT_TITLE".localized, message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "ALERT_PLACEHOLDER".localized
        }
        
        let saveImageAction = UIAlertAction(title: "DONE".localized, style: .default) { action in
            guard let text = alertController.textFields?[0].text,
                  text != ""
            else { return }
            ForecastRepository().fetchDataForLocation(title: text) { result in
                if !result {
                    print("error error error")
                } else {
                    var viewControllers: [UIViewController]
                    if self.dataItems.isEmpty {
                        viewControllers = [EmptyViewController()]
                    } else {
                        let index = self.dataItems.endIndex - 1
                        viewControllers = [MainForecastViewController(dataItems: self.dataItems[index], index: index)]
                    }
                    self.pageController?.setViewControllers(viewControllers, direction: .forward, animated: true, completion: nil)
                }
            }
        }
        
        let cancel = UIAlertAction(title: "CANCEL".localized, style: .cancel)
        
        alertController.addAction(cancel)
        alertController.addAction(saveImageAction)
        present(alertController, animated: true)
    }
}

extension PageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let currentVC = viewController as? MainForecastViewController,
              currentVC.index != 0
        else { return nil }
        
        let index = currentVC.index - 1
        return MainForecastViewController(dataItems: dataItems[index], index: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let currentVC = viewController as? MainForecastViewController,
              currentVC.index < dataItems.count - 1
        else { return nil }
        
        let index = currentVC.index + 1
        return MainForecastViewController(dataItems: dataItems[index], index: index)
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return dataItems.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
}
