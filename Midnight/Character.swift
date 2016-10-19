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
    var gender: Int = 1
    var level: Int = 1
    var experience: Int = 0
    var previousLevelGoal: Int = 0
    var nextLevelGoal: Int = 1000
    var invincible: Bool = false
    
    override init() {
        super.init()
    }
    
    init?(maxHealth: Int, currentHealth: Int, missChance: Int, name: String, gender: Int, strength: Double, defense: Int, level: Int, experience: Int, previousLevelGoal: Int, nextLevelGoal: Int) {
        self.maxHealth = maxHealth
        self.currentHealth = currentHealth
        self.missChance = missChance
        self.name = name
        self.gender = gender
        self.strength = strength
        self.defense = defense
        self.level = level
        self.experience = experience
        self.previousLevelGoal = previousLevelGoal
        self.nextLevelGoal = nextLevelGoal
        
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(maxHealth, forKey: "maxHealth")
        aCoder.encode(currentHealth, forKey: "currentHealth")
        aCoder.encode(missChance, forKey: "missChance")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(gender, forKey: "gender")
        aCoder.encode(strength, forKey: "strength")
        aCoder.encode(defense, forKey: "defense")
        aCoder.encode(level, forKey: "level")
        aCoder.encode(experience, forKey: "experience")
        aCoder.encode(previousLevelGoal, forKey: "previousLevelGoal")
        aCoder.encode(nextLevelGoal, forKey: "nextLevelGoal")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let maxHealth = aDecoder.decodeInteger(forKey: "maxHealth")
        let currentHealth = aDecoder.decodeInteger(forKey: "currentHealth")
        let missChance = aDecoder.decodeInteger(forKey: "missChance")
        let name = aDecoder.decodeObject(forKey: "name") as! String
        let gender = aDecoder.decodeInteger(forKey: "gender")
        let strength = aDecoder.decodeDouble(forKey: "strength")
        let defense = aDecoder.decodeInteger(forKey: "defense")
        let level = aDecoder.decodeInteger(forKey: "level")
        let experience = aDecoder.decodeInteger(forKey: "experience")
        let previousLevelGoal = aDecoder.decodeInteger(forKey: "previousLevelGoal")
        let nextLevelGoal = aDecoder.decodeInteger(forKey: "nextLevelGoal")
        
        self.init(maxHealth: maxHealth, currentHealth: currentHealth, missChance: missChance, name: name, gender: gender, strength: strength, defense: defense, level: level, experience: experience, previousLevelGoal: previousLevelGoal, nextLevelGoal: nextLevelGoal)
    }
    
    func levelUp() {
        self.level += 1
        self.previousLevelGoal = self.nextLevelGoal
        
        let filename = "CharacterLevels/Character_Level_\(self.level)"
        guard let dictionary = [String: AnyObject].loadJSONFromBundle(filename) else {return}
        
        self.nextLevelGoal = dictionary["nextLevel"] as! Int
        let rewards = dictionary["rewards"] as! [String: AnyObject]
        self.defense += rewards["defense"] as! Int
        self.strength += rewards["strength"] as! Double
        self.maxHealth += rewards["health"] as! Int
    }

}
