//
//  HourlyForecastPresenter.swift
//  WeatherWise
//
//  Created by Mariya Khutornaya on 15.01.23.
//

import UIKit

protocol HourlyForecastPresenterProtocol: AnyObject {
    func showData(_ data: MetaInfo)
}

final class HourlyForecastPresenter {

    private weak var viewController: HourlyForecastViewControllerProtocol?
    
    private var currentForecast: Current?

    private var isImperialUnits: Bool = {
        UserDefaultsManager.defaultManager.isImpericUnits()
    }()
    
    init(viewController: HourlyForecastViewControllerProtocol) {
        self.viewController = viewController
    }
    
    private func createViewModel(data: MetaInfo) -> HourViewModel {
        let hourModels = createHourOverviewModels(data: data)
        let diagramModel = createWeatherDiagramModel(data: data)
        
        let viewModel = HourViewModel(locationTitle: data.locationTitle ?? "",
                                      hoursForecast: hourModels,
                                      diagramData: diagramModel)
        
        return viewModel
    }
    
    private func createHourOverviewModels(data: MetaInfo) -> [HourOverviewModel] {
        guard let forecast = data.hourly,
              let timeZone = data.timeZone
        else { return [] }
        
        self.currentForecast = data.current
        var models: [HourOverviewModel] = []
        
        let oneHourForecastArray = hourlyForecastFilter(forecast: forecast)
        let twentyFourHoursForecast = Array(oneHourForecastArray[0...24])
        
        for forecast in twentyFourHoursForecast {
            if let date = forecast.date {
                let weatherParameters = createWeatherParameterModels(data: forecast)

                let model = HourOverviewModel(
                    weatherParameters: weatherParameters,
                    date: DateManager.convert(date, to: timeZone, with: "dd/MM"),
                    time: DateManager.convert(date, to: timeZone, with: "HH:mm"),
                    temperature: isImperialUnits ? "\(String(forecast.temperatureImp))°" : "\(String(forecast.temperature))°"
                )

                models.append(model)
            }
        }
        
        return models
    }
    
    private func hourlyForecastFilter(forecast: NSSet) -> [Hourly] {
        guard var array = Array(forecast) as? [Hourly]  else { return [] }
        array.sort(by: {
            guard let beforeDate = $0.date,
                  let afterDate = $1.date else { return false }
            return afterDate > beforeDate }
        )
        return array
    }
    
    private func createWeatherParameterModels(data: Hourly) -> [WeatherParameterViewModel] {
        
        let windSpeed = isImperialUnits ? "\(String(data.windSpeedImp)) \("SPEED_IMP".localized) " : "\(String(data.windSpeed)) \("SPEED_METRIC".localized) "
        let wind = WeatherParameterViewModel(
            parameterName: "WIND".localized.capitalizedSentence,
            value: windSpeed + (data.windDirection ?? ""),
            imageName: "wind"
        )
        
        let windGustValue = isImperialUnits ? "\(String(data.windGustImp)) \("SPEED_IMP".localized)" : "\(String(data.windGust)) \("SPEED_METRIC".localized)"
        let windGust = WeatherParameterViewModel(
            parameterName: "WIND_GUST".localized.capitalizedSentence,
            value: windGustValue,
            imageName: "wind_gust"
        )
        
        let humidity = WeatherParameterViewModel(
            parameterName: "HUMIDITY".localized.capitalizedSentence,
            value: "\(String(data.humidity))%",
            imageName: "humidity"
        )
        
        let pressure = WeatherParameterViewModel(
            parameterName: "PRESSURE".localized.capitalizedSentence,
            value: "\(String(data.pressure)) \("PRESSURE_UNITS".localized.capitalizedSentence)",
            imageName: "thermometer"
        )
        
        var isDay = true
        if let date = data.date,
           let sunset = currentForecast?.sunset,
           let sunrise = currentForecast?.sunrise,
           date > sunset,
           let nextSunrise = Calendar.current.date(byAdding: .day, value: 1, to: sunrise),
           date < nextSunrise
        { isDay = false }
        
        let precipitation = WeatherConditionManager.precipitation(rain: data.rain, snow: data.snow, cloudCover: data.cloudCover, isDay: isDay)
        
        return [wind, windGust, humidity, pressure, precipitation]
    }
    
    private func createWeatherDiagramModel(data: MetaInfo) -> WeatherDiagramViewModel {
        guard let forecast = data.hourly,
              let currentForecast = data.current,
              let timeZone = data.timeZone
        else { return WeatherDiagramViewModel(temperature: [], temperatureString: [], time: [], precipitation: [], image: []) }
        
        let oneHourForecastArray = hourlyForecastFilter(forecast: forecast)
        let sevenHoursForecast = Array(oneHourForecastArray[0...7])
        
        var temperature: [Int] = []
        var temperatureString: [String] = []
        var time: [String] = []
        var precipitation: [String] = []
        var image: [UIImage] = []
        
        for forecast in sevenHoursForecast {
            if let date = forecast.date {
                let temp = isImperialUnits ? forecast.temperatureImp : forecast.temperature
                temperature.append(Int(temp))
                temperatureString.append("\(String(temp))°")
                time.append(DateManager.convert(date, to: timeZone, with: "HH:mm"))
                precipitation.append(WeatherConditionManager.precipitationAmount(rain: forecast.rain, snow: forecast.snow))

                var isDay = true
                if let sunset = currentForecast.sunset,
                   let sunrise = currentForecast.sunrise,
                   date > sunset,
                   let nextSunrise = Calendar.current.date(byAdding: .day, value: 1, to: sunrise),
                   date < nextSunrise
                { isDay = false }

                let imageName = WeatherConditionManager.skyConditionImage(rain: forecast.rain, snow: forecast.snow, cloudCover: forecast.cloudCover, isDay: isDay)
                image.append(UIImage(named: imageName) ?? UIImage())
            }
        }
        
        return WeatherDiagramViewModel(temperature: temperature,
                                       temperatureString: temperatureString,
                                       time: time,
                                       precipitation: precipitation,
                                       image: image)
    }
}

extension HourlyForecastPresenter: HourlyForecastPresenterProtocol {
    func showData(_ data: MetaInfo) {
        let viewModel = createViewModel(data: data)
        viewController?.show(with: viewModel)
    }
}
