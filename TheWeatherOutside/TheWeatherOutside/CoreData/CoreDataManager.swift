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
    
    private func fillCoreDataWithForecast() {
        ForecastApiManager().forecastRequest(lat: 55.755864, lon: 37.617698, units: .metric)
    }
}

extension CoreDataManager {
    
    func addCurrent(_ forecast: ForecastResponse.CurrentWeatherParams) {
        persistentContainer.performBackgroundTask { context in
            let newForecast = Current(context: context)
            
            newForecast.date = Date(timeIntervalSince1970: forecast.date)
            newForecast.weatherDesc = forecast.weather[0].description
            newForecast.windSpeed = Int16(forecast.windSpeed)
            newForecast.windDirection = WindDirectionManager().windDirection(from: forecast.windDirection)
            newForecast.rain = forecast.rain?.level ?? 0
            newForecast.snow = forecast.snow?.level ?? 0
            newForecast.cloudCover = Int16(forecast.clouds)
            newForecast.feelsLike = Int16(forecast.feelsLike)
            newForecast.humidity = Int16(forecast.humidity)
            newForecast.pressure = Int16(forecast.pressure)
            newForecast.temperature = Int16(forecast.currentTemp)
            newForecast.uvi = Int16(forecast.uvi)
            newForecast.sunrise = Date(timeIntervalSince1970: forecast.sunrise!)
            newForecast.sunset = Date(timeIntervalSince1970: forecast.sunset!)
            
            do {
                try context.save()
                print("Current Forecast was added")
            } catch {
                print(error)
            }
        }
    }
    
    func addHourly(_ forecast: ForecastResponse.CurrentWeatherParams) {
        persistentContainer.performBackgroundTask { context in
            let newForecast = Hourly(context: context)
            
            newForecast.date = Date(timeIntervalSince1970: forecast.date)
            newForecast.weatherDesc = forecast.weather[0].description
            newForecast.windSpeed = Int16(forecast.windSpeed)
            newForecast.windDirection = WindDirectionManager().windDirection(from: forecast.windDirection)
            newForecast.rain = forecast.rain?.level ?? 0
            newForecast.snow = forecast.snow?.level ?? 0
            newForecast.cloudCover = Int16(forecast.clouds)
            newForecast.feelsLike = Int16(forecast.feelsLike)
            newForecast.humidity = Int16(forecast.humidity)
            newForecast.pressure = Int16(forecast.pressure)
            newForecast.temperature = Int16(forecast.currentTemp)
            newForecast.uvi = Int16(forecast.uvi)
            
            do {
                try context.save()
                print("Hourly Forecast was added")
            } catch {
                print(error)
            }
        }
    }
    
    func addDaily(_ forecast: ForecastResponse.DailyWeatherParams) {
        persistentContainer.performBackgroundTask { context in
            let newForecast = Daily(context: context)
            
            newForecast.date = Date(timeIntervalSince1970: forecast.date)
            newForecast.weatherDesc = forecast.weather[0].description
            newForecast.windSpeed = Int16(forecast.windSpeed)
            newForecast.windDirection = WindDirectionManager().windDirection(from: forecast.windDirection)
            newForecast.rain = forecast.rain ?? 0
            newForecast.snow = forecast.snow ?? 0
            newForecast.cloudCover = Int16(forecast.clouds)
            newForecast.feelsLikeDay = Int16(forecast.dailyFeelsLikeTemp.day)
            newForecast.feelsLikeMorn = Int16(forecast.dailyFeelsLikeTemp.morn)
            newForecast.feelsLikeEve = Int16(forecast.dailyFeelsLikeTemp.eve)
            newForecast.feelsLikeNight = Int16(forecast.dailyFeelsLikeTemp.night)
            newForecast.tempDay = Int16(forecast.dailyTemp.day)
            newForecast.tempEve = Int16(forecast.dailyTemp.eve)
            newForecast.tempMorn = Int16(forecast.dailyTemp.morn)
            newForecast.tempMin = Int16(forecast.dailyTemp.min)
            newForecast.tempNight = Int16(forecast.dailyTemp.night)
            newForecast.tempMax = Int16(forecast.dailyTemp.max)
            
            newForecast.humidity = Int16(forecast.humidity)
            newForecast.pressure = Int16(forecast.pressure)
            newForecast.uvi = Int16(forecast.uvi)
            newForecast.sunrise = Date(timeIntervalSince1970: forecast.sunrise)
            newForecast.sunset = Date(timeIntervalSince1970: forecast.sunset)
            newForecast.moonrise = Date(timeIntervalSince1970: forecast.moonrise)
            newForecast.moonset = Date(timeIntervalSince1970: forecast.moonset)
            newForecast.moonPhase = forecast.moonPhase
            
            do {
                try context.save()
                print("Daily forecast was added")
            } catch {
                print(error)
            }
        }
    }
    
    func addMetaInfo(_ timeZone: String, _ lat: Double, _ lon: Double) {
        persistentContainer.performBackgroundTask { context in
            let newMetaInfo = MetaInfo(context: context)
            newMetaInfo.timeZone = timeZone
            newMetaInfo.latitude = lat
            newMetaInfo.longitude = lon
            
            do {
                try context.save()
                print("newMetaInfo was added")
            } catch {
                print(error)
            }
        }
    }
}
