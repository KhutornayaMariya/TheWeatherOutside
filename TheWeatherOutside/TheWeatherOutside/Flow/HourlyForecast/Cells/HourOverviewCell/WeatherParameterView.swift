//
//  WeatherParameterView.swift
//  WeatherWise
//
//  Created by Mariya Khutornaya on 13.01.23.
//

import UIKit

struct WeatherParameterViewModel {
    let parameterName: String
    let value: String
    let imageName: String
}

final class WeatherParameterView: UIView {
    
    private lazy var image: UIImageView = {
        let view = UIImageView()
        
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var parameter: UILabel = {
        let view = UILabel()
        
        view.textColor = .label
        view.font = .rubikRegular(size: 14)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var value: UILabel = {
        let view = UILabel()
        
        view.textColor = .systemGray
        view.font = .rubikRegular(size: 14)
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
        let subviews = [image, parameter, value]
        subviews.forEach { addSubview($0) }
        
        NSLayoutConstraint.activate([
            image.heightAnchor.constraint(equalToConstant: 20),
            image.widthAnchor.constraint(equalToConstant: 20),
            image.leadingAnchor.constraint(equalTo: leadingAnchor),
            image.topAnchor.constraint(equalTo: topAnchor),
            
            parameter.topAnchor.constraint(equalTo: topAnchor),
            parameter.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 5),
            
            value.topAnchor.constraint(equalTo: topAnchor),
            value.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}

extension WeatherParameterView {
    func configure(with model: WeatherParameterViewModel) {
        parameter.text = model.parameterName.capitalizedSentence
        value.text = model.value
        image.image = UIImage(named: model.imageName)
    }
}
