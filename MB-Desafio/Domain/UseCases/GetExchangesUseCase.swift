//
//  GetExchangesUseCase.swift
//  MB-Desafio
//
//  Created by Bruno Vinicius on 10/12/25.
//

import Foundation

protocol GetExchangesUseCaseProtocol {
    func execute() async throws -> [Exchange]
}

final class GetExchangesUseCase: GetExchangesUseCaseProtocol {
    
    private let repository: ExchangeRepositoryProtocol
    
    init(repository: ExchangeRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() async throws -> [Exchange] {
        return try await repository.getExchanges()
    }
}
