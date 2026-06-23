//
//  APIError.swift
//  Skyline
//
//  Created by بسمله ابوزيد احمد on 22/06/2026.
//

import Foundation

enum APIError: LocalizedError {
    case invalidURL
    case noData
    case decodingError
    case networkError
    case serverError(statusCode: Int)
    case custom(message: String)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received"
        case .decodingError:
            return "Failed to decode response"
        case .networkError:
            return "Network connection error"
        case .serverError(let code):
            return "Server error with status code: \(code)"
        case .custom(let message):
            return message
        }
    }
}
