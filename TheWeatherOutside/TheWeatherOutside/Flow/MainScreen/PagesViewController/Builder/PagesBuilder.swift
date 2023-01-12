//
//  PagesBuilder.swift
//  WeatherWise
//
//  Created by Mariya Khutornaya on 12.01.23.
//

import UIKit

public protocol PagesBuilderProtocol: AnyObject {
    func build() -> UIViewController
}

final class PagesBuilder: PagesBuilderProtocol {
    private typealias Interactor = PagesInteractor
    private typealias Presenter = PagesPresenter
    private typealias ViewController = PagesViewController
    
    func build() -> UIViewController {
        let viewController = ViewController()
        let presenter = Presenter(viewController: viewController)
        let interactor = Interactor(
            repository: ForecastRepository(),
            presenter: presenter)
        
        viewController.interactor = interactor
        
        return viewController
    }
}
