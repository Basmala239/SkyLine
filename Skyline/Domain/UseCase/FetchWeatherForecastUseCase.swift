//
//  FetchWeatherForecastUseCase.swift
//  Skyline
//
//  Created by بسمله ابوزيد احمد on 22/06/2026.
//

import Foundation
import Combine

protocol FetchWeatherForecastUseCaseProtocol {
    func execute(city: String, days: Int) -> AnyPublisher<WeatherForecastResponse, Error>
}

class FetchWeatherForecastUseCase: FetchWeatherForecastUseCaseProtocol {
    private let repository: WeatherRepositoryProtocol
        
        init(repository: WeatherRepositoryProtocol = WeatherRepository()) {
            self.repository = repository
        }
        
        func execute(city: String, days: Int) -> AnyPublisher<WeatherForecastResponse, Error> {
            guard !city.trimmingCharacters(in: .whitespaces).isEmpty else {
                return Fail(error: APIError.custom(message: "City name cannot be empty"))
                    .eraseToAnyPublisher()
            }
            
            return repository.fetchWeatherForecost(city: city, NumberOfDays: days)
        }
}
