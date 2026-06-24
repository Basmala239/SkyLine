//
//  LocationManager.swift
//  Skyline
//
//  Created by بسمله ابوزيد احمد on 24/06/2026.
//

import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    @Published var currentLocation: CLLocation?
    @Published var currentCityName: String = "Loading..."
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 100
    }
    
    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startUpdatingLocation() {
        print("📍 startUpdatingLocation called")
        
        guard CLLocationManager.locationServicesEnabled() else {
            DispatchQueue.main.async {
                self.isLoading = false
                self.errorMessage = "Location services are disabled"
                self.currentCityName = "Location Unavailable"
            }
            return
        }
        
        switch authorizationStatus {
        case .notDetermined:
            requestLocationPermission()
        case .restricted, .denied:
            DispatchQueue.main.async {
                self.isLoading = false
                self.errorMessage = "Location access denied. Please enable in Settings."
                self.currentCityName = "Location Denied"
            }
        case .authorizedWhenInUse, .authorizedAlways:
            DispatchQueue.main.async {
                self.isLoading = true
                print("📍 Starting location updates...")
            }
            locationManager.startUpdatingLocation()
        @unknown default:
            break
        }
    }
    
    func getLocationName(from location: CLLocation) {
        print("📍 Getting location name from coordinates...")
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    print("❌ Geocoding error: \(error.localizedDescription)")
                    self?.errorMessage = "Failed to get location name: \(error.localizedDescription)"
                    self?.currentCityName = "Unknown Location"
                    return
                }
                
                guard let placemark = placemarks?.first else {
                    print("❌ No placemark found")
                    self?.currentCityName = "Unknown Location"
                    return
                }
                
                var cityName = "Current Location"
                if let city = placemark.locality {
                    cityName = city
                } else if let locality = placemark.administrativeArea {
                    cityName = locality
                } else if let country = placemark.country {
                    cityName = country
                }
                
                print("✅ Geocoding success: \(cityName)")
                self?.currentCityName = cityName
                self?.currentLocation = location
            }
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            print("📍 Location authorized, starting updates...")
            isLoading = true
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            print("❌ Location denied")
            DispatchQueue.main.async {
                self.isLoading = false
                self.errorMessage = "Location access denied. Please enable in Settings."
                self.currentCityName = "Location Denied"
            }
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        print("📍 Received location: \(location.coordinate.latitude), \(location.coordinate.longitude)")
        locationManager.stopUpdatingLocation()
        getLocationName(from: location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("❌ Location error: \(error.localizedDescription)")
        DispatchQueue.main.async {
            self.isLoading = false
            self.errorMessage = "Location error: \(error.localizedDescription)"
            self.currentCityName = "Location Error"
        }
    }
}
