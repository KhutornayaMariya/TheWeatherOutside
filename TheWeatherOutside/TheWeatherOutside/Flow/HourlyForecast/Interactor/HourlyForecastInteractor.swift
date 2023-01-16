//
//  HourlyForecastInteractor.swift
//  WeatherWise
//
//  Created by Mariya Khutornaya on 15.01.23.
//

import Foundation
import UIKit

final class HourlyForecastInteractor {
    
    private typealias ViewController = HourlyViewController
    
    private let repository: ForecastRepositoryProtocol
    private let presenter: HourlyForecastPresenterProtocol
    private let input: String
    
    init(input: String,
         repository: ForecastRepositoryProtocol,
         presenter: HourlyForecastPresenterProtocol
    ) {
        self.input = input
        self.repository = repository
        self.presenter = presenter
    }
}

extension HourlyForecastInteractor: HourlyForecastInteractorProtocol {
    func updateData() {
        guard let data = repository.fetchHourlyForecast(location: input) else { return }
        presenter.showData(data)
    }
}
