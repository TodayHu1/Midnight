//
//  PreGameViewController.swift
//  MatchRPG
//
//  Created by David Garrett on 8/30/16.
//  Copyright © 2016 David Garrett. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class PreGameViewController: UIViewController {
    var savedGame: GameSave!
    var character: Character!
    var level: Level!
    
    @IBOutlet weak var monsterImagePanel: UIImageView!
    @IBOutlet weak var characterImagePanel: UIImageView!
    @IBOutlet weak var levelTitleLabel: UILabel!
    @IBOutlet weak var totalMovesLabel: UILabel!
    @IBOutlet weak var totalDamageTakenLable: UILabel!
    @IBOutlet weak var elapsedTimeLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func viewDidLoad() {
        level = Level(filename: "Levels/\(savedGame.selectedLevel)")
        character = savedGame.characters[savedGame.selectedCharacter]
        
        characterImagePanel.image = UIImage(named: character.image)
        monsterImagePanel.image = UIImage(named: level.monsters[0].image)
        levelTitleLabel.text = level.title
        totalMovesLabel.text = String(format: "%ld", level.goals.totalMoves)
        totalDamageTakenLable.text = String(format: "%ld", level.goals.totalDamageTaken)
        elapsedTimeLabel.text = DateComponentsFormatter().string(from: level.goals.elapsedTime)
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showGame" {
            let vc = segue.destination as! GameViewController
            vc.savedGame = self.savedGame
        }
        if segue.identifier == "presentCharacterProfile" {
            let vc = segue.destination as! CharacterProfileViewController
            vc.callingView = "preGame"
            vc.savedGame = self.savedGame
        }
        if segue.identifier == "presentMonsterStats" {
            let vc = segue.destination as! MonsterStatsViewController
            vc.callingView = "preGame"
            vc.monster = self.level.monsters[0]
        }
        if segue.identifier == "showStoryMode" {
            let vc = segue.destination as! StoryModeViewController
            vc.savedGame = savedGame
        }
    }
}