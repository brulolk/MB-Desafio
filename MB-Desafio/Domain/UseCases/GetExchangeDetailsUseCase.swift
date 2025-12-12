//
//  GetExchangeDetailsUseCase.swift
//  MB-Desafio
//
//  Created by Bruno Vinicius on 11/12/25.
//

protocol GetExchangeDetailsUseCaseProtocol {
    func execute(id: Int) async throws -> (ExchangeDetail, [Coin])
}

final class GetExchangeDetailsUseCase: GetExchangeDetailsUseCaseProtocol {
    private let repository: ExchangeRepositoryProtocol
    
    // MARK: - Mock Data (Como minha key é free não consigo receber esses dados)
    private var mockCoins: [Coin] {
        return [
            Coin(symbol: "BTC", pairName: "BTC/USDT", price: 98500.42),
            Coin(symbol: "ETH", pairName: "ETH/USDT", price: 2750.15),
            Coin(symbol: "SOL", pairName: "SOL/USDT", price: 145.80),
            Coin(symbol: "BNB", pairName: "BNB/USDT", price: 620.33),
            Coin(symbol: "XRP", pairName: "XRP/USDT", price: 0.65),
            Coin(symbol: "ADA", pairName: "ADA/USDT", price: 0.45),
            Coin(symbol: "DOGE", pairName: "DOGE/USDT", price: 0.12)
        ]
    }
    
    init(repository: ExchangeRepositoryProtocol) { self.repository = repository }
    
    func execute(id: Int) async throws -> (ExchangeDetail, [Coin]) {
        async let details = repository.getExchangeDetails(id: id)
        async let coins = fetchCoinsSafe(id: id)
        
        return try await (details, coins)
    }
    
    private func fetchCoinsSafe(id: Int) async -> [Coin] {
        do {
            return try await repository.getExchangeCoins(id: id)
        } catch {
            print("⚠️ API Limit: Falha ao buscar moedas (Erro \(error)). Retornando lista mock.")
            return mockCoins
        }
    }
}
