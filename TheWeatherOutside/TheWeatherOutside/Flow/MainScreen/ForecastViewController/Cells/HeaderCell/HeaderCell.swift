//
//  HeaderCell.swift
//  WeatherWise
//
//  Created by Mariya Khutornaya on 11.01.23.
//

import UIKit

struct HeaderCellModel {
    let title: String?
    let link: String
}

final class HeaderCell: UICollectionReusableView {
    static let reuseIdentifier = "HeaderCell"
    
    public var onLinkTapHandler: (() -> Void)?

    // MARK: - Private properties

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = .rubikMedium(size: 18)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()

    private lazy var link: UIButton = {
        let view = UIButton()
                
        view.titleLabel?.font = .rubikRegular(size: 16)
        view.titleLabel?.textColor = .label
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(onLinkTap), for: .touchUpInside)
        
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

    func configure(with viewModel: HeaderCellModel) {
        let attributedString = NSMutableAttributedString(string: viewModel.link)
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedString.length))
        
        titleLabel.text = viewModel.title
        link.setAttributedTitle(attributedString, for: .normal)
    }

    // MARK: - Private properties

    private func setUp() {
        backgroundColor = .clear
        [titleLabel, link].forEach { addSubview($0) }

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),

            link.topAnchor.constraint(equalTo: topAnchor),
            link.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    @objc private func onLinkTap() {
        onLinkTapHandler?()
    }
}
