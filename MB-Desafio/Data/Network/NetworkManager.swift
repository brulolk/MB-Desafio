//
//  NetworkManager.swift
//  MB-Desafio
//
//  Created by Bruno Vinicius on 10/12/25.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case decode
    case unauthorized
    case unexpectedStatusCode(Int)
    case unknown
    case noResponse
}

protocol NetworkService {
    func request<T: Decodable>(endpoint: Endpoint, responseModel: T.Type) async throws -> T
}

final class NetworkManager: NetworkService {
    
    static let shared = NetworkManager()
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func request<T: Decodable>(endpoint: Endpoint, responseModel: T.Type) async throws -> T {
        guard let url = endpoint.urlComponents.url else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.header
        
        // Headers padrão (JSON)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let response = response as? HTTPURLResponse else {
                throw NetworkError.noResponse
            }
            
            switch response.statusCode {
            case 200...299:
                let decoder = JSONDecoder()
                // A CoinMarketCap usa snake_case (ex: date_launched)
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                return try decoder.decode(responseModel, from: data)
            case 401:
                throw NetworkError.unauthorized
            default:
                throw NetworkError.unexpectedStatusCode(response.statusCode)
            }
        } catch let error as DecodingError {
            print("❌ Erro de Decode: \(error)")
            throw NetworkError.decode
        } catch {
            throw error
        }
    }
}
