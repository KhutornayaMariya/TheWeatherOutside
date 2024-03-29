//
//  PagesViewController.swift
//  TheWeatherOutside
//
//  Created by m.khutornaya on 06.12.2022.
//

import UIKit

protocol PageViewControllerProtocol: AnyObject {
    func show(with dataItems: [ForecastViewModel])
}

final class PagesViewController: UIViewController {
    
    var interactor: PagesInteractorProtocol?
    
    private var pageController: UIPageViewController?
    
    private var dataItems: [ForecastViewModel]?
    private var selectedIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        setUpNavigationBar()
        setupPageController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor?.updateData()
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
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    private func setupPageController() {
        pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        
        guard let pageController = pageController else { return }
        pageController.dataSource = self
        pageController.delegate = self
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
        
        let saveImageAction = UIAlertAction(title: "DONE".localized, style: .default) { [weak self] action in
            guard let text = alertController.textFields?[0].text,
                  text != ""
            else { return }
            
            self?.interactor?.updateData(with: text, completionHandler: { result in
                if result {
                    self?.selectedIndex = self?.dataItems?.count ?? 0
                } else { print("Location error") }
            })
        }
        
        let cancel = UIAlertAction(title: "CANCEL".localized, style: .cancel)
        
        alertController.addAction(cancel)
        alertController.addAction(saveImageAction)
        present(alertController, animated: true)
    }
}

extension PagesViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            guard let currentVC = pageViewController.viewControllers?.first as? ForecastViewController
            else { return }
            selectedIndex = currentVC.index
        }
    }
}

extension PagesViewController: UIPageViewControllerDataSource {
        
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let currentVC = viewController as? ForecastViewController,
              let dataItems = dataItems,
              currentVC.index != 0
        else { return nil }
        
        let index = currentVC.index - 1
        return ForecastViewController(viewModel: dataItems[index], index: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let currentVC = viewController as? ForecastViewController,
              let dataItems = dataItems,
              currentVC.index < dataItems.count - 1
        else { return nil }
        
        let index = currentVC.index + 1
        return ForecastViewController(viewModel: dataItems[index], index: index)
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return dataItems?.count ?? 0
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return selectedIndex
    }
}

extension PagesViewController: PageViewControllerProtocol {
    func show(with dataItems: [ForecastViewModel]) {
        self.dataItems = dataItems
        
        var viewControllers: [UIViewController] = [EmptyViewController()]
        if !dataItems.isEmpty {
            viewControllers = [ForecastViewController(viewModel: dataItems[selectedIndex], index: selectedIndex)]
        }
        
        self.pageController?.setViewControllers(viewControllers, direction: .forward, animated: false, completion: nil)
    }
}
