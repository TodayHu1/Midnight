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
import Firebase

class GameViewController: UIViewController {
    var scene: GameScene!
    var level: Level!
    var savedGame: GameSave!
    var character: Character!
    var options: GameOptions = GameOptions()
    var gameOver: Bool = false
    lazy var backgroundMusic: AVAudioPlayer? = self.loadBackgroundMusic()
    var awardedStars: Int = 0
//    var levelUp: Bool = false
    var wave: Int = 0
    var shieldCount: Int = 0
    var teamStrength: Int = 0
    var supportCharacters: [SupportCharacter] = [SupportCharacter]()
    var supportTokens: [TokenType: Int] = [TokenType: Int]()
    var targetMultiplier: Double = 1
    
    @IBOutlet weak var movesLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var monsterImagePanel: UIImageView!
    @IBOutlet weak var characterImagePanel: UIImageView!
    @IBOutlet weak var comboLabel: UILabel!
    @IBOutlet weak var comboView: UIStackView!
    @IBOutlet weak var comboBackground: UIImageView!
    @IBOutlet weak var countdownLabel: UILabel!
    @IBOutlet weak var countdownView: UIStackView!
    @IBOutlet weak var countdownBackground: UIImageView!
    @IBOutlet weak var characterName: UILabel!
    @IBOutlet weak var monsterName: UILabel!
    @IBOutlet weak var support1: UIButton!
    @IBOutlet weak var support2: UIButton!
    @IBOutlet weak var support3: UIButton!
    @IBOutlet weak var support4: UIButton!
    @IBOutlet weak var support1Progress: UIProgressView!
    @IBOutlet weak var support2Progress: UIProgressView!
    @IBOutlet weak var support3Progress: UIProgressView!
    @IBOutlet weak var support4Progress: UIProgressView!
    @IBOutlet weak var support1View: UIView!
    @IBOutlet weak var support2View: UIView!
    @IBOutlet weak var support3View: UIView!
    @IBOutlet weak var support4View: UIView!
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var targetView: UIView!
    @IBOutlet weak var shieldLabel: UILabel!
    @IBOutlet weak var shieldView: UIView!
    @IBOutlet weak var supportImage1: UIImageView!
    @IBOutlet weak var supportImage2: UIImageView!
    @IBOutlet weak var supportImage3: UIImageView!
    @IBOutlet weak var supportImage4: UIImageView!
    
    @IBAction func myUnwindAction(_ unwindSegue: UIStoryboardSegue) {

    }
    
    @IBAction func supportButtonPressed(_ sender: UIButton) {
        var index: Int
        var supportProgress = [support1Progress, support2Progress, support3Progress, support4Progress]
        var supportImages = [supportImage1, supportImage2, supportImage3, supportImage4]
        
        switch sender {
        case support2:
            index = 1
        case support3:
            index = 2
        case support4:
            index = 3
        default:
            index = 0
        }
        
        supportCharacters[index].uses += 1
        supportProgress[index]!.progress = 0
        supportCharacters[index].currentMana = 0
        supportImages[index]!.alpha = 0.5
        sender.isEnabled = false
        
        executeCharacterPower(character: supportCharacters[index].name)
        
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
//        if options.playMusic {
//            try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategorySoloAmbient)
//            backgroundMusic?.play()
//        } else {
//            try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
//            backgroundMusic?.stop()
//        }
    }
    
    func setupLevel(selectedLevel: String) {
        //configure the view
        let skView = view as! SKView
        skView.isMultipleTouchEnabled = false
       
        //create level
        level = Level(filename: "Levels/\(selectedLevel)" )
        configureSupportButtons()
        
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
    
    func configureSupportButtons() {
        var supportView = [support1View, support2View, support3View, support4View]
        var supportProgress = [support1Progress, support2Progress, support3Progress, support4Progress]
        var supportButtons = [support1, support2, support3, support4]
        var supportImages = [supportImage1, supportImage2, supportImage3, supportImage4]
        
        if level.supportCharacters != nil {
            for item in level.supportCharacters! {
                if item != character.name {
                    let newCharacter = SupportCharacter()
                    newCharacter.name = item
                    
                    supportCharacters.append(newCharacter)
                }
            }
        } else {
            for item in savedGame.characters {
                if item.key != character.name {
                    let newCharacter = SupportCharacter()
                    newCharacter.name = item.key
                    
                    supportCharacters.append(newCharacter)
                }
            }
        }
        
        for index in 0..<supportCharacters.count {
            let characterName = supportCharacters[index].name
            supportButtons[index]!.setImage(UIImage(named: savedGame.characters[characterName]!.image), for: UIControlState.normal)
            supportButtons[index]!.isEnabled = false
            supportProgress[index]!.progress = 0
            supportView[index]!.isHidden = false
            supportImages[index]!.image = UIImage(named: savedGame.characters[characterName]!.supportPower.image)
            let tokenType = TokenType.createFromString(savedGame.characters[characterName]!.token)
            supportTokens[tokenType] = index
        }
    }
    
    func beginGame() {
        
        character.currentHealth = character.maxHealth
        teamStrength = savedGame.teamStrength
        
        updateLabels()
        monsterImagePanel.image = UIImage(named: level.monsters[wave].image)
        monsterName.text = level.monsters[wave].name
        characterImagePanel.image = UIImage(named: character.image)
        characterName.text = character.name
        addMonsterData(unlockKey: level.monsters[wave].unlockKey)
        level.resetComboMultiplier()
        scene.animateBeginGame() {}
        shuffle()
    }
    
    func shuffle(text: String = "", color: UIColor = UIColor.white) {
        scene.removeAllTokenSprites()
        let newTokens = level.shuffle()
        scene.addSpritesForTokens(tokens: newTokens)
        if text != "" {
            scene.animateBigText(text: text, color: color)
        }
    }
    
    
    func nextWave() {
        wave += 1
        monsterImagePanel.image = UIImage(named: level.monsters[wave].image)
        monsterName.text = level.monsters[wave].name
        addMonsterData(unlockKey: level.monsters[wave].unlockKey)
        level.resetComboMultiplier()
        updateLabels()
        scene.animateBigText(text: String(format: "Wave %ld", wave + 1))
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
        let attackStrength = (character.strength + (Double(teamStrength) / 100)) * targetMultiplier
        let matchResults = level.removeMatches(strength: attackStrength, wave: wave)
        if matchResults.count == 0 {
            beginNextTurn()
            return
        } else {
            targetMultiplier = 1
            targetView.isHidden = true
        }

        scene.animateMatchedTokens(matchResults, monster: level.monsters[wave]) {
            for chain in matchResults {
                self.updateMana(chain: chain)
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
    
    func updateMana(chain: Chain) {
        let supportProgress: [UIProgressView] = [support1Progress, support2Progress, support3Progress, support4Progress]
        let supportButtons: [UIButton] = [support1, support2, support3, support4]
        let supportImages: [UIImageView] = [supportImage1, supportImage2, supportImage3, supportImage4]
        if let index: Int = supportTokens[chain.firstToken().tokenType] {
            
            supportCharacters[index].currentMana += chain.score
            
            var progress: Float = Float(supportCharacters[index].currentMana) / Float(supportCharacters[index].targetMana)
            if progress > 1 { progress = 1 }
            
            supportProgress[index].setProgress(progress, animated: true)
            
            if progress >= 1 {
                supportButtons[index].isEnabled = true
                supportImages[index].alpha = 1.0
            }
            
        }
    }
    
    func decrementShield() {
        shieldCount -= 1
        if shieldCount > 0 {
            shieldLabel.text = String(shieldCount)
        } else {
            shieldView.isHidden = true
        }
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
            if Double(character.currentHealth) <= (Double(character.maxHealth) * 0.2) {movesLabel.textColor = UIColor.red}
        } else {
            movesLabel.text = String("0")
        }
        
        if level.comboMultiplier > 1 {
            comboView.isHidden = false
            comboBackground.isHidden = false
            comboLabel.text = String(format: "%ld", level.comboMultiplier)
        } else {
            comboView.isHidden = true
            comboBackground.isHidden = true
        }
        
        if level.countdown > 0 {
            countdownView.isHidden = false
            countdownBackground.isHidden = false
            countdownLabel.text = String(format: "%ld", level.countdown)
        } else {
            countdownView.isHidden = true
            countdownBackground.isHidden = true
        }
    }
    
    func decrementMoves() {
        if level.monsters[wave].currentHealth > 0 {
            // Calculate miss chance
 
            // Calculate poison damage
            let poisonTokens = level.poisonTokens()
            let poisonStrength = Int(level.monsters[wave].varStrength)
            var poisonDamage: Int = 0
            
            for token in poisonTokens {
                scene.animatePoisonDamage(token: token, strength: poisonStrength)
                poisonDamage += poisonStrength
            }

            character.currentHealth -= poisonDamage
            level.result.totalDamageTaken += poisonDamage
            
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
            if shieldCount > 0 {
                decrementShield()
            } else {
                character.currentHealth -= totalDamage
                level.result.totalDamageTaken += totalDamage
            }
            
            // Apply monster regeneration
            level.monsters[wave].currentHealth += level.monsters[wave].regeneration
            if level.monsters[wave].currentHealth > level.monsters[wave].maxHealth {
                level.monsters[wave].currentHealth = level.monsters[wave].maxHealth
            }
            
            // Monster special attack
            if level.countdown == 1 {
                level.countdown -= 1
                executeSpecialAttack()
            } else if level.countdown > 1 {
                level.countdown -= 1
            }
            
            if level.monsters[wave].specialAttackChance > 0 && level.countdown == 0 {
                let specialAttackSuccess: Bool = Int(arc4random_uniform(100)) <= level.monsters[wave].specialAttackChance ? true : false
                if specialAttackSuccess {
                    if level.monsters[wave].specialAttackCountdown == 0 {
                    executeSpecialAttack()
                    } else {
                        level.countdown = level.monsters[wave].specialAttackCountdown
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
                showLevelOver(gameOver: false)
            }
        } else if character.currentHealth <= 0 {
            level.result.elapsedTime = scene.elapsedTime
            gameOver = true
            saveLevelResults()
            savedGame.save()
            showLevelOver(gameOver: true)
        }
    }
    
    func showLevelOver(gameOver: Bool) {
        if gameOver {
            self.performSegue(withIdentifier: "showGameOver", sender: self)
        } else {
            self.performSegue(withIdentifier: "showLevelComplete", sender: self)
        }
    }
    
    func updateOptions() {
        options.load()
        scene.options = self.options
        configureAudio()
    }
    
    func saveLevelResults() {
        // Check to see if level goals have been reached and award experience, but only if level is successfully completed
        var checkResult: LevelResult = LevelResult()
        
        if savedGame.levelResults[savedGame.difficulty.description]![savedGame.selectedLevel] != nil {
            checkResult = savedGame.levelResults[savedGame.difficulty.description]![savedGame.selectedLevel]!
        }

        if gameOver == false {
            
            addQuestData()
            addAffinity()
            
            if level.result.totalMoves <= level.goals.totalMoves {
                checkResult.totalMovesCompleteCount += 1
                awardedStars += Int(Double(level.rewards.totalMoves) * savedGame.difficulty.rawValue / Double(checkResult.totalMovesCompleteCount))
            }
            
            if level.result.totalDamageTaken <= level.goals.totalDamageTaken {
                checkResult.totalDamageTakenCompleteCount += 1
                awardedStars += Int(Double(level.rewards.totalDamageTaken) * savedGame.difficulty.rawValue / Double(checkResult.totalDamageTakenCompleteCount))
            }
            
            if level.result.elapsedTime <= level.goals.elapsedTime {
                checkResult.elapsedTimeCompleteCount += 1
                awardedStars += Int(Double(level.rewards.elapsedTime) * savedGame.difficulty.rawValue / Double(checkResult.elapsedTimeCompleteCount))
            }
            
            savedGame.stars += awardedStars
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
        
        savedGame.levelResults[savedGame.difficulty.description]![savedGame.selectedLevel] = checkResult
        FIRAnalytics.logEvent(withName: "level_complete", parameters: ["name": level.title as NSObject, "total_moves": level.result.totalMoves as NSObject, "total_damage_taken": level.result.totalDamageTaken as NSObject, "elapsed_time": level.result.elapsedTime as NSObject])
    }
    
    func addQuestData() {
        for item in level.questData {
            savedGame.questData[item.key] = item.value
        }
    }
    
    func addAffinity() {
        for item in self.supportCharacters {
            savedGame.characters[character.name]!.affinity.relationships[item.name]!.modify(by: item.uses)
            savedGame.characters[item.name]!.affinity.relationships[character.name]!.modify(by: item.uses)
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
        if segue.identifier == "showLevelComplete" {
            let vc = segue.destination as! LevelCompleteViewController
            vc.level = self.level
            vc.gameOver = self.gameOver
            vc.savedGame = self.savedGame
            vc.awardedStars = self.awardedStars
            vc.affinity = self.supportCharacters
//            vc.levelUp = self.levelUp
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
        if segue.identifier == "showGameOver" {
            let vc = segue.destination as! GameOverViewController
            vc.savedGame = savedGame
            vc.monster = level.monsters[wave]
        }
    }
}
