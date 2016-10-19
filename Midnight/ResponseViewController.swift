//
//  ResponseViewController.swift
//  Midnight
//
//  Created by David Garrett on 9/29/16.
//  Copyright © 2016 David Garrett. All rights reserved.
//

import Foundation
import UIKit

class ResponseViewController: UIViewController {
    var level: Level!
    var savedGame: GameSave!
    
    @IBOutlet weak var response1: UIImageView!
    @IBOutlet weak var response2: UIImageView!
    @IBOutlet weak var response3: UIImageView!
    @IBOutlet weak var response4: UIImageView!
    @IBOutlet var tap1: UITapGestureRecognizer!
    @IBOutlet var tap2: UITapGestureRecognizer!
    @IBOutlet var tap3: UITapGestureRecognizer!
    @IBOutlet var tap4: UITapGestureRecognizer!
    @IBOutlet weak var dialogueLabel: UILabel!
    
    @IBAction func responseTapped(_ sender: UITapGestureRecognizer) {
        let response: String = ""
        
//        switch sender {
//        case tap1:
//            response = swnder.
//        }
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
