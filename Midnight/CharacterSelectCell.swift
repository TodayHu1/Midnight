//
//  CharacterSelectCell.swift
//  Midnight
//
//  Created by David Garrett on 10/21/16.
//  Copyright © 2016 David Garrett. All rights reserved.
//

import Foundation
import UIKit

class CharacterSelectCell: UICollectionViewCell {
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellLabel: UILabel!
    
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
