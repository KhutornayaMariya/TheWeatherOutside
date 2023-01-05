//
//  ViewController.swift
//  TheWeatherOutside
//
//  Created by m.khutornaya on 06.12.2022.
//

import UIKit

final class ViewController: UIViewController {
    
    //    private let pageController: UIPageViewController = {
    //        let pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    ////        pageController.dataSource = self
    //        pageController.delegate = self
    //        pageController.view.backgroundColor = .clear
    //        pageController.didMove(toParent: self)
    //
    //        return pageController
    //    }()
    
    private var pageController: UIPageViewController?
    private var currentIndex: Int = 0
    
    private func setupPageController() {
        pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageController?.dataSource = self
        self.pageController?.delegate = self
        self.pageController?.view.backgroundColor = .clear
        self.pageController?.view.frame = CGRect(x: 0,y: 0,width: self.view.frame.width,height: self.view.frame.height)
        
        addChild(pageController!)
        view.addSubview(pageController!.view)
        self.pageController?.setViewControllers([EmptyViewController()], direction: .forward, animated: true, completion: nil)
        self.pageController?.didMove(toParent: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        setUpNavigationBar()
        setupPageController()
        //        ForecastApiManager().forecastRequest(lat: 50.119469, lon: 8.599217, units: .metric)
        //        ForecastApiManager().forecastRequest(lat: 43.271008, lon: 5.372398, units: .metric)
        //        ForecastApiManager().forecastRequest(lat: 55.755864, lon: 37.617698, units: .metric)
        //        GeoCodeApiManager().geoCodeRequest(for: "Москва")43.271008, 5.372398
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
    
    @objc
    func openAppSettings() {
        self.navigationController?.pushViewController(SettingsViewController(), animated: true)
    }
    
    @objc
    func addLocation() {
        let alertController = UIAlertController(title: "ALERT_TITLE".localized, message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "ALERT_PLACEHOLDER".localized
        }
        
        let saveImageAction = UIAlertAction(title: "DONE".localized, style: .default) { action in
            guard let text = alertController.textFields?[0].text,
                  text != ""
            else { return }
            
            GeoCodeApiManager().geoCodeRequest(for: text) { response in
                guard let coordinates = response.value,
                      let lat = coordinates.latitude(),
                      let lon = coordinates.longitude(),
                      let title = coordinates.name()
                else { return }
                //                проверить есть ли такая локация уже
                //                если нет запрос
                // если есть -> открывать страницу с этой локацией
                ForecastRepository().fetchDataForLocation(lat: lat, lon: lon, title: title)
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
