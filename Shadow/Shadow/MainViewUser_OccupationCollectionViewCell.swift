//
//  MainViewUser_OccupationCollectionViewCell.swift
//  Shadow
//
//  Created by Aditi on 03/07/17.
//  Copyright © 2017 Atinderjit Kaur. All rights reserved.
//

import UIKit

class MainViewUser_OccupationCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var lbl_OccupationName: UILabel!
    
    override func awakeFromNib() {
        
         contentView.layer.cornerRadius = 5.0
         contentView.clipsToBounds = true
    }
}
