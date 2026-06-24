//
//  HomeView.swift
//  Skyline
//
//  Created by بسمله ابوزيد احمد on 22/06/2026.
//

import SwiftUI
import CoreLocation

struct HomeView: View {
    @State var selection = 0
    @State private var theme = AppTheme.current
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        TabView(selection: $selection) {
            NavigationView {
                DetailsView(
                    cityName: viewModel.currentLocationName,
                    isLoading: viewModel.isLoadingLocation
                )
                .id(viewModel.currentLocationName + String(viewModel.isLoadingLocation)) // Force refresh
            }
            .tabItem {
                Label("Home", systemImage: "house")
            }
            .tag(0)
            .onAppear {
                print("🏠 Home tab appeared")
                viewModel.startLocationUpdates()
            }
            
            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
                .tag(1)
            
            FavoriteView()
                .tabItem {
                    Label("Favorite", systemImage: "heart")
                }
                .tag(2)
        }
        .accentColor(theme.accentColor)
        .onAppear {
            theme = AppTheme.current
            viewModel.startLocationUpdates()
        }
        .onChange(of: theme) { _ in
            // Theme changes are handled globally in the app
        }
        .preferredColorScheme(theme == .morning ? .light : .dark)
        .alert("Location Error", isPresented: .constant(viewModel.locationError != nil)) {
            Button("OK") {
                viewModel.locationError = nil
            }
        } message: {
            Text(viewModel.locationError ?? "")
        }
    }
}
