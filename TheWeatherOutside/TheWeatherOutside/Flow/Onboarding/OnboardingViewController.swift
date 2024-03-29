//
//  OnboardingViewController.swift
//  WeatherWise
//
//  Created by Mariya Khutornaya on 03.01.23.
//

import UIKit
import CoreLocation

class OnboardingViewController: UIViewController {
    
    private var locationManager: CLLocationManager
    
    private let pagesBuilder: PagesBuilderProtocol
    
    private lazy var onboardingView: OnboardingView = {
        let view = OnboardingView()
        
        view.setConfirmButtonTapAction(action: requestLocation)
        view.onTapDenyButtonHandler = openForecastViewController
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    init(locationManager: CLLocationManager) {
        self.locationManager = locationManager
        self.pagesBuilder = PagesBuilder()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        navigationController?.navigationBar.isHidden = true
        locationManager.delegate = self
        view.addSubview(onboardingView)
        
        NSLayoutConstraint.activate([
            onboardingView.topAnchor.constraint(equalTo: view.topAnchor),
            onboardingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            onboardingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            onboardingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    @objc
    func openForecastViewController() {
        UserDefaults.standard.set(true, forKey: UserDefaultsKeys.locationDenied.rawValue)
        self.navigationController?.pushViewController(pagesBuilder.build(), animated: true)
    }
    
    @objc
    func requestLocation() {
        if locationManager.authorizationStatus == .denied {
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl)
            }
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
}

extension OnboardingViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("notDetermined")
            break
        case .restricted:
            print("restricted")
            break
        case .denied:
            print("deined")
            break
        case .authorizedAlways, .authorizedWhenInUse:
            print("authorized")
            manager.requestLocation()
            self.navigationController?.pushViewController(pagesBuilder.build(), animated: true)
        @unknown default:
            fatalError()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {}
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        guard let error = error as? CLError else { return }
        switch error.code {
        case .denied:
            print("denied")
        case .locationUnknown:
            print("locationUnknown")
        case .headingFailure:
            print("headingFailure")
        default:
            print("default error")
        }
    }
}
