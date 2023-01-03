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
    
    private lazy var onboardingView: OnboardingView = {
        let view = OnboardingView()
        
        view.setConfirmButtonTapAction(action: requestLocation)
        view.onTapDenyButtonHandler = openMainViewController
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    init(locationManager: CLLocationManager) {
        self.locationManager = locationManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        view.addSubview(onboardingView)
        
        NSLayoutConstraint.activate([
            onboardingView.topAnchor.constraint(equalTo: view.topAnchor),
            onboardingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            onboardingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            onboardingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    @objc
    func openMainViewController() {
        self.navigationController?.pushViewController(ViewController(), animated: true)
    }
    
    @objc
    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
    }
}
