//
//  StoryHub.swift
//  Midnight
//
//  Created by David Garrett on 2/28/17.
//  Copyright © 2017 David Garrett. All rights reserved.
//

import Foundation
import UIKit

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
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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
        if segue.identifier == "showChapterSelect" {
            let vc = segue.destination as! ChapterSelectViewController
            vc.savedGame = savedGame
        }
    }

}
