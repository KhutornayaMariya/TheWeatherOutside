//
//  DailyForecastViewCell.swift
//  WeatherWise
//
//  Created by Mariya Khutornaya on 11.01.23.
//

import Foundation
import UIKit

final class DailyForecastViewCell: UICollectionViewCell {
    static let reuseIdentifier = "DailyForecastViewCell"

    private lazy var date: UILabel = {
        let view = UILabel()
        
        view.textColor = .label
        view.font = .rubikRegular(size: 16)
        view.numberOfLines = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var temperature: UILabel = {
        let view = UILabel()
        
        view.textColor = .label
        view.font = .rubikRegular(size: 18)
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
    
    private lazy var precipitation: UILabel = {
        let view = UILabel()
        
        view.textColor = .accent
        view.font = .rubikRegular(size: 12)
        view.numberOfLines = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var weatherDescription: UILabel = {
        let view = UILabel()
        
        view.textColor = .label
        view.font = .rubikRegular(size: 16)
        view.numberOfLines = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var arrow: UIImageView = {
        let view = UIImageView()
        
        view.image = UIImage(named: "next")
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
        layer.cornerRadius = 5
        backgroundColor = .extraLightBlue
        
        let subviews = [date, image, temperature, precipitation, weatherDescription, arrow]
        subviews.forEach { addSubview($0) }
        
        NSLayoutConstraint.activate([
            date.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            date.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            
            image.heightAnchor.constraint(equalToConstant: 17),
            image.widthAnchor.constraint(equalToConstant: 17),
            image.topAnchor.constraint(equalTo: date.bottomAnchor, constant: 5),
            image.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            
            precipitation.centerYAnchor.constraint(equalTo: image.centerYAnchor),
            precipitation.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 5),
            
            weatherDescription.centerYAnchor.constraint(equalTo: centerYAnchor),
            weatherDescription.centerXAnchor.constraint(equalTo: centerXAnchor),
            weatherDescription.leadingAnchor.constraint(equalTo: precipitation.trailingAnchor, constant: -3),
            
            temperature.centerYAnchor.constraint(equalTo: centerYAnchor),
            temperature.trailingAnchor.constraint(equalTo: arrow.leadingAnchor, constant: -5),
            
            arrow.centerYAnchor.constraint(equalTo: centerYAnchor),
            arrow.heightAnchor.constraint(equalToConstant: 10),
            arrow.widthAnchor.constraint(equalToConstant: 9),
            arrow.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
    }
}

extension DailyForecastViewCell {
    func configure(with model: DailyForecastModel) {
        date.text = model.date
        image.image = UIImage(named: model.imageName)
        precipitation.text = model.amountOfPrecipitation
        weatherDescription.text = model.description
        temperature.text = model.temperature
    }
}
