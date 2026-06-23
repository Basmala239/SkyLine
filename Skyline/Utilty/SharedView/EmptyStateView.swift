//
//  EmptyStateView.swift
//  Skyline
//
//  Created by بسمله ابوزيد احمد on 22/06/2026.
//

import Foundation
import SwiftUI

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .font(.largeTitle)
                .foregroundColor(.gray)

            Text("Search for a city")
                .font(.headline)
                .foregroundColor(.secondary)

            Text("Enter a city name to get the weather")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}

