//
//  LevelCompleteViewController.swift
//  MatchRPG
//
//  Created by David Garrett on 8/28/16.
//  Copyright © 2016 David Garrett. All rights reserved.
//

import Foundation
import UIKit

class LevelCompleteViewController: UIViewController {
    @IBOutlet weak var gameOverPanel: UIImageView!
    
    @IBOutlet weak var totalMovesGoal: UILabel!
    @IBOutlet weak var damageTakenGoal: UILabel!
    @IBOutlet weak var elapsedTimeGoal: UILabel!
    @IBOutlet weak var totalMovesResult: UILabel!
    @IBOutlet weak var damageTakenResult: UILabel!
    @IBOutlet weak var elapsedTimeResult: UILabel!
    @IBOutlet weak var currentLevel: UILabel!
    @IBOutlet weak var nextLevel: UILabel!

    @IBOutlet weak var goal1: UIImageView!
    @IBOutlet weak var goal2: UIImageView!
    @IBOutlet weak var goal3: UIImageView!
    
    @IBOutlet weak var experienceProgress: UIProgressView!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var retryButton: UIButton!
    
    @IBAction func continueButtonPressed() {
        if gameOver {
            performSegue(withIdentifier: "showMainMenu", sender: self)
        } else {
            performSegue(withIdentifier: "showStoryMode", sender: self)
        }
    }
    
    var savedGame: GameSave!
    var level: Level!
    var gameOver: Bool = false
    var awardedExperience: Int = 0

    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if gameOver {
            gameOverPanel.image = UIImage(named: "Game Over")
            
            totalMovesGoal.text = String(format: "%ld", level.goals.totalMoves)
            damageTakenGoal.text = String(format: "%ld", level.goals.totalDamageTaken)
            elapsedTimeGoal.text = DateComponentsFormatter().string(from: level.goals.elapsedTime)
            
            totalMovesResult.text = String(format: "%ld", level.result.totalMoves)
            damageTakenResult.text = String(format: "%ld", level.result.totalDamageTaken)
            elapsedTimeResult.text = DateComponentsFormatter().string(from: level.result.elapsedTime)
            
            goal1.isHidden = true
            goal2.isHidden = true
            goal3.isHidden = true
        } else {
            gameOverPanel.image = UIImage(named: "Level Complete")
            
            totalMovesGoal.text = String(format: "%ld", level.goals.totalMoves)
            damageTakenGoal.text = String(format: "%ld", level.goals.totalDamageTaken)
            elapsedTimeGoal.text = DateComponentsFormatter().string(from: level.goals.elapsedTime)
            
            totalMovesResult.text = String(format: "%ld", level.result.totalMoves)
            damageTakenResult.text = String(format: "%ld", level.result.totalDamageTaken)
            elapsedTimeResult.text = DateComponentsFormatter().string(from: level.result.elapsedTime)
            
            if level.result.totalMoves <= level.goals.totalMoves {goal1.image = UIImage(named: "goal complete")}
            if level.result.totalDamageTaken <= level.goals.totalDamageTaken {goal2.image = UIImage(named: "goal complete")}
            if level.result.elapsedTime <= level.goals.elapsedTime {goal3.image = UIImage(named: "goal complete")}
            
            if awardedExperience > 0 {
                let progressPercentage = Float(savedGame.character.experience - savedGame.character.previousLevelGoal) / Float(savedGame.character.nextLevelGoal - savedGame.character.previousLevelGoal)
                experienceProgress.setProgress(progressPercentage, animated: true)
                currentLevel.text = String(format: "Level %ld", savedGame.character.level)
                nextLevel.text = String(format: "Level %ld", savedGame.character.level + 1)
            } else {
                experienceProgress.isHidden = true
                currentLevel.isHidden = true
                nextLevel.isHidden = true
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showStoryMode" {
            let vc = segue.destination as! StoryModeViewController
            vc.savedGame = savedGame
        }
        if segue.identifier == "showPreGame" {
            let vc = segue.destination as! PreGameViewController
            vc.savedGame = savedGame
        }
    }
}
