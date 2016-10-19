//
//  StoryModeViewController.swift
//  MatchRPG
//
//  Created by David Garrett on 8/30/16.
//  Copyright © 2016 David Garrett. All rights reserved.
//

import Foundation
import UIKit

class StoryModeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var characterButton: UIButton!
    @IBOutlet weak var encyclopediaButton: UIButton!
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var chapterTable: UITableView!
    
    var level: Int = 1
    var indexList : [QuestHierarchyNode] = [QuestHierarchyNode]()
    var selectedRow : QuestHierarchyNode?
    var savedGame : GameSave!
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chapterTable.dataSource = self
        chapterTable.delegate = self
        
        fillData()
        
        if savedGame.getQuestData(key: "encyclopedia_unlocked") as? Bool == true {
            encyclopediaButton.isHidden = false
        } else {
            encyclopediaButton.isHidden = true
        }
        
        if savedGame.getQuestData(key: "map_unlocked") as? Bool == true {
            mapButton.isHidden = false
        } else {
            mapButton.isHidden = true
        }
    }
    
    
    func numberOfSelectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return indexList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath)
        let item = indexList[indexPath.row]
        cell.textLabel?.text = item.title
        return cell
    }

    func fillData() {
        var tempList : [QuestHierarchyNode]!
        
        if level == 1 {
            tempList = Quest().nodes
        } else {
            tempList = selectedRow!.nodes
        }
        
        for item in tempList {
            if let value = savedGame.questData[item.unlockKey] {
                if value as! Bool == true {
                    item.unlocked = true
                    indexList.append(item)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "presentChildIndex" {
            let vc = segue.destination as! StoryModeViewController
            let indexPath = self.chapterTable.indexPathForSelectedRow
            vc.level += 1
            vc.selectedRow = self.indexList[indexPath!.row]
            vc.savedGame = self.savedGame
        }
        if segue.identifier == "showDialogue" {
            let vc = segue.destination as! DialogueViewController
            let indexPath = self.chapterTable.indexPathForSelectedRow
            let data = self.indexList[indexPath!.row]
            self.savedGame.selectedLevel = data.id
            vc.savedGame = savedGame
        }
        if segue.identifier == "presentCharacter" {
            let vc = segue.destination as! CharacterManagementTabController
            vc.savedGame = savedGame
            vc.callingView = "storyMode"
        }
        if segue.identifier == "presentEncyclopedia" {
            let vc = segue.destination as! IndexViewController
            vc.savedGame = savedGame
        }
    }
}
