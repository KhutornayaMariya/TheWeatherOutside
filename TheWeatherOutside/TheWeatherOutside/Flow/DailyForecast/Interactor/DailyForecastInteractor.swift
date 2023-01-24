//
//  DailyForecastInteractor.swift
//  WeatherWise
//
//  Created by Mariya Khutornaya on 16.01.23.
//

import Foundation
import UIKit

final class DailyForecastInteractor {
    
    private typealias ViewController = HourlyViewController
    
    private let repository: ForecastRepositoryProtocol
    private let presenter: DailyForecastPresenterProtocol
    private let input: String
    
    init(input: String,
         repository: ForecastRepositoryProtocol,
         presenter: DailyForecastPresenterProtocol
    ) {
        self.input = input
        self.repository = repository
        self.presenter = presenter
    }
}

extension DailyForecastInteractor: DailyForecastInteractorProtocol {
    func updateData() {
        guard let data = repository.fetchCachedForecast(for: input) else { return }
        presenter.showData(data)
    }
}
