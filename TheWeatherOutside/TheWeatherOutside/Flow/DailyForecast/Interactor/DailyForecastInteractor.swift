//
//  DailyForecastInteractor.swift
//  WeatherWise
//
//  Created by Mariya Khutornaya on 16.01.23.
//

import UIKit

protocol DailyForecastInteractorProtocol: AnyObject {
    func updateData()
}

final class DailyForecastInteractor {
    
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
