//
//  DateBubbleCell.swift
//  WeatherWise
//
//  Created by Mariya Khutornaya on 16.01.23.
//

import UIKit

struct DateBubbleModel {
    let date: String
}

final class DateBubbleCell: UICollectionViewCell {
    static let reuseIdentifier = "DateBubbleCell"
    
    override var isSelected: Bool{
        willSet{
            super.isSelected = newValue
            if newValue
            {
                backgroundColor = .accent
            }
            else
            {
                backgroundColor = .clear
            }
        }
    }
    
    // MARK: - Private properties
    
    private lazy var label: UILabel = {
        let label = UILabel()
        
        label.font = .rubikRegular(size: 18)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
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
        backgroundColor = .clear
        addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}

extension DateBubbleCell {
    func configure(with viewModel: DateBubbleModel) {
        label.text = viewModel.date.lowercased()
    }
    
    func setColor(_ color: UIColor) {
        backgroundColor = color
    }
}
