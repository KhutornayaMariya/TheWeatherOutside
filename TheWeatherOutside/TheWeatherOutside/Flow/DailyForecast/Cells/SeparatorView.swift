//
//  SeparatorView.swift
//  WeatherWise
//
//  Created by Mariya Khutornaya on 23.01.23.
//

import UIKit

final class SeparatorView: UICollectionViewCell {
    static let reuseIdentifier = "SeparatorView"

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
        backgroundColor = .accent
    }
}
