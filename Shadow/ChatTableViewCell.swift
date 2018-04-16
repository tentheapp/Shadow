//
//  ChatTableViewCell.swift
//  Shadow
//
//  Created by Atinderjit Kaur on 01/11/17.
//  Copyright © 2017 Atinderjit Kaur. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
    
//    var senderAndTimeLabel : UILabel!
//    var messageContentView : UITextView!
//    var bgImageView : UIImageView!
    
    
    @IBOutlet weak var kleading_Msg: NSLayoutConstraint!
    @IBOutlet weak var k_View_trailing: NSLayoutConstraint!
    @IBOutlet weak var view_Behind: UIView!
    @IBOutlet weak var view_Right: UIView!
    @IBOutlet weak var view_Left: UIView!
    @IBOutlet weak var lbl_Name: UILabel!
    @IBOutlet weak var lbl_Time: UILabel!
    @IBOutlet weak var klbl_Width: NSLayoutConstraint!
    @IBOutlet weak var lbl_Message: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    /*
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        /*
        let screenRect: CGRect = UIScreen.main.bounds
        let screenWidth: CGFloat = screenRect.size.width
        senderAndTimeLabel = UILabel(frame: CGRect(x: -10, y: contentView.frame.size.height + 10, width: screenWidth - 10, height: 15))
        senderAndTimeLabel.textAlignment = .center
        senderAndTimeLabel.font = UIFont.systemFont(ofSize: 9.0)
        senderAndTimeLabel.textColor = UIColor.black
        contentView.addSubview(senderAndTimeLabel)
        bgImageView = UIImageView(frame: CGRect.zero)
        contentView.addSubview(bgImageView)
        messageContentView = UITextView()
        messageContentView.backgroundColor = UIColor.clear
        messageContentView.isEditable = false
        messageContentView.textColor = UIColor.black
        messageContentView.isScrollEnabled = false
        messageContentView.sizeToFit()
        contentView.addSubview(messageContentView)
        senderAndTimeLabel.layer.zPosition = 100.0*/
    }
    */
    
    /*
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }*/

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

