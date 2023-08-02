//
//  DailyForecastPresenter.swift
//  WeatherWise
//
//  Created by Mariya Khutornaya on 16.01.23.
//

import UIKit

protocol DailyForecastPresenterProtocol: AnyObject {
    func showData(_ data: MetaInfo)
}

final class DailyForecastPresenter {

    weak var viewController: DailyViewControllerProtocol?
    
    init(viewController: DailyViewControllerProtocol) {
        self.viewController = viewController
    }
    
    private var isImpericUnits: Bool = {
        UserDefaultsManager.defaultManager.isImpericUnits()
    }()
    
    private func createViewModel(data: MetaInfo) -> DailyViewModel {
        let dailyForecastModel = createDailyForecastModels(data: data)
        let viewModel = DailyViewModel(locationTitle: data.locationTitle ?? "",
                                       dailyForecast: dailyForecastModel)
        return viewModel
    }
    
    private func createDailyForecastModels(data: MetaInfo) -> [DailyViewModel.DailyForecastItem] {
        guard let forecast = data.daily,
              let timeZone = data.timeZone
        else { return [] }
        
        var models: [DailyViewModel.DailyForecastItem] = []
        
        let oneDayForecastArray = dailyForecastFilter(forecast: forecast)
        
        for forecast in oneDayForecastArray {
            guard let date = forecast.date else { return [] }
            
            if Calendar.current.isDateInToday(date) { continue }
            
            let dayAndNightModel = createDayAndNightModels(data: forecast, timeZone)
            let timeOfDayModel = createTimeOfDayModel(data: forecast)
            
            let model: DailyViewModel.DailyForecastItem = .init(
                date: DateManager.convert(date, to: timeZone, with: "dd/MM EE"),
                timeOfDay: timeOfDayModel,
                dayAndNight: dayAndNightModel
            )
            
            models.append(model)
        }
        
        return models
    }
    
    private func dailyForecastFilter(forecast: NSSet) -> [Daily] {
        guard var array = Array(forecast) as? [Daily]  else { return [] }
        array.sort(by: {
            guard let beforeDate = $0.date,
                  let afterDate = $1.date else { return false }
            return afterDate > beforeDate }
        )
        return array
    }
    
    private func createTimeOfDayModel(data: Daily) -> [TimeOfDayItem] {
        let dayImage = WeatherConditionManager.skyConditionImage(rain: data.rain, snow: data.snow, cloudCover: data.cloudCover, isDay: true)
        let dayData = TimeOfDayItem(
            title: "DAY_TITLE".localized.capitalizedSentence,
            temperature: isImpericUnits ? "\(String( data.tempDayImp))°" : "\(String(data.tempDay))°",
            imageName: dayImage,
            weatherParameters: createWeatherParameterModels(data: data, isDay: true)
        )
        
        let nightImage = WeatherConditionManager.skyConditionImage(rain: data.rain, snow: data.snow, cloudCover: data.cloudCover, isDay: false)
        let nightData = TimeOfDayItem(
            title: "NIGTH_TITLE".localized.capitalizedSentence,
            temperature: isImpericUnits ? "\(String( data.tempNightImp))°" : "\(String(data.tempNight))°",
            imageName: nightImage,
            weatherParameters: createWeatherParameterModels(data: data, isDay: false)
        )
        
        return [dayData, nightData]
    }
    
    private func createWeatherParameterModels(data: Daily, isDay: Bool) -> [WeatherParameterViewModel] {
        var realFeelValue: String
        if isDay {
            realFeelValue = isImpericUnits ? "\(String( data.feelsLikeDayImp))°" : "\(String(data.feelsLikeDay))°"
        } else {
            realFeelValue = isImpericUnits ? "\(String( data.feelsLikeNightImp))°" : "\(String(data.feelsLikeNight))°"
        }
        
        let realFeel = WeatherParameterViewModel(
            parameterName: "FEELS_LIKE".localized.capitalizedSentence,
            value: realFeelValue,
            imageName: "thermometer"
        )
        
        let windSpeed = isImpericUnits ? "\(String(data.windSpeedImp)) \("SPEED_IMP".localized) " : "\(String(data.windSpeed)) \("SPEED_METRIC".localized) "
        let wind = WeatherParameterViewModel(
            parameterName: "WIND".localized.capitalizedSentence,
            value: windSpeed + (data.windDirection ?? ""),
            imageName: "wind"
        )
        
        let uvi = WeatherParameterViewModel(
            parameterName: "UV_INDEX".localized,
            value: isDay ? String(data.uvi) : "-",
            imageName: "sunny"
        )
        
        let cloudCover = WeatherParameterViewModel(
            parameterName: "CLOUD_COVER".localized.capitalizedSentence,
            value: "\(String(data.cloudCover))%",
            imageName: "cloudy"
        )
        
        let precipitation = WeatherConditionManager.precipitation(rain: data.rain, snow: data.snow, cloudCover: data.cloudCover, isDay: isDay)
        
        return [realFeel, wind, precipitation, cloudCover, uvi]
    }
    
    private func createDayAndNightModels(data: Daily, _ timeZone: String) -> [DayAndNight] {
        let dayLength = data.sunset! - data.sunrise!
        let nightLength = abs(data.moonset! - data.moonrise!)
        
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.zeroFormattingBehavior = .dropAll
        formatter.allowedUnits = [.hour, .minute]
        
        return [DayAndNight(rise: DateManager.convert(data.sunrise!, to: timeZone, with: "HH:mm"),
                            set: DateManager.convert(data.sunset!, to: timeZone, with: "HH:mm"),
                            duration: formatter.string(from: dayLength)!,
                            imageName: "sunny"),
                DayAndNight(rise: DateManager.convert(data.moonrise!, to: timeZone, with: "HH:mm"),
                            set: DateManager.convert(data.moonset!, to: timeZone, with: "HH:mm"),
                            duration: formatter.string(from: nightLength)!,
                            imageName: "moon")]
    }
}

extension DailyForecastPresenter: DailyForecastPresenterProtocol {
    func showData(_ data: MetaInfo) {
        let viewModel = createViewModel(data: data)
        viewController?.show(with: viewModel)
    }
}

extension Date {
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
}
