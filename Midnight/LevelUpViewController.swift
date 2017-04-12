//
//  LevelUpViewController.swift
//  Midnight
//
//  Created by David Garrett on 11/5/16.
//  Copyright © 2016 David Garrett. All rights reserved.
//

import Foundation
import UIKit

class LevelUpViewController : UIViewController {
    var savedGame : GameSave!
    var character : Character!
    
    @IBOutlet weak var characterProfile: UIImageView!
    @IBOutlet weak var healthReward: UILabel!
    @IBOutlet weak var strengthReward: UILabel!
    @IBOutlet weak var defenseReward: UILabel!
    @IBOutlet weak var healthNew: UILabel!
    @IBOutlet weak var strengthNew: UILabel!
    @IBOutlet weak var defenseNew: UILabel!
    @IBOutlet weak var nextLevelGoal: UILabel!
    @IBOutlet weak var okButton: UIButton!

    @IBAction func okButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: {})
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        character = savedGame.characters[savedGame.selectedCharacter]
        
        characterProfile.image = UIImage(named: character.image)
        
//        let filename = "Character_Progression"
//        guard let dictionary = [String: AnyObject].loadJSONFromBundle(filename) else {return}
        
//        let levels = dictionary["levels"] as! [[String: AnyObject]]
        
//        nextLevelGoal.text = String(format: "%ld", character.nextLevelGoal)
//        let rewards = levels[character.level-1]["rewards"] as! [String: AnyObject]
//        defenseReward.text = String(format: "+%ld", rewards["defense"] as! Int)
//        strengthReward.text = String(format: "+%ld", Int(rewards["strength"] as! Double * 100))
//        healthReward.text = String(format: "+%ld", rewards["health"] as! Int)
//        
//        healthNew.text = String(format: "%ld", character.maxHealth)
//        strengthNew.text = String(format: "%ld", Int(character.strength * 100))
//        defenseNew.text = String(format: "%ld", character.defense)
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showStory" {
            let vc = segue.destination as! StoryModeViewController
            vc.savedGame = savedGame
        }
    }
}
