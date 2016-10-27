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
                
                for levelItem in levelArray {
                    let level = QuestHierarchyNode()
                    level.id = levelItem["level"] as! String
                    level.title = levelItem["title"] as! String
                    level.unlockKey = levelItem["unlockKey"] as! String
                    
                    if unlockNode(savedGame: savedGame, unlockKey: level.unlockKey) {
                        chapter.nodes.append(level)
                    }
                }
                
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
