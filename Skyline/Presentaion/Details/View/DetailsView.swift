//
//  DetailsView.swift
//  Skyline
//
//  Created by بسمله ابوزيد احمد on 23/06/2026.
//

import SwiftUI

struct DetailsView: View {
    @ObservedObject var viewModel = DetailsViewModel()
    var cityName: String = "Alexandria"

    var body: some View {
            VStack(spacing: 0) {
                if viewModel.isLoading {
                    ProgressView() // Note: ProgressView requires iOS 14. If truly on pure iOS 13, use a custom ActivityIndicator
                        .scaleEffect(1.5)
                        .padding()
                } else if let error = viewModel.errorMessage {
                    ErrorView(message: error) {
                        viewModel.refreshWeather()
                    }
                } else if viewModel.weatherResponse != nil {
                    // In iOS 13, the List itself acts as the ScrollView
                    List {
                        // Section 1: Main Weather Card Content
                        WeatherCard(viewModel: viewModel)
                            .listRowInsets(EdgeInsets())
                            .background(Color(.systemBackground))
                        
                        // Section 2: Forecast Items
                        Section(header: Text("7-Day Forecast").font(.headline).padding(.vertical, 5)) {
                            ForEach(viewModel.weatherForecast?.forecast.forecastday ?? [], id: \.dateEpoch) { day in
                                NavigationLink(destination: DayDetails(forecastDay: day)) {
                                    ForecastItemView(forecastDay: day)
                                }
                            }
                        }
                    }
                    .listStyle(GroupedListStyle()) // Clean background styling for iOS 13
                } else {
                    EmptyStateView()
                }
            }
            .navigationBarTitle(Text(viewModel.locationDisplay), displayMode: .inline)
        
        .onAppear {
            viewModel.fetchWeather(for: cityName)
        }
    }
}

struct WeatherCard: View {
    @ObservedObject var viewModel: DetailsViewModel
    
    var body: some View {
        VStack(spacing: 15) {
            // Last Updated
            Text("Updated: \(viewModel.lastUpdated)")
                .font(.caption)
                .foregroundColor(.secondary)
            
            // Temperature
            Text(viewModel.temperature)
                .font(.system(size: 70, weight: .thin))
            
            AsyncImage(url: URL(string: viewModel.conditionIconURL)) { image in
                           image
                               .resizable()
                               .aspectRatio(contentMode: .fit)
                               .frame(width: 64, height: 64)
                       } placeholder: {
                           ProgressView()
                       }
            
            // Condition Text
            Text(viewModel.conditionText)
                .font(.headline)
            
            Text(viewModel.feelsLike)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            // Details Grid (iOS 13 does not have LazyVGrid, using HStacks instead)
            HStack(alignment: .center, spacing: 20) {
                WeatherDetailItem(icon: "humidity", value: viewModel.humidity, label: "Humidity")
                Spacer()
                WeatherDetailItem(icon: "wind", value: viewModel.windSpeed, label: "Wind")
                Spacer()
                WeatherDetailItem(icon: "sun.max", value: viewModel.uvIndex, label: "UV Index")
            }
            .padding(.top)
            
            Divider()
            
            // Extra details in HStack
            HStack(spacing: 20) {
                VStack {
                    Text("Direction").font(.caption).foregroundColor(.secondary)
                    Text(viewModel.windDirection).font(.subheadline).fontWeight(.medium)
                }
                .frame(maxWidth: .infinity)
                
                VStack {
                    Text("Cloud").font(.caption).foregroundColor(.secondary)
                    Text(viewModel.weatherResponse?.current.condition.text ?? "--")
                        .font(.subheadline).fontWeight(.medium).lineLimit(1)
                }
                .frame(maxWidth: .infinity)
                
                VStack {
                    Text("Visibility").font(.caption).foregroundColor(.secondary)
                    Text("\(Int(viewModel.weatherResponse?.current.windKph ?? 0)) km")
                        .font(.subheadline).fontWeight(.medium)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding()
    }
}

struct WeatherDetailItem: View {
    let icon: String
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 5) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
            
            Text(value)
                .font(.headline)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

struct ForecastItemView: View {
    var forecastDay: ForecastDay
    
    var body: some View {
        HStack {
            Text(forecastDay.date)
                .fontWeight(.medium)
            Spacer()
            Text("\(Int(forecastDay.day.avgtempC))°C")
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}

struct DayDetails: View {
    var forecastDay: ForecastDay
    
    var body: some View {
        VStack {
            Text("Details for \(forecastDay.date)")
                .font(.title)
            Text("Average Temp: \(Int(forecastDay.day.avgtempC))°C")
        }
    }
}

