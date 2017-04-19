//
//  LevelSelectCell.swift
//  Midnight
//
//  Created by David Garrett on 10/24/16.
//  Copyright © 2016 David Garrett. All rights reserved.
//

import Foundation
import UIKit

class LevelSelectCell: UICollectionViewCell {
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var totalDamageImage: UIImageView!
    @IBOutlet weak var elapsedTimeImage: UIImageView!
    @IBOutlet weak var totalMovesImage: UIImageView!
    @IBOutlet weak var wavesLabel: UILabel!
    @IBOutlet weak var cellDifficulty: UIImageView!
    
    override var isSelected: Bool {
        didSet {
            cellImage.layer.borderWidth = isSelected ? 3 : 0
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellImage.layer.borderColor = UIColor.purple.cgColor
        isSelected = false
    }
}
