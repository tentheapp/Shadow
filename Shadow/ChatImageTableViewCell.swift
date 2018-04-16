//
//  ChatImageTableViewCell.swift
//  Shadow
//
//  Created by Atinderjit Kaur on 07/11/17.
//  Copyright © 2017 Atinderjit Kaur. All rights reserved.
//

import UIKit

class ChatImageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageView_Attachment: UIImageView!
    @IBOutlet weak var lbl_Name: UILabel!
    @IBOutlet weak var view_Right: UIView!
    @IBOutlet weak var view_Left: UIView!
    @IBOutlet weak var lbl_Time: UILabel!
    @IBOutlet weak var k_view_trail: NSLayoutConstraint!
    @IBOutlet weak var view_Behind: UIView!
    
    
    @IBOutlet weak var btn_Play: UIButton!
    @IBOutlet weak var btn_Image: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
