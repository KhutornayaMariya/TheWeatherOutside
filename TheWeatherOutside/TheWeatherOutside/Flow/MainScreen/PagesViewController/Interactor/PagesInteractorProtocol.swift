//
//  PagesInteractorProtocol.swift
//  WeatherWise
//
//  Created by Mariya Khutornaya on 12.01.23.
//

import Foundation

protocol PagesInteractorProtocol {
    func updateData()
    func updateData(with newLocation: String, completionHandler: @escaping (Bool) -> Void)
}
