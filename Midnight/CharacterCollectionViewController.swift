//
//  CharacterCollectionViewController.swift
//  Midnight
//
//  Created by David Garrett on 4/11/17.
//  Copyright © 2017 David Garrett. All rights reserved.
//

import Foundation
import UIKit
import KCFloatingActionButton

class CharacterCollectionViewController : UIViewController {
    var savedGame: GameSave!
    var party: [Character] = [Character]()
    var selectedCharacter: String!
    
    @IBOutlet weak var characterCollection: UICollectionView!
    @IBOutlet weak var menuButton: KCFloatingActionButton!
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        characterCollection.dataSource = self
        characterCollection.delegate = self
        
        loadCharacters()
        
        renderMenuButton(currentButton: 1)
    }
    
    func loadCharacters() {
        for (_, character) in savedGame.characters {
            party.append(character)
        }
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

        if segue.identifier == "presentCharacter" {
            let vc = segue.destination as! CharacterProfileViewController
            vc.character = savedGame.characters[selectedCharacter]
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

extension CharacterCollectionViewController : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return party.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "characterCell", for: indexPath) as! CharacterSelectCell
        
        let character = party[indexPath.row]
        
        cell.cellImage.image = UIImage(named: character.image)
        cell.cellLabel.text = character.name
        cell.healthLabel.text = String(character.maxHealth)
        cell.strengthLabel.text = String(format: "%ld", Int(character.strength * 100))
        cell.defenseLabel.text = String(character.defense)
        cell.tokenImage.image = UIImage(named: String(character.token + ".png"))
        cell.className.text = character.className
        
        return cell
    }
}

extension CharacterCollectionViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedCharacter = party[indexPath.row].name
        self.performSegue(withIdentifier: "presentCharacter", sender: self)
    }
}
