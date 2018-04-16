//
//  AdminCompanyTableViewCell.swift
//  Shadow
//
//  Created by Navaldeep Kaur on 1/23/18.
//  Copyright © 2018 Atinderjit Kaur. All rights reserved.
//

import UIKit

class AdminCompanyTableViewCell: UITableViewCell {

    @IBOutlet weak var imageView_user: UIImageView!
    @IBOutlet weak var lbl_rating: UILabel!
    @IBOutlet weak var lbl_star: UILabel!
    @IBOutlet weak var lbl_companyName: UILabel!
    @IBOutlet var lbl_userName: UILabel!
    @IBOutlet var button_cross: UIButton!
    @IBOutlet var button_right: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
     
        button_right.backgroundColor = .clear
        button_right.setImage(UIImage(named: "verification-mark"), for: UIControlState.normal)
        button_right.layer.cornerRadius = 5
        button_right.layer.borderWidth = 1
     //   button_right.layer.borderColor = UIColor.green.cgColor
        button_right.layer.borderColor = UIColor.init(red: 160, green: 228, blue: 131).cgColor
        
        button_cross.backgroundColor = .clear
        button_cross.setImage(UIImage(named: "cross-out-mark"), for: UIControlState.normal)
        button_cross.layer.cornerRadius = 5
        button_cross.layer.borderWidth = 1
      //  button_cross.layer.borderColor = UIColor.orange.cgColor
        button_cross.layer.borderColor = UIColor.init(red: 244, green:131,blue: 111).cgColor
    
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
