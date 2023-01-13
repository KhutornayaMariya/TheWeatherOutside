//
//  SettingsViewController.swift
//  WeatherWise
//
//  Created by Mariya Khutornaya on 03.01.23.
//

import UIKit

final class SettingsViewController: UIViewController {
    
    private lazy var settingView: SettingsView = {
        let view = SettingsView()
        
        view.configure(with: isMetric())
        view.setApplyButtonTapAction(action: saveSettrings)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setUpNavigationBar()
    }
    
    private func setUpNavigationBar() {
        let navBar = self.navigationController?.navigationBar
        navBar?.backgroundColor = .clear
    }
    
    private func setUp() {
        view.backgroundColor = .accent
        view.addSubview(settingView)
        
        NSLayoutConstraint.activate([
            settingView.topAnchor.constraint(equalTo: view.topAnchor),
            settingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            settingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            settingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    @objc private func saveSettrings() {
        let value = settingView.isMetric() ? Units.metric.rawValue : Units.imperial.rawValue
        UserDefaults.standard.set(value, forKey: UserDefaultsKeys.units.rawValue)
    }
    
    private func isMetric() -> Bool {
        UserDefaults.standard.string(forKey: UserDefaultsKeys.units.rawValue) == Units.metric.rawValue
    }
}
