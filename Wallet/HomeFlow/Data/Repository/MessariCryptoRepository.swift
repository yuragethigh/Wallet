//
//  MessariCryptoRepository.swift
//  Wallet
//
//  Created by Yuriy on 10.06.2025.
//

import Foundation

protocol CryptoRepository {
    func loadMetrics(
        for symbols: [String],
        completion: @escaping (Result<[Coin], NetworkError>) -> Void
    )
}


final class MessariCryptoRepository: CryptoRepository {
    
    private let network: Network
    private let baseURL = "https://data.messari.io/api/v1/assets"
    
    init(network: Network) {
        self.network = network
    }
    
    func loadMetrics(
        for symbols: [String],
        completion: @escaping (Result<[Coin], NetworkError>) -> Void
    ){
        
        let group = DispatchGroup()
        var coins = [Coin]()
        coins.reserveCapacity(symbols.count)
        var error: NetworkError?
        let lock = NSLock()
        
        for symbol in symbols {
            
            guard let url = URL(string: "\(baseURL)/\(symbol)/metrics") else {
                completion(.failure(.invalidResponse))
                return
            }
            group.enter()
            
            network.fetch(from: URLRequest(url: url), for: MessariDecodableDTO.self) { result in
                
                switch result {
                case .success(let dto):
                    lock.lock()
                    coins.append(dto.toDomain)
                    lock.unlock()
                    group.leave()
                    
                case .failure(let err):
                    error = err
                    print(err)
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main) {
            if let err = error {
                completion(.failure(err))
            } else {
                completion(.success(coins))
            }
        }
    }
}
