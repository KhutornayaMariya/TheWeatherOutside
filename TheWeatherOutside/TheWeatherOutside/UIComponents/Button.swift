//
//  Button.swift
//  WeatherWise
//
//  Created by Mariya Khutornaya on 03.01.23.
//

import UIKit

final class Button: UIButton {

    private let title: String

    var tapAction: (() -> Void)?

    init(title: String) {
        self.title = title
        super.init(frame: .zero)

        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        backgroundColor = .button
        layer.cornerRadius = 10
        layer.masksToBounds = true
        setTitleColor(.white, for: .normal)
        setTitle(title, for: .normal)
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    @objc private func buttonTapped() {
        tapAction?()
    }
}
