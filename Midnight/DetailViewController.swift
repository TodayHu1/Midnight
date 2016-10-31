//
//  DetailViewController.swift
//  Midnight
//
//  Created by David Garrett on 9/22/16.
//  Copyright © 2016 David Garrett. All rights reserved.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {
    var data: EncyclopediaEntry!

    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var backButton: UIButton!

    @IBAction func backButtonPressed(_ sender: AnyObject) {
        dismiss(animated: false, completion: {})
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadText()

    }
    
    private func loadText() {
        if let filepath = Bundle.main.path(forResource: data.detailFile, ofType: "txt") {
            do {
                let entryText = try String(contentsOfFile: filepath)
                detailTextView.text = entryText
            } catch {
                print("Can't load file \(data.detailFile)")
                print(error.localizedDescription)
                return
            }
        } else {
            print("The file \(data.detailFile) was not found.")
        }

    }
}
