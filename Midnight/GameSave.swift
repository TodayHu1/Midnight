//
//  GameSave.swift
//  MatchRPG
//
//  Created by David Garrett on 8/16/16.
//  Copyright © 2016 David Garrett. All rights reserved.
//

import Foundation

enum Difficulty: Double {
    case unknown = 0.0
    case easy = 0.5
    case normal = 1.0
    case hard = 2.0
    case epic = 3.0
}

class GameSave: NSObject, NSCoding {
    var saveSlot: Int = 0
    var selectedLevel: String = ""
    lazy var totalMoves: Int = self.getTotalMoves()
    lazy var totalDamageTaken: Int = self.getTotalDamageTaken()
    lazy var elapsedtime: TimeInterval = self.getElapsedTime()
    var character: Character = Character()
    var levelResults: [String: LevelResult] = [String: LevelResult]()
    var difficulty: Difficulty = Difficulty.normal
    var questData: [String: AnyObject] = [String: AnyObject]()
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("GameSave")

    override init() {
        super.init()
    }

    init?(selectedLevel: String, character: Character, levelResults: [String: LevelResult], difficulty: Double, questData: [String: AnyObject]) {
        self.selectedLevel = selectedLevel
        self.character = character
        self.levelResults = levelResults
        self.difficulty = Difficulty(rawValue: difficulty)!
        self.questData = questData
        
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(selectedLevel, forKey: "selectedLevel")
        aCoder.encode(character, forKey: "character")
        aCoder.encode(levelResults, forKey: "levelResults")
        aCoder.encode(difficulty.rawValue, forKey: "difficulty")
        aCoder.encode(questData, forKey: "questData")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        var selectedLevel = ""
        if aDecoder.containsValue(forKey: "selectedLevel") {
            selectedLevel = aDecoder.decodeObject(forKey: "selectedLevel") as! String
        }
        let character = aDecoder.decodeObject(forKey: "character") as! Character
        var levelResults: [String: LevelResult] = [String: LevelResult]()
        if aDecoder.containsValue(forKey: "levelResults") {
            let object = aDecoder.decodeObject(forKey: "levelResults")
            if object is [String: LevelResult] {
                levelResults = object as! [String: LevelResult]
            }
        }
        let difficulty = aDecoder.decodeDouble(forKey: "difficulty")
        var questData: [String: AnyObject] = [String: AnyObject]()
        if let q = aDecoder.decodeObject(forKey: "questData") as? [String: AnyObject] {
            questData = q
        }
        
        self.init(selectedLevel: selectedLevel, character: character, levelResults: levelResults, difficulty: difficulty, questData: questData)
    }
    
    func save() {
        let savePath = GameSave.ArchiveURL.path +  String(saveSlot)
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(self, toFile: savePath)
        if !isSuccessfulSave {
            print("Failed to save options...")
        }
    }
    
    func load() {
        let savePath = GameSave.ArchiveURL.path +  String(saveSlot)
        if let savedGame = NSKeyedUnarchiver.unarchiveObject(withFile: savePath) as? GameSave {
            self.selectedLevel = savedGame.selectedLevel
            self.character = savedGame.character
            self.levelResults = savedGame.levelResults
            self.difficulty = savedGame.difficulty
            self.questData = savedGame.questData
        }
    }
    
    func deleteSave() -> Bool{
        let savePath = GameSave.ArchiveURL.path +  String(saveSlot)
        let exists = FileManager.default.fileExists(atPath: savePath)
        if exists {
            do {
                try FileManager.default.removeItem(atPath: savePath)
            }
            catch let error as NSError {
                print("error: \(error.localizedDescription)")
                return false
            }
        }
        return exists
    }
    
    fileprivate func getTotalMoves() -> Int {
        var totalMoves = 0
        for (_, result) in levelResults {
            if result.includeInLeaderboard {
                totalMoves += result.totalMoves
            }
        }
        return totalMoves
    }
    
    fileprivate func getTotalDamageTaken() -> Int {
        var totalDamageTaken = 0
        for (_, result) in levelResults {
            if result.includeInLeaderboard {
                totalDamageTaken += result.totalDamageTaken
            }
        }
        return totalDamageTaken
    }
    
    fileprivate func getElapsedTime() -> TimeInterval {
        var elapsedTime: TimeInterval = 0
        for (_, result) in levelResults {
            if result.includeInLeaderboard {
                elapsedTime += result.elapsedTime
            }
        }
        return elapsedTime
    }
    
    func getQuestData(key: String) -> AnyObject? {
        return questData[key]
    }
    
    func setQuestData(key: String, value: AnyObject) {
        questData[key] = value
    }
    
}
