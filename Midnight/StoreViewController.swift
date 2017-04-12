//
//  StoreViewController.swift
//  Midnight
//
//  Created by David Garrett on 4/11/17.
//  Copyright © 2017 David Garrett. All rights reserved.
//

import Foundation
import UIKit
import KCFloatingActionButton

class StoreViewController: UIViewController {
    var savedGame: GameSave!
    
    @IBOutlet weak var menuButton: KCFloatingActionButton!
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        totalStars.text = String(savedGame.stars)
        
        renderMenuButton(currentButton: 3)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showStory" {
            let vc = segue.destination as! StoryHubViewController
            vc.savedGame = savedGame
        }
        if segue.identifier == "showCharacter" {
            let vc = segue.destination as! CharacterCollectionViewController
            vc.savedGame = savedGame
        }
        if segue.identifier == "showSettings" {
            let vc = segue.destination as! OptionsViewcontroller
            vc.savedGame = savedGame
        }
        if segue.identifier == "showInventory" {
            let vc = segue.destination as! InventoryViewController
            vc.savedGame = savedGame
        }
        if segue.identifier == "showStore" {
            let vc = segue.destination as! StoreViewController
            vc.savedGame = savedGame
        }
    }
    
    func renderMenuButton(currentButton: Int) {
        let imageArray = ["Book", "Character", "Inventory", "Store", "Settings"]
        let segueArray = ["showStory", "showCharacter", "showInventory", "showStore", "showSettings"]
        
        let color = UIColor(red:0.27, green:0.00, blue:0.40, alpha:1.0)
        let selectedColor = UIColor.gray
        menuButton.openAnimationType = .pop
        menuButton.buttonImage = UIImage(named: "T")
        
        for index in 0..<imageArray.count {
            let item = KCFloatingActionButtonItem()
            item.icon = UIImage(named: imageArray[index])
            if index == currentButton {
                item.buttonColor = selectedColor
            } else {
                item.buttonColor = color
                item.handler = {item in self.performSegue(withIdentifier: segueArray[index], sender: self)}
            }
            
            menuButton.addItem(item: item)
        }
    }
    
}
