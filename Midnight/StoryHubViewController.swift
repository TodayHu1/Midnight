//
//  StoryHub.swift
//  Midnight
//
//  Created by David Garrett on 2/28/17.
//  Copyright © 2017 David Garrett. All rights reserved.
//

import Foundation
import UIKit
import KCFloatingActionButton

class StoryHubViewController: UIViewController   {
    @IBOutlet weak var characterButton: UIButton!
    @IBOutlet weak var encyclopediaButton: UIButton!
    @IBOutlet weak var storeButton: UIButton!
    @IBOutlet weak var statsButton: UIButton!
    @IBOutlet weak var messagesButton: UIButton!
    @IBOutlet weak var inventoryButton: UIButton!
    @IBOutlet var mainStoryTap: UITapGestureRecognizer!
    @IBOutlet var sideQuestTap: UITapGestureRecognizer!
    @IBOutlet var trainingTap: UITapGestureRecognizer!
    @IBOutlet weak var totalStars: UILabel!
    @IBOutlet weak var menuButton: KCFloatingActionButton!


    var selectedLevel: String = ""
    var questHierarchy : Quest!
    var savedGame : GameSave!
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questHierarchy = Quest(savedGame: savedGame)
        
        if savedGame.getQuestData(key: "encyclopedia_unlocked") as? Bool == true {
            encyclopediaButton.isHidden = false
        } else {
            encyclopediaButton.isHidden = true
        }
        
        totalStars.text = String(savedGame.stars)
        
        renderMenuButton(currentButton: 0)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //menu button items
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
        
        //additional display items
        if segue.identifier == "presentEncyclopedia" {
            let vc = segue.destination as! IndexViewController
            vc.savedGame = savedGame
        }
        if segue.identifier == "presentStatistics" {
            let vc = segue.destination as! StatisticsViewController
            vc.savedGame = savedGame
        }
        
        //story functionality
        if segue.identifier == "showChapterSelect" {
            let vc = segue.destination as! ChapterSelectViewController
            vc.savedGame = savedGame
        }
    }
    
    func renderMenuButton(currentButton: Int) {
        let imageArray = ["Book", "Character", "Inventory", "Store", "Settings", "Exit"]
        let segueArray = ["showStory", "showCharacter", "showInventory", "showStore", "showSettings", "showTitle"]
        
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
