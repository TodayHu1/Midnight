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

class EncyclopediaEntry {
    var text: String
    var status: EncyclopediaEntryStatus = EncyclopediaEntryStatus.new
    var detailFile: String = ""
    
    init(text: String, detailFile: String) {
        self.text = text
        self.detailFile = detailFile
    }
}

class Encyclopedia {
    var indexList: [EncyclopediaEntry] = [EncyclopediaEntry]()
    
    init(level: Int, section: String = "", questData: [String : AnyObject]) {
        let filename = "encyclopedia"
        guard let dictionary = [String: AnyObject].loadJSONFromBundle(filename) else {return}
        
        if level == 2 {
            let d = dictionary[section] as! [[String: AnyObject]]
            for entry in d {
                let unlockKey = entry["unlockKey"] as! String
                if questData[unlockKey] as? Bool == true {
                indexList.append(EncyclopediaEntry(text: entry["name"] as! String, detailFile: entry["detailFile"] as! String))
                }
            }
        } else {
            for entry in dictionary {
                indexList.append(EncyclopediaEntry(text: entry.key, detailFile: ""))
            }
        }
    }
}
