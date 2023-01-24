//
//  HourlyForecastInteractor.swift
//  WeatherWise
//
//  Created by Mariya Khutornaya on 15.01.23.
//

import UIKit

protocol HourlyForecastInteractorProtocol: AnyObject {
    func updateData()
}

final class HourlyForecastInteractor {
    
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
        guard let data = repository.fetchCachedForecast(for: input) else { return }
        presenter.showData(data)
    }
}
