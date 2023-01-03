//
//  CoreDataManager.swift
//  WeatherWise
//
//  Created by Mariya Khutornaya on 02.01.23.
//

import Foundation
import CoreData

final class CoreDataManager {
    
    static let defaultManager = CoreDataManager()
    
    var metaInfo: [MetaInfo] = []
    var current: [Current] = []
    var daily: [Daily] = []
    var hourly: [Hourly] = []
    
    init() {
        reloadMetaInfo()
        reloadDailyForecast()
        reloadHourlyForecast()
        reloadCurrentForecast()
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
    
    private func reloadCurrentForecast() {
        let request = Current.fetchRequest()
        current = (try? self.persistentContainer.viewContext.fetch(request)) ?? []
    }
    
    private func reloadHourlyForecast() {
        let request = Hourly.fetchRequest()
        hourly = (try? self.persistentContainer.viewContext.fetch(request)) ?? []
    }
    
    private func reloadDailyForecast() {
        let request = Daily.fetchRequest()
        daily = (try? self.persistentContainer.viewContext.fetch(request)) ?? []
    }
}

extension CoreDataManager {
    
    func addCurrent(_ forecast: ForecastResponse.CurrentWeatherParams, for metaInfo: MetaInfo) {
        let newForecast = Current(context: persistentContainer.viewContext)
        
        newForecast.date = Date(timeIntervalSince1970: forecast.date)
        newForecast.weatherDesc = forecast.weather[0].description
        newForecast.windSpeed = Int16(forecast.windSpeed)
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
        newForecast.metaInfo = metaInfo
        
        current.append(newForecast)
        self.saveContext()
    }
    
    func addHourly(_ forecast: ForecastResponse.CurrentWeatherParams, for metaInfo: MetaInfo) {
        let newForecast = Hourly(context: persistentContainer.viewContext)
        
        newForecast.date = Date(timeIntervalSince1970: forecast.date)
        newForecast.weatherDesc = forecast.weather[0].description
        newForecast.windSpeed = Int16(forecast.windSpeed)
        newForecast.windDirection = WindDirectionManager().windDirection(from: forecast.windDirection)
        newForecast.rain = forecast.rain?.level ?? 0
        newForecast.snow = forecast.snow?.level ?? 0
        newForecast.cloudCover = Int16(forecast.clouds)
        newForecast.feelsLike = Int16(forecast.feelsLike.rounded(.toNearestOrEven))
        newForecast.humidity = Int16(forecast.humidity)
        newForecast.pressure = Int16(forecast.pressure)
        newForecast.temperature = Int16(forecast.currentTemp.rounded(.toNearestOrEven))
        newForecast.uvi = Int16(forecast.uvi)
        newForecast.metaInfo = metaInfo
        
        hourly.append(newForecast)
        self.saveContext()
    }
    
    func addDaily(_ forecast: ForecastResponse.DailyWeatherParams, for metaInfo: MetaInfo) {
        let newForecast = Daily(context: persistentContainer.viewContext)
        
        newForecast.date = Date(timeIntervalSince1970: forecast.date)
        newForecast.weatherDesc = forecast.weather[0].description
        newForecast.windSpeed = Int16(forecast.windSpeed)
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
        newForecast.metaInfo = metaInfo
        
        daily.append(newForecast)
        self.saveContext()
    }
    
    func addMetaInfo(_ timeZone: String, _ lat: Double, _ lon: Double) {
        let newMetaInfo = MetaInfo(context: persistentContainer.viewContext)
        
        newMetaInfo.timeZone = timeZone
        newMetaInfo.latitude = lat
        newMetaInfo.longitude = lon
        
        metaInfo.append(newMetaInfo)
        self.saveContext()
    }
}
