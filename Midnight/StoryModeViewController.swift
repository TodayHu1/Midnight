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

    @IBOutlet weak var levelCollection: UICollectionView!

//    fileprivate let sectionInsets = UIEdgeInsets(top: 10.0, left: 0, bottom: 10.0, right: 0)
//    fileprivate let itemsPerRow: CGFloat = 1
    
    var selectedLevel: String = ""
    var questHierarchy : Quest!
    var savedGame : GameSave!
    var chapters : [QuestHierarchyNode]!
    var levels : [QuestHierarchyNode]!
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questHierarchy = Quest(savedGame: savedGame)
        chapters = questHierarchy.nodes.reversed()
        levels = chapters[savedGame.selectedChapter].nodes.reversed()
        
        levelCollection.dataSource = self
        levelCollection.delegate = self
        
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
        if segue.identifier == "showChapterSelect" {
            let vc = segue.destination as! ChapterSelectViewController
            vc.savedGame = savedGame
        }
    }
}

extension StoryModeViewController : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return levels.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "levelCell", for: indexPath) as! LevelSelectCell
        
        cell.cellLabel.text = levels[indexPath.row].title
        cell.wavesLabel.text = String(levels[indexPath.row].waves)
        
        if levels[indexPath.row].totalMovesGoal {
            cell.totalMovesImage.image = UIImage(named: "Complete_Star")
        }
        
        if levels[indexPath.row].totalDamageTakenGoal {
            cell.totalDamageImage.image = UIImage(named: "Complete_Star")
        }
        
        if levels[indexPath.row].elapsedTimeGoal {
            cell.elapsedTimeImage.image = UIImage(named: "Complete_Star")
        }
        
        return cell
    }
}

extension StoryModeViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedLevel = levels[indexPath.row].id
        self.performSegue(withIdentifier: "showDialogue", sender: self)
    }
}

//extension StoryModeViewController : UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        
//        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
//        let availableWidth = view.frame.width - paddingSpace
//        let widthPerItem = availableWidth / itemsPerRow
//        let heightPerItem = widthPerItem / 2
//        
//        return CGSize(width: widthPerItem, height: heightPerItem)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return sectionInsets
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return sectionInsets.left
//    }
//}
