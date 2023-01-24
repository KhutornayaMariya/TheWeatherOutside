//
//  PagesPresenter.swift
//  WeatherWise
//
//  Created by Mariya Khutornaya on 12.01.23.
//

import Foundation

protocol PagesPresenterProtocol: AnyObject {
    func showData(_ data: [MetaInfo])
}

final class PagesPresenter {
    private let dateManager: DateManagerProtocol
    private let imageManager = WeatherConditionManager()
    
    weak var viewController: PageViewControllerProtocol?
    
    init(viewController: PageViewControllerProtocol) {
        self.viewController = viewController
        self.dateManager = DateManager()
    }
    
    private func createViewModels(data: [MetaInfo]) -> [ForecastViewModel] {
        var viewModels: [ForecastViewModel] = []
        
        for dataItem in data {
            guard let currentForecast = createCurrentForecastModel(data: dataItem) else {
                return []
            }
            let viewModel = ForecastViewModel(
                locationTitle: dataItem.locationTitle ?? "",
                currentForecast: currentForecast,
                hourlySectionTitle: HeaderCellModel(title: nil, link: "DAY".localized),
                hourlyForecast: createHourlyForecastModel(data: dataItem),
                dailySectionTitle: HeaderCellModel(title: "DAILY_TITLE".localized, link: "DAILY".localized),
                dailyForecast: createDailyForecastModel(data: dataItem)
            )
            viewModels.append(viewModel)
        }
        
        return viewModels
    }
    
    private func createCurrentForecastModel(data: MetaInfo) -> CurrentForecastModel? {
        guard let forecast = data.current,
              let date = forecast.date,
              let sunriseTime = forecast.sunrise,
              let sunsetTime = forecast.sunset,
              let timeZone = data.timeZone
        else { return nil }
        
        let isImpericUnits = isImpericUnits()
        let windSpeed = isImpericUnits ? "\(String(forecast.windSpeedImp)) \("SPEED_IMP".localized)" : "\(String(forecast.windSpeed)) \("SPEED_METRIC".localized)"
        
        let model = CurrentForecastModel(
            feelsLikeTemp: isImpericUnits ? String(forecast.feelsLikeImp) : String(forecast.feelsLike),
            currentTemp: isImpericUnits ? String(forecast.temperatureImp) : String(forecast.temperature),
            description: forecast.weatherDesc?.capitalizedSentence ?? "",
            date: dateManager.convert(date, to: timeZone, with: "E, d MMMM yyyy"),
            sunriseTime: dateManager.convert(sunriseTime, to: timeZone, with: "HH:mm"),
            sunsetTime: dateManager.convert(sunsetTime, to: timeZone, with: "HH:mm"),
            windSpeed: windSpeed,
            cloudCover: String(forecast.cloudCover),
            precipitation: precipitation(rain: forecast.rain, snow: forecast.snow)
        )
        
        return model
    }
    
    private func createHourlyForecastModel(data: MetaInfo) -> [HourlyForecastModel] {
        guard let forecast = data.hourly,
              let currentForecast = data.current,
              let timeZone = data.timeZone
        else { return [] }
        
        var models: [HourlyForecastModel] = []
        let isImpericUnits = isImpericUnits()
        
        guard var oneHourForecastArray = Array(forecast) as? [Hourly]  else { return [] }
        oneHourForecastArray.sort(by: {
            guard let beforeDate = $0.date,
                  let afterDate = $1.date else { return false }
            return afterDate > beforeDate }
        )
        let twelveFourHoursForecast = Array(oneHourForecastArray[0...12])
        
        for forecast in twelveFourHoursForecast {
            guard let date = forecast.date else { return [] }
            
            var isDay: Bool
            if let sunset = currentForecast.sunset,
               let sunrise = currentForecast.sunrise,
               date > sunset,
               let nextSunrise = Calendar.current.date(byAdding: .day, value: 1, to: sunrise),
               date < nextSunrise
            {
                isDay = false
            } else {
                isDay = true
            }
            
            let model = HourlyForecastModel(
                time: dateManager.convert(date, to: timeZone, with: "HH:mm"),
                temperature: isImpericUnits ? "\(String(forecast.temperatureImp))°" : "\(String(forecast.temperature))°",
                imageName: imageManager.skyConditionImage(rain: forecast.rain, snow: forecast.snow, cloudCover: forecast.cloudCover, isDay: isDay)
            )
            
            models.append(model)
        }
        
        return models
    }
    
    private func createDailyForecastModel(data: MetaInfo) -> [DailyForecastModel] {
        guard let forecast = data.daily,
              let timeZone = data.timeZone
        else { return [] }
        
        var models: [DailyForecastModel] = []
        let isImpericUnits = isImpericUnits()
        
        for oneDayForecast in forecast {
            guard let forecast = oneDayForecast as? Daily,
                  let date = forecast.date
            else { return [] }
            
            if Calendar.current.isDateInToday(date) { continue }
            
            let temp = isImpericUnits ? "\(String(forecast.tempMinImp))/\(String(forecast.tempMaxImp))°" : "\(String(forecast.tempMin))/\(String(forecast.tempMax))°"
            
            let precipitation: String
            if forecast.rain != 0 {
                precipitation = "\(String(forecast.rain)) \("PRECIPITATION".localized)"
            } else if forecast.snow != 0 {
                precipitation = "\(String(forecast.snow)) \("PRECIPITATION".localized)"
            } else {
                precipitation = "0 \("PRECIPITATION".localized)"
            }
            
            let model = DailyForecastModel(
                date: dateManager.convert(date, to: timeZone, with: "dd/MM") ,
                temperature: temp,
                description: forecast.weatherDesc?.capitalizedSentence ?? "",
                imageName: imageManager.skyConditionImage(rain: forecast.rain, snow: forecast.snow, cloudCover: forecast.cloudCover, isDay: true),
                amountOfPrecipitation: precipitation
            )
            
            models.append(model)
        }
        
        models.sort(by: { $1.date > $0.date} )
        return models
    }
    
    private func precipitation(rain: Double, snow: Double) -> CurrentForecastModel.Precipitation {
        if rain != 0 && rain > snow {
            return .init(type: .rain, amount: String(rain))
        } else if snow > rain {
            return .init(type: .snow, amount: String(snow))
        } else {
            return .init(type: .rainless, amount: "0")
        }
    }
    
    private func isImpericUnits() -> Bool {
        UserDefaults.standard.string(forKey: UserDefaultsKeys.units.rawValue) == Units.imperial.rawValue
    }
}

extension PagesPresenter: PagesPresenterProtocol {
    func showData(_ data: [MetaInfo]) {
        let viewModel = createViewModels(data: data)
        viewController?.show(with: viewModel)
    }
}
