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
    @IBOutlet weak var goal1: UIImageView!
    @IBOutlet weak var goal2: UIImageView!
    @IBOutlet weak var goal3: UIImageView!
    
    @IBOutlet weak var totalStars: UILabel!
    @IBOutlet weak var awardedStarsLabel: UILabel!
    @IBOutlet weak var awardedStarsView: UIStackView!
    
    @IBOutlet weak var supportView1: UIStackView!
    @IBOutlet weak var supportView2: UIStackView!
    @IBOutlet weak var supportView3: UIStackView!
    @IBOutlet weak var supportView4: UIStackView!
    @IBOutlet weak var supportImage1: UIImageView!
    @IBOutlet weak var supportImage2: UIImageView!
    @IBOutlet weak var supportImage3: UIImageView!
    @IBOutlet weak var supportImage4: UIImageView!
    @IBOutlet weak var supportLabel1: UILabel!
    @IBOutlet weak var supportLabel2: UILabel!
    @IBOutlet weak var supportLabel3: UILabel!
    @IBOutlet weak var supportLabel4: UILabel!
    
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
    private var character: Character!
    var level: Level!
    var gameOver: Bool = false
    var awardedStars: Int = 0
    var affinity: [SupportCharacter]?
    var levelUp: Bool = false

    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        character = savedGame.characters[savedGame.selectedCharacter]
        
        totalStars.text = String(savedGame.stars)
        
        totalMovesGoal.text = String(format: "%ld", level.goals.totalMoves)
        damageTakenGoal.text = String(format: "%ld", level.goals.totalDamageTaken)
        elapsedTimeGoal.text = DateComponentsFormatter().string(from: level.goals.elapsedTime)
        
        totalMovesResult.text = String(format: "%ld", level.result.totalMoves)
        damageTakenResult.text = String(format: "%ld", level.result.totalDamageTaken)
        elapsedTimeResult.text = DateComponentsFormatter().string(from: level.result.elapsedTime)
        
        if level.result.totalMoves <= level.goals.totalMoves {goal1.image = UIImage(named: "Complete_Star")}
        if level.result.totalDamageTaken <= level.goals.totalDamageTaken {goal2.image = UIImage(named: "Complete_Star")}
        if level.result.elapsedTime <= level.goals.elapsedTime {goal3.image = UIImage(named: "Complete_Star")}
        
        if awardedStars > 0 {
            awardedStarsView.isHidden = false
            awardedStarsLabel.text = String(format: "+%ld", awardedStars)
        }
        
        let supportViews = [supportView1, supportView2, supportView3, supportView4]
        let supportImages = [supportImage1, supportImage2, supportImage3, supportImage4]
        let supportLabels = [supportLabel1, supportLabel2, supportLabel3, supportLabel4]
        
        for index in 0..<affinity!.count {
            supportViews[index]!.isHidden = false
            supportImages[index]!.image = UIImage(named: affinity![index].name)
            supportLabels[index]!.text = String(affinity![index].uses)
        }
        
//        if awardedExperience > 0 {
//            currentLevel.text = String(format: "Level %ld", character.level)
//            nextLevel.text = String(format: "Level %ld", character.level + 1)
//            
//            //set base experience on progress bar for animation purposes
//            let previousExperience = character.experience - awardedExperience
//            let basePercentage = Float(previousExperience - character.previousLevelGoal) / Float(character.nextLevelGoal - character.previousLevelGoal)
//            experienceProgress.setProgress(basePercentage, animated: false)
//            
//        } else {
//            experienceProgress.isHidden = true
//            currentLevel.isHidden = true
//            nextLevel.isHidden = true
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        //animate stars
//        let baseNumber = savedGame.stars - awardedStars
//        totalStars.text = String(baseNumber)
//        
//        for index in 0...awardedStars {
//            totalStars.text = String(baseNumber + index)
//        }
        
         //animate experience progress
//        let progressPercentage = Float(character.experience - character.previousLevelGoal) / Float(character.nextLevelGoal - character.previousLevelGoal)
//        experienceProgress.setProgress(progressPercentage, animated: true)
//        
//        if levelUp {
//            levelUp = false
//            self.performSegue(withIdentifier: "presentLevelUp", sender: self)
//        }
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
        if segue.identifier == "presentLevelUp" {
            let vc = segue.destination as! LevelUpViewController
            vc.savedGame = savedGame
        }
    }
}
