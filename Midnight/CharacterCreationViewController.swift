//
//  CharacterProfileViewController.swift
//  MatchRPG
//
//  Created by David Garrett on 8/29/16.
//  Copyright © 2016 David Garrett. All rights reserved.
//

import Foundation
import UIKit

class CharacterCreationViewController: UIViewController, UITextFieldDelegate {
    var savedGame: GameSave!
    var saveSlot: Int = 0
    
    @IBOutlet weak var characterName: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var characterMalePortrait: UIImageView!
    @IBOutlet weak var characterFemalePortrait: UIImageView!
    @IBOutlet weak var characterMaleSelector: UITapGestureRecognizer!
    @IBOutlet weak var characterFemaleSelector: UITapGestureRecognizer!
    
    @IBAction func saveButtonPressed() {

        if savedGame.selectedLevel == "" {
            savedGame.selectedLevel = "Level_1_1"
            savedGame.questData["unlock_chapter_1"] = true as AnyObject?
            savedGame.questData["unlock_level_1_1"] = true as AnyObject?
        }
        
        savedGame.character.name = characterName.text!
        savedGame.save()
        
        self.performSegue(withIdentifier: "showGame", sender: self)
    }
    
    @IBAction func characterPortraitSelected(_ sender: UITapGestureRecognizer) {
        switch sender {
        case characterFemaleSelector:
            characterFemalePortrait.alpha = 1.0
            characterMalePortrait.alpha = 0.5
            savedGame.character.gender = 2
        default:
            characterFemalePortrait.alpha = 0.5
            characterMalePortrait.alpha = 1.0
            savedGame.character.gender = 1
        }
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func viewDidLoad() {
        savedGame = GameSave()
        savedGame.saveSlot = saveSlot
        savedGame.load()
        
        characterName.text = savedGame.character.name
        if savedGame.character.gender == 2 {
            characterFemalePortrait.alpha = 1.0
        } else {
            characterMalePortrait.alpha = 1.0
        }
        characterName.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showGame" {
            let vc = segue.destination as! StoryModeViewController
            vc.savedGame = savedGame

        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        characterName.resignFirstResponder()
        return true
    }
}
