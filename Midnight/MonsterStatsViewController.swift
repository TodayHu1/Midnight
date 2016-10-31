//
//  MonsterStatsViewController.swift
//  Midnight
//
//  Created by David Garrett on 9/21/16.
//  Copyright © 2016 David Garrett. All rights reserved.
//

import Foundation
import UIKit

class MonsterStatsViewController: UIViewController {
    
    @IBOutlet weak var monsterNameLabel: UILabel!
    @IBOutlet weak var monsterImagePanel: UIImageView!
    @IBOutlet weak var monsterHealthLabel: UILabel!
    @IBOutlet weak var monsterStrengthLabel: UILabel!
    @IBOutlet weak var monsterCriticalLabel: UILabel!
    @IBOutlet weak var monsterRegeneration: UIImageView!
    @IBOutlet weak var monsterRegenerationLabel: UILabel!
    @IBOutlet weak var monsterVulnerability: UIImageView!
    @IBOutlet weak var monsterVulnerabilityLabel: UILabel!
    @IBOutlet weak var monsterResistance: UIImageView!
    @IBOutlet weak var monsterResistanceLabel: UILabel!
    @IBOutlet weak var monsterDescription: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var specialAbilityLabel: UILabel!
    
    var callingView: String = ""
    var monster: Monster!
    
    
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        dismiss(animated: true, completion: {})
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        monsterNameLabel.text = monster.name
        monsterDescription.text = monster.description
        monsterImagePanel.image = UIImage(named: monster.image)
        monsterHealthLabel.text = String(format: "%ld", monster.maxHealth)
        monsterStrengthLabel.text = String(format: "%ld - %ld", Int(monster.minStrength), Int(monster.minStrength + monster.varStrength))
        monsterCriticalLabel.text = String(format: "%ld%%", monster.critChance)
        if monster.regeneration > 0 {
            monsterRegenerationLabel.text = String(format: "%ld / turn", monster.regeneration)
        } else {
            monsterRegeneration.isHidden = true
            monsterRegenerationLabel.isHidden = true
        }
        
        if monster.vulnerability != TokenType.unknown {
            monsterVulnerability.image = UIImage(named: monster.vulnerability.spriteName)
        } else {
            monsterVulnerability.isHidden = true
        }
        
        if monster.resistance != TokenType.unknown {
            monsterResistance.image = UIImage(named: monster.resistance.spriteName)
        } else {
            monsterResistance.isHidden = true
        }

        specialAbilityLabel.text = monster.specialAbilities
    }
}
