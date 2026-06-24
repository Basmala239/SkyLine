//
//  DayDetailsView.swift
//  Skyline
//
//  Created by بسمله ابوزيد احمد on 24/06/2026.
//

import SwiftUI

struct DayDetailsView: View {
    var forecastDay: ForecastDay
    @State private var theme = AppTheme.current
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                DaySummaryCard(day: forecastDay.day, dateString: forecastDay.date, theme: theme)
                
                SectionHeader(title: "Hourly Forecast", theme: theme)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(forecastDay.hour, id: \.timeEpoch) { hourData in
                            HourlyTimelineItem(hour: hourData, theme: theme)
                        }
                    }
                    .padding(.horizontal)
                }
                
                SectionHeader(title: "Day Details", theme: theme)
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    DetailGridTile(
                        icon: "sun.max.fill",
                        iconColor: theme == .morning ? .orange : .yellow,
                        label: "UV Index",
                        value: String(format: "%.1f", forecastDay.day.uv),
                        theme: theme
                    )
                    DetailGridTile(
                        icon: "humidity.fill",
                        iconColor: theme == .morning ? .blue : .cyan,
                        label: "Avg Humidity",
                        value: "\(forecastDay.day.avghumidity)%",
                        theme: theme
                    )
                    DetailGridTile(
                        icon: "wind",
                        iconColor: theme == .morning ? .gray : .gray,
                        label: "Max Wind",
                        value: "\(Int(forecastDay.day.maxwindKph)) km/h",
                        theme: theme
                    )
                    DetailGridTile(
                        icon: "cloud.rain.fill",
                        iconColor: theme == .morning ? .teal : .mint,
                        label: "Rain Chance",
                        value: "\(forecastDay.day.dailyChanceOfRain)%",
                        theme: theme
                    )
                    DetailGridTile(
                        icon: "sunrise.fill",
                        iconColor: .yellow,
                        label: "Sunrise",
                        value: forecastDay.astro.sunrise,
                        theme: theme
                    )
                    DetailGridTile(
                        icon: "sunset.fill",
                        iconColor: .purple,
                        label: "Sunset",
                        value: forecastDay.astro.sunset,
                        theme: theme
                    )
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .background(theme.backgroundColor.edgesIgnoringSafeArea(.all))
        .navigationBarTitle(Text("Day Forecast"), displayMode: .inline)
        .foregroundColor(theme.fontColor)
        .onAppear {
            theme = AppTheme.current
        }
        .preferredColorScheme(theme == .morning ? .light : .dark)
    }
}

// MARK: - Section Header

struct SectionHeader: View {
    let title: String
    let theme: AppTheme
    
    var body: some View {
        HStack {
            Text(title)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(theme.fontColor)
            Spacer()
        }
        .padding(.horizontal)
    }
}

// MARK: - Day Summary Card

struct DaySummaryCard: View {
    let day: DaySummary
    let dateString: String
    let theme: AppTheme
    
    var body: some View {
        VStack(spacing: 16) {
            // Date
            Text(formatDate(dateString))
                .font(.headline)
                .foregroundColor(theme.secondaryFontColor)
            
            // Weather Icon and Temperature
            HStack(spacing: 24) {
                AsyncImage(url: URL(string: "https:\(day.condition.icon)")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80, height: 80)
                        .background(
                            Circle()
                                .fill(theme == .morning ? Color.blue.opacity(0.08) : Color.white.opacity(0.05))
                                .frame(width: 100, height: 100)
                        )
                } placeholder: {
                    ProgressView()
                        .tint(theme.secondaryFontColor)
                        .frame(width: 80, height: 80)
                        .background(
                            Circle()
                                .fill(theme == .morning ? Color.blue.opacity(0.08) : Color.white.opacity(0.05))
                                .frame(width: 100, height: 100)
                        )
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(Int(day.avgtempC))°C")
                        .font(.system(size: 44, weight: .semibold))
                        .foregroundColor(theme.fontColor)
                    
                    Text(day.condition.text)
                        .font(.subheadline)
                        .foregroundColor(theme.secondaryFontColor)
                }
                
                Spacer()
            }
            .padding(.horizontal, 4)
            
            Divider()
                .background(theme.dividerColor)
            
            // Min/Max Temperature
            HStack(spacing: 0) {
                Spacer()
                VStack(spacing: 4) {
                    Image(systemName: "arrow.up")
                        .foregroundColor(theme == .morning ? .red : .orange)
                    Text("\(Int(day.maxtempC))°C")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(theme.fontColor)
                    Text("Max")
                        .font(.caption2)
                        .foregroundColor(theme.secondaryFontColor)
                }
                Spacer()
                
                Divider()
                    .frame(height: 40)
                    .background(theme.dividerColor)
                
                Spacer()
                VStack(spacing: 4) {
                    Image(systemName: "arrow.down")
                        .foregroundColor(theme == .morning ? .blue : .cyan)
                    Text("\(Int(day.mintempC))°C")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(theme.fontColor)
                    Text("Min")
                        .font(.caption2)
                        .foregroundColor(theme.secondaryFontColor)
                }
                Spacer()
                
                Divider()
                    .frame(height: 40)
                    .background(theme.dividerColor)
                
                Spacer()
                VStack(spacing: 4) {
                    Image(systemName: "thermometer")
                        .foregroundColor(.green)
                    Text("\(Int(day.avgtempC))°C")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(theme.fontColor)
                    Text("Avg")
                        .font(.caption2)
                        .foregroundColor(theme.secondaryFontColor)
                }
            }
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(theme.cardBackgroundColor)
                .shadow(color: theme.shadowColor, radius: 8, x: 0, y: 4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(theme.dividerColor, lineWidth: 1)
        )
        .padding(.horizontal)
    }
    
    // Helper to format date
    func formatDate(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let date = formatter.date(from: dateString) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateFormat = "EEEE, MMM d, yyyy"
            return displayFormatter.string(from: date)
        }
        return dateString
    }
}

// MARK: - Hourly Timeline Item

struct HourlyTimelineItem: View {
    let hour: HourForecast
    let theme: AppTheme
    
    // Helper to extract clean hour format (e.g., "14:00")
    var cleanTime: String {
        guard let timePart = hour.time.split(separator: " ").last else { return hour.time }
        return String(timePart)
    }
    
    var body: some View {
        VStack(spacing: 8) {
            Text(cleanTime)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(theme.secondaryFontColor)
            
            AsyncImage(url: URL(string: "https:\(hour.condition.icon)")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 36, height: 36)
            } placeholder: {
                ProgressView()
                    .tint(theme.secondaryFontColor)
                    .frame(width: 36, height: 36)
            }
            
            Text("\(Int(hour.tempC))°")
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(theme.fontColor)
            
            // Condition text
            Text(hour.condition.text)
                .font(.caption2)
                .foregroundColor(theme.secondaryFontColor)
                .lineLimit(1)
                .frame(maxWidth: 60)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(theme.cardBackgroundColor)
                .shadow(color: theme.shadowColor, radius: 4, x: 0, y: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(theme.dividerColor, lineWidth: 1)
        )
        .frame(width: 80)
    }
}

// MARK: - Detail Grid Tile

struct DetailGridTile: View {
    let icon: String
    let iconColor: Color
    let label: String
    let value: String
    let theme: AppTheme
    
    var body: some View {
        HStack(spacing: 12) {
            // Icon with background
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(iconColor)
                .frame(width: 40, height: 40)
                .background(
                    Circle()
                        .fill(iconColor.opacity(0.15))
                )
            
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.caption)
                    .foregroundColor(theme.secondaryFontColor)
                    .textCase(.uppercase)
                
                Text(value)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(theme.fontColor)
            }
            
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(theme.cardBackgroundColor)
                .shadow(color: theme.shadowColor, radius: 4, x: 0, y: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(theme.dividerColor, lineWidth: 1)
        )
    }
}

// MARK: - Additional Detail Grid Tile (Alternative Style)

struct DetailGridTileAlt: View {
    let icon: String
    let iconColor: Color
    let label: String
    let value: String
    let theme: AppTheme
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(iconColor)
                .frame(height: 30)
            
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
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(theme.cardBackgroundColor)
                .shadow(color: theme.shadowColor, radius: 4, x: 0, y: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(theme.dividerColor, lineWidth: 1)
        )
    }
}

// MARK: - Weather Icon Helper

extension View {
    func weatherIcon(urlString: String, theme: AppTheme) -> some View {
        AsyncImage(url: URL(string: "https:\(urlString)")) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
        } placeholder: {
            ProgressView()
                .tint(theme.secondaryFontColor)
        }
    }
}

// MARK: - Model Extensions (if needed)

extension ForecastDay {
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let date = formatter.date(from: self.date) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateFormat = "EEEE, MMM d"
            return displayFormatter.string(from: date)
        }
        return self.date
    }
    
    var dayOfWeek: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let date = formatter.date(from: self.date) {
            let weekdayFormatter = DateFormatter()
            weekdayFormatter.dateFormat = "EEEE"
            return weekdayFormatter.string(from: date)
        }
        return ""
    }
}
