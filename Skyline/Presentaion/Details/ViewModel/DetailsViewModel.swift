//
//  DetailsViewModel.swift
//  Skyline
//
//  Created by بسمله ابوزيد احمد on 23/06/2026.
//

import Foundation
import Combine

class DetailsViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var weatherResponse: WeatherResponse?
    @Published var weatherForecast: WeatherForecastResponse?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isCityFavorited = false

    // MARK: - Computed Properties for UI
    var locationName: String {
        weatherResponse?.location.name ?? "Unknown"
    }

    var country: String {
        weatherResponse?.location.country ?? ""
    }

    var temperature: String {
        guard let temp = weatherResponse?.current.tempC else { return "--°C" }
        return "\(Int(temp))°C"
    }

    var conditionText: String {
        weatherResponse?.current.condition.text ?? "Unknown"
    }

    var conditionIconURL: String {
        guard let icon = weatherResponse?.current.condition.icon else { return "" }
        return "https:" + icon
    }

    var feelsLike: String {
        guard let feelsLike = weatherResponse?.current.feelslikeC else { return "--°C" }
        return "Feels like \(Int(feelsLike))°C"
    }

    var humidity: String {
        guard let humidity = weatherResponse?.current.humidity else { return "--%" }
        return "\(humidity)%"
    }

    var windSpeed: String {
        guard let wind = weatherResponse?.current.windKph else { return "-- km/h" }
        return "\(Int(wind)) km/h"
    }

    var windDirection: String {
        weatherResponse?.current.windDir ?? "--"
    }

    var uvIndex: String {
        guard let uv = weatherResponse?.current.uv else { return "--" }
        return String(format: "%.1f", uv)
    }

    var lastUpdated: String {
        weatherResponse?.current.lastUpdated ?? "Unknown"
    }

    var locationDisplay: String {
        guard let location = weatherResponse?.location else { return "Unknown" }
        return "\(location.name), \(location.country)"
    }
    
    var maxTemp: String {
         if let forecastDays = weatherForecast?.forecast.forecastday, !forecastDays.isEmpty {
            let today = forecastDays[0]
            return "\(Int(today.day.maxtempC))°C"
        }
        return "--"
    }
    
    var minTemp: String {
        if let forecastDays = weatherForecast?.forecast.forecastday, !forecastDays.isEmpty {
            let today = forecastDays[0]
            return "\(Int(today.day.mintempC))°C"
        }
        return "--"
    }

    // MARK: - Private Properties
    private let fetchCurrentWeatherUseCase: FetchCurrentWeatherUseCaseProtocol
    private let fetchWeatherForecastUseCase: FetchWeatherForecastUseCaseProtocol
    private let saveFavoriteUseCase: SaveFavoriteUseCaseProtocol
    private let checkFavoriteUseCase: CheckFavoriteUseCaseProtocol
    private let deleteFavoriteUseCase: DeleteFavoriteUseCaseProtocol
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization
    init(
        fetchWeatherUseCase: FetchCurrentWeatherUseCaseProtocol = FetchCurrentWeatherUseCase(),
        fetchWeatherForecastUseCase: FetchWeatherForecastUseCaseProtocol = FetchWeatherForecastUseCase(),
        saveFavoriteUseCase: SaveFavoriteUseCaseProtocol = SaveFavoriteUseCase(),
        checkFavoriteUseCase: CheckFavoriteUseCaseProtocol = CheckFavoriteUseCase(),
        deleteFavoriteUseCase: DeleteFavoriteUseCaseProtocol = DeleteFavoriteUseCase()
    ) {
        self.deleteFavoriteUseCase = deleteFavoriteUseCase
        self.fetchCurrentWeatherUseCase = fetchWeatherUseCase
        self.fetchWeatherForecastUseCase = fetchWeatherForecastUseCase
        self.saveFavoriteUseCase = saveFavoriteUseCase
        self.checkFavoriteUseCase = checkFavoriteUseCase
    }

    // MARK: - Public Methods
    func fetchWeather(for city: String) {
        guard !city.trimmingCharacters(in: .whitespaces).isEmpty else { return }

        isLoading = true
        errorMessage = nil

        let currentWeatherPublisher = fetchCurrentWeatherUseCase.execute(city: city)
        let forecastPublisher = fetchWeatherForecastUseCase.execute(city: city, days: 7)

        Publishers.CombineLatest(currentWeatherPublisher, forecastPublisher)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false

                    switch completion {
                    case .failure(let error):
                        self?.errorMessage = error.localizedDescription
                        self?.weatherResponse = nil
                        self?.weatherForecast = nil
                    case .finished:
                        break
                    }
                },
                receiveValue: { [weak self] currentWeather, forecast in
                    guard let self = self else { return }
                    self.weatherResponse = currentWeather
                    self.weatherForecast = forecast
                    self.errorMessage = nil
                    
                    self.updateFavoriteStatus()
                }
            )
            .store(in: &cancellables)
    }
    
    func refreshWeather() {
        guard let city = weatherResponse?.location.name else { return }
        fetchWeather(for: city)
    }
    
    func updateFavoriteStatus() {
        self.isCityFavorited = checkFavoriteUseCase.execute(name: locationName)
    }
    
    func toggleFavorite() {
        if isCityFavorited {
            deleteFavoriteUseCase.execute(name: locationName)
            isCityFavorited = false
        } else {
            saveFavoriteUseCase.execute(
                name: locationName,
                temp: temperature,
                icon: conditionIconURL,
                lastUpdated: lastUpdated
            )
            isCityFavorited = true
        }
    }
}
