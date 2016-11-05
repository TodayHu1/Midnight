//
//  IndexViewController.swift
//  Midnight
//
//  Created by David Garrett on 9/21/16.
//  Copyright © 2016 David Garrett. All rights reserved.
//

import Foundation
import UIKit

class IndexViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var indexTable: UITableView!
    var encyclopedia: Encyclopedia!
    var entryList: [EncyclopediaEntry]!
    var selectedRow: Int?
    var savedGame: GameSave!
    
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        dismiss(animated: false, completion: {})
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indexTable.dataSource = self
        indexTable.delegate = self

        encyclopedia = Encyclopedia(savedGame: savedGame)
        
        if selectedRow != nil {
            entryList = encyclopedia.entries[selectedRow!].entries
        } else {
            entryList = encyclopedia.entries
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "presentChildIndex" {
            let vc = segue.destination as! IndexViewController
            let indexPath = self.indexTable.indexPathForSelectedRow
            vc.selectedRow = indexPath!.row
            vc.savedGame = savedGame
        }
        if segue.identifier == "presentDetail" {
            let vc = segue.destination as! DetailViewController
            let indexPath = self.indexTable.indexPathForSelectedRow
            let data = self.encyclopedia.entries[selectedRow!].entries[indexPath!.row]
            vc.data = data
        }
        if segue.identifier == "presentMonsterView" {
            let vc = segue.destination as! MonsterStatsViewController
            let indexPath = self.indexTable.indexPathForSelectedRow
            let monsterFile = self.encyclopedia.entries[selectedRow!].entries[indexPath!.row].detailFile
            let monster = Monster(filename: "Monsters/\(monsterFile)")
            vc.monster = monster
        }
    }
}

extension IndexViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath)
        
        cell.textLabel?.text = entryList[indexPath.row].text
        
        return cell
    }
}

extension IndexViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedRow != nil {
            switch entryList[indexPath.row].type{
            case EncyclopediaEntryType.Monsters:
                self.performSegue(withIdentifier: "presentMonsterView", sender: self)
            default:
                self.performSegue(withIdentifier: "presentDetail", sender: self)
            }
        } else {
            self.performSegue(withIdentifier: "presentChildIndex", sender: self)
        }
    }
}
