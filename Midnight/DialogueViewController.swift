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
    var skipCharacterSelect : Bool = false
    var scene : [Scene]?
    var currentScene : Int = 0
    var lineNo : Int = 0
    

    @IBOutlet var dialogueTap: UITapGestureRecognizer!
    @IBOutlet weak var dialogueContentView: UIView!
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
        
        if level.availableCharacters?.count == 1 {
            savedGame.selectedCharacter = level.availableCharacters![0]
            skipCharacterSelect = true
        }
        
        if let sceneArray : [String] = level.scene {
            scene = [Scene]()
            for item in sceneArray {
                scene!.append(Scene(filename: item))
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if scene != nil {
            showScene(index: lineNo)
        } else {
            if skipCharacterSelect {
                self.performSegue(withIdentifier: "showPreGame", sender: self)
            } else {
                self.performSegue(withIdentifier: "showCharacterSelect", sender: self)
            }
        }
    }
    
    func showScene(index: Int) {
        if lineNo < scene![currentScene].lines.count {
            
            for item in dialogueContentView.subviews {
                item.removeFromSuperview()
            }
            
            switch scene![currentScene].lines[index] {
            case is DialogueTitle:
                let line = scene![currentScene].lines[index] as! DialogueTitle

                if line.questData != nil {
                    addQuestData(questData: line.questData!)
                }
                
                let textView = UILabel(frame: CGRect(x: 0, y: 0, width: dialogueContentView.frame.width, height: dialogueContentView.frame.height))
                textView.font = UIFont(name: "SilverBulletBB", size: 36.0)
                textView.textColor = UIColor.white
                textView.text = line.text
                textView.textAlignment = .center
                
                actorImageRight.isHidden = true
                actorImageLeft.isHidden = true
                actorNameLabel.isHidden = true
                
                dialogueContentView.backgroundColor = UIColor.darkGray
                dialogueContentView.alpha = 0.5
                dialogueContentView.addSubview(textView)
                
                
            case is DialogueLine:
                let line = scene![currentScene].lines[index] as! DialogueLine
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

                if line.questData != nil {
                    addQuestData(questData: line.questData!)
                }
                
                let textView = UITextView(frame: CGRect(x: 0, y: 0, width: dialogueContentView.frame.width, height: dialogueContentView.frame.height))
                textView.font = UIFont(name: "DigitalStripBB", size: 17.0)
                textView.isEditable = false
                textView.backgroundColor = UIColor.clear
                textView.textColor = UIColor.white
                textView.text = line.text
                
                dialogueContentView.backgroundColor = UIColor.darkGray
                dialogueContentView.alpha = 0.5
                dialogueContentView.addSubview(textView)

            case is DialogueFX:
                let line = scene![currentScene].lines[index] as! DialogueFX
                
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
                
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: dialogueContentView.frame.width, height: dialogueContentView.frame.height))
                imageView.contentMode = .scaleAspectFit
                imageView.image = UIImage(named: line.image!)

                dialogueContentView.backgroundColor = UIColor.clear
                dialogueContentView.alpha = 1.0
                dialogueContentView.addSubview(imageView)
                
            default:
                assert(false, "unknown line type")
            }
        } else {
            if currentScene + 1 < scene!.count {
                resetScene()
                currentScene += 1
                showScene(index: lineNo)
            } else {
                if skipCharacterSelect {
                    self.performSegue(withIdentifier: "showPreGame", sender: self)
                } else {
                    self.performSegue(withIdentifier: "showCharacterSelect", sender: self)
                }
            }
        }
    }
    
    func presentText(text: String) {
        
    }
    
    func resetScene() {
        lineNo = 0
        actorImageRight.isHidden = true
        actorImageLeft.isHidden = true
        actorNameLabel.isHidden = true
    }
    
    func addQuestData(questData: [String: AnyObject]) {
        for (key, value) in questData {
            savedGame.setQuestData(key: key, value: value)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCharacterSelect" {
            let vc = segue.destination as! CharacterSelectViewController
            vc.savedGame = savedGame
        }
        if segue.identifier == "showPreGame" {
            let vc = segue.destination as! PreGameViewController
            vc.savedGame = savedGame
        }
    }
}
