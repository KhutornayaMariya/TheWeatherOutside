//
//  ViewController.swift
//  TheWeatherOutside
//
//  Created by m.khutornaya on 06.12.2022.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGreen
        ForecastApiManager().forecastRequest(lat: 50.119469, lon: 8.599217, units: .metric)
        ForecastApiManager().forecastRequest(lat: 43.271008, lon: 5.372398, units: .metric)
        ForecastApiManager().forecastRequest(lat: 55.755864, lon: 37.617698, units: .metric)
        //        GeoCodeApiManager().geoCodeRequest(for: "Москва")43.271008, 5.372398
    }
}
