//
//  EmptyView.swift
//  WeatherWise
//
//  Created by Mariya Khutornaya on 05.01.23.
//

import UIKit

final class EmptyView: UIView {
    
    private lazy var image: UIImageView = {
        let view = UIImageView()
        
        view.image = UIImage(named: "umbrella")
        
        view.contentMode = .scaleToFill
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var locationDescription: UILabel = {
        let view = UILabel()
        
        view.text = "EMPTY_LOCATION_DESCRIPTION".localized
        view.textColor = .label
        view.font = .rubikRegular(size: 16)
        view.numberOfLines = 0
        view.textAlignment = .center
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
        backgroundColor = .background
        let subviews = [image, locationDescription]
        subviews.forEach { addSubview($0) }
        
        NSLayoutConstraint.activate([
            image.widthAnchor.constraint(equalToConstant: .imageWidth),
            image.heightAnchor.constraint(equalToConstant: .imageHigh),
            image.centerYAnchor.constraint(equalTo: centerYAnchor),
            image.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            locationDescription.topAnchor.constraint(equalTo: image.bottomAnchor, constant: .verticalMargin),
            locationDescription.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .textSafeArea),
            locationDescription.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.textSafeArea)
        ])
    }
}

private extension CGFloat {
    static let imageHigh: CGFloat = 196
    static let imageWidth: CGFloat = 180
    static let verticalMargin: CGFloat = 55
    static let textSafeArea: CGFloat = 25
}
