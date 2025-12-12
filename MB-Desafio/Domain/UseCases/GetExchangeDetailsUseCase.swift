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
    
    init(repository: ExchangeRepositoryProtocol) { self.repository = repository }
    
    func execute(id: Int) async throws -> (ExchangeDetail, [Coin]) {
        // DECISÃO DE PERFORMANCE:
        // Usamos 'async let' para buscar detalhes e moedas simultaneamente,
        // reduzindo o tempo total de carregamento pela metade.
        async let details = repository.getExchangeDetails(id: id)
        
        // Tratamento de falha parcial: Se a lista de moedas falhar (plano Free),
        // retornamos uma lista vazia, mas ainda mostramos os detalhes da exchange.
        async let coins = fetchCoinsSafe(id: id)
        
        return try await (details, coins)
    }
    
    private func fetchCoinsSafe(id: Int) async -> [Coin] {
        do {
            return try await repository.getExchangeCoins(id: id)
        } catch {
            print("⚠️ Aviso: Falha ao buscar moedas (provável limitação de API Free): \(error)")
            return []
        }
    }
}
