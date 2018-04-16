

//
//  SkillsNInterestCollectionViewCell.swift
//  Shadow
//
//  Created by Atinderjit Kaur on 09/06/17.
//  Copyright © 2017 Atinderjit Kaur. All rights reserved.
//

import UIKit

class SkillsNInterestCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var lbl_Skill: UILabel!
    
    override func awakeFromNib() {
        
        contentView.layer.cornerRadius = 5.0
        contentView.clipsToBounds = true
        
    }

}
