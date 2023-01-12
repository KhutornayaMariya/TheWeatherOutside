//
//  MainViewControllerProtocol.swift
//  WeatherWise
//
//  Created by Mariya Khutornaya on 12.01.23.
//

import Foundation

protocol PageViewControllerProtocol: AnyObject {
    func show(with dataItems: [MainViewModel])
}
