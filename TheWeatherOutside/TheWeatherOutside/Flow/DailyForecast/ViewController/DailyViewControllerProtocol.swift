//
//  DailyViewControllerProtocol.swift
//  WeatherWise
//
//  Created by Mariya Khutornaya on 16.01.23.
//

import Foundation

protocol DailyViewControllerProtocol: AnyObject {
    func show(with dataItems: DailyViewModel)
}
