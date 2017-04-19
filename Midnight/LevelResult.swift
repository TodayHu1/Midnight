//
//  LevelResult.swift
//  MatchRPG
//
//  Created by David Garrett on 8/23/16.
//  Copyright © 2016 David Garrett. All rights reserved.
//

import Foundation

class LevelResult: NSObject, NSCoding {
    var stats: [String: Int] = [String: Int]()
    var totalMoves: Int = 0
    var totalDamageTaken: Int = 0
    var elapsedTime: TimeInterval = 0
//    var totalMovesGoal: Bool = false
//    var totalDamageTakenGoal: Bool = false
//    var elapsedTimeGoal: Bool = false
    var includeInLeaderboard: Bool = true
    var totalMovesCompleteCount: Int = 0
    var totalDamageTakenCompleteCount: Int = 0
    var elapsedTimeCompleteCount: Int = 0
    
    override init() {
        super.init()
    }
    
    init?(totalMoves: Int, totalDamageTaken: Int, elapsedTime: TimeInterval, includeInLeaderboard: Bool, stats: [String: Int], totalMovesCompleteCount: Int, totalDamageTakenCompleteCount: Int, elapsedTimeCompleteCount: Int) {
        self.totalMoves = totalMoves
        self.totalDamageTaken = totalDamageTaken
        self.elapsedTime = elapsedTime
//        self.totalMovesGoal = totalMovesGoal
//        self.totalDamageTakenGoal = totalDamageTakenGoal
//        self.elapsedTimeGoal = elapsedTimeGoal
        self.includeInLeaderboard = includeInLeaderboard
        self.stats = stats
        self.totalMovesCompleteCount = totalMovesCompleteCount
        self.totalDamageTakenCompleteCount = totalDamageTakenCompleteCount
        self.elapsedTimeCompleteCount = elapsedTimeCompleteCount
        
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(totalMoves, forKey: "totalMoves")
        aCoder.encode(totalDamageTaken, forKey: "totalDamageTaken")
        aCoder.encode(elapsedTime, forKey: "elapsedTime")
//        aCoder.encode(totalMovesGoal, forKey: "totalMovesGoal")
//        aCoder.encode(totalDamageTakenGoal, forKey: "totalDamageTakenGoal")
//        aCoder.encode(elapsedTimeGoal, forKey: "elapsedTimeGoal")
        aCoder.encode(includeInLeaderboard, forKey: "includeInLeaderboard")
        aCoder.encode(stats, forKey: "stats")
        aCoder.encode(totalMovesCompleteCount, forKey: "totalMovesCompleteCount")
        aCoder.encode(totalDamageTakenCompleteCount, forKey: "totalDamageTakenCompleteCount")
        aCoder.encode(elapsedTimeCompleteCount, forKey: "elapsedTimeCompleteCount")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let totalMoves = aDecoder.decodeInteger(forKey: "totalMoves")
        let totalDamageTaken = aDecoder.decodeInteger(forKey: "totalDamageTaken")
        let elapsedTime = aDecoder.decodeDouble(forKey: "elapsedTime")
//        let totalMovesGoal = aDecoder.decodeBool(forKey: "totalMovesGoal")
//        let totalDamageTakenGoal = aDecoder.decodeBool(forKey: "totalDamageTakenGoal")
//        let elapsedTimeGoal = aDecoder.decodeBool(forKey: "elapsedTimeGoal")
        let includeInLeaderboard = aDecoder.decodeBool(forKey: "includeInLeaderboard")
        let totalMovesCompleteCount = aDecoder.decodeInteger(forKey: "totalMovesCompleteCount")
        let totalDamageTakenCompleteCount = aDecoder.decodeInteger(forKey: "totalDamageTakenCompleteCount")
        let elapsedTimeCompleteCount = aDecoder.decodeInteger(forKey: "elapsedTimeCompleteCount")
        
        var stats = [String: Int]()
        if aDecoder.containsValue(forKey: "stats") {
            stats = aDecoder.decodeObject(forKey: "stats") as! [String : Int]
        }
        
        self.init(totalMoves: totalMoves, totalDamageTaken: totalDamageTaken, elapsedTime: elapsedTime, includeInLeaderboard: includeInLeaderboard, stats: stats, totalMovesCompleteCount: totalMovesCompleteCount, totalDamageTakenCompleteCount: totalDamageTakenCompleteCount, elapsedTimeCompleteCount: elapsedTimeCompleteCount)
    }
    
}
