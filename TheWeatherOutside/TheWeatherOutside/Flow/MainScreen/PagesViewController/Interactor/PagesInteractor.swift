//
//  PagesInteractor.swift
//  WeatherWise
//
//  Created by Mariya Khutornaya on 12.01.23.
//

import Foundation
import UIKit

final class PagesInteractor {
    
    private typealias ViewController = PagesViewController
    
    private let repository: ForecastRepositoryProtocol
    private let presenter: PagesPresenterProtocol
    
    init(repository: ForecastRepositoryProtocol, presenter: PagesPresenterProtocol) {
        self.repository = repository
        self.presenter = presenter
    }
}

extension PagesInteractor: PagesInteractorProtocol {
    func updateData() {
        repository.fetchData { [weak self] metaInfo in
            self?.presenter.showData(metaInfo)
        }
    }
    
    func updateData(with newLocation: String, completionHandler: @escaping (Bool) -> Void) {
        repository.fetchDataForLocation(title: newLocation) { [weak self]  result, metaInfo in
            if !result {
                completionHandler(false)
            } else {
                self?.presenter.showData(metaInfo)
            }
        }
    }
}
