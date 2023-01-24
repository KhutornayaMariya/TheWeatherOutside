//
//  DayAndNightCell.swift
//  WeatherWise
//
//  Created by Mariya Khutornaya on 23.01.23.
//

import UIKit

final class DayAndNightCell: UICollectionViewCell {
    static let reuseIdentifier = "DayAndNightCell"
    
    // MARK: - Private properties
    
    private lazy var sunriseTitle: UILabel = {
        let label = UILabel()
        
        label.font = .rubikRegular(size: 14)
        label.textColor = .systemGray2
        label.text = "SUNRISE".localized.capitalizedSentence
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var sunsetTitle: UILabel = {
        let label = UILabel()
        
        label.font = .rubikRegular(size: 14)
        label.textColor = .systemGray2
        label.text = "SUNSET".localized.capitalizedSentence
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var sunriseTime: UILabel = {
        let label = UILabel()
        
        label.font = .rubikRegular(size: 16)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var sunsetTime: UILabel = {
        let label = UILabel()
        
        label.font = .rubikRegular(size: 16)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var dayTime: UILabel = {
        let label = UILabel()
        
        label.font = .rubikRegular(size: 16)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var image: UIImageView = {
        let view = UIImageView()
        
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private properties
    
    private func setUp() {
        backgroundColor = .clear
        
        [image, dayTime, sunriseTitle, sunriseTime, sunsetTime, sunsetTitle].forEach{ addSubview($0) }
        
        drawDottedLine(start: CGPoint(x: bounds.minX + .safeArea, y: 46), end: CGPoint(x: bounds.maxX - .safeArea, y: 46))
        drawDottedLine(start: CGPoint(x: bounds.minX + .safeArea, y: 82), end: CGPoint(x: bounds.maxX - .safeArea, y: 82))
        
        NSLayoutConstraint.activate([
            image.heightAnchor.constraint(equalToConstant: .imageSize),
            image.widthAnchor.constraint(equalToConstant: .imageSize),
            image.centerYAnchor.constraint(equalTo: dayTime.centerYAnchor),
            image.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .safeArea),
            
            dayTime.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.safeArea),
            dayTime.topAnchor.constraint(equalTo: topAnchor, constant: .safeArea),
            
            sunriseTime.topAnchor.constraint(equalTo: dayTime.bottomAnchor, constant: .mergin),
            sunriseTime.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.safeArea),
            
            sunriseTitle.topAnchor.constraint(equalTo: dayTime.bottomAnchor, constant: .mergin),
            sunriseTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .safeArea),
            
            sunsetTime.topAnchor.constraint(equalTo: sunriseTime.bottomAnchor, constant: .mergin),
            sunsetTime.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.safeArea),
            
            sunsetTitle.topAnchor.constraint(equalTo: sunriseTime.bottomAnchor, constant: .mergin),
            sunsetTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .safeArea)
        ])
    }
    
    private func drawDottedLine(start p0: CGPoint, end p1: CGPoint) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.accent.cgColor
        shapeLayer.lineWidth = 0.3
        shapeLayer.lineDashPattern = [7, 3] // 7 is the length of dash, 3 is length of the gap.

        let path = CGMutablePath()
        path.addLines(between: [p0, p1])
        shapeLayer.path = path
        layer.addSublayer(shapeLayer)
    }
}

extension DayAndNightCell {
    func configure(with model: DayAndNight) {
        image.image = UIImage(named: model.imageName)
        dayTime.text = model.duration
        sunriseTime.text = model.rise
        sunsetTime.text = model.set
    }
}

private extension CGFloat {
    static let safeArea: CGFloat = 16
    static let imageSize: CGFloat = 15
    static let mergin: CGFloat = 20
}
