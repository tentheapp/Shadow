//
//  DateTableViewCell.swift
//  Shadow
//
//  Created by Atinderjit Kaur on 08/11/17.
//  Copyright © 2017 Atinderjit Kaur. All rights reserved.
//

import UIKit

class DateTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var lbl_Date: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
