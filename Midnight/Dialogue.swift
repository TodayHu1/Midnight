//
//  Dialogue.swift
//  Midnight
//
//  Created by David Garrett on 10/18/16.
//  Copyright © 2016 David Garrett. All rights reserved.
//

import Foundation

class DialogueItem {
    var unlockKey : String?
    var questData : [String : AnyObject]?
    var rewards : [String : AnyObject]?
}

class DialogueLine : DialogueItem {
    var text : String = ""
    var actor : String = ""
    
    init(text: String, actor: String?) {
        self.text = text
        if actor != nil {
            self.actor = actor!
        }
    }
}

class DialogueBranch : DialogueItem {
    
}

class DialogueChoice : DialogueItem {
    var responses : [String] = [String]()
}

class DialogueStageDirection : DialogueItem {
    
}

class Scene {
    var lines : [AnyObject] = [AnyObject]()
    var background : String = ""
    
    init(filename: String) {
        guard let dictionary = [String: AnyObject].loadJSONFromBundle(filename) else {return}
        
        background = dictionary["background"] as! String
        let items = dictionary["items"] as! [[String: String]]
        
        for item in items {
            if item["sceneType"] as String! == "line" {
                let text = item["text"]
                let actor = item["actor"] as String?
                let line = DialogueLine(text: text!, actor: actor)
                lines.append(line)
            }
        }
    }
}
