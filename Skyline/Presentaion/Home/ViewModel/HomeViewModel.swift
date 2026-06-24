//
//  HomeViewModel.swift
//  Skyline
//
//  Created by بسمله ابوزيد احمد on 24/06/2026.
//

import SwiftUI
import Combine

class HomeViewModel: ObservableObject {
    @Published var currentLocationName: String = "Loading..."
    @Published var isLoadingLocation: Bool = false
    @Published var locationError: String?
    
    private let locationManager = LocationManager()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // Bind to location manager changes
        locationManager.$currentCityName
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newName in
                print("📍 HomeViewModel received location: \(newName)")
                self?.currentLocationName = newName
            }
            .store(in: &cancellables)
        
        locationManager.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                print("🔄 HomeViewModel isLoading: \(isLoading)")
                self?.isLoadingLocation = isLoading
            }
            .store(in: &cancellables)
        
        locationManager.$errorMessage
            .receive(on: DispatchQueue.main)
            .assign(to: \.locationError, on: self)
            .store(in: &cancellables)
    }
    
    func startLocationUpdates() {
        locationManager.requestLocationPermission()
        locationManager.startUpdatingLocation()
    }
}
