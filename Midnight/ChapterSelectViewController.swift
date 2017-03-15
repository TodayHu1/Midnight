//
//  ChapterSelectViewController.swift
//  Midnight
//
//  Created by David Garrett on 3/7/17.
//  Copyright © 2017 David Garrett. All rights reserved.
//


import Foundation
import UIKit

class ChapterSelectViewController: UIViewController   {
    
    @IBOutlet weak var chapterCollection: UICollectionView!
    
    var selectedChapter: Int = 1
    var questHierarchy : Quest!
    var savedGame : GameSave!
    var chapters : [QuestHierarchyNode]!
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questHierarchy = Quest(savedGame: savedGame)
        chapters = questHierarchy.nodes.reversed()
        
        chapterCollection.dataSource = self
        chapterCollection.delegate = self
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showLevelSelect" {
            let vc = segue.destination as! StoryModeViewController
            self.savedGame.selectedChapter = selectedChapter
            vc.savedGame = savedGame
        }
        if segue.identifier == "showStoryHub" {
            let vc = segue.destination as! StoryHubViewController
            vc.savedGame = savedGame
        }
    }
}

extension ChapterSelectViewController : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chapters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "chapterCell", for: indexPath) as! ChapterSelectCell
        
        cell.cellLabel.text = chapters[indexPath.row].title
        cell.cellPercent.text = String(format: "%d%%", chapters[indexPath.row].percentComplete)
        
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        
//        var returnView : UICollectionReusableView!
//        
//        switch kind {
//        case UICollectionElementKindSectionHeader:
//            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "levelSelectHeader", for: indexPath) as! LevelSelectHeader
//            headerView.chapterLabel.text = questHierarchy.nodes[indexPath.section].title
//            returnView = headerView
//        default:
//            assert(false, "Unexpected element kind")
//        }
//        
//        return returnView
//    }
}

extension ChapterSelectViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedChapter = indexPath.row
        self.performSegue(withIdentifier: "showLevelSelect", sender: self)
    }
}

