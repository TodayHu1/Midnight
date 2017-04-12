//
//  CharacterSelectViewController.swift
//  Midnight
//
//  Created by David Garrett on 10/21/16.
//  Copyright © 2016 David Garrett. All rights reserved.
//

import Foundation
import UIKit

class CharacterSelectViewController : UIViewController {
    var savedGame: GameSave!
    var party: [Character] = [Character]()
    
    @IBOutlet weak var characterCollection: UICollectionView!
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        characterCollection.dataSource = self
        characterCollection.delegate = self
        
        loadCharacters()
    }
    
    func loadCharacters() {
        let level = Level(filename: "Levels/\(savedGame.selectedLevel)")
        for (_, character) in savedGame.characters {
            if level.availableCharacters != nil {
                if level.availableCharacters!.contains(character.name) {
                    party.append(character)
                }
            } else {
                party.append(character)
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPreGame" {
            let vc = segue.destination as! PreGameViewController
            vc.savedGame = savedGame
        }
    }
}

extension CharacterSelectViewController : UICollectionViewDataSource {
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

extension CharacterSelectViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        savedGame.selectedCharacter = party[indexPath.row].name
        self.performSegue(withIdentifier: "showPreGame", sender: self)
    }
}
