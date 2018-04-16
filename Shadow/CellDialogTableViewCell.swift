//
//  CellDialogTableViewCell.swift
//  Shadow
//
//  Created by Atinderjit Kaur on 16/11/17.
//  Copyright © 2017 Atinderjit Kaur. All rights reserved.
//

import UIKit

class CellDialogTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lbl_Name: UILabel!
    @IBOutlet weak var lbl_LastMSG: UILabel!
    @IBOutlet weak var lbl_Date: UILabel!
    
    @IBOutlet weak var lbl_countUnreadMessages: UILabel!
    @IBOutlet weak var btn_ImageClick: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        DispatchQueue.main.async {
            self.imgView.layer.cornerRadius = 30.0
            self.imgView.clipsToBounds = true
            
         //   self.lbl_LastMSG.sizeToFit()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
