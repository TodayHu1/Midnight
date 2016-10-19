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
            self.performSegue(withIdentifier: "showPreGame", sender: self)
        }
    }
    
    func showScene(index: Int) {
        if lineNo < scene!.lines.count {
            if scene?.lines[index] is DialogueLine {
                let line = scene?.lines[index] as! DialogueLine
                if line.actor != "" {
                    actorNameLabel.text = line.actor
                    actorNameLabel.isHidden = false
                } else {
                    actorNameLabel.isHidden = true
                }
                
                dialogueTextView.text = line.text
            }
        } else {
            self.performSegue(withIdentifier: "showPreGame", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPreGame" {
            let vc = segue.destination as! PreGameViewController
            vc.savedGame = savedGame
        }
    }
}
