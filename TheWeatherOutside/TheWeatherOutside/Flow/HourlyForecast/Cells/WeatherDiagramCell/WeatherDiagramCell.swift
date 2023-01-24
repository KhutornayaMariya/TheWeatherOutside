//
//  WeatherDiagramCell.swift
//  WeatherWise
//
//  Created by Mariya Khutornaya on 15.01.23.
//

import SnapKit
import UIKit

final class WeatherDiagramCell: UITableViewCell {
    
    private let diagramView: WeatherDiagramView = {
        WeatherDiagramFactory().weatherDiagramView()
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        contentView.backgroundColor = .extraLightBlue
        addSubview(diagramView)
        
        diagramView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.edges.height.equalTo(150)
        }
    }
    
    func configure(with model: WeatherDiagramViewModel) {
        diagramView.setup(data: model.temperature,
                          dataLabels: model.temperatureString,
                          xAxisInfoImages: model.image,
                          xAxisInfoTexts: model.precipitation,
                          xAxisLabelTexts: model.time)
    }
}
