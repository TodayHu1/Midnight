//
//  Token.swift
//  MatchRPG
//
//  Created by David Garrett on 8/1/16.
//  Copyright © 2016 David Garrett. All rights reserved.
//

import SpriteKit

enum TokenType: Int, CustomStringConvertible {
    case unknown = 0, Token1, Token2, Token3, Token4, Token5
    
    var spriteName: String {
        let spriteNames = [
            "Token1",
            "Token2",
            "Token3",
            "Token4",
            "Token5"
        ]
        
        return spriteNames[rawValue - 1]
    }
    
    var highlightedSpriteName: String {
        return spriteName + "-highlighted"
//        return spriteName
    }
    
    var hiddenSpriteName: String {
        return spriteName + "-" + TokenStatus.Hidden.rawValue
    }
    
    var poisonSpriteName: String {
        return spriteName + "-" + TokenStatus.Poison.rawValue
    }

    var freezeSpriteName: String {
        return spriteName + "-" + TokenStatus.Freeze.rawValue
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
        case "Token1":
            raw = 1
        case "Token2":
            raw = 2
        case "Token3":
            raw = 3
        case "Token4":
            raw = 4
        case "Token5":
            raw = 5
        default:
            raw = 0
        }
        return TokenType(rawValue: raw)!
    }
}

enum TokenStatus : String {
    case None = ""
    case Poison = "poison"
    case Hidden = "hidden"
    case Freeze = "freeze"
}

class Token: CustomStringConvertible, Hashable {
    var column: Int
    var row: Int
    var tokenType: TokenType
    var status: TokenStatus = TokenStatus.None
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

