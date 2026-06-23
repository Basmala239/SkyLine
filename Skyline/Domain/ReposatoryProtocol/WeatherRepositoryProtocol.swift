//
//  WeatherRepositoryProtocol.swift
//  Skyline
//
//  Created by بسمله ابوزيد احمد on 22/06/2026.
//

import Foundation
import Combine

protocol WeatherRepositoryProtocol {
    func fetchCurrentWeather(city: String) -> AnyPublisher<WeatherResponse, Error>
    func fetchWeatherForecost(city: String, NumberOfDays: Int) -> AnyPublisher<WeatherForecastResponse, Error>
    func fetchLocation(city: String) -> AnyPublisher<[SearchResult], Error>
}
