//
//  ExchangeDetail.swift
//  MB-Desafio
//
//  Created by Bruno Vinicius on 11/12/25.
//

struct ExchangeDetail: Identifiable {
    let id: Int
    let name: String
    let logoURL: String
    let description: String
    let website: String
    let launchedAt: String
    let makerFee: Double?
    let takerFee: Double?
}

struct Coin: Identifiable {
    var id: String { pairName }
    let symbol: String
    let pairName: String
    let price: Double
}
