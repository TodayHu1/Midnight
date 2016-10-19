//
//  ProgressViewController.swift
//  MatchRPG
//
//  Created by David Garrett on 8/31/16.
//  Copyright © 2016 David Garrett. All rights reserved.
//

import Foundation
import UIKit

class ProgressViewController: UIViewController {
    @IBOutlet weak var progressMap: UIScrollView!
    @IBOutlet weak var progressMapImage: UIImageView!
    @IBOutlet weak var backButton: UIButton!

    @IBAction func backButtonPressed(_ sender: AnyObject) {
        dismiss(animated: true, completion: {})
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressMapImage.image = UIImage(named: "villageofbarovia.png")
        
    }
    
}
