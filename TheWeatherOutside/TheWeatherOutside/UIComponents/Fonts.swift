//
//  Fonts.swift
//  WeatherWise
//
//  Created by Mariya Khutornaya on 03.01.23.
//

import UIKit

extension UIFont {
    static func rubikRegular(size: CGFloat) -> UIFont {
        return UIFont(name: "Rubik-Regular", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static func rubikSemibold(size: CGFloat) -> UIFont {
        return UIFont(name: "Rubik-Semibold", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static func rubikMedium(size: CGFloat) -> UIFont {
        return UIFont(name: "Rubik-Medium", size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
