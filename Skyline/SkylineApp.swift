//
//  SkylineApp.swift
//  Skyline
//
//  Created by بسمله ابوزيد احمد on 18/06/2026.
//

import SwiftUI

@main
struct SkylineApp: App {
    let managedObjectContext = FavoriteCoreDataManager.shared.viewContext
    @State private var showSplash = true
    @State private var theme = AppTheme.current
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if showSplash {
                    SplashView(theme: theme)
                        .transition(.opacity)
                } else {
                    HomeView()
                        .environment(\.managedObjectContext, managedObjectContext)
                        .preferredColorScheme(theme == .morning ? .light : .dark)
                        .onAppear {
                            // Apply theme to UIKit components
                            configureAppearance()
                        }
                }
            }
            .onAppear {
                // Update theme when app appears
                theme = AppTheme.current
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    withAnimation(.easeInOut(duration: 0.4)) {
                        self.showSplash = false
                    }
                }
            }
            .onChange(of: theme) { _ in
                // Update appearance when theme changes
                configureAppearance()
            }
        }
    }
    
    // MARK: - Configure Global Appearance
    private func configureAppearance() {
        configureTabBar()
        configureNavigationBar()
        configureUIViews()
    }
    
    private func configureTabBar() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        // Set background color
        appearance.backgroundColor = UIColor(theme.tabBarBackgroundColor)
        
        // Set shadow/separator color
        appearance.shadowColor = UIColor(theme.dividerColor)
        
        // Configure normal state
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(theme.secondaryFontColor)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(theme.secondaryFontColor),
            .font: UIFont.systemFont(ofSize: 10, weight: .medium)
        ]
        
        // Configure selected state
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(theme.accentColor)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(theme.accentColor),
            .font: UIFont.systemFont(ofSize: 10, weight: .semibold)
        ]
        
        // Apply appearance
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        
        // Set tint colors
        UITabBar.appearance().tintColor = UIColor(theme.accentColor)
        UITabBar.appearance().unselectedItemTintColor = UIColor(theme.secondaryFontColor)
        UITabBar.appearance().barTintColor = UIColor(theme.tabBarBackgroundColor)
    }
    
    private func configureNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        // Set background color
        appearance.backgroundColor = UIColor(theme.navigationBarBackgroundColor)
        
        // Set shadow/separator color
        appearance.shadowColor = UIColor(theme.dividerColor)
        
        // Configure large title
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor(theme.fontColor),
            .font: UIFont.systemFont(ofSize: 34, weight: .bold)
        ]
        
        // Configure standard title
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor(theme.fontColor),
            .font: UIFont.systemFont(ofSize: 17, weight: .semibold)
        ]
        
        // Configure bar button items
        let buttonAppearance = UIBarButtonItemAppearance()
        buttonAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(theme.accentColor)
        ]
        buttonAppearance.highlighted.titleTextAttributes = [
            .foregroundColor: UIColor(theme.accentColor)
        ]
        buttonAppearance.disabled.titleTextAttributes = [
            .foregroundColor: UIColor(theme.secondaryFontColor)
        ]
        appearance.buttonAppearance = buttonAppearance
        
        // Configure back button
        let backButtonAppearance = UIBarButtonItemAppearance()
        backButtonAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(theme.accentColor)
        ]
        appearance.backButtonAppearance = backButtonAppearance
        
        // Apply appearance
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        
        // Set tint color for bar buttons
        UINavigationBar.appearance().tintColor = UIColor(theme.accentColor)
        UINavigationBar.appearance().barTintColor = UIColor(theme.navigationBarBackgroundColor)
        UINavigationBar.appearance().isTranslucent = false
    }
    
    private func configureUIViews() {
        // Configure UITableView (for lists and favorites)
        let tableViewAppearance = UITableView.appearance()
        tableViewAppearance.backgroundColor = UIColor(theme.backgroundColor)
        tableViewAppearance.separatorColor = UIColor(theme.dividerColor)
        
        // Configure UICollectionView (if used)
        let collectionViewAppearance = UICollectionView.appearance()
        collectionViewAppearance.backgroundColor = UIColor(theme.backgroundColor)
        
        // Configure UIScrollView (for all scroll views)
        let scrollViewAppearance = UIScrollView.appearance()
        scrollViewAppearance.backgroundColor = UIColor(theme.backgroundColor)
    }
}

