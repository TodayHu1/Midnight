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
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var monsterDescription: UITextView!
    
    @IBOutlet weak var specialAbilities: UITextView!
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
        specialAbilities.text = monster.specialAbilities
    }
}
