//
//  SplashView.swift
//  Skyline
//
//  Created by بسمله ابوزيد احمد on 24/06/2026.
//

import SwiftUI

struct SplashView: View {
    let theme: AppTheme
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0.0
    
    var body: some View {
        ZStack {
            theme.backgroundColor
                .edgesIgnoringSafeArea(.all)
            
            LinearGradient(
                gradient: Gradient(colors: [
                    theme.gradientStart,
                    theme.gradientEnd
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                // App Icon
                Image(systemName: "cloud.sun.fill")
                    .font(.system(size: 80))
                    .foregroundColor(theme.accentColor)
                    .scaleEffect(scale)
                    .opacity(opacity)
                    .shadow(color: theme.shadowColor, radius: 20, x: 0, y: 10)
                
                // App Name
                Text("Skyline")
                    .font(.system(size: 42, weight: .thin))
                    .foregroundColor(theme.fontColor)
                    .opacity(opacity)
                
                // Subtitle
                Text("Weather at your fingertips")
                    .font(.subheadline)
                    .foregroundColor(theme.secondaryFontColor)
                    .opacity(opacity)
                
                // Loading Indicator
                ProgressView()
                    .tint(theme.accentColor)
                    .scaleEffect(0.8)
                    .opacity(opacity)
                    .padding(.top, 20)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8)) {
                scale = 1.0
                opacity = 1.0
            }
        }
        .preferredColorScheme(theme == .morning ? .light : .dark)
    }
}
