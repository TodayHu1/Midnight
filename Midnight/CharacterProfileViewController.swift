//
//  CharacterProfileViewController.swift
//  MatchRPG
//
//  Created by David Garrett on 9/7/16.
//  Copyright © 2016 David Garrett. All rights reserved.
//

import Foundation
import UIKit

class CharacterProfileViewController: UIViewController {
    
    @IBOutlet weak var characterNameLabel: UILabel!
    @IBOutlet weak var characterImagePanel: UIImageView!
    @IBOutlet weak var characterHealthLabel: UILabel!
    @IBOutlet weak var characterStrengthLabel: UILabel!
    @IBOutlet weak var characterDefenseLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    var callingView: String = ""
    var savedGame: GameSave!
    
    
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        dismiss(animated: true, completion: {})
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.tabBarController != nil {
            let tc = self.tabBarController as! CharacterManagementTabController
            self.savedGame = tc.savedGame
            self.callingView = tc.callingView
        }
        
        characterNameLabel.text = savedGame.character.name
        if savedGame.character.gender == 1 {
            characterImagePanel.image = UIImage(named: "character_male")
        } else {
            characterImagePanel.image = UIImage(named: "character_female")
        }
        characterHealthLabel.text = String(format: "%ld", savedGame.character.maxHealth)
        characterStrengthLabel.text = String(format: "%ld", Int(savedGame.character.strength * 100))
        characterDefenseLabel.text = String(format: "%ld", savedGame.character.defense)

    }
}
