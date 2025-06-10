//
//  MessariDecodableDTO.swift
//  Wallet
//
//  Created by Yuriy on 10.06.2025.
//

import Foundation

struct MessariDecodableDTO: Decodable {
    let data: Data
    struct Data: Decodable {
        let id, symbol, name: String
        let marketData: MarketData
        
        struct MarketData: Decodable {
            let priceUsd: Double
            let percentChangeUsdLast1Hour: Double
            let percentChangeUsdLast24Hours: Double
        }
    }
}

extension MessariDecodableDTO {
    var toDomain: Coin {
        .init(
            id: data.id,
            name: data.name,
            symbol: data.symbol.uppercased(),
            price: data.marketData.priceUsd,
            change1h: data.marketData.percentChangeUsdLast1Hour,
            change24h: data.marketData.percentChangeUsdLast24Hours
        )
    }
}

