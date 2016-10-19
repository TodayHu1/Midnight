//
//  Options.swift
//  MatchRPG
//
//  Created by David Garrett on 8/15/16.
//  Copyright © 2016 David Garrett. All rights reserved.
//

import Foundation

class GameOptions: NSObject, NSCoding {
    var playSounds: Bool = true
    var playMusic: Bool = true
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("GameOptions")
    
    override init() {
        super.init()
    }
    
    init?(playSounds: Bool, playMusic: Bool) {
        self.playSounds = playSounds
        self.playMusic = playMusic
        
        super.init()
    }

    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(playMusic, forKey: "playMusic")
        aCoder.encode(playSounds, forKey: "playSounds")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let playMusic = aDecoder.decodeBool(forKey: "playMusic")
        let playSounds = aDecoder.decodeBool(forKey: "playSounds")
        
        self.init(playSounds: playSounds, playMusic: playMusic)
    }
    
    func save() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(self, toFile: GameOptions.ArchiveURL.path)
        if !isSuccessfulSave {
            print("Failed to save options...")
        }
        
    }
    
    func load() {
        if let savedSettings = NSKeyedUnarchiver.unarchiveObject(withFile: GameOptions.ArchiveURL.path) as? GameOptions {
            self.playSounds = savedSettings.playSounds
            self.playMusic = savedSettings.playMusic
        }
    }
    
}
