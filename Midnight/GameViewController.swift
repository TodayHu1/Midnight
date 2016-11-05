//
//  GameViewController.swift
//  MatchRPG
//
//  Created by David Garrett on 6/21/16.
//  Copyright (c) 2016 David Garrett. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation
import GameKit

class GameViewController: UIViewController {
    var scene: GameScene!
    var level: Level!
    var savedGame: GameSave!
    var character: Character!
    var options: GameOptions = GameOptions()
    var gameOver: Bool = false
    lazy var backgroundMusic: AVAudioPlayer? = self.loadBackgroundMusic()
    var awardedExperience: Int = 0
    var wave: Int = 0
    
    @IBOutlet weak var movesLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var monsterImagePanel: UIImageView!
    @IBOutlet weak var characterImagePanel: UIImageView!
    @IBOutlet weak var comboLabel: UILabel!
    @IBOutlet weak var comboView: UIStackView!


    
    @IBAction func myUnwindAction(_ unwindSegue: UIStoryboardSegue) {
        if unwindSegue.identifier == "dismissDebugMenu" {
            scene.timer.unpause()
            let vc = unwindSegue.source as! DebugMenuViewcontroller
            setInvincibility(vc.invincibleSwitch.isOn)
        }
        
        if unwindSegue.identifier == "unwindPauseMenu" {
            scene.timer.unpause()
            updateOptions()
        }
    }
    
    var tapGestureRecognizer: UITapGestureRecognizer!
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override var shouldAutorotate : Bool {
        return true
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.portrait, UIInterfaceOrientationMask.portraitUpsideDown]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        character = savedGame.characters[savedGame.selectedCharacter]
        options.load()
        setupLevel(selectedLevel: savedGame.selectedLevel)
        configureAudio()
        
        let center = NotificationCenter.default
        
        center.addObserver(self,
                           selector: #selector(UIApplicationDelegate.applicationDidBecomeActive(_:)),
                           name: NSNotification.Name.UIApplicationDidBecomeActive,
                           object: nil)
        
        center.addObserver(self,
                           selector: #selector(UIApplicationDelegate.applicationWillEnterForeground(_:)),
                           name: NSNotification.Name.UIApplicationWillEnterForeground,
                           object: nil)
        
        center.addObserver(self,
                           selector: #selector(UIApplicationDelegate.applicationWillResignActive(_:)),
                           name: NSNotification.Name.UIApplicationWillResignActive,
                           object: nil)
        
        center.addObserver(self,
                           selector: #selector(UIApplicationDelegate.applicationDidEnterBackground(_:)),
                           name: NSNotification.Name.UIApplicationDidEnterBackground,
                           object: nil)

    }
    
    func applicationDidBecomeActive(_ notification : Notification) {
       scene.timer.unpause()
    }
    
    func applicationDidEnterBackground(_ notification : Notification) {
//        NSLog("Application entered background - unload textures!")
    }
    
    func applicationWillEnterForeground(_ notification : Notification) {
//        NSLog("Application will enter foreground - reload " +
//            "any textures that were unloaded")
    }
    
    func applicationWillResignActive(_ notification : Notification) {
        scene.timer.pause()
    }
    
    deinit {
        // Remove this object from the notification center
        NotificationCenter.default
            .removeObserver(self)
    }
    
    func configureAudio() {
        if options.playMusic {
            try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategorySoloAmbient)
            backgroundMusic?.play()
        } else {
            try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
            backgroundMusic?.stop()
        }
    }
    
    func setupLevel(selectedLevel: String) {
        //configure the view
        let skView = view as! SKView
        skView.isMultipleTouchEnabled = false
       
        //create level
        level = Level(filename: "Levels/\(selectedLevel)" )
        
        //create and configure the scene
        scene = GameScene(size: skView.bounds.size)
        scene.setupLevel(level)
        scene.scaleMode = .aspectFill
        scene.options = self.options
        
        scene.swipeHandler = handleSwipe
        
        //present the scene
        skView.presentScene(scene)
        
        beginGame()
    }
    
    func beginGame() {
        
        character.currentHealth = character.maxHealth
        
        updateLabels()
        monsterImagePanel.image = UIImage(named: level.monsters[wave].image)
        characterImagePanel.image = UIImage(named: character.image)
        addMonsterData(unlockKey: level.monsters[wave].unlockKey)
        level.resetComboMultiplier()
        scene.animateBeginGame() {}
        shuffle()
    }
    
    func shuffle(text: String = "", color: UIColor = UIColor.white) {
        scene.removeAllTokenSprites()
        let newTokens = level.shuffle()
        scene.addSpritesForTokens(newTokens)
        if text != "" {
            scene.animateBigText(text: text, color: color)
        }
    }
    
    func hide() {
        
    }
    
    func freeze() {
        
    }
    
    func stun() {
        
    }
    
    func nextWave() {
        wave += 1
        monsterImagePanel.image = UIImage(named: level.monsters[wave].image)
        addMonsterData(unlockKey: level.monsters[wave].unlockKey)
        level.resetComboMultiplier()
        updateLabels()
        scene.animateBigText(text: level.monsters[wave].name)
    }
    
    func handleSwipe(_ swap: Swap) {
        view.isUserInteractionEnabled = false
        
        if level.isPossibleSwap(swap) {
            level.result.totalMoves += 1
            level.performSwap(swap)
            scene.animateSwap(swap, completion: handleMatches)
        } else {
            scene.animateInvalidSwap(swap, completion: {self.view.isUserInteractionEnabled = true})
        }
    }
    
    func handleMatches() {
        let chains = level.removeMatches(character.strength, wave: wave)
        if chains.count == 0 {
            beginNextTurn()
            return
        }
        
        scene.animateMatchedTokens(chains, monster: level.monsters[wave]) {
            for chain in chains {
                self.level.monsters[self.wave].currentHealth -= chain.score
            }
            self.updateLabels()
            let columns = self.level.fillHoles()
            self.scene.animateFallingTokens(columns) {
                let columns = self.level.topUpTokens()
                self.scene.animateNewTokens(columns) {
                    self.handleMatches()
                }
            }
        }
    }
    
    func beginNextTurn() {
        level.resetComboMultiplier()
        level.detectPossibleSwaps()
        if level.noSwaps == true {
            shuffle(text: "Out of Moves")
        }
        decrementMoves()
        self.view.isUserInteractionEnabled = true
    }
    
    func updateLabels() {
        if level.monsters[wave].currentHealth >= 0 {
            scoreLabel.text = String(format: "%ld", level.monsters[wave].currentHealth)
        } else {
            scoreLabel.text = String("0")
        }
        
        if character.invincible == true {
            movesLabel.text = String("∞")
        } else if character.currentHealth >= 0 && character.invincible == false {
            movesLabel.text = String(format: "%ld", character.currentHealth)
            if Double(character.currentHealth) <= (Double(character.maxHealth) * 0.2) {movesLabel.textColor = UIColor(red:1.00, green:0.00, blue:0.00, alpha:1.0)}
        } else {
            movesLabel.text = String("0")
        }
        
        if level.comboMultiplier > 1 {
            comboView.isHidden = false
            comboLabel.text = String(format: "%ld", level.comboMultiplier)
        } else {
            comboView.isHidden = true
        }
    }
    
    func decrementMoves() {
        if level.monsters[wave].currentHealth > 0 {
            // Calculate miss chance
 
            // Calculate monster damage
            var monsterDamage: Double
            let criticalHit: Bool = Int(arc4random_uniform(100)) <= level.monsters[wave].critChance ? true : false
            if criticalHit {
                monsterDamage = (level.monsters[wave].minStrength + level.monsters[wave].varStrength) * 1.2
            } else {
                monsterDamage = (level.monsters[wave].minStrength + round((Double(arc4random_uniform(UInt32(level.monsters[wave].varStrength)))/10))*10)
            }
            
            // Apply difficulty mode multipler to monster damage
            monsterDamage *= savedGame.difficulty.rawValue
            
            // Subtract character defense - convert to INT for easy UX
            let totalDamage = (Int(round(monsterDamage)) - character.defense) > 0 ? (Int(round(monsterDamage)) - character.defense) : 0
            
            // Apply total damage to character and level totals
            if character.invincible == false {
//                let centerPosition = characterImagePanel.center
//                self.scene.animateCharacterDamage(criticalHit, monsterDamage: monsterDamage, centerPosition: centerPosition)
                character.currentHealth -= totalDamage
            }
            
            level.result.totalDamageTaken += totalDamage
            
            // Apply monster regeneration
            level.monsters[wave].currentHealth += level.monsters[wave].regeneration
            if level.monsters[wave].currentHealth > level.monsters[wave].maxHealth {
                level.monsters[wave].currentHealth = level.monsters[wave].maxHealth
            }
            
            // Monster special attack
            if level.monsters[wave].specialAttackChance > 0 {
                let specialAttackSuccess: Bool = Int(arc4random_uniform(100)) <= level.monsters[wave].specialAttackChance ? true : false
                if specialAttackSuccess {
                    switch level.monsters[wave].specialAttack {
                    case .freeze:
                        freeze()
                    case .hide:
                        hide()
                    case .shuffle:
                        shuffle(text: "Chaos!", color: UIColor.red)
                    case .stun:
                        stun()
                    default:
                        assert(false, "Unknown Special Attack type")
                    }
                }
            }
        }
        updateLabels()
        
        if level.monsters[wave].currentHealth <= 0 {
            if wave < level.monsters.count - 1 {
                nextWave()
            } else {
                level.result.elapsedTime = scene.elapsedTime
                saveLevelResults()
                savedGame.save()
                showGameOver()
            }
        } else if character.currentHealth <= 0 {
            level.result.elapsedTime = scene.elapsedTime
            gameOver = true
            saveLevelResults()
            savedGame.save()
            showGameOver()
        }
    }
    
    func showGameOver() {
        self.performSegue(withIdentifier: "showLevelComplete", sender: self)
    }
    
    func updateOptions() {
        options.load()
        scene.options = self.options
        configureAudio()
    }
    
    func saveLevelResults() {
        // Check to see if level goals have been reached and award experience, but only if level is successfully completed
        var checkResult: LevelResult = LevelResult()
        
        if savedGame.levelResults[savedGame.selectedLevel] != nil {
            checkResult = savedGame.levelResults[savedGame.selectedLevel]!
        }

        if gameOver == false {
            
            addQuestData()
            
            if level.result.totalMoves <= level.goals.totalMoves {
                checkResult.totalMovesGoal = true
                awardedExperience += level.rewards.totalMoves
            }
            
            if level.result.totalDamageTaken <= level.goals.totalDamageTaken {
                checkResult.totalDamageTakenGoal = true
                awardedExperience += level.rewards.totalDamageTaken
            }
            
            if level.result.elapsedTime <= level.goals.elapsedTime {
                checkResult.elapsedTimeGoal = true
                awardedExperience += level.rewards.elapsedTime
            }
            
            character.experience += awardedExperience
            if character.experience >= character.nextLevelGoal {
                character.levelUp()
            }
        }
        
        // Take the best results of the saved data or the current level
        if checkResult.totalMoves == 0 || (level.result.totalMoves < checkResult.totalMoves) {
            checkResult.totalMoves = level.result.totalMoves
        }

        if checkResult.totalDamageTaken == 0 || (level.result.totalDamageTaken < checkResult.totalDamageTaken) {
            checkResult.totalDamageTaken = level.result.totalDamageTaken
        }
        
        if checkResult.elapsedTime == 0 || (level.result.elapsedTime < checkResult.elapsedTime) {
            checkResult.elapsedTime = level.result.elapsedTime
        }
        
        savedGame.levelResults[savedGame.selectedLevel] = checkResult
    }
    
    func addQuestData() {
        for item in level.questData {
            savedGame.questData[item.key] = item.value
        }
    }
    
    func addMonsterData(unlockKey: String) {
        savedGame.questData[unlockKey] = true as AnyObject
    }
    
    func loadBackgroundMusic() -> AVAudioPlayer?
    {
        guard let url = Bundle.main.url(forResource: level.music, withExtension: "m4a", subdirectory: "Sounds") else {
            return nil
        }
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.numberOfLoops = -1
            return player
        } catch {
            return nil
        }
    }
    
    func setInvincibility(_ isInvincible: Bool) {
        character.invincible = isInvincible
        
        if isInvincible {
            movesLabel.text = String("∞")
        } else {
            movesLabel.text = String(format: "%ld", character.currentHealth)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "presentDebugMenu" {
            scene.timer.pause()
            let vc = segue.destination as! DebugMenuViewcontroller
            vc.totalMoves = self.level.result.totalMoves
            vc.totalDamageTaken = self.level.result.totalDamageTaken
            vc.invincible = character.invincible
        }
        if segue.identifier == "presentPauseMenu" {
            scene.timer.pause()
            let vc = segue.destination as! PauseViewController
            vc.options = self.options
        }
        if segue.identifier == "showLevelComplete" {
            let vc = segue.destination as! LevelCompleteViewController
            vc.level = self.level
            vc.gameOver = self.gameOver
            vc.savedGame = self.savedGame
            vc.awardedExperience = self.awardedExperience
        }
        if segue.identifier == "presentCharacterProfile" {
            let vc = segue.destination as! CharacterProfileViewController
            vc.character = character
        }
        if segue.identifier == "presentMonsterStats" {
            let vc = segue.destination as! MonsterStatsViewController
            vc.callingView = "game"
            vc.monster = self.level.monsters[wave]
        }
    }
}
