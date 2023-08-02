//
//  OnboardingView.swift
//  WeatherWise
//
//  Created by Mariya Khutornaya on 03.01.23.
//

import UIKit

final class OnboardingView: UIView {
    
    var onTapDenyButtonHandler: (() -> Void)?
    var onTapConfirmButtonHandler: (() -> Void)?
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var image: UIImageView = {
        let view = UIImageView()
        
        view.image = UIImage(named: "Umbrella")
        view.contentMode = .scaleToFill
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var locationAskDescription: UILabel = {
        let view = UILabel()
        
        view.text = "LOCATION_ASK_DESC".localized
        view.textColor = .white
        view.font = .rubikSemibold(size: 16)
        view.numberOfLines = 0
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var locationAskExplanation: UILabel = {
        let view = UILabel()
        
        view.text = "LOCATION_ASK_EXPLANATION".localized
        view.textColor = .white
        view.font = .rubikRegular(size: 14)
        view.numberOfLines = 0
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var confirmLocationButton: Button = {
        let view = Button(title: "USE_LOCATION".localized)
        
        view.titleLabel?.font = UIFont.rubikMedium(size: 12)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var denyLocationButton: UIButton = {
        let view = UIButton()
        
        view.setTitleColor(.white, for: .normal)
        view.setTitle("DENY_USING_LOCATION".localized, for: .normal)
        view.titleLabel?.font = UIFont.rubikRegular(size: 16)
        view.addTarget(self, action: #selector(denyButtonTapped), for: .touchUpInside)
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
        let subviews = [scrollView, confirmLocationButton, denyLocationButton]
        subviews.forEach { addSubview($0) }
        
        scrollView.addSubview(contentView)
        
        let scrollViewSubview = [image, locationAskDescription, locationAskExplanation]
        scrollViewSubview.forEach { contentView.addSubview($0) }
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: confirmLocationButton.topAnchor, constant: -.safeArea),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            image.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 148),
            image.widthAnchor.constraint(equalToConstant: 180),
            image.heightAnchor.constraint(equalToConstant: 196),
            image.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            locationAskDescription.topAnchor.constraint(equalTo: image.bottomAnchor, constant: .verticalMargin),
            locationAskDescription.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .textSafeArea),
            locationAskDescription.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.textSafeArea),
            
            locationAskExplanation.topAnchor.constraint(equalTo: locationAskDescription.bottomAnchor, constant: .verticalMargin),
            locationAskExplanation.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .textSafeArea),
            locationAskExplanation.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.textSafeArea),
            locationAskExplanation.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            denyLocationButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -77),
            denyLocationButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            confirmLocationButton.bottomAnchor.constraint(equalTo: denyLocationButton.topAnchor, constant: -.textSafeArea),
            confirmLocationButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .safeArea),
            confirmLocationButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.safeArea),
            confirmLocationButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc private func denyButtonTapped() {
        onTapDenyButtonHandler?()
    }
    
    @objc private func confirmButtonTapped() {
        onTapConfirmButtonHandler?()
    }
}

extension OnboardingView {
    func setConfirmButtonTapAction(action: @escaping () -> Void) {
        confirmLocationButton.tapAction = action
    }
}

private extension CGFloat {
    static let imageHigh: CGFloat = 196
    static let imageWidth: CGFloat = 180
    
    static let verticalMargin: CGFloat = 55
    
    static let safeArea: CGFloat = 16
    static let textSafeArea: CGFloat = 25
}
