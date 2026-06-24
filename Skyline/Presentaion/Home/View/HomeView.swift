//
//  HomeView.swift
//  Skyline
//
//  Created by بسمله ابوزيد احمد on 22/06/2026.
//

import SwiftUI

struct HomeView: View {
    @State var selection = 0
    @State private var theme = AppTheme.current
    
    var body: some View {
        TabView(selection: $selection) {
            NavigationView {
                DetailsView()
            }
            .tabItem {
                Label("Home", systemImage: "house")
            }
            .tag(0)
            
            
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
        }
        .onChange(of: theme) { _ in
            // Theme changes are handled globally in the app
        }
        .preferredColorScheme(theme == .morning ? .light : .dark)
    }
}
