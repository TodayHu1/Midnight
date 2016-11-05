//
//  Monster.swift
//  MatchRPG
//
//  Created by David Garrett on 8/5/16.
//  Copyright © 2016 David Garrett. All rights reserved.
//

import Foundation

enum SpecialAttack: String {
    case none = "None"
    case freeze = "Freeze"
    case hide = "Hide"
    case shuffle = "Shuffle"
    case stun = "Stun"
}

class Monster {
    var name: String = ""
    var image: String = ""
    var maxHealth: Int = 0
    var currentHealth: Int = 0
    var minStrength: Double = 0.0
    var varStrength: Double = 0.0
    var critChance = 0
    var regeneration = 0
    var vulnerability: TokenType = TokenType.unknown
    var resistance: TokenType = TokenType.unknown
    var specialAttack: SpecialAttack = SpecialAttack.none
    var specialAttackChance: Int = 0
    var specialAbilities: String?
    var description: String = ""
    var unlockKey: String = ""
    var gameOverText: String?
    
    init(filename: String) {
        guard let dictionary = [String: AnyObject].loadJSONFromBundle(filename) else {
            assert(false, "Unable to load monster info")
            return
        }

        maxHealth = dictionary["health"] as! Int
        currentHealth = dictionary["health"] as! Int
        name = dictionary["name"] as! String
        image = dictionary["image"] as! String
        minStrength = dictionary["minStrength"] as! Double
        varStrength = dictionary["varStrength"] as! Double
        critChance = dictionary["critChance"] as! Int
        regeneration = dictionary["regeneration"] as! Int
        if let v = dictionary["vulnerability"] as? String {
            vulnerability = TokenType.createFromString(v)
        }
        if let r = dictionary["resistance"] as? String {
            resistance = TokenType.createFromString(r)
        }
        if let s = dictionary["specialAttack"] as? String {
            specialAttack = SpecialAttack.init(rawValue: s)!
            specialAttackChance = dictionary["specialAttackChance"] as! Int
        }
        description = dictionary["description"] as! String
        unlockKey = dictionary["unlockKey"] as! String
        specialAbilities = dictionary["specialAbilities"] as? String
        gameOverText = dictionary["gameOver"] as? String
    }
}
