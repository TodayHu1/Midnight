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
    @IBOutlet weak var credits: UITextView!
    
    @IBAction func dismissView(_: AnyObject) {
        self.dismiss(animated: false, completion: {})
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadText()
        
    }
    
    private func loadText() {
        if let filepath = Bundle.main.path(forResource: "credits", ofType: "txt") {
            do {
                let entryText = try String(contentsOfFile: filepath)
                credits.text = entryText
            } catch {
                print("Can't load credits.")
                print(error.localizedDescription)
                return
            }
        } else {
            print("The file credits.txt was not found.")
        }
        
    }
}
