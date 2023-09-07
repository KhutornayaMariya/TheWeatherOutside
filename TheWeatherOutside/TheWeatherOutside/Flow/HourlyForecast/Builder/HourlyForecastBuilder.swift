//
//  HourlyForecastBuilder.swift
//  WeatherWise
//
//  Created by Mariya Khutornaya on 15.01.23.
//

import UIKit

protocol HourlyForecastBuilderProtocol: AnyObject {
    func build(with location: String) -> UIViewController
}

final class HourlyForecastBuilder: HourlyForecastBuilderProtocol {
    
    func build(with location: String) -> UIViewController {
        let viewController = HourlyViewController()
        let presenter = HourlyForecastPresenter(viewController: viewController)
        let interactor = HourlyForecastInteractor(
            input: location,
            repository: ForecastRepository(),
            presenter: presenter
        )
        
        viewController.interactor = interactor
        
        return viewController
    }
}
