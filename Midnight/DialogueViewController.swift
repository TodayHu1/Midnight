//
//  DialogueViewController.swift
//  Midnight
//
//  Created by David Garrett on 10/18/16.
//  Copyright © 2016 David Garrett. All rights reserved.
//

import Foundation
import UIKit

class DialogueViewController : UIViewController {
    var savedGame : GameSave!
    var level : Level!
    var scene : Scene?
    var lineNo : Int = 0
    

    @IBOutlet var dialogueTap: UITapGestureRecognizer!
    @IBOutlet weak var dialogueTextView: UITextView!
    @IBOutlet weak var actorNameLabel: UILabel!
    @IBOutlet weak var actorImageLeft: UIImageView!
    @IBOutlet weak var actorImageRight: UIImageView!
    
    @IBAction func dialogueTapped(_ sender: AnyObject) {
        lineNo += 1
        showScene(index: lineNo)
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let levelFilename = "Levels/\(savedGame.selectedLevel)"
        
        level = Level(filename: levelFilename)
        
        if let filename = level.scene {
            scene = Scene(filename: filename)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if scene != nil {
            showScene(index: lineNo)
        } else {
            self.performSegue(withIdentifier: "showCharacterSelect", sender: self)
        }
    }
    
    func showScene(index: Int) {
        if lineNo < scene!.lines.count {
            if scene?.lines[index] is DialogueLine {
                let line = scene?.lines[index] as! DialogueLine
                if line.actor != "" {
                    actorNameLabel.text = line.actor
                    actorNameLabel.isHidden = false
                    switch line.direction {
                    case "left":
                        actorNameLabel.textAlignment = NSTextAlignment.left
                    case "right":
                        actorNameLabel.textAlignment = NSTextAlignment.right
                    case "center":
                        actorNameLabel.textAlignment = NSTextAlignment.center
                    default:
                        actorNameLabel.textAlignment = NSTextAlignment.left
                    }
                } else {
                    actorNameLabel.isHidden = true
                }
                
                if line.image != nil {
                    switch line.direction {
                    case "right":
                        actorImageRight.image = UIImage(named: line.image!)
                        actorImageRight.isHidden = false
                    default:
                        actorImageLeft.image = UIImage(named: line.image!)
                        actorImageLeft.isHidden = false
                    }
                }
                
                dialogueTextView.text = line.text
                
                if line.questData != nil {
                    addQuestData(line: line)
                }
            }
        } else {
            self.performSegue(withIdentifier: "showCharacterSelect", sender: self)
        }
    }
    
    func addQuestData(line: DialogueLine) {
        for (key, value) in line.questData! {
            savedGame.setQuestData(key: key, value: value)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPreGame" {
            let vc = segue.destination as! PreGameViewController
            vc.savedGame = savedGame
        }
        if segue.identifier == "showCharacterSelect" {
            let vc = segue.destination as! CharacterSelectViewController
            vc.savedGame = savedGame
        }
    }
}
