//
//  TopUserCollectionViewCell.swift
//  Shadow
//
//  Created by Navaldeep Kaur on 1/24/18.
//  Copyright © 2018 Atinderjit Kaur. All rights reserved.
//

import UIKit

class TopUserCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var btn_OpenStat: UIButton!
    @IBOutlet weak var lbl_users: UILabel!
    @IBOutlet weak var lbl_schoolName: UILabel!
    @IBOutlet weak var img_topSchool: UIImageView!
    @IBOutlet weak var lbl_companyName: UILabel!
    @IBOutlet weak var img_topCompanies: UIImageView!
    @IBOutlet weak var lbl_userName: UILabel!
    @IBOutlet weak var imgView_topUsers: UIImageView!
    @IBOutlet weak var lbl_totalUsers: UILabel!
    
    @IBOutlet weak var btn_Users: UIButton!
    @IBOutlet weak var btn_Companies: UIButton!
    @IBOutlet weak var btn_Schools: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
}
