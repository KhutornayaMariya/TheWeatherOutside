//
//  ForecastBriefView.swift
//  WeatherWise
//
//  Created by Mariya Khutornaya on 06.01.23.
//

import UIKit

final class ForecastBriefView: UIView {
    
    private lazy var label: UILabel = {
        let view = UILabel()
        
        view.textColor = .white
        view.font = .rubikRegular(size: 14)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var image: UIImageView = {
        let view = UIImageView()
        
        view.contentMode = .scaleAspectFit
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

extension ForecastBriefView {
    func configure(text: String, imageName: String) {
        label.text = text
        image.image = UIImage(named: imageName)
    }
}
