//
//  Monster.swift
//  MatchRPG
//
//  Created by David Garrett on 8/5/16.
//  Copyright © 2016 David Garrett. All rights reserved.
//

import Foundation
import UIKit

enum SpecialAttack: String {
    case none = "None"
    case freeze = "Freeze"
    case hide = "Darkness"
    case shuffle = "Chaos"
    case stun = "Stun"
    case poison = "Poison"
    case engulf = "Entomb"
    case explode = "Meteor"
    
    var attackColor: UIColor {
        let color = ["None": UIColor.clear, "Freeze": UIColor.blue, "Darkness": UIColor.darkGray, "Chaos": UIColor.red, "Stun": UIColor.lightGray, "Poison": UIColor.green, "Entomb": UIColor.brown, "Meteor": UIColor.orange]
        
        return color[rawValue]!
    }
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
    var specialAttackCountdown: Int = 1
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
            specialAttackCountdown = dictionary["specialAttackCountdown"] as! Int
        }
        description = dictionary["description"] as! String
        unlockKey = dictionary["unlockKey"] as! String
        specialAbilities = dictionary["specialAbilities"] as? String
        gameOverText = dictionary["gameOver"] as? String
    }
}

//Special attacks
extension GameViewController {
    func executeSpecialAttack() {
        switch level.monsters[wave].specialAttack {
        case .freeze:
            freeze()
        case .hide:
            hide()
        case .shuffle:
            randomizeGrid()
        case .stun:
            stun()
        case .poison:
            poison()
        case .engulf:
            engulf()
        case .explode:
            explode()
        default:
            assert(false, "Unknown Special Attack type")
        }
    }
    
    func hide() {
        let hiddenTokens = level.hide()
        scene.removeSpritesForTokens(tokens: hiddenTokens)
        scene.addSpritesForTokens(tokens: hiddenTokens)
        scene.animateBigText(text: SpecialAttack.hide.rawValue, color: SpecialAttack.hide.attackColor)
    }
    
    func freeze() {
        scene.animateBigText(text: SpecialAttack.freeze.rawValue, color: SpecialAttack.freeze.attackColor)
    }
    
    func stun() {
        scene.animateBigText(text: SpecialAttack.stun.rawValue, color: SpecialAttack.stun.attackColor)
    }
    
    func poison() {
        let poisonTokens = level.poison()
        scene.removeSpritesForTokens(tokens: poisonTokens)
        scene.addSpritesForTokens(tokens: poisonTokens)
        scene.animateBigText(text: SpecialAttack.poison.rawValue, color: SpecialAttack.poison.attackColor)
    }
    
    func engulf() {
        scene.animateBigText(text: SpecialAttack.engulf.rawValue, color: SpecialAttack.engulf.attackColor)
    }
    
    func explode() {
        scene.animateBigText(text: SpecialAttack.explode.rawValue, color: SpecialAttack.explode.attackColor)
    }
    
    func randomizeGrid() {
        scene.removeAllTokenSprites()
        let newTokens = level.shuffle()
        scene.addSpritesForTokens(tokens: newTokens)
        scene.animateBigText(text: SpecialAttack.shuffle.rawValue, color: SpecialAttack.shuffle.attackColor)
    }
}
