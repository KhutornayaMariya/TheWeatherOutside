//
//  CoreDataManager.swift
//  WeatherWise
//
//  Created by Mariya Khutornaya on 02.01.23.
//

import Foundation
import CoreData

final class CoreDataManager {
    
    private let unitsManager: UnitsManagerProtocol
    
    static let defaultManager = CoreDataManager()
    
    var metaInfo: [MetaInfo] = []
    
    init() {
        unitsManager = UnitsManager()
        reloadMetaInfo()
    }
    
    private lazy var backgroundContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentContainer.persistentStoreCoordinator
        return context
    }()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TheWeatherOutside")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    private func saveContext () {
        if backgroundContext.hasChanges {
            do {
                try backgroundContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    private func reloadMetaInfo() {
        let request = MetaInfo.fetchRequest()
        metaInfo = (try? self.persistentContainer.viewContext.fetch(request)) ?? []
    }
    
    private func currentForecast(_ forecast: ForecastResponse.CurrentWeatherParams) -> Current {
        let newForecast = Current(context: persistentContainer.viewContext)
        
        newForecast.date = Date(timeIntervalSince1970: forecast.date)
        newForecast.weatherDesc = forecast.weather[0].description
        newForecast.windSpeed = Int16(forecast.windSpeed.rounded(.toNearestOrEven))
        newForecast.windGust = Int16(forecast.windGust?.rounded(.toNearestOrEven) ?? 0)
        newForecast.windDirection = WindDirectionManager().windDirection(from: forecast.windDirection)
        newForecast.rain = forecast.rain?.level ?? 0
        newForecast.snow = forecast.snow?.level ?? 0
        newForecast.cloudCover = Int16(forecast.clouds)
        newForecast.feelsLike = Int16(forecast.feelsLike.rounded(.toNearestOrEven))
        newForecast.humidity = Int16(forecast.humidity)
        newForecast.pressure = Int16(forecast.pressure)
        newForecast.temperature = Int16(forecast.currentTemp.rounded(.toNearestOrEven))
        newForecast.uvi = Int16(forecast.uvi)
        newForecast.sunrise = Date(timeIntervalSince1970: forecast.sunrise!)
        newForecast.sunset = Date(timeIntervalSince1970: forecast.sunset!)
        newForecast.temperatureImp = unitsManager.convertTempToImperial(forecast.currentTemp)
        newForecast.feelsLikeImp = unitsManager.convertTempToImperial(forecast.feelsLike)
        newForecast.windSpeed = unitsManager.convertSpeedToImperial(forecast.windSpeed)
        newForecast.windGust = unitsManager.convertSpeedToImperial(forecast.windGust ?? 0)
        
        return newForecast
    }
    
    private func hourlyForecast(_ forecast: ForecastResponse.CurrentWeatherParams) -> Hourly {
        let newForecast = Hourly(context: persistentContainer.viewContext)
        
        newForecast.date = Date(timeIntervalSince1970: forecast.date)
        newForecast.weatherDesc = forecast.weather[0].description
        newForecast.windSpeed = Int16(forecast.windSpeed.rounded(.toNearestOrEven))
        newForecast.windGust = Int16(forecast.windGust?.rounded(.toNearestOrEven) ?? 0)
        newForecast.windDirection = WindDirectionManager().windDirection(from: forecast.windDirection)
        newForecast.rain = forecast.rain?.level ?? 0
        newForecast.snow = forecast.snow?.level ?? 0
        newForecast.cloudCover = Int16(forecast.clouds)
        newForecast.feelsLike = Int16(forecast.feelsLike.rounded(.toNearestOrEven))
        newForecast.humidity = Int16(forecast.humidity)
        newForecast.pressure = Int16(forecast.pressure)
        newForecast.temperature = Int16(forecast.currentTemp.rounded(.toNearestOrEven))
        newForecast.uvi = Int16(forecast.uvi)
        newForecast.temperatureImp = unitsManager.convertTempToImperial(forecast.currentTemp)
        newForecast.feelsLikeImp = unitsManager.convertTempToImperial(forecast.feelsLike)
        newForecast.windSpeed = unitsManager.convertSpeedToImperial(forecast.windSpeed)
        newForecast.windGust = unitsManager.convertSpeedToImperial(forecast.windGust ?? 0)
        
        return newForecast
    }
    
    private func dailyForecast(_ forecast: ForecastResponse.DailyWeatherParams) -> Daily {
        let newForecast = Daily(context: persistentContainer.viewContext)
        
        newForecast.date = Date(timeIntervalSince1970: forecast.date)
        newForecast.weatherDesc = forecast.weather[0].description
        newForecast.windSpeed = Int16(forecast.windSpeed.rounded(.toNearestOrEven))
        newForecast.windGust = Int16(forecast.windGust?.rounded(.toNearestOrEven) ?? 0)
        newForecast.windDirection = WindDirectionManager().windDirection(from: forecast.windDirection)
        newForecast.rain = forecast.rain ?? 0
        newForecast.snow = forecast.snow ?? 0
        newForecast.cloudCover = Int16(forecast.clouds)
        newForecast.feelsLikeDay = Int16(forecast.dailyFeelsLikeTemp.day.rounded(.toNearestOrEven))
        newForecast.feelsLikeMorn = Int16(forecast.dailyFeelsLikeTemp.morn.rounded(.toNearestOrEven))
        newForecast.feelsLikeEve = Int16(forecast.dailyFeelsLikeTemp.eve.rounded(.toNearestOrEven))
        newForecast.feelsLikeNight = Int16(forecast.dailyFeelsLikeTemp.night.rounded(.toNearestOrEven))
        newForecast.tempDay = Int16(forecast.dailyTemp.day.rounded(.toNearestOrEven))
        newForecast.tempEve = Int16(forecast.dailyTemp.eve.rounded(.toNearestOrEven))
        newForecast.tempMorn = Int16(forecast.dailyTemp.morn.rounded(.toNearestOrEven))
        newForecast.tempMin = Int16(forecast.dailyTemp.min.rounded(.toNearestOrEven))
        newForecast.tempNight = Int16(forecast.dailyTemp.night.rounded(.toNearestOrEven))
        newForecast.tempMax = Int16(forecast.dailyTemp.max.rounded(.toNearestOrEven))
        newForecast.humidity = Int16(forecast.humidity)
        newForecast.pressure = Int16(forecast.pressure)
        newForecast.uvi = Int16(forecast.uvi)
        newForecast.sunrise = Date(timeIntervalSince1970: forecast.sunrise)
        newForecast.sunset = Date(timeIntervalSince1970: forecast.sunset)
        newForecast.moonrise = Date(timeIntervalSince1970: forecast.moonrise)
        newForecast.moonset = Date(timeIntervalSince1970: forecast.moonset)
        newForecast.moonPhase = forecast.moonPhase
        newForecast.feelsLikeDayImp = unitsManager.convertTempToImperial(forecast.dailyFeelsLikeTemp.day)
        newForecast.feelsLikeMornImp = unitsManager.convertTempToImperial(forecast.dailyFeelsLikeTemp.morn)
        newForecast.feelsLikeEveImp = unitsManager.convertTempToImperial(forecast.dailyFeelsLikeTemp.eve)
        newForecast.feelsLikeNightImp = unitsManager.convertTempToImperial(forecast.dailyFeelsLikeTemp.night)
        newForecast.tempDayImp = unitsManager.convertTempToImperial(forecast.dailyTemp.day)
        newForecast.tempEveImp = unitsManager.convertTempToImperial(forecast.dailyTemp.eve)
        newForecast.tempMornImp = unitsManager.convertTempToImperial(forecast.dailyTemp.morn)
        newForecast.tempMinImp = unitsManager.convertTempToImperial(forecast.dailyTemp.min)
        newForecast.tempNightImp = unitsManager.convertTempToImperial(forecast.dailyTemp.night)
        newForecast.tempMaxImp = unitsManager.convertTempToImperial(forecast.dailyTemp.max)
        newForecast.windSpeed = unitsManager.convertSpeedToImperial(forecast.windSpeed)
        newForecast.windGust = unitsManager.convertSpeedToImperial(forecast.windGust ?? 0)
        
        return newForecast
    }
}

extension CoreDataManager {
    
    func doesAlreadyExistMetaInfo(with title: String) -> Bool {
        metaInfo.contains(where: { $0.locationTitle == title })
    }
    
    func addMetaInfo(forecast: ForecastResponse, locationTitle: String) {
        guard !doesAlreadyExistMetaInfo(with: locationTitle) else { return }
        
        let newMetaInfo = MetaInfo(context: persistentContainer.viewContext)
        
        newMetaInfo.locationTitle = locationTitle
        newMetaInfo.timeZone = forecast.timezone
        newMetaInfo.latitude = forecast.lat
        newMetaInfo.longitude = forecast.lon
        newMetaInfo.current = currentForecast(forecast.current)
        var hourlyArray: [Hourly] = []
        for forecast in forecast.hourly {
            hourlyArray.append(hourlyForecast(forecast))
        }
        newMetaInfo.hourly = NSSet(array: hourlyArray)
        
        var dailyArray: [Daily] = []
        for forecast in forecast.daily {
            dailyArray.append(dailyForecast(forecast))
        }
        newMetaInfo.daily = NSSet(array: dailyArray)
        
        metaInfo.append(newMetaInfo)
        self.saveContext()
    }
}
