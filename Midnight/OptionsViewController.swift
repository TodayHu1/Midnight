//
//  OptionsViewController.swift
//  MatchRPG
//
//  Created by David Garrett on 8/11/16.
//  Copyright © 2016 David Garrett. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation
import KCFloatingActionButton

class OptionsViewcontroller: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    var options: GameOptions = GameOptions()
    var savedGame: GameSave!
    var difficultyData: [String]!
    
    @IBOutlet weak var menuButton: KCFloatingActionButton!
    @IBOutlet weak var soundsSwitch: UISwitch!
    @IBOutlet weak var musicSwitch: UISwitch!
    @IBOutlet weak var difficultyView: UIPickerView!
    
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        options.load()
        
        soundsSwitch.isOn = self.options.playSounds
        musicSwitch.isOn = self.options.playMusic
        
        difficultyData = ["Easy", "Normal", "Hard", "Epic"]
        
        difficultyView.dataSource = self
        difficultyView.delegate = self
        
        var difficultyIndex = 0
        switch savedGame.difficulty {
        case .easy:
            difficultyIndex = 0
        case .normal:
            difficultyIndex = 1
        case .hard:
            difficultyIndex = 2
        case .epic:
            difficultyIndex = 3
        default:
            difficultyIndex = 1
        }
        
        difficultyView.selectRow(difficultyIndex, inComponent: 0, animated: false)
        
        renderMenuButton(currentButton: 4)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.options.playSounds = soundsSwitch.isOn
        self.options.playMusic = musicSwitch.isOn
        
        self.options.save()
        self.savedGame.save()
        
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
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 4
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        savedGame.difficulty = Difficulty.createFromString(difficultyData[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel = view as! UILabel!
        if view == nil {
            pickerLabel = UILabel()
        }
        pickerLabel!.text = difficultyData[row]
        pickerLabel!.font = UIFont(name: "DigitalStripBB", size: 17.0)
        pickerLabel!.textColor = UIColor.white
        pickerLabel!.textAlignment = .center
        
        return pickerLabel!
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
