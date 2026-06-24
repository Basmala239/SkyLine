//
//  FavoriteViewModel.swift
//  Skyline
//
//  Created by بسمله ابوزيد احمد on 23/06/2026.
//

import Foundation
import Combine

class FavoriteViewModel: ObservableObject {
    
    @Published var favoriteList: [FavoriteLocation] = []
    @Published var isEmpty = true
    @Published var showNoInternetAlert = false
    
    private let fetchFavoritesUseCase: FetchFavoritesUseCaseProtocol
    private let deleteFavoriteUseCase: DeleteFavoriteUseCaseProtocol
    
    init(
        fetchFavoritesUseCase: FetchFavoritesUseCaseProtocol = FetchFavoritesUseCase(),
        deleteFavoriteUseCase: DeleteFavoriteUseCaseProtocol = DeleteFavoriteUseCase()
    ) {
        self.fetchFavoritesUseCase = fetchFavoritesUseCase
        self.deleteFavoriteUseCase = deleteFavoriteUseCase
    }
    
    func fetchFavorites() {
        let savedLocations = fetchFavoritesUseCase.execute()
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.favoriteList = savedLocations
            self.isEmpty = savedLocations.isEmpty
        }
    }
    
    func deleteItems(at offsets: IndexSet) {
        let itemsToDelete = offsets.map { favoriteList[$0] }
        
        self.favoriteList.remove(atOffsets: offsets)
        self.isEmpty = self.favoriteList.isEmpty
        
        itemsToDelete.forEach { location in
            if let cityName = location.name {
                deleteFavoriteUseCase.execute(name: cityName)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.fetchFavorites()
        }
    }
    
    func canNavigate() -> Bool {
        if !NetworkService.shared.isInternetConnected() {
            showNoInternetAlert = true
            return false
        }

        return true
    }
}
