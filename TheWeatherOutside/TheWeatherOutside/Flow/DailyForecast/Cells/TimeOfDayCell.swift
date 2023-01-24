//
//  TimeOfDayCell.swift
//  WeatherWise
//
//  Created by Mariya Khutornaya on 20.01.23.
//

import UIKit

final class TimeOfDayCell: UICollectionViewCell {
    static let reuseIdentifier = "TimeOfDayCell"
    
    private let stackArrangedViews = [WeatherParameterView(), WeatherParameterView(), WeatherParameterView(), WeatherParameterView(), WeatherParameterView()]
    
    // MARK: - Private properties
    
    private lazy var timeOfDayLabel: UILabel = {
        let label = UILabel()
        
        label.font = .rubikRegular(size: 18)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var temp: UILabel = {
        let label = UILabel()
        
        label.font = .rubikRegular(size: 30)
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
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        
        view.axis = .vertical
        view.alignment = .fill
        view.spacing = 20
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
        layer.cornerRadius = 5
        backgroundColor = .extraLightBlue
        
        stackArrangedViews.forEach { stackView.addArrangedSubview($0) }
        [temp, timeOfDayLabel, image, stackView].forEach{ addSubview($0) }
        
        NSLayoutConstraint.activate([
            temp.centerXAnchor.constraint(equalTo: centerXAnchor),
            temp.topAnchor.constraint(equalTo: topAnchor, constant: .safeArea),
            
            timeOfDayLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .safeArea),
            timeOfDayLabel.topAnchor.constraint(equalTo: topAnchor, constant: 21),
            
            image.heightAnchor.constraint(equalToConstant: .imageSize),
            image.widthAnchor.constraint(equalToConstant: .imageSize),
            image.topAnchor.constraint(equalTo: topAnchor, constant: .safeArea),
            image.trailingAnchor.constraint(equalTo: temp.leadingAnchor, constant: -5),
            
            stackView.topAnchor.constraint(equalTo: temp.bottomAnchor, constant: 28),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .safeArea),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.safeArea),
        ])
    }
}

extension TimeOfDayCell {
    func configure(with model: TimeOfDayItem) {
        temp.text = model.temperature
        image.image = UIImage(named: model.imageName)
        timeOfDayLabel.text = model.title
        
        for index in 0...model.weatherParameters.count - 1 {
            if index > stackArrangedViews.endIndex { continue }
            stackArrangedViews[index].configure(with: model.weatherParameters[index])
        }
        stackView.layoutSubviews()
    }
}

private extension CGFloat {
    static let safeArea: CGFloat = 15
    static let imageSize: CGFloat = 35
}
