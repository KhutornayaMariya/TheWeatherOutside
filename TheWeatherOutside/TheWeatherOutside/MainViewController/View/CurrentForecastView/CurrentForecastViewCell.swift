//
//  CurrentForecastViewCell.swift
//  WeatherWise
//
//  Created by Mariya Khutornaya on 06.01.23.
//

import UIKit

final class CurrentForecastViewCell : UICollectionViewCell {
    static let reuseIdentifier = "CurrentForecastViewCell"
    
    private var stackSubviews: [UIView]!
    
    private let dateManager: DateManagerProtocol = DateManager()
    private let windView = ForecastBriefView()
    private let cloudView = ForecastBriefView()
    private let precipitationView = ForecastBriefView()
    
    private var screenWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    
    private var ringRadius: CGFloat {
        (screenWidth - 98) / 2
    }
    
    private var viewHeightAnchor: CGFloat {
        84 + ringRadius
    }
    
    private lazy var feelsLikeTemp: UILabel = {
        let view = UILabel()
        
        view.textColor = .white
        view.font = .rubikRegular(size: 16)
        view.numberOfLines = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var currentTemp: UILabel = {
        let view = UILabel()
        
        view.textColor = .white
        view.font = .rubikMedium(size: 36)
        view.numberOfLines = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var summary: UILabel = {
        let view = UILabel()
        
        view.textColor = .white
        view.font = .rubikRegular(size: 16)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var date: UILabel = {
        let view = UILabel()
        
        view.textColor = .calibry
        view.font = .rubikRegular(size: 16)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var sunrise: UILabel = {
        let view = UILabel()
        
        view.textColor = .white
        view.font = .rubikMedium(size: 14)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var sunset: UILabel = {
        let view = UILabel()
        
        view.textColor = .white
        view.font = .rubikMedium(size: 14)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var sunrisePic: UIImageView = {
        let view = UIImageView()
        
        view.image = UIImage(named: "sunrise")
        view.tintColor = .calibry
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var sunsetPic: UIImageView = {
        let view = UIImageView()
        
        view.image = UIImage(named: "sunset")
        view.tintColor = .calibry
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let briefStackView: UIStackView = {
        let view = UIStackView()
        
        view.axis = .horizontal
        view.alignment = .center
        view.distribution = .fill
        view.spacing = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var halfRingShape: CAShapeLayer = {
        let center = CGPoint(x: (screenWidth - 32) / 2, y: viewHeightAnchor - 67)
        let beizerPath = UIBezierPath()
        beizerPath.addArc(withCenter: center,
                          radius: ringRadius,
                          startAngle: .pi,
                          endAngle: 2 * .pi,
                          clockwise: true)
        
        let ring = CAShapeLayer()
        ring.lineWidth = 3
        ring.path = beizerPath.cgPath
        ring.strokeColor = UIColor.calibry.cgColor
        ring.fillColor = UIColor.clear.cgColor
        return ring
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
        layer.cornerRadius = 5
        layer.masksToBounds = true
        layer.addSublayer(halfRingShape)
        
        let subviews = [feelsLikeTemp, currentTemp, summary, briefStackView,
                        date, sunrise, sunset, sunrisePic, sunsetPic]
        subviews.forEach { addSubview($0) }
        
        [cloudView, windView, precipitationView].forEach { briefStackView.addArrangedSubview($0) }
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: viewHeightAnchor),
            
            currentTemp.topAnchor.constraint(equalTo: topAnchor, constant: 33),
            currentTemp.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            feelsLikeTemp.topAnchor.constraint(equalTo: currentTemp.bottomAnchor, constant: .verticalMergin),
            feelsLikeTemp.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            summary.topAnchor.constraint(equalTo: feelsLikeTemp.bottomAnchor, constant: .verticalMergin),
            summary.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            briefStackView.topAnchor.constraint(equalTo: summary.bottomAnchor, constant: 8),
            briefStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            briefStackView.heightAnchor.constraint(equalToConstant: 30),
            
            date.topAnchor.constraint(equalTo: briefStackView.bottomAnchor, constant: 10),
            date.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            sunrise.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            sunrise.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.imageAnchor),
            sunsetPic.heightAnchor.constraint(equalToConstant: .imageSize),
            sunsetPic.widthAnchor.constraint(equalToConstant: .imageSize),
            
            sunrisePic.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .imageAnchor),
            sunrisePic.bottomAnchor.constraint(equalTo: sunrise.topAnchor, constant: -.verticalMergin),
            sunrisePic.heightAnchor.constraint(equalToConstant: .imageSize),
            sunrisePic.widthAnchor.constraint(equalToConstant: .imageSize),
            
            sunset.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            sunset.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.imageAnchor),
            sunsetPic.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.imageAnchor),
            sunsetPic.bottomAnchor.constraint(equalTo: sunset.topAnchor, constant: -.verticalMergin)
        ])
    }
    
    private func forecastBriefView(wind: String, cloud: String, precipitation: CurrentForecastModel.Precipitation) -> [ForecastBriefView] {
        let windView = ForecastBriefView()
        let cloudView = ForecastBriefView()
        let precipitationView = ForecastBriefView()
        

        
        return [cloudView, windView, precipitationView]
    }
    
    private func precipitationImage(for type: CurrentForecastModel.Precipitation.precipitationType) -> String {
        switch type {
        case .snow:
            return "snow"
        case .rain, .rainless:
            return "humidity"
        }
    }
}

extension CurrentForecastViewCell {
    
    func viewHeight() -> CGFloat {
        viewHeightAnchor
    }
    
    func configue(with model: CurrentForecastModel) {
        feelsLikeTemp.text = "\("FEELS_LIKE".localized) \(model.feelsLikeTemp)°"
        currentTemp.text = "\(model.currentTemp)°"
        summary.text = model.description
        date.text = model.date
        sunrise.text = model.sunriseTime
        sunset.text = model.sunsetTime
        
        windView.configure(text: model.windSpeed, imageName: "wind")
        cloudView.configure(text: "\(model.cloudCover) %", imageName: "cloudy")
        precipitationView.configure(text: "\(model.precipitation.amount) \("PRECIPITATION".localized)", imageName: precipitationImage(for: model.precipitation.type))
    }
}

private extension CGFloat {
    static let imageSize: CGFloat = 17
    static let imageAnchor: CGFloat = 25
    
    static let verticalMergin: CGFloat = 5
}
