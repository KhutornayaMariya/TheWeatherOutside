//
//  HourlyForecastBuilder.swift
//  WeatherWise
//
//  Created by Mariya Khutornaya on 15.01.23.
//

import UIKit

public protocol HourlyForecastBuilderProtocol: AnyObject {
    func build(with location: String) -> UIViewController
}

final class HourlyForecastBuilder: HourlyForecastBuilderProtocol {
    private typealias Interactor = HourlyForecastInteractor
    private typealias Presenter = HourlyForecastPresenter
    private typealias ViewController = HourlyViewController
    
    func build(with location: String) -> UIViewController {
        let viewController = ViewController()
        let presenter = Presenter(viewController: viewController)
        let interactor = Interactor(
            input: location,
            repository: ForecastRepository(),
            presenter: presenter)
        
        viewController.interactor = interactor
        
        return viewController
    }
}
