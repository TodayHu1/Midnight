//
//  Token.swift
//  MatchRPG
//
//  Created by David Garrett on 8/1/16.
//  Copyright © 2016 David Garrett. All rights reserved.
//

import SpriteKit

enum TokenType: Int, CustomStringConvertible {
    case unknown = 0, redskull, purpleskull, blueskull, greenskull, goldskull
    
    var spriteName: String {
        let spriteNames = [
            "RedSkull",
            "PurpleSkull",
            "BlueSkull",
            "GreenSkull",
            "GoldSkull"
        ]
        
        return spriteNames[rawValue - 1]
    }
    
    var highlightedSpriteName: String {
//        return spriteName + "-highlighted"
        return spriteName
    }
    
    var hiddenSpriteName: String {
        return spriteName + "=hidden"
    }
    
    static func random() -> TokenType {
        return TokenType(rawValue: Int(arc4random_uniform(5)) + 1)!
    }
    
    var description: String {
        return spriteName
    }
    
    static func createFromString(_ type: String) -> TokenType {
        var raw: Int
        switch type {
        case "RedSkull":
            raw = 1
        case "PurpleSkull":
            raw = 2
        case "BlueSkull":
            raw = 3
        case "GreenSkull":
            raw = 4
        case "GoldSkull":
            raw = 5
        default:
            raw = 0
        }
        return TokenType(rawValue: raw)!
    }
}

class Token: CustomStringConvertible, Hashable {
    var column: Int
    var row: Int
    var tokenType: TokenType
    var sprite: SKSpriteNode?
    var description: String {
        return "type:\(tokenType) square:(\(column),\(row))"
    }
    var hashValue: Int {
        return row*10 + column
    }
    
    init(column: Int, row: Int, tokenType: TokenType) {
        self.column = column
        self.row = row
        self.tokenType = tokenType
    }
}

func ==(lhs: Token, rhs: Token) -> Bool {
    return lhs.column == rhs.column && lhs.row == rhs.row
}

