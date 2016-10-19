//
//  IndexViewController.swift
//  Midnight
//
//  Created by David Garrett on 9/21/16.
//  Copyright © 2016 David Garrett. All rights reserved.
//

import Foundation
import UIKit

class IndexViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var indexTable: UITableView!
    var indexList = [EncyclopediaEntry]()
    var level: Int = 1
    var selectedRow: EncyclopediaEntry?
    var savedGame: GameSave!
    
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        dismiss(animated: true, completion: {})
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indexTable.dataSource = self
        indexTable.delegate = self
        
        if level == 1 {
            indexList = Encyclopedia(level: 1, section: "", questData: savedGame.questData).indexList
        } else {
            indexList = Encyclopedia(level: 2, section: selectedRow!.text, questData: savedGame.questData).indexList
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
        cell.textLabel?.text = item.text
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "presentChildIndex" {
            let vc = segue.destination as! IndexViewController
            let indexPath = self.indexTable.indexPathForSelectedRow
            vc.level += 1
            vc.selectedRow = self.indexList[indexPath!.row]
            vc.savedGame = savedGame
        }
        if segue.identifier == "presentDetail" {
            let vc = segue.destination as! DetailViewController
            let indexPath = self.indexTable.indexPathForSelectedRow
            let data = self.indexList[indexPath!.row]
            
            vc.selectedRow = indexPath
            vc.data = data
        }
    }
}
