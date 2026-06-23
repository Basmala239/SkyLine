//
//  SearchView.swift
//  Skyline
//
//  Created by بسمله ابوزيد احمد on 23/06/2026.
//

import Foundation
import Foundation
import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                SearchBar(text: $viewModel.searchText)
                
                if viewModel.isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                        .padding()
                } else if let error = viewModel.errorMessage {
                    ErrorView(message: error) {
                    }
                } else if viewModel.searchResult != nil {
                    CityList(citys: viewModel.searchResult ?? [])
                } else {
                    EmptyStateView()
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Skyline Weather")
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search city...", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.words)
            
            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(.horizontal)
    }
}

struct CityList: View {
    var citys : [SearchResult]
    var body: some View {
        List{
            ForEach(citys, id: \.id){ city in
                NavigationLink(destination: DetailsView(cityName: city.name)){
                    CityItem(city: city)
                }
            }
        }
    }
}

struct CityItem: View {
    var city: SearchResult
    var body: some View {
        HStack{
            Text("\(city.name), \(city.country)")
            Spacer()
        }
        .frame(height: 80)
        .foregroundColor(.red)
        .padding()
    }
}
