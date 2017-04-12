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
    @IBOutlet weak var friend1Image: UIImageView!
    @IBOutlet weak var friend2Image: UIImageView!
    @IBOutlet weak var friend3Image: UIImageView!
    @IBOutlet weak var friend4Image: UIImageView!
    @IBOutlet weak var friend1Affinity: UILabel!
    @IBOutlet weak var friend2Affinity: UILabel!
    @IBOutlet weak var friend3Affinity: UILabel!
    @IBOutlet weak var friend4Affinity: UILabel!
    @IBOutlet weak var characterClassName: UILabel!
    @IBOutlet weak var characterTokenImage: UIImageView!
    
    var callingView: String = ""
    var character: Character!
    var pageIndex = 0
    
    
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        dismiss(animated: false, completion: {})
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        characterNameLabel.text = character.name
        characterImagePanel.image = UIImage(named: character.image)
        characterHealthLabel.text = String(format: "%ld", character.maxHealth)
        characterStrengthLabel.text = String(format: "%ld", Int(character.strength * 100))
        characterDefenseLabel.text = String(format: "%ld", character.defense)
        characterTokenImage.image = UIImage(named: String(character.token + ".png"))
        characterClassName.text = character.className
        
        displayAffinity()
    }
    
    func displayAffinity () {
        var friendImages = [friend1Image, friend2Image, friend3Image, friend4Image]
        var friendLabels = [friend1Affinity, friend2Affinity, friend3Affinity, friend4Affinity]
        
        var friendKeys = character.affinity.relationships.keys.sorted()
        
        for index in 0..<friendKeys.count {
            let characterName = friendKeys[index]
            friendImages[index]!.image = UIImage(named: characterName)
            friendLabels[index]!.text = String(character.affinity.relationships[characterName]!.score)
        }
    }
}
