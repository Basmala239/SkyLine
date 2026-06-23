//
//  WeatherRequest.swift
//  Skyline
//
//  Created by بسمله ابوزيد احمد on 22/06/2026.
//

import Foundation

struct WeatherRequest {
    let city: String
    let includeForecast: Bool
    
    init(city: String, includeForecast: Bool = false) {
        self.city = city
        self.includeForecast = includeForecast
    }
}
