//
//  NetworkService.swift
//  Skyline
//
//  Created by بسمله ابوزيد احمد on 22/06/2026.
//

import Foundation
import Combine

protocol NetworkServiceProtocol {
    func isInternetConnected() -> Bool
    func getData<T: Decodable>(endpoint: String, method: String, parameters: [String: Any]?) -> AnyPublisher<T, Error>
}

class NetworkService: NetworkServiceProtocol {
    static let shared = NetworkService()
    
    private let baseURL = "https://api.weatherapi.com/v1"
    private let apiKey = "fd25ebb8814a4d49acc122359241903"
    
    private init() {}

    func getData<T: Decodable>(
        endpoint: String,
        method: String = "GET",
        parameters: [String: Any]? = nil
    ) -> AnyPublisher<T, Error> {
        
        guard var components = URLComponents(string: baseURL + endpoint) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        var queryItems = [URLQueryItem(name: "key", value: apiKey)]
        
        if let parameters = parameters {
            for (key, value) in parameters {
                queryItems.append(URLQueryItem(name: key, value: "\(value)"))
            }
        }
        components.queryItems = queryItems
        
        guard let url = components.url else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in

                guard let response = output.response as? HTTPURLResponse else {
                    throw APIError.networkError
                }

                switch response.statusCode {
                case 200...299:
                    return output.data

                default:
                    throw APIError.serverError(statusCode: response.statusCode)
                }
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func isInternetConnected() -> Bool {
         return true
    }
}
