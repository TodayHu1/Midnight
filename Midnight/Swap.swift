//
//  Swap.swift
//  MatchRPG
//
//  Created by David Garrett on 8/1/16.
//  Copyright © 2016 David Garrett. All rights reserved.
//

struct Swap: CustomStringConvertible, Hashable {
    let tokenA: Token
    let tokenB: Token
    
    init(tokenA: Token, tokenB: Token) {
        self.tokenA = tokenA
        self.tokenB = tokenB
    }
    
    var description: String {
        return "swap \(tokenA) with \(tokenB)"
    }
    
    var hashValue: Int {
        return tokenA.hashValue ^ tokenB.hashValue
    }
}

func ==(lhs: Swap, rhs: Swap) -> Bool {
    return (lhs.tokenA == rhs.tokenA && lhs.tokenB == rhs.tokenB) || (lhs.tokenB == rhs.tokenA && lhs.tokenA == rhs.tokenB)
}

