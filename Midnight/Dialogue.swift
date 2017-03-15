//
//  Dialogue.swift
//  Midnight
//
//  Created by David Garrett on 10/18/16.
//  Copyright © 2016 David Garrett. All rights reserved.
//

import Foundation

enum DialogueItemType : String {
    case Unknown = ""
    case Line = "line"
    case FX = "fx"
    case Branch = "branch"
    case Choice = "choice"
    case Title = "title"
}

class DialogueItem {
    var unlockKey : String?
    var questData : [String : AnyObject]?
    var rewards : [String : AnyObject]?
    var type : DialogueItemType = .Unknown
}

// A chapter or scene title, displayed prominantly
class DialogueTitle : DialogueItem {
    var text : String!
    
    init(text: String, questData: [String: AnyObject]?) {
        super.init()
        
        self.text = text
        self.type = DialogueItemType.Title
        if questData != nil {
            self.questData = questData
        }
    }
}

// A line of dialogue spoken by an actor or a line of narration
class DialogueLine : DialogueItem {
    var text : String = ""
    var actor : String = ""
    var image : String?
    var direction : String = "left"
    
    init(text: String, actor: String?, image: String?, direction: String?, questData: [String: AnyObject]?) {
        super.init()
        
        self.type = .Line
        self.text = text
        if actor != nil {
            self.actor = actor!
        }
        
        self.image = image
        
        if direction != nil {
            self.direction = direction!
        }
        if questData != nil {
            self.questData = questData
        }
    }
}

// A visual representation of a sound effect (e.g. *kapow*, *crash*, *crunch*)
class DialogueFX : DialogueItem {
    var text : String = ""
    var image : String?
    var actor : String?
    var direction : String = "left"
    
    init(text: String, image: String?, actor: String?, direction: String?) {
        super.init()
        
        self.type = .FX
        self.text = text
        self.image = image
        self.actor = actor
        if direction != nil {
            self.direction = direction!
        }
    }
}

// A branch in the script based on previous story choices
class DialogueBranch : DialogueItem {
    
}

// An interactive prompt to allow the player to choose from one or more responses
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
        let items = dictionary["items"] as! [[String: AnyObject]]
        
        for item in items {
            switch item["sceneType"] as! String {
            case "line":
                let text = item["text"] as! String
                let actor = item["actor"] as? String
                let image = item["image"] as? String
                let direction = item["direction"] as? String
                var questData: [String: AnyObject]?
                if let questDataArray = item["questdata"] as? [[String: AnyObject]] {
                    questData = [String: AnyObject]()
                    for item in questDataArray {
                        let key = item["key"] as! String
                        let value = item["value"]
                        questData![key] = value
                    }
                }
                let line = DialogueLine(text: text, actor: actor, image: image, direction: direction, questData: questData)
                lines.append(line)
                
            case "fx":
                let text = item["text"] as! String
                let image = item["image"] as? String
                let actor = item["actor"] as? String
                let direction = item["direction"] as? String
                let line = DialogueFX(text: text, image: image, actor: actor, direction: direction)
                lines.append(line)
                
            case "title":
                let text = item["text"] as! String
                var questData: [String: AnyObject]?
                if let questDataArray = item["questdata"] as? [[String: AnyObject]] {
                    questData = [String: AnyObject]()
                    for item in questDataArray {
                        let key = item["key"] as! String
                        let value = item["value"]
                        questData![key] = value
                    }
                }
                let line = DialogueTitle(text: text, questData: questData)
                lines.append(line)
                
            default:
                assert(false, "unknown dialogue type")
            }
        }
    }
}
