//
//  ForecastBriefView.swift
//  WeatherWise
//
//  Created by Mariya Khutornaya on 06.01.23.
//

import UIKit

final class ForecastBriefView: UIView {
    
    private let imageName: String
    private let text: String
    
    init(text: String, imageName: String) {
        self.text = text
        self.imageName = imageName
        super.init(frame: .zero)
        
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var label: UILabel = {
        let view = UILabel()
        
        view.text = text
        view.textColor = .white
        view.font = .rubikRegular(size: 14)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var image: UIImageView = {
        let view = UIImageView()
        
        view.image = UIImage(named: imageName)
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private func setUp() {
        let subviews = [label, image]
        subviews.forEach { addSubview($0) }
        
        NSLayoutConstraint.activate([
            image.heightAnchor.constraint(equalToConstant: 18),
            image.widthAnchor.constraint(equalToConstant: 20),
            image.leadingAnchor.constraint(equalTo: leadingAnchor),
            image.topAnchor.constraint(equalTo: topAnchor),
            
            label.topAnchor.constraint(equalTo: topAnchor),
            label.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 5),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
