//
//  WeatherRepositoryImpl.swift
//  Skyline
//
//  Created by بسمله ابوزيد احمد on 22/06/2026.
//

import Foundation
import Combine

class WeatherRepository: WeatherRepositoryProtocol {
    
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.networkService = networkService
    }
    
    func fetchCurrentWeather(city: String) -> AnyPublisher<WeatherResponse, Error> {
        guard networkService.isInternetConnected() else {
            return Fail(error: APIError.networkError)
                .eraseToAnyPublisher()
        }
        
        let parameters: [String: Any] = [
            "q": city
        ]
        
        return networkService.getData(
            endpoint: APIEndpoints.current,
            method: "GET",
            parameters: parameters
        )
        .eraseToAnyPublisher()
    }
    
    func fetchWeatherForecost(city: String, NumberOfDays: Int) -> AnyPublisher<WeatherForecastResponse, Error> {
        guard networkService.isInternetConnected() else {
            return Fail(error: APIError.networkError)
                .eraseToAnyPublisher()
        }
        
        let parameters: [String: Any] = [
            "q": city,
            "days": 7
        ]
        
        return networkService.getData(
            endpoint: APIEndpoints.forecast,
            method: "GET",
            parameters: parameters
        )
        .eraseToAnyPublisher()
    }
    
    func fetchLocation(city: String) -> AnyPublisher<[SearchResult], Error> {
        guard networkService.isInternetConnected() else {
            return Fail(error: APIError.networkError)
                .eraseToAnyPublisher()
        }
        
        let parameters: [String: Any] = [
            "q": city
        ]
        
        return networkService.getData(
            endpoint: APIEndpoints.search,
            method: "GET",
            parameters: parameters
        )
        .eraseToAnyPublisher()
    }
}
