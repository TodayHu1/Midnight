//
//  StoryModeViewController.swift
//  MatchRPG
//
//  Created by David Garrett on 8/30/16.
//  Copyright © 2016 David Garrett. All rights reserved.
//

import Foundation
import UIKit

class StoryModeViewController: UIViewController   {
    @IBOutlet weak var characterButton: UIButton!
    @IBOutlet weak var encyclopediaButton: UIButton!
    @IBOutlet weak var levelCollection: UICollectionView!

    fileprivate let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    fileprivate let itemsPerRow: CGFloat = 3
    
    var selectedLevel: String = ""
    var questHierarchy : Quest!
    var savedGame : GameSave!
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questHierarchy = Quest(savedGame: savedGame)
        
        levelCollection.dataSource = self
        levelCollection.delegate = self
        
        if savedGame.getQuestData(key: "encyclopedia_unlocked") as? Bool == true {
            encyclopediaButton.isHidden = false
        } else {
            encyclopediaButton.isHidden = true
        }
    }
    
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDialogue" {
            let vc = segue.destination as! DialogueViewController
            self.savedGame.selectedLevel = selectedLevel
            vc.savedGame = savedGame
        }
        if segue.identifier == "showCharacterSelect" {
            let vc = segue.destination as! CharacterSelectViewController
            vc.savedGame = savedGame
        }
        if segue.identifier == "presentCharacter" {
            let vc = segue.destination as! CharacterProfilePageController
            vc.savedGame = savedGame
        }
        if segue.identifier == "presentEncyclopedia" {
            let vc = segue.destination as! IndexViewController
            vc.savedGame = savedGame
        }
        if segue.identifier == "presentStatistics" {
            let vc = segue.destination as! StatisticsViewController
            vc.savedGame = savedGame
        }
    }
}

extension StoryModeViewController : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return questHierarchy.nodes.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return questHierarchy.nodes[section].nodes.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "levelCell", for: indexPath) as! LevelSelectCell
        
        cell.cellLabel.text = questHierarchy.nodes[indexPath.section].nodes[indexPath.row].title
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        var returnView : UICollectionReusableView!
        
        switch kind {
        case UICollectionElementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "levelSelectHeader", for: indexPath) as! LevelSelectHeader
            headerView.chapterLabel.text = questHierarchy.nodes[indexPath.section].title
            returnView = headerView
        default:
            assert(false, "Unexpected element kind")
        }
        
        return returnView
    }
}

extension StoryModeViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedLevel = questHierarchy.nodes[indexPath.section].nodes[indexPath.row].id
        self.performSegue(withIdentifier: "showDialogue", sender: self)
    }
}

extension StoryModeViewController : UICollectionViewDelegateFlowLayout {
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
}
