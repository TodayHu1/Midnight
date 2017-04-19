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
    @IBOutlet weak var difficultyLabel: UILabel!
    @IBOutlet weak var difficultyImage: UIImageView!
    @IBOutlet var difficultyTap: UITapGestureRecognizer!

    @IBAction func difficultyTapTapped(_ sender: Any) {
        switch savedGame.difficulty {
        case .easy:
            savedGame.difficulty = .normal
        case .normal:
            savedGame.difficulty = .hard
        case .hard:
            savedGame.difficulty = .epic
        case.epic:
            savedGame.difficulty = .easy
        default:
            savedGame.difficulty = .hard
        }
        
        questHierarchy = Quest(savedGame: savedGame, file: "Progress")
        chapters = questHierarchy.nodes.reversed()
        levels = chapters[savedGame.selectedChapter].nodes.reversed()

        setDifficulty()
        levelCollection.reloadData()

    }
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
        
        questHierarchy = Quest(savedGame: savedGame, file: "Progress")
        chapters = questHierarchy.nodes.reversed()
        levels = chapters[savedGame.selectedChapter].nodes.reversed()
        
        levelCollection.dataSource = self
        levelCollection.delegate = self
        
        setDifficulty()
        
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
    
    func setDifficulty() {
        difficultyLabel.text = "Difficulty: " + savedGame.difficulty.description
        difficultyImage.image = UIImage(named: "difficulty_" + savedGame.difficulty.description)
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
        cell.cellDifficulty.image = UIImage(named: "select_background_" + savedGame.difficulty.description)
        
        if levels[indexPath.row].totalMovesGoal {
            cell.totalMovesImage.image = UIImage(named: "Complete_Star")
        } else {
            cell.totalMovesImage.image = UIImage(named: "Incomplete_Star")
        }
        
        if levels[indexPath.row].totalDamageTakenGoal {
            cell.totalDamageImage.image = UIImage(named: "Complete_Star")
        } else {
            cell.totalDamageImage.image = UIImage(named: "Incomplete_Star")
        }
        
        if levels[indexPath.row].elapsedTimeGoal {
            cell.elapsedTimeImage.image = UIImage(named: "Complete_Star")
        } else {
            cell.elapsedTimeImage.image = UIImage(named: "Incomplete_Star")
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
