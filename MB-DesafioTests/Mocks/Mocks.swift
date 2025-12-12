//
//  Mocks.swift
//  MB-Desafio
//
//  Created by Bruno Vinicius on 12/12/25.
//

import Foundation
@testable import MB_Desafio

// MARK: - Mock Exchange Repository
final class MockExchangeRepository: ExchangeRepositoryProtocol {
    
    var shouldReturnError = false
    
    // Dados falsos para teste
    var mockExchanges: [Exchange] = [
        Exchange(id: 1, name: "Binance", slug: "binance", isActive: true, volume: 50000, dateLaunched: "2017-01-01"),
        Exchange(id: 2, name: "Coinbase", slug: "coinbase", isActive: true, volume: 30000, dateLaunched: "2012-05-01"),
        Exchange(id: 3, name: "Kraken", slug: "kraken", isActive: true, volume: 10000, dateLaunched: "2011-07-01")
    ]
    
    func getExchanges() async throws -> [Exchange] {
        if shouldReturnError {
            throw NetworkError.unexpectedStatusCode(500)
        }
        return mockExchanges
    }
    
    func getExchangeDetails(id: Int) async throws -> ExchangeDetail {
        fatalError("Não implementado para este teste")
    }
    
    func getExchangeCoins(id: Int) async throws -> [Coin] {
        return []
    }
}

// MARK: - Mock Favorites Repository
final class MockFavoritesRepository: FavoritesRepositoryProtocol {
    
    var favorites: Set<Int> = []
    
    func getFavorites() -> Set<Int> {
        return favorites
    }
    
    func toggleFavorite(id: Int) {
        if favorites.contains(id) {
            favorites.remove(id)
        } else {
            favorites.insert(id)
        }
    }
    
    func isFavorite(id: Int) -> Bool {
        return favorites.contains(id)
    }
}

final class MockGetExchangeDetailsUseCase: GetExchangeDetailsUseCaseProtocol {
    
    var shouldReturnError = false
    
    let mockDetail = ExchangeDetail(
        id: 1,
        name: "Binance",
        logoURL: "http://logo.png",
        description: "A maior exchange.",
        website: "http://binance.com",
        launchedAt: "2017-07-14",
        makerFee: 0.1,
        takerFee: 0.1
    )
    
    let mockCoins = [
        Coin(symbol: "BTC", pairName: "BTC/USDT", price: 90000.0)
    ]
    
    func execute(id: Int) async throws -> (ExchangeDetail, [Coin]) {
        if shouldReturnError {
            throw NetworkError.unexpectedStatusCode(500)
        }
        return (mockDetail, mockCoins)
    }
}
