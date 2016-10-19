//
//  SaveMenuViewController.swift
//  MatchRPG
//
//  Created by David Garrett on 8/12/16.
//  Copyright © 2016 David Garrett. All rights reserved.
//

import UIKit
import SpriteKit

class SaveMenuViewcontroller: UIViewController {
    var saveSlot: Int = 0
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var savedGame1: UITapGestureRecognizer!
    @IBOutlet weak var savedGame2: UITapGestureRecognizer!
    @IBOutlet weak var savedGame3: UITapGestureRecognizer!
    @IBOutlet weak var savedGameLabel1: UILabel!
    @IBOutlet weak var savedGameLabel2: UILabel!
    @IBOutlet weak var savedGameLabel3: UILabel!
    @IBOutlet weak var deleteGame1: UIButton!
    @IBOutlet weak var deleteGame2: UIButton!
    @IBOutlet weak var deleteGame3: UIButton!
    
    @IBAction func dismissView(_: AnyObject) {
        self.dismiss(animated: false, completion: {})
    }
    
    @IBAction func saveMenuUnwindAction(_ unwindSegue: UIStoryboardSegue) {
        if unwindSegue.identifier == "unwindConfirmDelete" {
            deleteSave()
        }
    }
    
    @IBAction func startGame(_ sender: UITapGestureRecognizer) {
        var newGame: Bool = false
        switch sender {
        case savedGame1:
            saveSlot = 1
            if savedGameLabel1.text == "New Game" {newGame = true}
        case savedGame2:
            saveSlot = 2
            if savedGameLabel2.text == "New Game" {newGame = true}
        case savedGame3:
            saveSlot = 3
            if savedGameLabel3.text == "New Game" {newGame = true}
        default:
            saveSlot = 0
        }
        
        if newGame {
            performSegue(withIdentifier: "showCharacterProfile", sender: self)
        } else {
            performSegue(withIdentifier: "showSavedGame", sender: self)
        }
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        switch sender {
        case deleteGame1:
            saveSlot = 1
        case deleteGame2:
            saveSlot = 2
        case deleteGame3:
            saveSlot = 3
        default:
            saveSlot = 0
        }
        
        performSegue(withIdentifier: "presentConfirmation", sender: self)
    }
    
    func deleteSave() {
        let savedGame: GameSave = GameSave()
        
        if self.saveSlot > 0 {
            savedGame.saveSlot = self.saveSlot
            savedGame.deleteSave()
        }
        loadAvailableSaves()
        
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func viewDidLoad() {
        loadAvailableSaves()
    }
    
    func loadAvailableSaves() {
        let savedGame01: GameSave = GameSave()
        
        savedGame01.saveSlot = 1
        savedGame01.load()
        
        if savedGame01.selectedLevel != "" {
            savedGameLabel1.text = String(format: "\(savedGame01.selectedLevel)")
        } else {
            savedGameLabel1.text = "New Game"
            deleteGame1.isHidden = true
        }
        
        let savedGame02: GameSave = GameSave()
        savedGame02.saveSlot = 2
        savedGame02.load()
        
        if savedGame02.selectedLevel != "" {
            savedGameLabel2.text = String(format: "\(savedGame02.selectedLevel)")
        } else {
            savedGameLabel2.text = "New Game"
            deleteGame2.isHidden = true
        }
        
        let savedGame03: GameSave = GameSave()
        savedGame03.saveSlot = 3
        savedGame03.load()
        
        if savedGame03.selectedLevel != "" {
            savedGameLabel3.text = String(format: "\(savedGame03.selectedLevel)")
        } else {
            savedGameLabel3.text = "New Game"
            deleteGame3.isHidden = true
        }

    }
    
    func passGameInfo(_ vc: inout StoryModeViewController, saveSlot: Int) {
        let savedGame: GameSave = GameSave()
        savedGame.saveSlot = saveSlot
        savedGame.load()
        
        if savedGame.selectedLevel != "" {
            vc.savedGame = savedGame
        } else {
            savedGame.selectedLevel = "Level_1_1"
            vc.savedGame = savedGame
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSavedGame" {
            var vc = segue.destination as! StoryModeViewController
            passGameInfo(&vc, saveSlot: self.saveSlot)
        } else if segue.identifier == "presentConfirmation" {
            let vc = segue.destination as! ConfirmDeleteViewController
            vc.saveSlot = self.saveSlot
        } else if segue.identifier == "showCharacterProfile" {
            let vc = segue.destination as! CharacterCreationViewController
            vc.saveSlot = self.saveSlot
        }
    }
}
