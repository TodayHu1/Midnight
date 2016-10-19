//
//  Chain.swift
//  MatchRPG
//
//  Created by David Garrett on 8/1/16.
//  Copyright © 2016 David Garrett. All rights reserved.
//

class Chain: Hashable, CustomStringConvertible {
    var tokens = [Token]()
    var score = 0
    
    enum ChainType: CustomStringConvertible {
        case horizontal
        case vertical
        case specialL
        case specialT
        
        var description: String {
            switch self {
            case .horizontal: return "Horizontal"
            case .vertical: return "Vertical"
            case .specialL: return "SpecialL"
            case .specialT: return "SpecialT"
            }
        }
        
        var typeMultiplier: Int {
            switch self {
            case .horizontal: return 1
            case .vertical: return 1
            case .specialL: return 2
            case .specialT: return 2
            }
        }
    }
    
    var chainType: ChainType
    
    init(chainType: ChainType) {
        self.chainType = chainType
    }
    
    func addToken(_ token: Token) {
        tokens.append(token)
    }
    
    func firstToken() -> Token {
        return tokens[0]
    }
    
    func lastToken() -> Token {
        return tokens[tokens.count - 1]
    }
    
    var length: Int {
        return tokens.count
    }
    
    var description: String {
        return "type:\(chainType) tokens:\(tokens)"
    }
    
    var hashValue: Int {
        return tokens.reduce (0) { $0.hashValue ^ $1.hashValue }
    }
}

func ==(lhs: Chain, rhs: Chain) -> Bool {
    return lhs.tokens == rhs.tokens
}

