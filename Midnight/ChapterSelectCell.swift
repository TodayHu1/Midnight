//
//  ChapterSelectCell.swift
//  Midnight
//
//  Created by David Garrett on 3/7/17.
//  Copyright © 2017 David Garrett. All rights reserved.
//

import Foundation
import UIKit

class ChapterSelectCell: UICollectionViewCell {
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var cellPercent: UILabel!
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

