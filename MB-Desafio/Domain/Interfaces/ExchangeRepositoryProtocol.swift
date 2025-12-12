//
//  ExchangeRepositoryProtocol.swift
//  MB-Desafio
//
//  Created by Bruno Vinicius on 10/12/25.
//

import Foundation

protocol ExchangeRepositoryProtocol {
    func getExchanges() async throws -> [Exchange]
    func getExchangeDetails(id: Int) async throws -> ExchangeDetail
    func getExchangeCoins(id: Int) async throws -> [Coin]
}
