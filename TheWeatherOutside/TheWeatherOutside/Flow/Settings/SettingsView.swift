//
//  SettingsView.swift
//  WeatherWise
//
//  Created by Mariya Khutornaya on 13.01.23.
//

import UIKit

final class SettingsView: UIView {
    
    public var onApplyButtonTapHandler: (() -> Void)?
    
    private lazy var cloudOneImage: UIImageView = {
        let view = UIImageView()
        
        view.image = UIImage(named: "cloud 1")
        
        view.contentMode = .scaleToFill
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var cloudTwoImage: UIImageView = {
        let view = UIImageView()
        
        view.image = UIImage(named: "cloud 2")
        
        view.contentMode = .scaleToFill
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var cloudThreeImage: UIImageView = {
        let view = UIImageView()
        
        view.image = UIImage(named: "cloud 3")
        
        view.contentMode = .scaleToFill
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .extraLightBlue
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var title: UILabel = {
        let view = UILabel()
        
        view.text = "SETTINGS".localized
        view.textColor = .label
        view.font = .rubikMedium(size: 18)
        view.numberOfLines = 0
        view.textAlignment = .left
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var units: UILabel = {
        let view = UILabel()
        
        view.text = "UNITS".localized
        view.textColor = .systemGray2
        view.font = .rubikRegular(size: 16)
        view.numberOfLines = 2
        view.textAlignment = .left
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var applyButton: Button = {
        let view = Button(title: "APPLY_SETTINGS".localized)
        
        view.titleLabel?.font = UIFont.rubikRegular(size: 16)
        view.isEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var imperialButton: UIButton = {
        let view = UIButton()
        
        view.setTitle("IMPERIAL".localized, for: .normal)
        view.layer.cornerRadius = 5
        view.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMaxXMinYCorner]
        view.titleLabel?.font = UIFont.rubikRegular(size: 16)
        view.addTarget(self, action: #selector(imperialButtonTapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var metricButton: UIButton = {
        let view = UIButton()
        
        view.setTitle("METRIC".localized, for: .normal)
        view.layer.cornerRadius = 5
        view.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMinXMinYCorner]
        view.titleLabel?.font = UIFont.rubikRegular(size: 16)
        view.addTarget(self, action: #selector(metricButtonTapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        backgroundColor = .accent
        let subviews = [cloudOneImage, cloudTwoImage, cloudThreeImage, backgroundView,
                        title, units, applyButton, imperialButton, metricButton]
        subviews.forEach { addSubview($0) }
        
        NSLayoutConstraint.activate([
            backgroundView.centerYAnchor.constraint(equalTo: centerYAnchor),
            backgroundView.centerXAnchor.constraint(equalTo: centerXAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .safeArea),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.safeArea),
            
            cloudThreeImage.heightAnchor.constraint(equalToConstant: 58),
            cloudThreeImage.topAnchor.constraint(equalTo: topAnchor, constant: 40),
            cloudThreeImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -130),
            
            cloudTwoImage.heightAnchor.constraint(equalToConstant: 95),
            cloudTwoImage.topAnchor.constraint(equalTo: topAnchor, constant: 120),
            cloudTwoImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 5),
            
            cloudOneImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            cloudOneImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -95),
            
            applyButton.heightAnchor.constraint(equalToConstant: 40),
            applyButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .buttonSafeArea),
            applyButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.buttonSafeArea),
            applyButton.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -15),
            applyButton.topAnchor.constraint(equalTo: metricButton.bottomAnchor, constant: .safeArea),
            
            title.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: .safeArea),
            title.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: .anchor),
            
            units.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: .anchor),
            units.topAnchor.constraint(equalTo: title.topAnchor, constant: .safeArea),
            
            imperialButton.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -.anchor),
            imperialButton.centerYAnchor.constraint(equalTo: units.centerYAnchor),
            imperialButton.heightAnchor.constraint(equalToConstant: .buttonHigh),
            imperialButton.widthAnchor.constraint(equalToConstant: .buttonWidth),
            
            metricButton.trailingAnchor.constraint(equalTo: imperialButton.leadingAnchor),
            metricButton.centerYAnchor.constraint(equalTo: units.centerYAnchor),
            metricButton.heightAnchor.constraint(equalToConstant: .buttonHigh),
            metricButton.widthAnchor.constraint(equalToConstant: .buttonWidth)
        ])
    }
    
    @objc private func metricButtonTapped() {
        setupUnitsButtons(isMetric: true)
        applyButton.isEnabled = true
    }
    
    @objc private func imperialButtonTapped() {
        setupUnitsButtons(isMetric: false)
        applyButton.isEnabled = true
    }
    
    private func setupUnitsButtons(isMetric: Bool) {
        metricButton.backgroundColor = isMetric ? .accent : .systemGray3
        imperialButton.backgroundColor = isMetric ? .systemGray3 : .accent
        
        imperialButton.isSelected = !isMetric
        metricButton.isSelected = isMetric
    }
}

extension SettingsView {
    
    func configure(with isMetric: Bool) {
        setupUnitsButtons(isMetric: isMetric)
    }
    
    func setApplyButtonTapAction(action: @escaping () -> Void) {
        applyButton.tapAction = action
    }
    
    func isMetric() -> Bool {
        metricButton.isSelected
    }
}

private extension CGFloat {
    static let buttonHigh: CGFloat = 30
    static let buttonWidth: CGFloat = 60
    static let anchor: CGFloat = 20
    static let safeArea: CGFloat = 28
    static let buttonSafeArea: CGFloat = 65
}
