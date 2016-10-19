//
//  DebugMenuViewController.swift
//  MatchRPG
//
//  Created by David Garrett on 8/15/16.
//  Copyright © 2016 David Garrett. All rights reserved.
//
import UIKit
import SpriteKit

class DebugMenuViewcontroller: UIViewController {
    var totalMoves: Int = 0
    var totalDamageTaken: Int = 0
    var invincible: Bool = false
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var invincibleSwitch: UISwitch!
    @IBOutlet weak var movesLabel: UILabel!
    @IBOutlet weak var totalDamageLabel: UILabel!
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movesLabel.text = String(format: "%ld", self.totalMoves)
        totalDamageLabel.text = String(format: "%ld", self.totalDamageTaken)
        invincibleSwitch.isOn = self.invincible

    }

}

