//
//  ViewController.swift
//  TheWeatherOutside
//
//  Created by m.khutornaya on 06.12.2022.
//

import UIKit

final class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGreen
        setUpNavigationBar()
//        ForecastApiManager().forecastRequest(lat: 50.119469, lon: 8.599217, units: .metric)
//        ForecastApiManager().forecastRequest(lat: 43.271008, lon: 5.372398, units: .metric)
//        ForecastApiManager().forecastRequest(lat: 55.755864, lon: 37.617698, units: .metric)
        //        GeoCodeApiManager().geoCodeRequest(for: "Москва")43.271008, 5.372398
    }
    
    private func setUpNavigationBar() {
        let navBar: UINavigationBar? = navigationController?.navigationBar
        navBar?.isHidden = false
        navBar?.backgroundColor = .white
        navBar?.tintColor = .black
        
        let menuButtonItem = UIBarButtonItem(
            image: UIImage(named: "burgerMenu"),
            style: UIBarButtonItem.Style.plain,
            target: self,
            action: #selector(openAppSettings)
        )
        
        let locationButtonItem = UIBarButtonItem(
            image: UIImage(named: "location"),
            style: UIBarButtonItem.Style.plain,
            target: self,
            action: #selector(addLocation)
        )
        
        navigationItem.rightBarButtonItem = locationButtonItem
        navigationItem.leftBarButtonItem = menuButtonItem
    }
    
    @objc
    func openAppSettings() {
        self.navigationController?.pushViewController(SettingsViewController(), animated: true)
    }
    
    @objc
    func addLocation() {
        let alertController = UIAlertController(title: "Загрузка фотографии", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Введите название"
        }
        
        let saveImageAction = UIAlertAction(title: "Сохранить", style: .default) { [weak self] action in
            guard let self = self,
                  let text = alertController.textFields?[0].text,
                  text != ""
            else { return }
            
            GeoCodeApiManager().geoCodeRequest(for: text) { response in
                guard let coordinates = response.value,
                      let lat = coordinates.latitude(),
                      let lon = coordinates.longitude(),
                      let title = coordinates.name()
                else { return }
//                проверить есть ли такая локация уже
//                если нет запрос
                // если есть -> открывать страницу с этой локацией
                ForecastRepository().fetchDataForLocation(lat: lat, lon: lon, title: title)
            }
        }
        
        let cancel = UIAlertAction(title: "Отменить", style: .cancel)
        
        alertController.addAction(cancel)
        alertController.addAction(saveImageAction)
        present(alertController, animated: true)
    }
}
