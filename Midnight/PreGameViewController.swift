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
    var monsterIndex: Int = 0
    
    @IBOutlet weak var monsterImagePanel: UIImageView!
    @IBOutlet weak var monsterImagePanel2: UIImageView!
    @IBOutlet weak var characterImagePanel: UIImageView!
    @IBOutlet weak var monsterImagePanel3: UIImageView!
    @IBOutlet weak var levelTitleLabel: UILabel!
    @IBOutlet weak var totalMovesLabel: UILabel!
    @IBOutlet weak var totalDamageTakenLable: UILabel!
    @IBOutlet weak var elapsedTimeLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var goal1: UIImageView!
    @IBOutlet weak var goal2: UIImageView!
    @IBOutlet weak var goal3: UIImageView!
    @IBOutlet weak var characterName: UILabel!
    @IBOutlet weak var monsterName: UILabel!
    @IBOutlet var swipeMonsterRight: UISwipeGestureRecognizer!
    @IBOutlet var tapMonster: UITapGestureRecognizer!
//    @IBOutlet var panMonster: UIPanGestureRecognizer!
    
    @IBOutlet var swipeMonsterLeft: UISwipeGestureRecognizer!
    @IBAction func swipeMonsterSwiped(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == UISwipeGestureRecognizerDirection.left {
            monsterIndex -= 1
            if monsterIndex < 0 {
                monsterIndex = level.monsters.count - 1
            }
            showMonsters() }
        else if sender.direction == UISwipeGestureRecognizerDirection.right {
            monsterIndex += 1
            if monsterIndex > level.monsters.count - 1 {
                monsterIndex = 0
            }
            showMonsters()
        }
    }
    
//    @IBAction func panMonsterPanned(_ sender: UIPanGestureRecognizer) {
//        let point = sender.translation(in: self.view)
//        
//        monsterImagePanel.center = point
//    }
    
    
    @IBAction func tapMonsterTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "presentMonsterStats", sender: self)
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        level = Level(filename: "Levels/\(savedGame.selectedLevel)")
        character = savedGame.characters[savedGame.selectedCharacter]
        
        characterImagePanel.image = UIImage(named: character.image)
        characterName.text = character.name
        showMonsters()
        levelTitleLabel.text = level.title
        totalMovesLabel.text = String(format: "%ld", level.goals.totalMoves)
        totalDamageTakenLable.text = String(format: "%ld", level.goals.totalDamageTaken)
        elapsedTimeLabel.text = DateComponentsFormatter().string(from: level.goals.elapsedTime)
        
        if let levelResults = savedGame.levelResults[savedGame.difficulty.description]![savedGame.selectedLevel] {
            if levelResults.totalMovesCompleteCount > 0 {
                goal1.image = UIImage(named: "Complete_Star")
            }
            if levelResults.totalDamageTakenCompleteCount > 0 {
                goal2.image = UIImage(named: "Complete_Star")
            }
            if levelResults.elapsedTimeCompleteCount > 0 {
                goal3.image = UIImage(named: "Complete_Star")
            }
        }
    }
    
    func showMonsters() {
        let maxMonster = level.monsters.count
        
        monsterImagePanel.image = UIImage(named: level.monsters[monsterIndex].image)
        monsterName.text = level.monsters[monsterIndex].name
        
        var nextMonster = monsterIndex + 1
        
        if maxMonster > 1 {
            if nextMonster > level.monsters.count - 1 {
                nextMonster = 0
            }
            
            monsterImagePanel2.image = UIImage(named: level.monsters[nextMonster].image)
            monsterImagePanel2.isHidden = false
        }
        
        nextMonster += 1
        
        if maxMonster > 2 {
            if nextMonster > level.monsters.count - 1 {
                nextMonster = 0
            }
            monsterImagePanel3.image = UIImage(named: level.monsters[nextMonster].image)
            monsterImagePanel3.isHidden = false
        }

    }
    
    func moveMonster(translation: CGPoint) {
        let oldPoint = monsterImagePanel.center
        let newPoint = CGPoint(x: oldPoint.x + translation.x, y: oldPoint.y)
        monsterImagePanel.center = newPoint
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showGame" {
            let vc = segue.destination as! GameViewController
            vc.savedGame = self.savedGame
        }
        if segue.identifier == "presentCharacterProfile" {
            let vc = segue.destination as! CharacterProfileViewController
            vc.callingView = "preGame"
            vc.character = character
        }
        if segue.identifier == "presentMonsterStats" {
            let vc = segue.destination as! MonsterStatsViewController
            vc.callingView = "preGame"
            vc.monster = self.level.monsters[monsterIndex]
        }
        if segue.identifier == "showStory" {
            let vc = segue.destination as! StoryModeViewController
            vc.savedGame = savedGame
        }
    }
}
