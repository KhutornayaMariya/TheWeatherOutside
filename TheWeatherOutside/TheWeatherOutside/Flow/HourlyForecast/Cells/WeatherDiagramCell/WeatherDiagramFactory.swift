//
//  WeatherDiagramFactory.swift
//  WeatherWise
//
//  Created by Mariya Khutornaya on 15.01.23.
//

import UIKit

struct WeatherDiagramFactory {
    enum Constants {
        static let safeArea: CGFloat = 16
        static let margin: CGFloat = 10
    }
    
    func weatherDiagramView() -> WeatherDiagramView {
        let view = WeatherDiagramView()
        view.backgroundColor = .extraLightBlue
        view.contentInset = UIEdgeInsets(top: Constants.margin,
                                         left: Constants.safeArea,
                                         bottom: Constants.margin,
                                         right: Constants.safeArea + 34)
        
        view.gradientColors = [UIColor(red: 61 / 255, green: 105 / 255, blue: 220 / 225, alpha: 0.3),
                               UIColor(red: 32 / 255, green: 78 / 255, blue: 199 / 225, alpha: 0.3),
                               UIColor(red: 32 / 255, green: 78 / 255, blue: 199 / 225, alpha: 0)]
        
        view.gradientColorLocations = [0.0, 0.0, 1.0]
        
        view.lineWidth = 0.3
        view.lineColor = .accent
        view.gradientBorderWidth = 0.3
        view.gradientBorderColor = .accent
        view.bottomBorder = 47
        view.graphPointRadius = 2
        
        view.xAxisColor = .accent
        view.xAxisPointColor = .accent
        view.xAxisWidth = 0.5
        view.xAxisInfoImagesOffset = .init(x: 3, y: 68 - 116)
        view.xAxisInfoOffset = .init(x: 0, y: 88 - 116)
        view.xAxisYPosition = 116
        view.xAxisLabelOffset = .init(x: -2, y: 128 - 116)
        view.xAxisPointLabelSize = .init(width: 4, height: 8)
        
        view.pointLabelFont = .systemFont(ofSize: 14)
        view.pointLabelColor = .label
        view.pointLabelOffset = .init(x: -2, y: -8)
        
        view.xAxisInfoLabelFont = .systemFont(ofSize: 12)
        view.xAxisInfoLabelColor = .label
        
        view.xAxisPointLabelFont = .systemFont(ofSize: 12)
        view.xAxisPointLabelColor = .label
        
        return view
    }
}
