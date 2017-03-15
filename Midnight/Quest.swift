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
}

class Quest {
    var nodes: [QuestHierarchyNode] = [QuestHierarchyNode]()
    
    init (savedGame: GameSave) {
        let filename = "Levels/Progress"
        guard let dictionary = [String: AnyObject].loadJSONFromBundle(filename) else {return}
        
        let chaptersArray = dictionary["chapters"] as! [[String: AnyObject]]
        for chapterItem in chaptersArray {
            let chapter = QuestHierarchyNode()
            chapter.id = chapterItem["chapter"] as! String
            chapter.title = chapterItem["title"] as! String
            chapter.unlockKey = chapterItem["unlockKey"] as! String
            
            if unlockNode(savedGame: savedGame, unlockKey: chapter.unlockKey) {
                
                let levelArray = chapterItem["levels"] as! [[String: AnyObject]]
                var starCount: Int = 0
                
                for levelItem in levelArray {
                    let level = QuestHierarchyNode()
                    level.id = levelItem["level"] as! String
                    level.title = levelItem["title"] as! String
                    level.unlockKey = levelItem["unlockKey"] as! String
                    level.waves = levelItem["waves"] as! Int
                    
                    if unlockNode(savedGame: savedGame, unlockKey: level.unlockKey) {
                        if let levelResults = savedGame.levelResults[level.id] {
                            level.totalMovesGoal = levelResults.totalMovesGoal
                            level.totalDamageTakenGoal = levelResults.totalDamageTakenGoal
                            level.elapsedTimeGoal = levelResults.elapsedTimeGoal
                            
                            if level.totalDamageTakenGoal { starCount += 1 }
                            if level.totalMovesGoal { starCount += 1 }
                            if level.elapsedTimeGoal { starCount += 1 }
                        }
                        chapter.nodes.append(level)
                    }
                }
                
                chapter.percentComplete = Int(Double(starCount) / Double(levelArray.count * 3) * 100)
                self.nodes.append(chapter)
            }
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
