//
//  CharacterManagementTabController.swift
//  MatchRPG
//
//  Created by David Garrett on 9/7/16.
//  Copyright © 2016 David Garrett. All rights reserved.
//

import Foundation
import UIKit

class CharacterManagementTabController: UITabBarController {
    var savedGame: GameSave!
    var callingView: String!
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
}
