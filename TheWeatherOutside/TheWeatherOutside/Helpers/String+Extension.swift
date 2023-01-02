//
//  String+Extensions.swift
//  WeatherWise
//
//  Created by Mariya Khutornaya on 02.01.23.
//

import Foundation

extension String {
    var localized: String  {
        NSLocalizedString(self, comment: "")
    }
}
