//
//  Affinity.swift
//  Midnight
//
//  Created by David Garrett on 11/21/16.
//  Copyright © 2016 David Garrett. All rights reserved.
//

import Foundation

class RelationshipStrength: NSObject, NSCoding {
    private var rawValue: Int = 0
    var score: Int {
        get {
            if rawValue > 100 {
                return 100
            } else if rawValue < -100 {
                return -100
            } else {
                return rawValue
            }
        }
    }
    func modify(by: Int) {
        rawValue += by
    }
    
    override init() {
        super.init()
    }
    
    init?(rawValue: Int) {
        self.rawValue = rawValue
        
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(rawValue, forKey: "rawValue")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let rawValue = aDecoder.decodeInteger(forKey: "rawValue")
        
        self.init(rawValue: rawValue)
    }
}

class Affinity: NSObject, NSCoding {
    var relationships: [String: RelationshipStrength] = [String: RelationshipStrength]()
    var average: Int {
        get {
            var total: Int = 0
            for r in relationships {
                total += r.value.score
            }
            
            return Int(total / relationships.count)
        }
    }
    
    override init() {
        super.init()
    }
    
    init?(relationships: [String: RelationshipStrength]) {
        self.relationships = relationships
        
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(relationships, forKey: "relationships")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let relationships = aDecoder.decodeObject(forKey: "relationships") as! [String: RelationshipStrength]
        
        self.init(relationships: relationships)
    
    }
}
