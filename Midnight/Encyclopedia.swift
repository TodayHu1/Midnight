//
//  IndexItem.swift
//  Midnight
//
//  Created by David Garrett on 9/22/16.
//  Copyright © 2016 David Garrett. All rights reserved.
//

import UIKit

enum EncyclopediaEntryStatus : Int {
    case new = 0
    case read = 1
}

enum EncyclopediaEntryType : String {
    case unknown = ""
    case People = "People"
    case Places = "Places"
    case Monsters = "Monsters"
    case Magic = "Magic"
}

class EncyclopediaEntry {
    var text: String = ""
    var status: EncyclopediaEntryStatus = EncyclopediaEntryStatus.new
    var detailFile: String = ""
    var entries: [EncyclopediaEntry] = [EncyclopediaEntry]()
    var type: EncyclopediaEntryType = EncyclopediaEntryType.unknown
}

class Encyclopedia {
    var entries: [EncyclopediaEntry] = [EncyclopediaEntry]()
    
    init(section: String = "", savedGame: GameSave) {
        let filename = "encyclopedia"
        guard let dictionary = [String: AnyObject].loadJSONFromBundle(filename) else {return}
        
        let sectionArray = dictionary["sections"] as! [[String: AnyObject]]
        
        for item in sectionArray {
            let entry = EncyclopediaEntry()
            entry.text = item["section"] as! String
            
            if unlockEntry(savedGame: savedGame, unlockKey: item["unlockKey"] as! String) {
                entries.append(entry)
                
                let detailArray = item["entries"] as! [[String: AnyObject]]
                for detailItem in detailArray {
                    let detailEntry = EncyclopediaEntry()
                    detailEntry.text = detailItem["name"] as! String
                    detailEntry.detailFile = detailItem["detailFile"] as! String
                    detailEntry.type = EncyclopediaEntryType(rawValue: entry.text)!
                    
                    if unlockEntry(savedGame: savedGame, unlockKey: detailItem["unlockKey"] as! String) {
                        entry.entries.append(detailEntry)
                    }
                }
            }
        }
    }
    
    func unlockEntry(savedGame: GameSave, unlockKey: String) -> Bool {
        var unlocked = false
        if let key = savedGame.questData[unlockKey] {
            if key as! Bool == true {
                unlocked = true
            }
        }
        return unlocked
    }
    
}
