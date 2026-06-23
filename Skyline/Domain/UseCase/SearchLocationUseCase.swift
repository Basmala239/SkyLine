//
//  SearchLocationUseCase.swift
//  Skyline
//
//  Created by بسمله ابوزيد احمد on 22/06/2026.
//

import Foundation
import Combine

protocol SearchLocationUseCaseProtocol {
    func execute(city: String) -> AnyPublisher<[SearchResult], Error>
}

class SearchLocationUseCase: SearchLocationUseCaseProtocol {
    private let repository: WeatherRepositoryProtocol
        
        init(repository: WeatherRepositoryProtocol = WeatherRepository()) {
            self.repository = repository
        }
        
        func execute(city: String) -> AnyPublisher<[SearchResult], Error> {
            guard !city.trimmingCharacters(in: .whitespaces).isEmpty else {
                return Fail(error: APIError.custom(message: "City name cannot be empty"))
                    .eraseToAnyPublisher()
            }
            
            return repository.fetchLocation(city: city)
        }
}
