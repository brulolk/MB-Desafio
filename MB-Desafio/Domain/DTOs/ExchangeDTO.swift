//
//  ExchangeDTO.swift
//  MB-Desafio
//
//  Created by Bruno Vinicius on 10/12/25.
//

import Foundation

struct ExchangeListResponseDTO: Decodable {
    let data: [ExchangeDTO]
}

struct ExchangeDTO: Decodable {
    let id: Int
    let name: String
    let slug: String
    let isActive: Int
    let firstHistoricalData: String?
    
    func toDomain() -> Exchange {
        let dateDisplay = firstHistoricalData != nil ? String(firstHistoricalData!.prefix(10)) : nil
        
        return Exchange(
            id: id,
            name: name,
            slug: slug,
            isActive: isActive == 1,
            volume: nil, // Volume será nil devido limitação da API no free
            dateLaunched: dateDisplay
        )
    }
}
