//
//  NotificationTableViewCell.swift
//  Shadow
//
//  Created by Aditi on 24/08/17.
//  Copyright © 2017 Atinderjit Kaur. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    
    @IBOutlet var imgView_Notification: UIImageView!
    @IBOutlet var lbl_Notification: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        DispatchQueue.main.async {
            self.imgView_Notification.layer.cornerRadius = 30.0
            self.imgView_Notification.clipsToBounds = true
        }
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func dataToCell(dict:NSDictionary){
        
        DispatchQueue.main.async {
            
            if dict.value(forKey: "type") as! String != "Verified" {
            let dict_UserInfo = (dict.value(forKey: "requestDTO") as! NSDictionary).value(forKey: "userDTO") as! NSDictionary
            print(dict_UserInfo)
         
            //setting profile image
            let str_profileImage = dict_UserInfo.value(forKey: "profileImageUrl") as? String
            if str_profileImage != nil && str_profileImage != "" {
                
                self.imgView_Notification.sd_setImage(with: URL.init(string: str_profileImage!), placeholderImage: UIImage.init(named: "dummySearch"))
            }
            
            //setting user info
            let dict_RequestDTO = dict.value(forKey: "requestDTO") as! NSDictionary
            print(dict_RequestDTO)
            //if role is user
            if dict_UserInfo.value(forKey: Global.macros.krole) as? String == "USER"{
                
                let username = (dict_UserInfo.value(forKey: Global.macros.kUserName) as? String)?.capitalized

                if  dict.value(forKey: "type") as? String == "Send"{
                    
                    self.lbl_Notification.text = "\(username!) has sent you a request."

                }
                else if dict.value(forKey: "type") as? String == "Reject"{
                    
                    self.lbl_Notification.text = "\(username!) has rejected your request."
                }
                else if dict.value(forKey: "type") as? String == "Update" {
                    
                    self.lbl_Notification.text = "\(username!) has updated your request."

                    
                    }
                    
               
                
                else if dict.value(forKey: "type") as? String == "Accept" {
                    
                    self.lbl_Notification.text = "\(username!) has accepted your request."
                    
                    
                }
                    
                else if dict.value(forKey: "type") as? String == "Verified" {
                    
                    self.lbl_Notification.text = "Admin has verified your account."
                    
                    
                }
                
                else if dict.value(forKey: "type") as? String == "Rating" {
                    
                    self.lbl_Notification.text = "\(username!) has added reviews to your profile."
                }
                    
                    
                
                else{
                    
                    self.lbl_Notification.text = "\(username!) has added reviews to your profile."
                }
                }
            
            //if role is school
            else if dict_UserInfo.value(forKey: Global.macros.krole) as? String == "SCHOOL"{
                
                let school_name = (dict_UserInfo.value(forKey: Global.macros.kschoolName) as? String)?.capitalized
                
                if  dict.value(forKey: "type") as? String == "Send"{
                    
                    self.lbl_Notification.text = "\(school_name!) has sent you a request."
                    
                }
                else if dict.value(forKey: "type") as? String == "Reject"{
                    
                    self.lbl_Notification.text = "\(school_name!) has rejected your request."
                }
                else if dict.value(forKey: "type") as? String == "Update" {
                    
                    self.lbl_Notification.text = "\(school_name!) has updated your request."
                    
                    
                }
                    
                else if dict.value(forKey: "type") as? String == "Accept" {
                    
                    self.lbl_Notification.text = "\(school_name!) has accepted your request."
                    
                    
                }
                else if dict.value(forKey: "type") as? String == "Rating" {
                    
                    self.lbl_Notification.text = "\(school_name!) has added reviews to your profile."
                }
                    
                else if dict.value(forKey: "type") as? String == "Verified" {
                    
                    self.lbl_Notification.text = "Admin has verified your account."
                    
                    
                }
                else{
                    
                    self.lbl_Notification.text = "\(school_name!) has added reviews to your profile."
                }
                
            }
            //if role is company
            else if dict_UserInfo.value(forKey: Global.macros.krole) as? String == "COMPANY"{
                
                let company_name = (dict_UserInfo.value(forKey: Global.macros.kcompanyName) as? String)?.capitalized

                if  dict.value(forKey: "type") as? String == "Send"{
                    
                    self.lbl_Notification.text = "\(company_name!) has sent you a request."
                    
                }
                else if dict.value(forKey: "type") as? String == "Reject"{
                    
                    self.lbl_Notification.text = "\(company_name!) has rejected your request."
                }
                else if dict.value(forKey: "type") as? String == "Update" {
                    
                    self.lbl_Notification.text = "\(company_name!) has updated your request."
                    
                    
                }
                    
                else if dict.value(forKey: "type") as? String == "Accept" {
                    
                    self.lbl_Notification.text = "\(company_name!) has accepted your request."
                    
                    
                }
                
                
                else if dict.value(forKey: "type") as? String == "Rating" {
                    
                    self.lbl_Notification.text = "\(company_name!) has added reviews to your profile."
                }
                    
                else if dict.value(forKey: "type") as? String == "Verified" {
                    
                    self.lbl_Notification.text = "Admin has verified your account."
                    
                    
                }
                else{
                    
                    self.lbl_Notification.text = "\(company_name!) has added reviews to your profile."
                }

            }
            
        }
            
            else{
                
                  self.lbl_Notification.text = "Admin has verified your account."
                    self.imgView_Notification.image  =   UIImage.init(named: "dummySearch")
                
            }
            
        }
    }
}
