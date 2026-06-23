//
//  WeatherForecastResponseDTO+Mapping.swift
//  Skyline
//
//  Created by بسمله ابوزيد احمد on 22/06/2026.
//

import Foundation

extension WeatherForecastResponse {
    
    func toDomain() -> AppWeatherForecast {
        // Map the array of hourly forecast objects safely
        let domainHours = (self.forecast.forecastday.first?.hour ?? []).map { hourDTO in
            HourForecastItem(
                timeString: hourDTO.time, // You can format this string later if needed
                tempCelsius: Int(hourDTO.tempC.rounded()),
                iconURL: "https:\(hourDTO.condition.icon)"
            )
        }
        
        return AppWeatherForecast(
            cityName: self.location.name,
            country: self.location.country,
            currentTempCelsius: Int(self.current.tempC.rounded()),
            conditionText: self.current.condition.text,
            conditionIconURL: "https:\(self.current.condition.icon)",
            hourlyForecast: domainHours
        )
    }
}
