//
//  CoinMarketCapEndpoint.swift
//  MB-Desafio
//
//  Created by Bruno Vinicius on 10/12/25.
//

import Foundation

enum CoinMarketCapEndpoint: Endpoint {
    case listExchanges
    case exchangeDetails(id: Int)
    case exchangeMarketPairs(id: Int)
    
    var path: String {
        switch self {
        case .listExchanges: 
            return "/v1/exchange/map"
        case .exchangeDetails: 
            return "/v1/exchange/info"
        case .exchangeMarketPairs: 
            return "/v1/exchange/market-pairs/latest"
        }
    }
    
    var method: HTTPMethod { .get }
    
    var header: [String : String]? {
        ["X-CMC_PRO_API_KEY": Secrets.coinMarketCapKey]
    }
    
    var body: [String : String]? {
        return nil
    }
    
    var queryParams: [String : String]? {
        switch self {
        case .listExchanges:
            return ["listing_status": "active",
                    "sort": "volume_24h",
                    "limit": "50"]
        case .exchangeDetails(let id):
            return ["id": String(id)]
        case .exchangeMarketPairs(let id):
            return ["id": String(id),
                    "limit": "20"] // Top 20 moedas
        }
    }
}
