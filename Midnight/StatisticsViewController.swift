//
//  StatisticsViewController.swift
//  Midnight
//
//  Created by David Garrett on 9/27/16.
//  Copyright © 2016 David Garrett. All rights reserved.
//

import Foundation
import UIKit

class StatisticsViewController : UIViewController {
    @IBOutlet weak var percentCompleteLabel: UILabel!
    @IBOutlet weak var totalMovesLabel: UILabel!
    @IBOutlet weak var totalDamageTakenLabel: UILabel!
    @IBOutlet weak var elapsedTimeLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        dismiss(animated: true, completion: {})
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tc = self.tabBarController as! CharacterManagementTabController
        
        totalMovesLabel.text = String(format: "%ld", tc.savedGame.totalMoves)
        totalDamageTakenLabel.text = String(format: "%ld", tc.savedGame.totalDamageTaken)
        elapsedTimeLabel.text = DateComponentsFormatter().string(from: tc.savedGame.elapsedtime)
        
    }
    
}
