//
//  ErrorView.swift
//  Skyline
//
//  Created by بسمله ابوزيد احمد on 22/06/2026.
//

import Foundation
import SwiftUI

struct ErrorView: View {
    let message: String
    let retryAction: () -> Void
    @State private var theme = AppTheme.current
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 40))
                .foregroundColor(theme == .morning ? .orange : .yellow)
            
            Text("Oops! Something went wrong")
                .font(.headline)
                .foregroundColor(theme.fontColor)
            
            Text(message)
                .font(.subheadline)
                .foregroundColor(theme.secondaryFontColor)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Button(action: retryAction) {
                Text("Try Again")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 10)
                    .background(
                        Capsule()
                            .fill(theme == .morning ? Color.blue : Color.cyan)
                    )
            }
        }
        .padding().frame(width: .infinity)
        .onAppear {
            theme = AppTheme.current
        }
    }
}
