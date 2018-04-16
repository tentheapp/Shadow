//
//  AllSearchesTableViewCell.swift
//  Shadow
//
//  Created by Atinderjit Kaur on 26/06/17.
//  Copyright © 2017 Atinderjit Kaur. All rights reserved.
//

import UIKit

class AllSearchesTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var imgView_Profile: UIImageView!
    @IBOutlet weak var lbl_Name: UILabel!
    @IBOutlet var lbl_totalRatingCount: UILabel!
    
    @IBOutlet weak var lbl_RatingFloat: UILabel!
    @IBOutlet weak var img_LocNcom: UIImageView!
    @IBOutlet weak var lbl_LocNcom: UILabel!
    @IBOutlet weak var btn_DidSelectRow: UIButton!
    @IBOutlet weak var lbl_Time: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        DispatchQueue.main.async {
            self.imgView_Profile.layer.cornerRadius = 25.0
            self.imgView_Profile.clipsToBounds = true
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
