//
//  ForecastResponse.swift
//  WeatherWise
//
//  Created by Mariya Khutornaya on 30.12.22.
//

import Foundation

struct ForecastResponse: Decodable {
    
    let current: CurrentWeatherParams
    let hourly: [CurrentWeatherParams]
    let daily: [DailyWeatherParams]
    let timezone: String
    let lon: Double
    let lat: Double
}

extension ForecastResponse {
    struct CurrentWeatherParams: Decodable {
        let date: Double
        let currentTemp: Double
        let feelsLike: Double
        let humidity: Int
        let windSpeed: Double
        let windGust: Double?
        let windDirection: Double
        let uvi: Double
        let clouds: Int
        let rain: Precipitation?
        let snow: Precipitation?
        let weather: [WeatherDescription]
        let pressure: Int
        let sunrise: Double?
        let sunset: Double?
    }
    
    struct DailyWeatherParams: Decodable {
        let date: Double
        let dailyTemp: DailyTemp
        let dailyFeelsLikeTemp: DailyFeelsLikeTemp
        let humidity: Int
        let windSpeed: Double
        let windGust: Double?
        let windDirection: Double
        let uvi: Double
        let clouds: Int
        let rain: Double?
        let snow: Double?
        let weather: [WeatherDescription]
        let pressure: Int
        let sunrise: Double
        let sunset: Double
        let moonrise: Double
        let moonset: Double
        let moonPhase: Double
    }
    
    struct WeatherDescription: Decodable {
        let description: String
    }
}

extension ForecastResponse.DailyWeatherParams {
    struct DailyTemp: Decodable {
        let day: Double
        let min: Double
        let max: Double
        let night: Double
        let eve: Double
        let morn: Double
    }
    
    struct DailyFeelsLikeTemp: Decodable {
        let day: Double
        let night: Double
        let eve: Double
        let morn: Double
    }
    
    enum CodingKeys: String, CodingKey {
        case date = "dt"
        case dailyTemp = "temp"
        case dailyFeelsLikeTemp = "feels_like"
        case humidity
        case windSpeed = "wind_speed"
        case windDirection = "wind_deg"
        case windGust = "wind_gust"
        case uvi
        case clouds
        case rain
        case snow
        case weather
        case pressure
        case sunrise
        case sunset
        case moonrise
        case moonset
        case moonPhase = "moon_phase"
    }
}

extension ForecastResponse.CurrentWeatherParams {
    struct Precipitation: Decodable {
        let level: Double
        
        enum CodingKeys: String, CodingKey {
            case level = "1h"
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case date = "dt"
        case currentTemp = "temp"
        case feelsLike = "feels_like"
        case humidity
        case windSpeed = "wind_speed"
        case windGust = "wind_gust"
        case windDirection = "wind_deg"
        case uvi
        case clouds
        case rain
        case snow
        case weather
        case pressure
        case sunrise
        case sunset
    }
}
