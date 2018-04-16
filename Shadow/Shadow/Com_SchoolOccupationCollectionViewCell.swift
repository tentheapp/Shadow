//
//  Com_SchoolOccupationCollectionViewCell.swift
//  Shadow
//
//  Created by Aditi on 27/06/17.
//  Copyright © 2017 Atinderjit Kaur. All rights reserved.
//

import UIKit

class Com_SchoolOccupationCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var lbl_Occupationname: UILabel!
    
    override func awakeFromNib() {
        
        contentView.layer.cornerRadius = 5.0
        contentView.clipsToBounds = true
      }
 }
