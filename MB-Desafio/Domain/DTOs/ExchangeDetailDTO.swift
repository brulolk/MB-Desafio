//
//  ExchangeDetailDTO.swift
//  MB-Desafio
//
//  Created by Bruno Vinicius on 11/12/25.
//

import Foundation

struct ExchangeInfoResponseDTO: Decodable {
    let data: [String: ExchangeDetailDTO]
}

struct ExchangeDetailDTO: Decodable {
    let id: Int
    let name: String
    let logo: String
    let description: String?
    let dateLaunched: String?
    let makerFee: Double?
    let takerFee: Double?
    let urls: ExchangeUrlsDTO
    
    struct ExchangeUrlsDTO: Decodable {
        let website: [String]?
        let twitter: [String]?
    }
    
    func toDomain() -> ExchangeDetail {
        let formattedDate: String
        if let rawDate = dateLaunched {
            // A API manda algo como "2017-07-14T00:00:00.000Z"
            let isoFormatter = ISO8601DateFormatter()
            isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            if let date = isoFormatter.date(from: rawDate) {
                let displayFormatter = DateFormatter()
                displayFormatter.dateStyle = .short
                displayFormatter.locale = Locale(identifier: "pt_BR")
                formattedDate = displayFormatter.string(from: date)
            } else {
                formattedDate = String(rawDate.prefix(10))
            }
        } else {
            formattedDate = "Desconhecido"
        }
        
        return ExchangeDetail(
            id: id,
            name: name,
            logoURL: logo,
            description: description ?? "Sem descrição disponível.",
            website: urls.website?.first ?? "",
            launchedAt: formattedDate,
            makerFee: makerFee,
            takerFee: takerFee
        )
    }
}

struct MarketPairsResponseDTO: Decodable {
    let data: MarketPairsDataDTO
}

struct MarketPairsDataDTO: Decodable {
    let marketPairs: [MarketPairDTO]
}

struct MarketPairDTO: Decodable {
    let marketPair: String
    let marketPairBase: CurrencyDTO
    let quote: QuoteDTO
    
    struct CurrencyDTO: Decodable {
        let symbol: String
    }
    
    struct QuoteDTO: Decodable {
        let exchangeReported: ExchangeReportedDTO?
        
        struct ExchangeReportedDTO: Decodable {
            let price: Double?
        }
    }
    
    func toDomain() -> Coin {
        return Coin(
            symbol: marketPairBase.symbol,
            pairName: marketPair,
            price: quote.exchangeReported?.price ?? 0.0
        )
    }
}
