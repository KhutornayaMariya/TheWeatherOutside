//
//  WeatherDiagramViewModel.swift
//  WeatherWise
//
//  Created by Mariya Khutornaya on 15.01.23.
//

import Foundation

struct WeatherDiagramViewModel {
    struct Parameters {
        let time: String
        let temperature: String
        let precipitation: String
        let imageName: String
    }
    
    let parametrs: [Parameters]
}
