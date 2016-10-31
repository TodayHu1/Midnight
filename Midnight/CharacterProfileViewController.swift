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
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var experienceLabel: UILabel!
    @IBOutlet weak var nextLevelLabel: UILabel!
    
    var callingView: String = ""
    var savedGame: GameSave!
    var character: Character!
    
    
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        dismiss(animated: true, completion: {})
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        character = savedGame.characters[savedGame.selectedCharacter]!
        
        characterNameLabel.text = character.name
        characterImagePanel.image = UIImage(named: character.image)
        characterHealthLabel.text = String(format: "%ld", character.maxHealth)
        characterStrengthLabel.text = String(format: "%ld", Int(character.strength * 100))
        characterDefenseLabel.text = String(format: "%ld", character.defense)
        levelLabel.text = String(format: "%ld", character.level)
        experienceLabel.text = String(format: "%ld", character.experience)
        nextLevelLabel.text = String(format: "%ld", character.nextLevelGoal)

    }
}
