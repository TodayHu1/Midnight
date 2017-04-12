//
//  Character.swift
//  MatchRPG
//
//  Created by David Garrett on 8/5/16.
//  Copyright © 2016 David Garrett. All rights reserved.
//

import Foundation

class Character: NSObject, NSCoding {
    var maxHealth: Int = 1500
    var currentHealth: Int = 1500
    var missChance: Int = 0
    var strength: Double = 0.8
    var defense: Int = 0
    var name: String = ""
    var image: String = ""
    var gender: Int = 1
    var level: Int = 1
//    var experience: Int = 0
//    var previousLevelGoal: Int = 0
//    var nextLevelGoal: Int = 1000
    var invincible: Bool = false
    var token: String = ""
    var className: String = ""
    var affinity: Affinity = Affinity()
    var supportPower: SupportPower = SupportPower.unknown
    
    override init() {
        super.init()
    }
    
    init?(maxHealth: Int, currentHealth: Int, missChance: Int, name: String, image: String, gender: Int, strength: Double, defense: Int, token: String, className: String, affinity: Affinity, supportPower: SupportPower) {
        self.maxHealth = maxHealth
        self.currentHealth = currentHealth
        self.missChance = missChance
        self.name = name
        self.image = image
        self.gender = gender
        self.strength = strength
        self.defense = defense
//        self.level = level
//        self.experience = experience
//        self.previousLevelGoal = previousLevelGoal
//        self.nextLevelGoal = nextLevelGoal
        self.token = token
        self.className = className
        self.affinity = affinity
        self.supportPower = supportPower
        
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(maxHealth, forKey: "maxHealth")
        aCoder.encode(currentHealth, forKey: "currentHealth")
        aCoder.encode(missChance, forKey: "missChance")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(image, forKey: "image")
        aCoder.encode(gender, forKey: "gender")
        aCoder.encode(strength, forKey: "strength")
        aCoder.encode(defense, forKey: "defense")
//        aCoder.encode(level, forKey: "level")
//        aCoder.encode(experience, forKey: "experience")
//        aCoder.encode(previousLevelGoal, forKey: "previousLevelGoal")
//        aCoder.encode(nextLevelGoal, forKey: "nextLevelGoal")
        aCoder.encode(token, forKey: "token")
        aCoder.encode(className, forKey: "className")
        aCoder.encode(affinity, forKey: "affinity")
        aCoder.encode(supportPower.description, forKey: "supportPower")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let maxHealth = aDecoder.decodeInteger(forKey: "maxHealth")
        let currentHealth = aDecoder.decodeInteger(forKey: "currentHealth")
        let missChance = aDecoder.decodeInteger(forKey: "missChance")
        let name = aDecoder.decodeObject(forKey: "name") as! String
        var image = ""
        if let i = aDecoder.decodeObject(forKey: "image") as? String {
            image = i
        }
        let gender = aDecoder.decodeInteger(forKey: "gender")
        let strength = aDecoder.decodeDouble(forKey: "strength")
        let defense = aDecoder.decodeInteger(forKey: "defense")
//        let level = aDecoder.decodeInteger(forKey: "level")
//        let experience = aDecoder.decodeInteger(forKey: "experience")
//        let previousLevelGoal = aDecoder.decodeInteger(forKey: "previousLevelGoal")
//        let nextLevelGoal = aDecoder.decodeInteger(forKey: "nextLevelGoal")
        var token = ""
        if let t = aDecoder.decodeObject(forKey: "token") as? String {
            token = t
        }
        var className = ""
        if let c = aDecoder.decodeObject(forKey: "className") as? String {
            className = c
        }
        
        var affinity = Affinity()
        if let a = aDecoder.decodeObject(forKey: "affinity") as? Affinity {
            affinity = a
        }
        
        var supportPower = SupportPower.unknown
        if let s = aDecoder.decodeObject(forKey: "supportPower") as? String {
            supportPower = SupportPower.createFromString(s)
        }
        
        self.init(maxHealth: maxHealth, currentHealth: currentHealth, missChance: missChance, name: name, image: image, gender: gender, strength: strength, defense: defense, token: token, className: className, affinity: affinity, supportPower: supportPower)
    }
    
    func levelUp() {
//        self.level += 1
//        self.previousLevelGoal = self.nextLevelGoal
        
//        let filename = "Character_Progression"
//        guard let dictionary = [String: AnyObject].loadJSONFromBundle(filename) else {return}
//        
//        let levels = dictionary["levels"] as! [[String: AnyObject]]
//        
//        self.nextLevelGoal = levels[level-1]["nextLevel"] as! Int
//        let rewards = levels[level-1]["rewards"] as! [String: AnyObject]
//        self.defense += rewards["defense"] as! Int
//        self.strength += rewards["strength"] as! Double
//        self.maxHealth += rewards["health"] as! Int
    }
    
    func create(filename: String) {
        guard let dictionary = [String: AnyObject].loadJSONFromBundle(filename) else {return}

        self.name = dictionary["name"] as! String
        self.image = dictionary["image"] as! String
//        self.experience = dictionary["startingExperience"] as! Int
        self.maxHealth = dictionary["startingHealth"] as! Int
        self.defense = dictionary["startingDefense"] as! Int
        self.strength = dictionary["startingStrength"] as! Double
        self.token = dictionary["token"] as! String
        self.className = dictionary["className"] as! String
        self.supportPower = SupportPower.createFromString(dictionary["supportPower"] as! String)
        
        let relationships = dictionary["relationships"] as! [[String: AnyObject]]
        
        for relationship in relationships {
            let strength = RelationshipStrength()
            strength.modify(by: relationship["score"] as! Int)
            
            self.affinity.relationships[relationship["name"] as! String] = strength
        }

//        let targetLevel = dictionary["startingLevel"] as! Int
//        
//        while self.level < targetLevel {
//            levelUp()
//        }
    }
    
//    func getMissingValue(characterName: String, key: String) -> AnyObject {
//        let filename = "Character_\(characterName)"
//        
//        guard let dictionary = [String: AnyObject].loadJSONFromBundle(filename) else {return false as AnyObject}
//        
//        return dictionary[key] as AnyObject
//
//    }

}

class SupportCharacter {
    var name: String = ""
    var uses: Int = 0
    var targetMana = 200
    var currentMana = 0
    var tokenType = TokenType.unknown
}

enum SupportPower: Int, CustomStringConvertible {
    case unknown = 0, Heal, Shield, Cleanse, Transmute, Target
    
    var image: String {
        let spriteNames = [
            "Heal",
            "Shield_Purple",
            "Cleanse",
            "Transmute",
            "Target"
        ]
        
        return spriteNames[rawValue - 1]
    }
    
    var description: String {
        let descriptions = [
            "Heal",
            "Shield",
            "Cleanse",
            "Transmute",
            "Target"
        ]
        
        return descriptions[rawValue - 1]
    }
    
    static func createFromString(_ type: String) -> SupportPower {
        var raw: Int
        switch type {
        case "Heal":
            raw = 1
        case "Shield":
            raw = 2
        case "Cleanse":
            raw = 3
        case "Transmute":
            raw = 4
        case "Target":
            raw = 5
        default:
            raw = 0
        }
        return SupportPower(rawValue: raw)!
    }
}

extension GameViewController {    
    func executeCharacterPower(character: String) {
        switch character {
        case "Lilly":
            heal()
        case "Olivia":
            target()
        case "Yuna":
            cleanse()
        case "Anaya":
            transmute()
        case "Camila":
            shield()
        default:
            assert(false, "Unknown Character Power type")
        }
    }
    
    func heal() {
        character.currentHealth += (100 + teamStrength)
        updateLabels()
        scene.animateBigText(text: "Heal")
    }
    
    func target() {
        targetMultiplier = 1 + (Double(savedGame.teamStrength) / 100)
        targetLabel.text = String(targetMultiplier)
        targetView.isHidden = false
        scene.animateBigText(text: "Target")
    }
    
    func cleanse() {
        let s: Int = savedGame.teamStrength / 100
        var cleanseMax: Int
        
        switch s {
        case 2:
            cleanseMax = 8
        case 3:
            cleanseMax = 16
        case 4:
            cleanseMax = 32
        case 5:
            cleanseMax = 64
        default:
            cleanseMax = 4
        }
        
        let cleanTokens = level.cleanse(numberToCleanse: cleanseMax)
        scene.removeSpritesForTokens(tokens: cleanTokens)
        scene.addSpritesForTokens(tokens: cleanTokens)
        scene.animateBigText(text: "Cleanse")
    }
    
    func transmute() {
        let s: Int = savedGame.teamStrength / 100
        var transmuteMax: Int
        
        switch s {
        case 2:
            transmuteMax = 8
        case 3:
            transmuteMax = 16
        case 4:
            transmuteMax = 32
        case 5:
            transmuteMax = 64
        default:
            transmuteMax = 4
        }
        
        let targetTokenType = TokenType.createFromString(character.token)
        let changedTokens = level.transmute(numberToChange: transmuteMax,tokenType: targetTokenType)
        scene.removeSpritesForTokens(tokens: changedTokens)
        scene.addSpritesForTokens(tokens: changedTokens)
        
        scene.animateBigText(text: "Transmute")
        
        handleMatches()
    }
    
    func shield() {
        shieldCount = (100 + teamStrength) / 100
        shieldLabel.text = String(shieldCount)
        shieldView.isHidden = false
        scene.animateBigText(text: "Shield")
    }
}
