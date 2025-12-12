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
    let isActive: Int // A API retorna 1 para ativo
    
    func toDomain() -> Exchange {
        return Exchange(
            id: id,
            name: name,
            slug: slug,
            isActive: isActive == 1
        )
    }
}
