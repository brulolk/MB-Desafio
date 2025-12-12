//
//  ExchangeDetailViewModel.swift
//  MB-Desafio
//
//  Created by Bruno Vinicius on 11/12/25.
//

import Foundation

enum DetailViewState {
    case loading
    case success
    case error(String)
}

@MainActor
final class ExchangeDetailViewModel {
    private let useCase: GetExchangeDetailsUseCaseProtocol
    private let exchangeId: Int
    
    var detail: ExchangeDetail?
    var coins: [Coin] = []
    
    var onStateChanged: ((DetailViewState) -> Void)?
    
    init(exchangeId: Int, useCase: GetExchangeDetailsUseCaseProtocol) {
        self.exchangeId = exchangeId
        self.useCase = useCase
    }
    
    func fetch() {
        onStateChanged?(.loading)
        Task {
            do {
                let (detail, coins) = try await useCase.execute(id: exchangeId)
                self.detail = detail
                self.coins = coins
                self.onStateChanged?(.success)
            } catch {
                self.onStateChanged?(.error(error.localizedDescription))
            }
        }
    }
}
