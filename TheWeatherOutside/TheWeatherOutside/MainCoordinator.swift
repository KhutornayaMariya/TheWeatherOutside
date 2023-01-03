//
//  MainCoordinator.swift
//  WeatherWise
//
//  Created by Mariya Khutornaya on 03.01.23.
//

import UIKit
import CoreLocation

protocol MainCoordinatorProtocol {
    func startApplication() -> UIViewController
}

final class MainCoordinator {
    
    private lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        return locationManager
    }()
}

extension MainCoordinator: MainCoordinatorProtocol {
    func startApplication() -> UIViewController {
        return UINavigationController(rootViewController: OnboardingViewController(locationManager: locationManager))
        
//        UserDefaults.standard.set(nil, forKey: "locationDenied")
//        if locationManager.authorizationStatus == .notDetermined && UserDefaults.standard.bool(forKey: "locationDenied") != true {
//            return OnboardingViewController() // onboarding
//        } else {
//            return ViewController() // main screen
//        }
    }
}
