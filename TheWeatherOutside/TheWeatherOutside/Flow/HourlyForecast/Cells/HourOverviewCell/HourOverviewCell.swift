//
//  HourOverviewCell.swift
//  WeatherWise
//
//  Created by Mariya Khutornaya on 13.01.23.
//

import UIKit

final class HourOverviewCell: UITableViewCell {
    
    private let stackArrangedViews = [WeatherParameterView(), WeatherParameterView(), WeatherParameterView(), WeatherParameterView(), WeatherParameterView()]
    
    private lazy var date: UILabel = {
        let view = UILabel()
        
        view.textColor = .label
        view.font = .rubikMedium(size: 18)
        view.numberOfLines = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var time: UILabel = {
        let view = UILabel()
        
        view.textColor = .systemGray
        view.font = .rubikRegular(size: 16)
        view.numberOfLines = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var temperature: UILabel = {
        let view = UILabel()
        
        view.textColor = .label
        view.font = .rubikMedium(size: 18)
        view.numberOfLines = 1
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        backgroundColor = .extraLightBlue
        
        let subviews = [date, time, temperature, stackView]
        subviews.forEach { addSubview($0) }
        stackArrangedViews.forEach { stackView.addArrangedSubview($0) }
        
        NSLayoutConstraint.activate([
            date.topAnchor.constraint(equalTo: topAnchor, constant: .safeArea),
            date.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .safeArea),
            
            time.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .safeArea),
            time.topAnchor.constraint(equalTo: date.bottomAnchor, constant: 5),
            
            temperature.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 22),
            temperature.topAnchor.constraint(equalTo: time.bottomAnchor, constant: 10),
            
            stackView.topAnchor.constraint(equalTo: time.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: time.trailingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30)
        ])
    }
}

extension HourOverviewCell {
    func configure(with model: HourOverviewModel) {
        date.text = model.date
        time.text = model.time
        temperature.text = model.temperature
        for index in 0...model.weatherParameters.count - 1 {
            if index > stackArrangedViews.endIndex { continue }
            stackArrangedViews[index].configure(with: model.weatherParameters[index])
        }
        stackView.layoutSubviews()
    }
}

private extension CGFloat {
    static let safeArea: CGFloat = 16
}
