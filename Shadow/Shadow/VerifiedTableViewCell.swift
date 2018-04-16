//
//  VerifiedTableViewCell.swift
//  Shadow
//
//  Created by Navaldeep Kaur on 1/24/18.
//  Copyright © 2018 Atinderjit Kaur. All rights reserved.
//

import UIKit

class VerifiedTableViewCell: UITableViewCell {

    @IBOutlet weak var lbl_CompanyName: UILabel!
    @IBOutlet weak var btn_schedule: UIButton!
    @IBOutlet weak var btn_remove: UIButton!
    @IBOutlet weak var lbl_star: UILabel!
    @IBOutlet weak var lbl_userName: UILabel!
    @IBOutlet weak var lbl_rating: UILabel!
    @IBOutlet weak var imageView_user: UIImageView!
    @IBOutlet weak var lbl_Time: UILabel!
  
    @IBOutlet weak var lbl_textRating: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        btn_schedule.layer.cornerRadius = 3
        btn_schedule.layer.borderWidth = 1
        
        btn_remove.layer.cornerRadius = 3
        btn_remove.layer.borderWidth = 1
        
        self.imageView_user.layer.cornerRadius = 24.0
        self.imageView_user.clipsToBounds = true
     // btn_schedule.layer.borderColor = UIColor.orange.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
