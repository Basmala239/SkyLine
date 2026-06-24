//
//  FavoriteLocationUseCasesProtocols.swift
//  Skyline
//
//  Created by بسمله ابوزيد احمد on 23/06/2026.
//

import Foundation

protocol SaveFavoriteUseCaseProtocol {
    func execute(name: String, temp: String, icon: String, lastUpdated: String)
}

protocol FetchFavoritesUseCaseProtocol {
    func execute() -> [FavoriteLocation]
}

protocol DeleteFavoriteUseCaseProtocol {
    func execute(name: String)
}

protocol CheckFavoriteUseCaseProtocol {
    func execute(name: String) -> Bool
}
