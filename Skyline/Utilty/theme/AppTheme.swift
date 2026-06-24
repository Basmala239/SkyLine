//
//  AppTheme.swift
//  Skyline
//
//  Created by بسمله ابوزيد احمد on 24/06/2026.
//

import SwiftUI

enum AppTheme {
    case morning
    case evening
    
    static var current: AppTheme {
        let hour = Calendar.current.component(.hour, from: Date())
        if hour >= 5 && hour < 18 {
            return .morning
        } else {
            return .evening
        }
    }
    
    var backgroundImage: String {
        switch self {
        case .morning: return "morning_bg"
        case .evening: return "evening_bg"
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .morning: return Color(red: 0.95, green: 0.97, blue: 1.0)
        case .evening: return Color(red: 0.06, green: 0.06, blue: 0.10)
        }
    }
    
    var cardBackgroundColor: Color {
        switch self {
        case .morning: return .white
        case .evening: return Color(red: 0.12, green: 0.12, blue: 0.18)
        }
    }
    
    var fontColor: Color {
        switch self {
        case .morning: return Color(red: 0.1, green: 0.1, blue: 0.15)
        case .evening: return Color(red: 0.95, green: 0.95, blue: 0.98)
        }
    }
    
    var secondaryFontColor: Color {
        switch self {
        case .morning: return Color(red: 0.5, green: 0.5, blue: 0.55)
        case .evening: return Color(red: 0.7, green: 0.7, blue: 0.75)
        }
    }
    
    var accentColor: Color {
        switch self {
        case .morning: return .blue
        case .evening: return Color(red: 0.3, green: 0.7, blue: 1.0)
        }
    }
    
    var shadowColor: Color {
        switch self {
        case .morning: return Color.black.opacity(0.08)
        case .evening: return Color.clear
        }
    }
    
    var dividerColor: Color {
        switch self {
        case .morning: return Color.gray.opacity(0.15)
        case .evening: return Color.white.opacity(0.08)
        }
    }
    
    var gradientStart: Color {
        switch self {
        case .morning: return .white
        case .evening: return Color(red: 0.12, green: 0.12, blue: 0.18)
        }
    }
    
    var gradientEnd: Color {
        switch self {
        case .morning: return Color.blue.opacity(0.05)
        case .evening: return Color.gray.opacity(0.05)
        }
    }
    
    // Tab Bar Colors
    var tabBarBackgroundColor: Color {
        switch self {
        case .morning:
            return Color.white
        case .evening:
            return Color(red: 0.08, green: 0.08, blue: 0.12)
        }
    }
    
    // Navigation Bar Colors
    var navigationBarBackgroundColor: Color {
        switch self {
        case .morning:
            return Color.white.opacity(0.95)
        case .evening:
            return Color(red: 0.08, green: 0.08, blue: 0.12).opacity(0.95)
        }
    }
    
    // Status Bar Style
    var statusBarStyle: UIStatusBarStyle {
        switch self {
        case .morning:
            return .darkContent
        case .evening:
            return .lightContent
        }
    }
}
