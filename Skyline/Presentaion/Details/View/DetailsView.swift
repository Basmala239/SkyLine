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
    var showAddToFavoriteBtn: Bool = false
    @State private var theme = AppTheme.current
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if viewModel.isLoading {
                    ProgressView()
                        .tint(theme.fontColor)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(.top, 100)
                    
                } else if let error = viewModel.errorMessage {
                    ErrorView(message: error) {
                        viewModel.refreshWeather()
                    }
                    .padding(.top, 50)
                } else if viewModel.weatherResponse != nil {
                    
                    
                    WeatherCard(viewModel: viewModel, theme: theme)
                        .padding()
                    
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("DETAILS")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(theme.secondaryFontColor)
                            .padding(.horizontal, 4)
                        
                        WeatherDetail(viewModel: viewModel, theme: theme)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(theme.cardBackgroundColor)
                                    .shadow(color: theme.shadowColor, radius: 8, x: 0, y: 2)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(theme.dividerColor, lineWidth: 1)
                            )
                    }
                    .padding(.horizontal)
                    
                    // Forecast Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("3-DAY FORECAST")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(theme.secondaryFontColor)
                            .padding(.horizontal, 4)
                        
                        VStack(spacing: 0) {
                            let days = viewModel.weatherForecast?.forecast.forecastday ?? []
                            ForEach(days.indices, id: \.self) { index in
                                let day = days[index]
                                
                                NavigationLink(destination: DayDetailsView(forecastDay: day)) {
                                    ForecastItemView(forecastDay: day, theme: theme)
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                                if index < days.count - 1 {
                                    Divider()
                                        .padding(.leading, 16)
                                        .background(theme.dividerColor)
                                }
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(theme.cardBackgroundColor)
                                .shadow(color: theme.shadowColor, radius: 8, x: 0, y: 2)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(theme.dividerColor, lineWidth: 1)
                        )
                    }
                    .padding(.horizontal)
                    
                } else {
                    EmptyStateView(
                        iconName: "location",
                        title: "No Weather",
                        description: "Enter your location to follow up the weather",
                        theme: theme
                    )
                    .padding(.top, 100)
                }
            }
            .padding(.vertical)
        }
        .background(theme.backgroundColor.edgesIgnoringSafeArea(.all))
        .navigationBarTitle(Text(viewModel.locationName), displayMode: .inline)
        .navigationBarItems(trailing: groupTrailingItems)
        .foregroundColor(theme.fontColor)
        .onAppear {
            theme = AppTheme.current
            viewModel.fetchWeather(for: cityName)
        }
    }
    
    @ViewBuilder
    private var groupTrailingItems: some View {
        if showAddToFavoriteBtn {
            Button(action: {
                viewModel.toggleFavorite()
            }) {
                Image(systemName: viewModel.isCityFavorited ? "star.fill" : "star")
                    .foregroundColor(viewModel.isCityFavorited ? .yellow : theme.secondaryFontColor)
                    .imageScale(.large)
                    .scaleEffect(viewModel.isCityFavorited ? 1.1 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: viewModel.isCityFavorited)
            }
        }
    }
}

// MARK: - Weather Card

struct WeatherCard: View {
    @ObservedObject var viewModel: DetailsViewModel
    let theme: AppTheme
    
    var body: some View {
        VStack(spacing: 8) {
            // City and Country
            Text(viewModel.locationDisplay)
                .font(.title2)
                .fontWeight(.medium)
                .foregroundColor(theme.fontColor)
            
            // Temperature
            Text(viewModel.temperature)
                .font(.system(size: 76, weight: .thin))
                .foregroundColor(theme.fontColor)
                .padding(.leading, 16)
                .shadow(color: theme == .morning ? Color.clear : Color.white.opacity(0.05), radius: 2, x: 0, y: 0)
            
            // Condition with Icon
            HStack(spacing: 8) {
                AsyncImage(url: URL(string: viewModel.conditionIconURL)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                } placeholder: {
                    ProgressView()
                        .tint(theme.secondaryFontColor)
                }
                
                Text(viewModel.conditionText)
                    .font(.headline)
                    .foregroundColor(theme.secondaryFontColor)
            }
            
            // Min/Max Temperature
            HStack(spacing: 16) {
                Label(viewModel.maxTemp, systemImage: "arrow.up")
                    .foregroundColor(theme == .morning ? .red : .orange)
                Label(viewModel.minTemp, systemImage: "arrow.down")
                    .foregroundColor(theme == .morning ? .blue : .cyan)
            }
            .font(.subheadline)
            .foregroundColor(theme.fontColor)
            
            // Last Updated
            Text("Updated: \(viewModel.lastUpdated)")
                .font(.caption2)
                .foregroundColor(theme.secondaryFontColor)
                .padding(.top, 8)
        }
        .padding(.vertical, 24)
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [theme.gradientStart, theme.gradientEnd]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .shadow(color: theme.shadowColor, radius: 8, x: 0, y: 4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(theme.dividerColor, lineWidth: 1)
        )
    }
}

// MARK: - Weather Detail

struct WeatherDetail: View {
    @ObservedObject var viewModel: DetailsViewModel
    let theme: AppTheme
    
    var body: some View {
        VStack(spacing: 16) {
            // First Row: Humidity, Wind, UV Index
            HStack(alignment: .center, spacing: 0) {
                WeatherDetailItem(
                    icon: "humidity.fill",
                    value: viewModel.humidity,
                    label: "Humidity",
                    iconColor: theme == .morning ? .blue : .cyan,
                    theme: theme
                )
                
                Spacer()
                
                WeatherDetailItem(
                    icon: "wind",
                    value: viewModel.windSpeed,
                    label: "Wind",
                    iconColor: theme == .morning ? .teal : .mint,
                    theme: theme
                )
                
                Spacer()
                
                WeatherDetailItem(
                    icon: "sun.max.fill",
                    value: viewModel.uvIndex,
                    label: "UV Index",
                    iconColor: theme == .morning ? .orange : .yellow,
                    theme: theme
                )
            }
            .padding(.top, 4)
            
            Divider()
                .background(theme.dividerColor)
            
            // Second Row: Direction, Cloud Cover, Visibility
            HStack(spacing: 0) {
                ViewDataRow(
                    title: "Direction",
                    value: viewModel.windDirection,
                    theme: theme
                )
                
                ViewDataRow(
                    title: "Cloud Cover",
                    value: viewModel.weatherResponse?.current.condition.text ?? "--",
                    theme: theme
                )
                
                ViewDataRow(
                    title: "Visibility",
                    value: "\(Int(viewModel.weatherResponse?.current.visKm ?? 0)) km",
                    theme: theme
                )
            }
        }
        .padding()
    }
}

// MARK: - Weather Detail Item

struct WeatherDetailItem: View {
    let icon: String
    let value: String
    let label: String
    let iconColor: Color
    let theme: AppTheme
    
    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(iconColor)
                .frame(height: 24)
            
            Text(value)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(theme.fontColor)
            
            Text(label)
                .font(.caption2)
                .foregroundColor(theme.secondaryFontColor)
                .textCase(.uppercase)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - View Data Row

struct ViewDataRow: View {
    let title: String
    let value: String
    let theme: AppTheme
    
    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.caption2)
                .foregroundColor(theme.secondaryFontColor)
                .textCase(.uppercase)
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
                .lineLimit(1)
                .foregroundColor(theme.fontColor)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Forecast Item

struct ForecastItemView: View {
    var forecastDay: ForecastDay
    let theme: AppTheme
    
    var body: some View {
        HStack(spacing: 16) {
            // Date with day name
            VStack(alignment: .leading, spacing: 2) {
                Text(forecastDay.date)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(theme.fontColor)
                
                Text(getDayName(from: forecastDay.date))
                    .font(.caption2)
                    .foregroundColor(theme.secondaryFontColor)
            }
            .frame(width: 80, alignment: .leading)
            
            Spacer()
            
            // Weather Icon with background
            AsyncImage(url: URL(string: "https:\(forecastDay.day.condition.icon)")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 36, height: 36)
                    .background(
                        Circle()
                            .fill(theme == .morning ? Color.blue.opacity(0.08) : Color.white.opacity(0.05))
                            .frame(width: 44, height: 44)
                    )
            } placeholder: {
                ProgressView()
                    .tint(theme.secondaryFontColor)
                    .frame(width: 44, height: 44)
            }
            
            // Temperature Range
            VStack(alignment: .trailing, spacing: 4) {
                HStack(spacing: 12) {
                    Text("\(Int(forecastDay.day.mintempC))°")
                        .font(.body)
                        .foregroundColor(theme.secondaryFontColor)
                        .frame(width: 36, alignment: .trailing)
                    
                    // Temperature Bar with animation
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: theme == .morning ?
                                [Color.blue.opacity(0.6), Color.orange.opacity(0.6)] :
                                [Color.cyan.opacity(0.6), Color.orange.opacity(0.6)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: 60, height: 6)
                    
                    Text("\(Int(forecastDay.day.maxtempC))°")
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(theme.fontColor)
                        .frame(width: 36, alignment: .leading)
                }
                
                // Condition text
                Text(forecastDay.day.condition.text)
                    .font(.caption2)
                    .foregroundColor(theme.secondaryFontColor)
                    .lineLimit(1)
            }
        }
        .padding(.all, 16)
        .contentShape(Rectangle())
        .background(
            theme == .morning ? Color.white.opacity(0.01) : Color.clear
        )
        .scaleEffect(1.0)
    }
    
    func getDayName(from dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let date = formatter.date(from: dateString) {
            let weekdayFormatter = DateFormatter()
            weekdayFormatter.dateFormat = "EEEE"
            return weekdayFormatter.string(from: date)
        }
        return ""
    }
}
