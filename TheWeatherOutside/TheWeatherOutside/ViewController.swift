//
//  ViewController.swift
//  TheWeatherOutside
//
//  Created by m.khutornaya on 06.12.2022.
//

import UIKit

final class ViewController: UIViewController {
    
    private var pageController: UIPageViewController?
    private var currentIndex: Int = 0
    
    private let repository = ForecastRepository()
    private let dataManager: CoreDataManager = CoreDataManager.defaultManager
    
    private var data: [MetaInfo]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        repository.fetchData {
            self.data = self.dataManager.metaInfo
        }
        setUpNavigationBar()
        setupPageController()
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
        pageController?.dataSource = self
        pageController?.delegate = self
        pageController?.view.backgroundColor = .clear
        pageController?.view.frame = CGRect(x: 0,y: 0,width: self.view.frame.width,height: self.view.frame.height)
        
        addChild(pageController!)
        view.addSubview(pageController!.view)
        pageController?.setViewControllers([EmptyViewController()], direction: .forward, animated: true, completion: nil)
        pageController?.didMove(toParent: self)
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
                        print(self.dataManager.metaInfo)
                    }
                }
        }
        
        let cancel = UIAlertAction(title: "CANCEL".localized, style: .cancel)
        
        alertController.addAction(cancel)
        alertController.addAction(saveImageAction)
        present(alertController, animated: true)
    }
}

extension ViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return UIViewController()
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return UIViewController()
    }
}

extension ViewController: UIPageViewControllerDataSource {
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return 4
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return currentIndex
    }
}
