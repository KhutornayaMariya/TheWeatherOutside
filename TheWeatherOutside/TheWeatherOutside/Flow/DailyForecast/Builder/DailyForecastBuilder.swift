//
//  DailyForecastBuilder.swift
//  WeatherWise
//
//  Created by Mariya Khutornaya on 16.01.23.
//

import UIKit

protocol DailyForecastBuilderProtocol: AnyObject {
    func build(with location: String) -> UIViewController
}

final class DailyForecastBuilder: DailyForecastBuilderProtocol {
    
    func build(with location: String) -> UIViewController {
        let viewController = DailyViewController()
        let presenter = DailyForecastPresenter(viewController: viewController)
        let interactor = DailyForecastInteractor(
            input: location,
            repository: ForecastRepository(),
            presenter: presenter)
        
        viewController.interactor = interactor
        
        return viewController
    }
}
