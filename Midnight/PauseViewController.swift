//
//  PauseViewController.swift
//  MatchRPG
//
//  Created by David Garrett on 8/10/16.
//  Copyright © 2016 David Garrett. All rights reserved.
//


import UIKit
import SpriteKit
import AVFoundation

class PauseViewController: UIViewController {
    var options: GameOptions = GameOptions()
    var returnView: String = ""
    
    @IBOutlet weak var pauseButton: UIButton!
    
    @IBAction func pauseMenuUnwindAction(_ unwindSegue: UIStoryboardSegue) {

    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "presentOptionsMenu" {
            let vc = segue.destination as! OptionsViewcontroller
            vc.callingView = "pauseMenu"
        }
    }
}
