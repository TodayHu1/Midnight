//
//  GameOverViewController.swift
//  Midnight
//
//  Created by David Garrett on 11/5/16.
//  Copyright © 2016 David Garrett. All rights reserved.
//

import Foundation
import UIKit

class GameOverViewController: UIViewController {
    @IBOutlet weak var gameOverPanel: UIImageView!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var retryButton: UIButton!
    @IBOutlet weak var gameOverText: UILabel!
    
    var savedGame: GameSave!
    var monster: Monster!
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if monster.gameOverText != nil {
            gameOverText.text = monster.gameOverText
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPreGame" {
            let vc = segue.destination as! PreGameViewController
            vc.savedGame = savedGame
        }
    }
}

