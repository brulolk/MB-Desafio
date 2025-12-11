//
//  CoinMarketCapEndpoint.swift
//  MB-Desafio
//
//  Created by Bruno Vinicius on 10/12/25.
//

import Foundation

enum CoinMarketCapEndpoint: Endpoint {
    case listExchanges
    case exchangeDetails(id: String)
    
    var path: String {
        switch self {
        case .listExchanges:
            return "/v1/exchange/map" // Endpoint leve para listagem
        case .exchangeDetails:
            return "/v1/exchange/info" // Detalhes completos
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var header: [String : String]? {
        // Injeta a chave de segurança do Secrets.swift
        return ["X-CMC_PRO_API_KEY": Secrets.coinMarketCapKey]
    }
    
    var body: [String : String]? {
        return nil
    }
    
    var queryParams: [String : String]? {
        switch self {
        case .listExchanges:
            return [
                "listing_status": "active",
                "sort": "volume_24h", // Requisito: trazer relevantes primeiro
                "limit": "50" // Vamos limitar para não estourar a cota grátis
            ]
        case .exchangeDetails(let id):
            return ["id": id]
        }
    }
}
