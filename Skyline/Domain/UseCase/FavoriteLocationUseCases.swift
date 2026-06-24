//
//  FavoriteLocationUseCases.swift
//  Skyline
//
//  Created by بسمله ابوزيد احمد on 23/06/2026.
//

import Foundation

// MARK: - Save Favorite Use Case
class SaveFavoriteUseCase: SaveFavoriteUseCaseProtocol {
    private let manager: FavoriteCoreDataManager
    
    init(manager: FavoriteCoreDataManager = .shared) {
        self.manager = manager
    }
    
    func execute(name: String, temp: String, icon: String, lastUpdated: String) {
        manager.saveOrUpdateFavorite(name: name, temp: temp, icon: icon, lastUpdated: lastUpdated)
    }
}

// MARK: - Fetch Favorites Use Case
class FetchFavoritesUseCase: FetchFavoritesUseCaseProtocol {
    private let manager: FavoriteCoreDataManager
    
    init(manager: FavoriteCoreDataManager = .shared) {
        self.manager = manager
    }
    
    func execute() -> [FavoriteLocation] {
        return manager.fetchAllFavorites()
    }
}

// MARK: - Delete Favorite Use Case
class DeleteFavoriteUseCase: DeleteFavoriteUseCaseProtocol {
    private let manager: FavoriteCoreDataManager
    
    init(manager: FavoriteCoreDataManager = .shared) {
        self.manager = manager
    }
    
    func execute(name: String) {
        manager.deleteFavorite(name: name)
    }
}

// MARK: - Check Favorite Use Case
class CheckFavoriteUseCase: CheckFavoriteUseCaseProtocol {
    private let manager: FavoriteCoreDataManager
    
    init(manager: FavoriteCoreDataManager = .shared) {
        self.manager = manager
    }
    
    func execute(name: String) -> Bool {
        return manager.isFavorite(name: name)
    }
}
