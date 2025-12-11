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
        
        // Mapeia a lista de DTOs para Entidades de Domínio
        return responseDTO.data.map { $0.toDomain() }
    }
}
