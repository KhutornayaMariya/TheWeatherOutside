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

    init(locationManager: CLLocationManager) {
        self.locationManager = locationManager
        self.pagesBuilder = PagesBuilder()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
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
            print("locationManager notDetermined")
            break
        case .restricted:
            print("locationManager restricted")
            break
        case .denied:
            print("locationManager deined")
            break
        case .authorizedAlways, .authorizedWhenInUse:
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
            print("locationManager denied")
        case .locationUnknown:
            print("locationManager locationUnknown")
        case .headingFailure:
            print("locationManager headingFailure")
        default:
            print("locationManager default error")
        }
    }
}
