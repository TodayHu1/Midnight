//
//  Quest.swift
//  Midnight
//
//  Created by David Garrett on 10/1/16.
//  Copyright © 2016 David Garrett. All rights reserved.
//

import Foundation

class QuestHierarchyNode {
    var id : String!
    var title : String!
    var unlockKey : String!
    var unlocked : Bool = false
    var nodes : [QuestHierarchyNode] = [QuestHierarchyNode]()
    var percentComplete : Int = 0
    var totalMovesGoal: Bool = false
    var totalDamageTakenGoal: Bool = false
    var elapsedTimeGoal: Bool = false
    var waves: Int = 1
    var image: String = ""
}

class Quest {
    var nodes: [QuestHierarchyNode] = [QuestHierarchyNode]()
    var percentComplete: Int = 0
    
    init (savedGame: GameSave, file: String) {
        let filename = "Levels/" + file
        guard let dictionary = [String: AnyObject].loadJSONFromBundle(filename) else {return}
        
        let chaptersArray = dictionary["chapters"] as! [[String: AnyObject]]
        var totalStars: Int = 0
        var totalLevels: Int = 0
        
        for chapterItem in chaptersArray {
            let chapter = QuestHierarchyNode()
            chapter.id = chapterItem["chapter"] as! String
            chapter.title = chapterItem["title"] as! String
            chapter.unlockKey = chapterItem["unlockKey"] as! String
            
            
            let levelArray = chapterItem["levels"] as! [[String: AnyObject]]
            var starCount: Int = 0
            
            for levelItem in levelArray {
                let level = QuestHierarchyNode()
                level.id = levelItem["level"] as! String
                level.title = levelItem["title"] as! String
                level.unlockKey = levelItem["unlockKey"] as! String
                level.waves = levelItem["waves"] as! Int
                
                if let levelResults = savedGame.levelResults[savedGame.difficulty.description]![level.id] {
                    if levelResults.totalMovesCompleteCount > 0 {
                        level.totalMovesGoal = true
                    }
                    if levelResults.totalDamageTakenCompleteCount > 0 {
                        level.totalDamageTakenGoal = true
                    }
                    if levelResults.elapsedTimeCompleteCount > 0 {
                        level.elapsedTimeGoal = true
                    }
                    
                    if level.totalDamageTakenGoal { starCount += 1 }
                    if level.totalMovesGoal { starCount += 1 }
                    if level.elapsedTimeGoal { starCount += 1 }
                }
                
                if unlockNode(savedGame: savedGame, unlockKey: level.unlockKey) {
                    chapter.nodes.append(level)
                }
            }
            
            chapter.percentComplete = Int(Double(starCount) / Double(levelArray.count * 3) * 100)
            totalStars += starCount
            totalLevels += levelArray.count

            if unlockNode(savedGame: savedGame, unlockKey: chapter.unlockKey) {
                self.nodes.append(chapter)
            }
            
            self.percentComplete = Int(Double(totalStars) / Double(totalLevels * 3) * 100)
        }
    }
    
    func unlockNode(savedGame: GameSave, unlockKey: String) -> Bool {
        var unlocked = false
        if let key = savedGame.questData[unlockKey] {
            if key as! Bool == true {
                unlocked = true
            }
        }
        return unlocked
    }
}
