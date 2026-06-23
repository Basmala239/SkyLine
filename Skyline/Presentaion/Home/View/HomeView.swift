//
//  HomeView.swift
//  Skyline
//
//  Created by بسمله ابوزيد احمد on 22/06/2026.
//
import Foundation
import SwiftUI

struct HomeView: View {
//    @StateObject private var viewModel = HomeViewModel()
   @State var selection = 0
    var body: some View {
        TabView {
            NavigationView {
                DetailsView()
            }
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            SearchView()
                .tabItem {
                    Label("Search", systemImage: "setting")
                }
        }
        
    }
}
