//
//  ExchangeRepository.swift
//  MB-Desafio
//
//  Created by Bruno Vinicius on 10/12/25.
//

import Foundation

final class ExchangeRepository: ExchangeRepositoryProtocol {
    
    private let networkService: NetworkService
    
    init(networkService: NetworkService = NetworkManager.shared) {
        self.networkService = networkService
    }
    
    func getExchanges() async throws -> [Exchange] {
        let endpoint = CoinMarketCapEndpoint.listExchanges
        let responseDTO = try await networkService.request(endpoint: endpoint, responseModel: ExchangeListResponseDTO.self)
        
        return responseDTO.data.map { $0.toDomain() }
    }
    
    func getExchangeDetails(id: Int) async throws -> ExchangeDetail {
        let endpoint = CoinMarketCapEndpoint.exchangeDetails(id: id)
        let response = try await networkService.request(endpoint: endpoint, responseModel: ExchangeInfoResponseDTO.self)
        
        guard let detailDTO = response.data[String(id)] else {
            throw NetworkError.decode
        }
        return detailDTO.toDomain()
    }
        
    func getExchangeCoins(id: Int) async throws -> [Coin] {
        let endpoint = CoinMarketCapEndpoint.exchangeMarketPairs(id: id)
        let response = try await networkService.request(endpoint: endpoint, responseModel: MarketPairsResponseDTO.self)
        return response.data.marketPairs.map { $0.toDomain() }
    }
}
