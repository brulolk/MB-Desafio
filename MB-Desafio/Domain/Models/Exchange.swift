//
//  Exchange.swift
//  MB-Desafio
//
//  Created by Bruno Vinicius on 10/12/25.
//

import Foundation

struct Exchange: Identifiable {
    let id: Int
    let name: String
    let slug: String
    let isActive: Bool
    let volume: Double?
    let dateLaunched: String?
}
