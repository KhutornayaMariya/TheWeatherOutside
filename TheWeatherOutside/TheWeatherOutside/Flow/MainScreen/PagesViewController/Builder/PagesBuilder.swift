//
//  PagesBuilder.swift
//  WeatherWise
//
//  Created by Mariya Khutornaya on 12.01.23.
//

import UIKit

protocol PagesBuilderProtocol: AnyObject {
    func build() -> UIViewController
}

final class PagesBuilder: PagesBuilderProtocol {
    func build() -> UIViewController {
        let viewController = PagesViewController()
        let presenter = PagesPresenter(viewController: viewController)
        let interactor = PagesInteractor(
            repository: ForecastRepository(),
            presenter: presenter)
        
        viewController.interactor = interactor
        
        return viewController
    }
}
