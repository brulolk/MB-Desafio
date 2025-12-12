//
//  ExchangeListViewModel.swift
//  MB-Desafio
//
//  Created by Bruno Vinicius on 11/12/25.
//

import Foundation

// MARK: - Enums de Estado
enum ExchangeListViewState {
    case idle
    case loading
    case success
    case error(String)
    case empty
}

enum ListFilterType: Int {
    case all = 0
    case favorites = 1
}

protocol ExchangeListViewModelProtocol {
    var state: ExchangeListViewState { get }
    var displayedExchanges: [Exchange] { get } // Lista filtrada para a View
    var onStateChanged: ((ExchangeListViewState) -> Void)? { get set }
    
    func fetchExchanges()
    func toggleFavorite(exchangeId: Int)
    func isFavorite(exchangeId: Int) -> Bool
    func filterChanged(to type: ListFilterType)
    func search(query: String)
}

@MainActor
final class ExchangeListViewModel: ExchangeListViewModelProtocol {
    
    private let getExchangesUseCase: GetExchangesUseCaseProtocol
    private let favoritesRepository: FavoritesRepositoryProtocol
    
    private var allExchanges: [Exchange] = []
    var displayedExchanges: [Exchange] = []
    
    private var currentFilter: ListFilterType = .all
    private var currentSearchQuery: String = ""
    
    var onStateChanged: ((ExchangeListViewState) -> Void)?
    var state: ExchangeListViewState = .idle {
        didSet { onStateChanged?(state) }
    }
    
    init(getExchangesUseCase: GetExchangesUseCaseProtocol,
         favoritesRepository: FavoritesRepositoryProtocol) {
        self.getExchangesUseCase = getExchangesUseCase
        self.favoritesRepository = favoritesRepository
    }
    
    func fetchExchanges() {
        state = .loading
        Task {
            do {
                let result = try await getExchangesUseCase.execute()
                await MainActor.run {
                    self.allExchanges = result
                    self.applyFilters()
                    self.state = .success
                }
            } catch {
                await MainActor.run {
                    self.state = .error(error.localizedDescription)
                }
            }
        }
    }
    
    func toggleFavorite(exchangeId: Int) {
        favoritesRepository.toggleFavorite(id: exchangeId)
        applyFilters()
        onStateChanged?(.success)
    }
    
    func isFavorite(exchangeId: Int) -> Bool {
        return favoritesRepository.isFavorite(id: exchangeId)
    }
    
    func filterChanged(to type: ListFilterType) {
        self.currentFilter = type
        applyFilters()
        onStateChanged?(.success)
    }
    
    func search(query: String) {
        self.currentSearchQuery = query
        applyFilters()
        onStateChanged?(.success)
    }
    
    private func applyFilters() {
        var result = allExchanges
        
        // Filtro por Favoritos
        if currentFilter == .favorites {
            let favoriteIds = favoritesRepository.getFavorites()
            result = result.filter { favoriteIds.contains($0.id) }
        }
        
        // Filtro de Busca
        if !currentSearchQuery.isEmpty {
            result = result.filter { $0.name.lowercased().contains(currentSearchQuery.lowercased()) }
        }
        
        self.displayedExchanges = result
    }
}
