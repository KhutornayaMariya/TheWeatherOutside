//
//  DailyForecastBuilder.swift
//  WeatherWise
//
//  Created by Mariya Khutornaya on 16.01.23.
//

import Foundation
import UIKit

public protocol DailyForecastBuilderProtocol: AnyObject {
    func build(with location: String) -> UIViewController
}

final class DailyForecastBuilder: DailyForecastBuilderProtocol {
    private typealias Interactor = DailyForecastInteractor
    private typealias Presenter = DailyForecastPresenter
    private typealias ViewController = DailyViewController
    
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
