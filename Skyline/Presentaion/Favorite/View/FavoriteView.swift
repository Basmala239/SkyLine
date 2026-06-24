//
//  FavoriteView.swift
//  Skyline
//
//  Created by بسمله ابوزيد احمد on 23/06/2026.
//

import SwiftUI

struct FavoriteView: View {
    @StateObject private var viewModel = FavoriteViewModel()
    private var currentTheme: AppTheme { AppTheme.current }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if viewModel.isEmpty {
                    EmptyStateView(
                        iconName: "heart",
                        title: "No Favorite Location",
                        description: "Let's add a location to your favorites",
                        theme: currentTheme
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    FavoriteList(viewModel: viewModel, theme: currentTheme)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(currentTheme.backgroundColor.ignoresSafeArea())
            .navigationTitle("Favorites")
            .navigationBarTitleDisplayMode(.large)
        }
        .onAppear {
            viewModel.fetchFavorites()
        }
        .alert(
            "No Internet Connection",
            isPresented: $viewModel.showNoInternetAlert
        ) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Please check your internet connection and try again.")
        }
    }
}

struct FavoriteList: View {
    @ObservedObject var viewModel: FavoriteViewModel
    var theme: AppTheme

    @State private var indexToDelete: IndexSet?
    @State private var showDeleteAlert = false

    @State private var selectedCity: String?
    @State private var navigateToDetails = false

    var body: some View {
        ZStack {
            List {
                if let city = selectedCity {
                    NavigationLink(
                        destination: DetailsView(cityName: city, showAddToFavoriteBtn: true),
                        isActive: $navigateToDetails
                    ) {
                        EmptyView()
                    }
                    .frame(width: 0, height: 0)
                    .hidden()
                }

                ForEach(viewModel.favoriteList, id: \.objectID) { item in
                    Button {
                        guard let city = item.name else { return }

                        if viewModel.canNavigate() {
                            selectedCity = city
                            navigateToDetails = true
                        }
                    } label: {
                        FavoriteItem(item: item, theme: theme)
                    }
                    .buttonStyle(.plain)
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .listRowInsets(
                        EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16)
                    )
                }
                .onDelete { indexSet in
                    indexToDelete = indexSet
                    showDeleteAlert = true
                }
            }
            .listStyle(.plain)
            .background(theme.backgroundColor.edgesIgnoringSafeArea(.bottom))
            
            if showDeleteAlert {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        showDeleteAlert = false
                        indexToDelete = nil
                    }
                
                VStack(spacing: 20) {
                    VStack(spacing: 8) {
                        Text("Are you sure?")
                            .font(.headline)
                            .foregroundColor(theme.fontColor)
                        
                        Text("This action cannot be undone.")
                            .font(.subheadline)
                            .foregroundColor(theme.secondaryFontColor)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 20)
                    .padding(.horizontal, 20)
                    
                    Divider()
                        .background(theme.dividerColor)
                    
                    HStack(spacing: 0) {
                        Button {
                            showDeleteAlert = false
                            indexToDelete = nil
                        } label: {
                            Text("Cancel")
                                .frame(maxWidth: .infinity)
                                .font(.body)
                                .foregroundColor(.blue)
                        }
                        
                        Divider()
                            .frame(height: 44)
                            .background(theme.dividerColor)
                        
                        Button {
                            if let indices = indexToDelete {
                                viewModel.deleteItems(at: indices)
                            }
                            showDeleteAlert = false
                        } label: {
                            Text("Delete")
                                .frame(maxWidth: .infinity)
                                .font(.body)
                        }
                    }
                    .frame(height: 44)
                }
                .frame(width: 270)
                .background(theme.cardBackgroundColor)
                .cornerRadius(14)
                .shadow(radius: 10)
                .transition(.opacity.combined(with: .scale(scale: 0.9)))
                .animation(.easeOut(duration: 0.15), value: showDeleteAlert)
            }
        }
    }
}

struct FavoriteItem: View {
    var item: FavoriteLocation
    var theme: AppTheme

    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 4) {

                Text(item.name ?? "Unknown Location")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(theme.fontColor)

                Text("Updated: \(item.lastUpdate ?? "--:--")")
                    .font(.caption)
                    .foregroundColor(theme.secondaryFontColor)
            }

            Spacer()

            HStack(spacing: 12) {

                Text(item.temp ?? "--°C")
                    .font(.system(size: 32, weight: .light))
                    .foregroundColor(theme.fontColor)

                if let iconString = item.icon,
                   let url = URL(string: iconString) {

                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)

                    } placeholder: {
                        ProgressView()
                            .tint(theme.accentColor)
                    }
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(theme.cardBackgroundColor)
        )
        .shadow(
            color: theme.shadowColor,
            radius: 4,
            x: 0,
            y: 2
        )
    }
}

