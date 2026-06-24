//
//  EmptyStateView.swift
//  Skyline
//
//  Created by بسمله ابوزيد احمد on 22/06/2026.
//

import Foundation
import SwiftUI

struct EmptyStateView: View {
    let iconName: String
    let title: String
    let description: String
    let theme: AppTheme
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: iconName)
                .font(.system(size: 50))
                .foregroundColor(theme.secondaryFontColor)
                .padding()
                .background(
                    Circle()
                        .fill(theme == .morning ? Color.blue.opacity(0.1) : Color.white.opacity(0.05))
                        .frame(width: 100, height: 100)
                )
            
            Text(title)
                .font(.title2)
                .fontWeight(.medium)
                .foregroundColor(theme.fontColor)
            
            Text(description)
                .font(.subheadline)
                .foregroundColor(theme.secondaryFontColor)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .padding()
    }
}
