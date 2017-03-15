//
//  OptionsViewController.swift
//  MatchRPG
//
//  Created by David Garrett on 8/11/16.
//  Copyright © 2016 David Garrett. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation

class OptionsViewcontroller: UIViewController {
    var options: GameOptions = GameOptions()
    var callingView: String = ""
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var soundsSwitch: UISwitch!
    @IBOutlet weak var musicSwitch: UISwitch!
    
    @IBAction func backButtonPressed() {
        self.options.playSounds = soundsSwitch.isOn
        self.options.playMusic = musicSwitch.isOn
        
        self.options.save()
        
        switch callingView {
            case "mainMenu":
                performSegue(withIdentifier: "unwindOptionsMenuToMainMenu", sender: self)
            case "pauseMenu":
                performSegue(withIdentifier: "unwindOptionsMenuToPauseMenu", sender: self)
        default:
            dismiss(animated: true, completion: {})
        }
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        options.load()
        
        soundsSwitch.isOn = self.options.playSounds
        musicSwitch.isOn = self.options.playMusic
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    

    
}
