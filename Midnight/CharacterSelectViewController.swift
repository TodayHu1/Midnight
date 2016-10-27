//
//  CharacterSelectViewController.swift
//  Midnight
//
//  Created by David Garrett on 10/21/16.
//  Copyright © 2016 David Garrett. All rights reserved.
//

import Foundation
import UIKit

class CharacterSelectViewController : UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    var savedGame: GameSave!
    var party: [Character] = [Character]()
    var selectedCharacter: String?
    
    private let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    private let itemsPerRow: CGFloat = 2
    
    @IBOutlet weak var buttonOK: UIButton!
    @IBOutlet weak var characterCollection: UICollectionView!
    
    @IBAction func pressOK(_ sender: AnyObject) {
        if selectedCharacter != nil {
            savedGame.selectedCharacter = selectedCharacter!
            self.performSegue(withIdentifier: "showPreGame", sender: self)
        }
    }
    
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
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return party.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "characterCell", for: indexPath) as! CharacterSelectCell
        
        let characterImageName = party[indexPath.row].image
        let characterImage = UIImage(named: characterImageName)
        
        cell.cellImage.image = characterImage
        cell.cellLabel.text = party[indexPath.row].name
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCharacter = party[indexPath.row].name
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPreGame" {
            let vc = segue.destination as! PreGameViewController
            vc.savedGame = savedGame
        }
    }
}
