//
//  SearchView.swift
//  Skyline
//
//  Created by بسمله ابوزيد احمد on 23/06/2026.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    @State private var currentTheme = AppTheme.current
    @State private var selectedCity: SearchResult?
    @State private var navigateToDetails = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search Bar
                SearchBar(text: $viewModel.searchText, theme: currentTheme)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 4)
                
                Group {
                    if viewModel.isLoading {
                        Spacer()
                        ProgressView()
                            .scaleEffect(1.5)
                            .tint(currentTheme.fontColor)
                        Spacer()
                    } else if let error = viewModel.errorMessage {
                        Spacer()
                        ErrorView(message: error) {
                            viewModel.searchText = ""
                        }
                        .foregroundColor(currentTheme.fontColor)
                        Spacer()
                    } else if !viewModel.searchResult.isEmpty {
                        CityList(
                            citys: viewModel.searchResult,
                            theme: currentTheme,
                            selectedCity: $selectedCity,
                            navigateToDetails: $navigateToDetails
                        )
                    } else if viewModel.hasNoResults {
                        Spacer()
                        EmptyStateView(
                            iconName: "magnifyingglass",
                            title: "No Results Found",
                            description: "Try searching for another city.",
                            theme: currentTheme
                        )
                        Spacer()
                    } else {
                        Spacer()
                        EmptyStateView(
                            iconName: "location.magnifyingglass",
                            title: "Find Your City",
                            description: "Search for any city worldwide to get the current weather conditions.",
                            theme: currentTheme
                        )
                        Spacer()
                    }
                }
            }
            .background(currentTheme.backgroundColor.edgesIgnoringSafeArea(.all))
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Search Weather")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(currentTheme.fontColor)
                }
            }
            .foregroundColor(currentTheme.fontColor)
            .onAppear {
                currentTheme = AppTheme.current
            }
            // NavigationLink for selected city
            .background(
                NavigationLink(
                    destination: DetailsView(
                        cityName: selectedCity?.name ?? "",
                        showAddToFavoriteBtn: true
                    )
                    .accentColor(currentTheme.accentColor),
                    isActive: $navigateToDetails
                ) {
                    EmptyView()
                }
                .hidden()
            )
        }
        .accentColor(currentTheme.accentColor)
        .preferredColorScheme(currentTheme == .morning ? .light : .dark)
    }
}

// MARK: - Search Bar

struct SearchBar: View {
    @Binding var text: String
    let theme: AppTheme
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(theme.secondaryFontColor)
                    .font(.body)
                    .padding(.leading, 4)
                
                TextField("", text: $text)
                    .placeholder(when: text.isEmpty) {
                        Text("Search for a city...")
                            .foregroundColor(theme.secondaryFontColor)
                    }
                    .autocapitalization(.words)
                    .disableAutocorrection(true)
                    .foregroundColor(theme.fontColor)
                    .focused($isFocused)
                    .submitLabel(.search)
                    .onSubmit {
                        // Trigger search if needed
                    }
                
                if !text.isEmpty {
                    Button(action: {
                        text = ""
                        isFocused = true
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(theme.secondaryFontColor)
                    }
                    .padding(.trailing, 4)
                }
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 14)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(theme == .morning ? Color.white : Color(.secondarySystemGroupedBackground))
                    .shadow(color: theme.shadowColor, radius: 8, x: 0, y: 2)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(
                        isFocused ? theme.accentColor : theme.dividerColor,
                        lineWidth: isFocused ? 2 : 1
                    )
            )
            .animation(.easeInOut(duration: 0.2), value: isFocused)
        }
        .padding(.horizontal)
    }
}

// MARK: - Extension for Placeholder

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
        
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

// MARK: - City List

struct CityList: View {
    var citys: [SearchResult]
    let theme: AppTheme
    @Binding var selectedCity: SearchResult?
    @Binding var navigateToDetails: Bool
    
    @StateObject private var networkMonitor = NetworkMonitor()
    @State private var showNoInternetAlert = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                // Results count header
                HStack {
                    Text("\(citys.count) results found")
                        .font(.caption)
                        .foregroundColor(theme.secondaryFontColor)
                    Spacer()
                }
                .padding(.horizontal, 4)
                .padding(.bottom, 4)
                
                ForEach(citys, id: \.id) { city in
                    CityItem(
                        city: city,
                        theme: theme,
                        onTap: {
                            if networkMonitor.isConnected {
                                selectedCity = city
                                navigateToDetails = true
                            } else {
                                showNoInternetAlert = true
                            }
                        }
                    )
                }
            }
            .padding(.horizontal)
            .padding(.top, 8)
            .padding(.bottom, 16)
            .alert(isPresented: $showNoInternetAlert) {
                Alert(
                    title: Text("No Internet Connection"),
                    message: Text("Please establish an active internet connection to retrieve real-time regional weather information."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}

// MARK: - City Item

struct CityItem: View {
    var city: SearchResult
    let theme: AppTheme
    let onTap: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            isPressed = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isPressed = false
                onTap()
            }
        }) {
            HStack(spacing: 14) {
                // City icon
                ZStack {
                    Circle()
                        .fill(theme == .morning ? Color.blue.opacity(0.08) : Color.white.opacity(0.05))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: "building.2.fill")
                        .font(.system(size: 18))
                        .foregroundColor(theme.accentColor)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(city.name)
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundColor(theme.fontColor)
                    
                    Text(city.country)
                        .font(.footnote)
                        .foregroundColor(theme.secondaryFontColor)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.footnote)
                    .foregroundColor(theme == .morning ? .blue : .cyan)
                    .padding(8)
                    .background(
                        Circle()
                            .fill(theme == .morning ? Color.blue.opacity(0.1) : Color.cyan.opacity(0.1))
                    )
            }
            .padding(.all, 16)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(theme.cardBackgroundColor)
                    .shadow(color: theme.shadowColor, radius: 4, x: 0, y: 2)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(theme.dividerColor, lineWidth: 1)
            )
            .scaleEffect(isPressed ? 0.97 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

