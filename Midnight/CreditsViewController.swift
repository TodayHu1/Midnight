//
//  CreditsViewController.swift
//  MatchRPG
//
//  Created by David Garrett on 8/11/16.
//  Copyright © 2016 David Garrett. All rights reserved.
//

import UIKit
import SpriteKit

class CreditsViewcontroller: UIViewController {
    @IBOutlet weak var backButton: UIButton!
    
    @IBAction func dismissView(_: AnyObject) {
        self.dismiss(animated: false, completion: {})
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
}
