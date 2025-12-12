//
//  FavoritesRepository.swift
//  MB-Desafio
//
//  Created by Bruno Vinicius on 11/12/25.
//

import Foundation

protocol FavoritesRepositoryProtocol {
    func getFavorites() -> Set<Int>
    func toggleFavorite(id: Int)
    func isFavorite(id: Int) -> Bool
}

final class FavoritesRepository: FavoritesRepositoryProtocol {
    
    private let key = "favorite_ids"
    private let defaults = UserDefaults.standard
    
    func getFavorites() -> Set<Int> {
        let array = defaults.array(forKey: key) as? [Int] ?? []
        return Set(array)
    }
    
    func toggleFavorite(id: Int) {
        var favorites = getFavorites()
        if favorites.contains(id) {
            favorites.remove(id)
        } else {
            favorites.insert(id)
        }
        defaults.set(Array(favorites), forKey: key)
    }
    
    func isFavorite(id: Int) -> Bool {
        return getFavorites().contains(id)
    }
}
