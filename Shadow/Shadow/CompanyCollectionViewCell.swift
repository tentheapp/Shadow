//
//  CompanyCollectionViewCell.swift
//  Shadow
//
//  Created by Atinderjit Kaur on 23/08/17.
//  Copyright © 2017 Atinderjit Kaur. All rights reserved.
//

import UIKit

class CompanyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var lbl_CompanyName: UILabel!
    
    override func awakeFromNib() {
        
        
        contentView.layer.cornerRadius = 5.0
        contentView.clipsToBounds = true
        
    }
    
}
