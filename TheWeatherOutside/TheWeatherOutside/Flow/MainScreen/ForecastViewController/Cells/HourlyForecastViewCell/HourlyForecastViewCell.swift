//
//  HourlyForecastViewCell.swift
//  WeatherWise
//
//  Created by Mariya Khutornaya on 11.01.23.
//

import UIKit

final class HourlyForecastViewCell: UICollectionViewCell {
    static let reuseIdentifier = "HourlyForecastViewCell"

    private lazy var time: UILabel = {
        let view = UILabel()
        
        view.textColor = .label
        view.font = .rubikRegular(size: 14)
        view.numberOfLines = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var temperature: UILabel = {
        let view = UILabel()
        
        view.textColor = .label
        view.font = .rubikRegular(size: 16)
        view.numberOfLines = 1
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
        layer.cornerRadius = 22
        layer.borderColor = UIColor.lightBlue.cgColor
        layer.borderWidth = 2
        
        let subviews = [time, image, temperature]
        subviews.forEach { addSubview($0) }
        
        NSLayoutConstraint.activate([
            time.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            time.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            image.heightAnchor.constraint(equalToConstant: 13),
            image.widthAnchor.constraint(equalToConstant: 13),
            image.topAnchor.constraint(equalTo: time.bottomAnchor, constant: 6),
            image.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            temperature.centerXAnchor.constraint(equalTo: centerXAnchor),
            temperature.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 7)
        ])
    }
}

extension HourlyForecastViewCell {
    func configure(with model: HourlyForecastModel) {
        time.text = model.time
        image.image = UIImage(named: model.imageName)
        temperature.text = model.temperature
    }
}
