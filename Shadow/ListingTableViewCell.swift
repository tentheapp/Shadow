//
//  ListingTableViewCell.swift
//  Shadow
//
//  Created by Atinderjit Kaur on 06/09/17.
//  Copyright © 2017 Atinderjit Kaur. All rights reserved.
//

import UIKit

class ListingTableViewCell: UITableViewCell {

    
    @IBOutlet var imgView_Profile: UIImageView!
    @IBOutlet var lbl_username: UILabel!
    @IBOutlet var imgView_Company_loc_school: UIImageView!
    @IBOutlet var lbl_name_loc_com_school: UILabel!
    @IBOutlet var lbl_AvrRatingCount: UILabel!
    @IBOutlet var lbl_ratingUsers: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imgView_Profile.layer.cornerRadius = 25.0
        self.imgView_Profile.clipsToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func dataToCell(dictionay:NSDictionary) {
        
        print(dictionay)
        
        DispatchQueue.main.async {
             var user_dict = NSDictionary()
            if dictionay["userDTO"] != nil{
                
                 user_dict = dictionay.value(forKey: "userDTO") as! NSDictionary
            }
            else{
                user_dict = dictionay
            }
            
            let role = user_dict.value(forKey: Global.macros.krole) as? String
            
            if role == "COMPANY" {
                
                //setting name2335
                if user_dict ["name"] != nil{

                    self.lbl_username.text = (user_dict.value(forKey: "name") as? String)?.capitalized
                }
                else{
                    
                    self.lbl_username.text = (user_dict.value(forKey: "companyName") as? String)?.capitalized

                }
                
            }
            else if role == "USER"{
                
                //setting name
                self.lbl_username.text = (user_dict.value(forKey: "userName") as? String)?.capitalized

                
                
            }
            else if role == "SCHOOL"{
                
                //setting name
                if user_dict ["name"] != nil{
                self.lbl_username.text = (user_dict.value(forKey: "name") as? String)?.capitalized
                }
                else{
                    
                    self.lbl_username.text = (user_dict.value(forKey: "schoolName") as? String)?.capitalized

                }
            }
            
            //setting profile image
            if user_dict["profileImageUrl"] != nil{
                let str_profileImage = user_dict.value(forKey: "profileImageUrl") as? String
                if str_profileImage != nil{
                    
                    self.imgView_Profile.sd_setImage(with: URL.init(string: str_profileImage!), placeholderImage: UIImage.init(named: "dummySearch"))
                }
            }
            
            if user_dict["avgRating"] != nil {
            let rating_number = "\(user_dict["avgRating"]!)"
           
            
            //print(rating_number)
            
            let dbl = 2.0
            if  dbl.truncatingRemainder(dividingBy: 1) == 0
            {
                self.lbl_AvrRatingCount.text = rating_number + ".0"
                
            }
            else {
               self.lbl_AvrRatingCount.text = rating_number
            }
            
            
           self.lbl_ratingUsers.text = "\(user_dict["ratingCount"]!)"
            }
            
            if role == "USER" {
                
                
                if user_dict.value(forKey: "companyName") != nil  && user_dict.value(forKey: "companyName") as? String != ""  && user_dict.value(forKey: "companyName") as? String != " " {
                    
                    if user_dict["occupationDTO"] == nil {
                        
                        let companyName =  user_dict.value(forKey: "companyName") as! String
                        
                        if companyName != "" && user_dict.value(forKey: "companyName") != nil && companyName != " " {
                            self.lbl_name_loc_com_school.text = companyName.capitalized
                            self.imgView_Company_loc_school.image = UIImage.init(named: "company-icon")
                        }
                        else {
                            
                            self.lbl_name_loc_com_school.text  = ""
                            self.imgView_Company_loc_school.isHidden = true
                            
                        }
                        
                    }
                    else {
                        self.lbl_name_loc_com_school.isHidden = true
                        self.imgView_Company_loc_school.isHidden = true
                        
                    }
                }
                    
                else {
                    
                    if user_dict.value(forKey: "schoolName") != nil && user_dict.value(forKey: "schoolName") as? String != "" && user_dict.value(forKey: "schoolName") as? String != " " {
                        
                        if user_dict["occupationDTO"] == nil {
                            
                            let schoolName = user_dict.value(forKey: "schoolName") as! String
                            
                            if schoolName != "" && user_dict.value(forKey: "schoolName") != nil && schoolName != " "
                            {
                                self.lbl_name_loc_com_school.text = schoolName.capitalized
                                self.imgView_Company_loc_school.image = UIImage.init(named: "company-icon")
                                
                            }
                            else {
                                self.lbl_name_loc_com_school.text = ""
                                self.imgView_Company_loc_school.isHidden = true
                                
                            }
                            
                        }
                            
                            
                        else {
                            self.lbl_name_loc_com_school.isHidden = true
                            self.imgView_Company_loc_school.isHidden = true
                            
                        }
                    }
                        
                    else {
                        
                        self.lbl_name_loc_com_school.isHidden = true
                        self.imgView_Company_loc_school.isHidden = true
                        
                    }
                    
                }
                
            }
                
            else {
                
                if user_dict["occupationDTO"] == nil   {
                    
                    if user_dict.value(forKey: "location") != nil && user_dict.value(forKey: "location") as? String != "" && user_dict.value(forKey: "location") as? String != " " {
                        
                        let str = user_dict.value(forKey: Global.macros.klocation) as? String
                        print(str!)
                        var strArry = str?.components(separatedBy: ",")
                        
                        
                        if strArry?.count == 1 {
                            var tempStr:String = ""
                            
                            tempStr = (strArry?.first)!
                            
                            let stringWithoutDigit = (tempStr.components(separatedBy: NSCharacterSet.decimalDigits) as NSArray).componentsJoined(by: "")
                           self.lbl_name_loc_com_school.text = stringWithoutDigit
                            
                        }
                            
                        else if strArry?.count == 2 {
                            strArry?.removeLast()
                            var tempStr:String = ""
                            
                            tempStr = (strArry?.first)!
                            
                            let stringWithoutDigit = (tempStr.components(separatedBy: NSCharacterSet.decimalDigits) as NSArray).componentsJoined(by: "")
                            self.lbl_name_loc_com_school.text = stringWithoutDigit
                            
                            
                        }
                            
                        else if strArry?.count == 3 {
                            
                            strArry?.removeLast()
                            
                            var tempStr:String = ""
                            if strArry != nil {
                                for (index,element) in (strArry?.enumerated())!
                                {
                                    var coma = ""
                                    
                                    if index == 0
                                    {
                                        coma = ""
                                    }
                                    else
                                    {
                                        coma = ","
                                    }
                                    
                                    
                                    tempStr = tempStr + coma + element
                                    let stringWithoutDigit = (tempStr.components(separatedBy: NSCharacterSet.decimalDigits) as NSArray).componentsJoined(by: "")
                                    self.lbl_name_loc_com_school.text = stringWithoutDigit
                                    
                                    
                                }
                                
                            }
                        }
                        else if (strArry?.count)! > 3 {
                            
                            print(strArry!)
                            strArry?.removeLast()
                            strArry?.removeFirst()
                            
                            
                            
                            var tempStr:String = ""
                            for (index,element) in (strArry?.enumerated())!
                            {
                                var coma = ""
                                
                                if index == 0
                                {
                                    coma = ""
                                }
                                else
                                {
                                    coma = ","
                                }
                                
                                
                                tempStr = tempStr + coma + element
                                
                                let stringWithoutDigit = (tempStr.components(separatedBy: NSCharacterSet.decimalDigits) as NSArray).componentsJoined(by: "")
                                self.lbl_name_loc_com_school.text = stringWithoutDigit
                                
                            }
                        }
                        
                        //self.lbl_name_loc_com_school.text = user_dict.value(forKey: "location") as? String
                       self.imgView_Company_loc_school.image = UIImage.init(named: "location-pin")
                        
                    }
                        
                    else {
                        
                        self.lbl_name_loc_com_school.text = ""
                        self.imgView_Company_loc_school.image = UIImage.init(named: "")
                        self.imgView_Company_loc_school.isHidden = true
                        
                        
                    }
                }
                else {
                    self.lbl_name_loc_com_school.isHidden = true
                    self.imgView_Company_loc_school.isHidden = true
                    
                }
                
            }
            
            
            
        }
        
        
        
        
    }

}
