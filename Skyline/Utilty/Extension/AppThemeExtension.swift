//
//  AppThemeExtension.swift
//  Skyline
//
//  Created by بسمله ابوزيد احمد on 24/06/2026.
//

import SwiftUI
extension AppTheme {
    var tabBarBackgroundColor: Color {
        switch self {
        case .morning:
            return Color.white
        case .evening:
            return Color(red: 0.08, green: 0.08, blue: 0.12)
        }
    }
    
    var navigationBarBackgroundColor: Color {
        switch self {
        case .morning:
            return Color.white.opacity(0.95)
        case .evening:
            return Color(red: 0.08, green: 0.08, blue: 0.12).opacity(0.95)
        }
    }
}
