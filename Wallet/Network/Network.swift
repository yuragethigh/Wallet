//
//  Network.swift
//  Wallet
//
//  Created by Yuriy on 09.06.2025.
//

import Foundation

protocol Network {
    func fetch<T: Decodable>(
        from request: URLRequest,
        for type: T.Type,
        _ completion: @escaping (Result<T, NetworkError>) -> Void
    )
}


final class NetworkLayer: Network {
    
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(
        session: URLSession = .shared,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.session = session
        self.decoder = decoder
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    deinit {
        print("Deinit - \(self)")
    }
    
    func fetch<T: Decodable>(
        from request: URLRequest,
        for type: T.Type,
        _ completion: @escaping (Result<T, NetworkError>) -> Void
    ) {

        session.dataTask(with: request) { data, response, error in
            if let error = error {
                return completion(.failure(.url(error)))
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                return completion(.failure(.invalidResponse))
            }
            
            guard 200..<300 ~= httpResponse.statusCode else {
                return completion(.failure(.httpStatus(code: httpResponse.statusCode)))
            }
            
            guard let data = data else {
                return completion(.failure(.noData))
            }
            
            do {
                let decoded = try self.decoder.decode(T.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(.decoding(error)))
            }
        }
        .resume()
    }
}

// MARK: - Errors

enum NetworkError: Error {
    case url(Error)
    case invalidResponse
    case httpStatus(code: Int)
    case noData
    case decoding(Error)
    
    var errorDescription: String? {
        switch self {
        case .url(let err): return err.localizedDescription
        case .invalidResponse: return "Invalid response from server."
        case .httpStatus(let code): return "HTTP error with status code \(code)."
        case .noData: return "Server returned empty data."
        case .decoding(let err): return "Failed to decode: \(err.localizedDescription)"
        }
    }
}
