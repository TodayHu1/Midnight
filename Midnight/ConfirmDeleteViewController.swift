//
//  ConfirmDeleteViewController.swift
//  MatchRPG
//
//  Created by David Garrett on 8/22/16.
//  Copyright © 2016 David Garrett. All rights reserved.
//

import UIKit
import SpriteKit

class ConfirmDeleteViewController: UIViewController {
    var saveSlot: Int = 0
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBAction func dismissView(_: AnyObject) {
        self.dismiss(animated: false, completion: {})
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! SaveMenuViewcontroller
        vc.saveSlot = self.saveSlot
    }
    
}
