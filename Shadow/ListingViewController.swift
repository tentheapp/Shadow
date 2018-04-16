//
//  ListingViewController.swift
//  Shadow
//
//  Created by Atinderjit Kaur on 06/09/17.
//  Copyright © 2017 Atinderjit Kaur. All rights reserved.
//

import UIKit
var bool_ComingFromList : Bool = false

class ListingViewController: UIViewController {

    @IBOutlet var tbl_View: UITableView!
    var type:               String?
    var navigation_title:   String?
    fileprivate var array_userList = NSMutableArray()
    var ListuserId :        NSNumber!
    var comingFromOcc :     Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
         comingFromOcc =  false
    }

    override func viewWillAppear(_ animated: Bool) {
        
        DispatchQueue.main.async {
            self.navigationItem.title = self.navigation_title
            self.navigationItem.setHidesBackButton(false, animated:true)
            self.CreateNavigation_BackBarButton()
            self.tabBarController?.tabBar.isHidden = true
            self.tbl_View.tableFooterView = UIView()  //Set table extra rows eliminate
            bool_ComingRatingList = false
        }
        
        if comingFromOcc == false {
         if type != nil{
            if type == "Verified Users" {
                
                self.getVerifiedUsers()
            }
            else{
            self.getlistofusers()
            }
            }
        }
        else {
           
            self.ServiceForOccupation()
            
        }
    }
    
    
    func ServiceForOccupation() {
        
        let dict = NSMutableDictionary()
        dict.setValue(ListuserId, forKey: "occupationId")
        dict.setValue(SavedPreferences.value(forKey: Global.macros.kUserId) as? NSNumber, forKey: Global.macros.kUserId)
        
        print(dict)
        
        if checkInternetConnection() {
            
            DispatchQueue.main.async {
                self.pleaseWait()
                
            }
            OpenList_API.sharedInstance.getListOfUsersOcc(completion_block: { (status, dict_Info) in
                
                DispatchQueue.main.async {
                    self.clearAllNotice()
                }
                
                switch status{
                    
                case 200:
                    DispatchQueue.main.async {
                        
                        self.array_userList.removeAllObjects()
                        
                       
                        
                        if (dict_Info.value(forKey: "users") as? NSArray) != nil {
                            
                            let arr = (dict_Info.value(forKey: "users") as! NSArray).mutableCopy()
                            self.array_userList = arr as! NSMutableArray
                            self.tbl_View.reloadData()

                        }
                        
                        
                        
                    }
                    break
                    
                case 401:
                    DispatchQueue.main.async {
                        self.clearAllNotice()
                        self.AlertSessionExpire()
                    }
                    
                    break
                default:
                    break
                    
                    
                }
                
            }, error_block: { (error) in
                DispatchQueue.main.async {
                    self.clearAllNotice()
                    self.showAlert(Message: Global.macros.kError, vc: self)
                }
            }, dict: dict)
        }else{
            self.showAlert(Message: Global.macros.kInternetConnection, vc: self)
        }

        
        
    }
    
    func CreateNavigation_BackBarButton() {
        
        let myBackButton:UIButton = UIButton()
        myBackButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        myBackButton.setImage(UIImage(named:"back-new"), for: UIControlState())
        myBackButton.addTarget(self, action: #selector(self.Pop_ToRootViewController), for: UIControlEvents.touchUpInside)
        let leftBackBarButton:UIBarButtonItem = UIBarButtonItem(customView: myBackButton)
        self.navigationItem.leftBarButtonItem = leftBackBarButton
        
    }
    
    func Pop_ToRootViewController()
    {
        
        let vcArray = self.navigationController?.viewControllers
        print(vcArray!)
        
        if ((vcArray?.count)! > 2) {
            
            _ = self.navigationController?.popViewController(animated: true)
        }
        else  {
            _ = self.navigationController?.popViewController(animated: true)
            
            }
    }


    
    //MARK: - Functions
    
    func getVerifiedUsers() {

        let dict = NSMutableDictionary()
        dict.setValue(ListuserId, forKey: Global.macros.kUserId)
        dict.setValue(0, forKey: "searchType")
        dict.setValue(0, forKey: "pageIndex")
        dict.setValue(100, forKey: "pageSize")
        print(dict)
        
        //  if ListuserId == SavedPreferences.value(forKey: Global.macros.kUserId) as? NSNumber {
        if checkInternetConnection(){
            DispatchQueue.main.async {
                self.pleaseWait()
                
            }
            OpenList_API.sharedInstance.VerifiedUsers(completion_block: { (status, dict_Info) in
                
                DispatchQueue.main.async {
                    self.clearAllNotice()
                }
                
                switch status{
                    
                case 200:
                    DispatchQueue.main.async {
                        
                        self.array_userList.removeAllObjects()
                       
                            
                        let arr = dict_Info.value(forKey: "data") as? NSDictionary
                        
                        self.array_userList.addObjects(from: dict_Info.value(forKey: "data") as? NSArray as! [Any])
                        self.tbl_View.reloadData()
                        
                    }
                    break
                    
                case 401:
                    DispatchQueue.main.async {
                        self.clearAllNotice()
                        self.AlertSessionExpire()
                    }
                    
                    break
                    
                case 404:
                    DispatchQueue.main.async {
                        self.clearAllNotice()
                        self.showAlert(Message: "No data Found.", vc: self)
                    }
                    
                    
                default:
                    
                    
                    break
                    
                    
                }
                
            }, error_block: { (error) in
                DispatchQueue.main.async {
                    self.clearAllNotice()
                    self.showAlert(Message: Global.macros.kError, vc: self)
                }
            }, dict: dict)
        }else{
            self.showAlert(Message: Global.macros.kInternetConnection, vc: self)
        }
        
        
    }
    
    func getlistofusers()  {
        
        let dict = NSMutableDictionary()
        dict.setValue(ListuserId, forKey: "otherUserId")
        dict.setValue(SavedPreferences.value(forKey: Global.macros.kUserId) as? NSNumber, forKey: Global.macros.kUserId)

        dict.setValue(self.type!, forKey: Global.macros.k_type)

        print(dict)
        
     //  if ListuserId == SavedPreferences.value(forKey: Global.macros.kUserId) as? NSNumber {
        if checkInternetConnection(){
            DispatchQueue.main.async {
                self.pleaseWait()
            
            }
        OpenList_API.sharedInstance.getListOfUsers(completion_block: { (status, dict_Info) in
            
            DispatchQueue.main.async {
                self.clearAllNotice()
            }
            
            switch status{
                
            case 200:
                DispatchQueue.main.async {
                    
                    self.array_userList.removeAllObjects()
                    if dict_Info["shadowersVerified"] != nil{
                        
                        if (dict_Info.value(forKey: "shadowersVerified") as! NSDictionary).value(forKey:"count") as? NSNumber != 0{

                        self.array_userList = ((dict_Info.value(forKey: "shadowersVerified") as! NSDictionary).value(forKey:"requestDTOs") as! NSArray).mutableCopy() as! NSMutableArray
                            
                        }else{
                            
                            self.showAlert(Message: "No Data Found.", vc: self)

                        }
                    }
                    
                    if dict_Info["shadowedByShadowUser"] != nil{
                        
                         if (dict_Info.value(forKey: "shadowedByShadowUser") as! NSDictionary).value(forKey:"count") as? NSNumber != 0{
                        
                        
                        self.array_userList = ((dict_Info.value(forKey: "shadowedByShadowUser") as! NSDictionary).value(forKey:"requestDTOs") as! NSArray).mutableCopy() as! NSMutableArray
                         }else{
                            self.showAlert(Message: "No Data Found.", vc: self)

                        }
                    }
                    
                    if dict_Info["schoolOrCompanyWithTheseOccupations"] != nil{
                        
                        if (dict_Info.value(forKey: "schoolOrCompanyWithTheseOccupations") as! NSDictionary).value(forKey:"count") as? NSNumber != 0{
                          
                            
                            if (dict_Info.value(forKey: "schoolOrCompanyWithTheseOccupations") as! NSDictionary).value(forKey:"schoolList") != nil {
                            
                        self.array_userList = ((dict_Info.value(forKey: "schoolOrCompanyWithTheseOccupations") as! NSDictionary).value(forKey:"schoolList") as! NSArray).mutableCopy() as! NSMutableArray
                            }
                            
                            if (dict_Info.value(forKey: "schoolOrCompanyWithTheseOccupations") as! NSDictionary).value(forKey:"companyList") != nil {
                                
                                self.array_userList = ((dict_Info.value(forKey: "schoolOrCompanyWithTheseOccupations") as! NSDictionary).value(forKey:"companyList") as! NSArray).mutableCopy() as! NSMutableArray
                            }
                        }
                        else{
                            
                            self.showAlert(Message: "No Data Found.", vc: self)

                        }
                    }
                    if dict_Info["schoolOrCompanyWithTheseUsers"] != nil{
                        
                        if (dict_Info.value(forKey: "schoolOrCompanyWithTheseUsers") as! NSDictionary).value(forKey:"count") as? NSNumber != 0 {
                        
                        self.array_userList = ((dict_Info.value(forKey: "schoolOrCompanyWithTheseUsers") as! NSDictionary).value(forKey:"userList") as! NSArray).mutableCopy() as! NSMutableArray
                        }
                        else{
                            self.showAlert(Message: "No Data Found.", vc: self)
                        }
                    }
                    
                    self.tbl_View.reloadData()

                }
                break
                
            case 401:
                DispatchQueue.main.async {
                    self.clearAllNotice()
                    self.AlertSessionExpire()
                }

                break
                
                
            default:
                
                
                break
                
                
            }
            
        }, error_block: { (error) in
            DispatchQueue.main.async {
                self.clearAllNotice()
                self.showAlert(Message: Global.macros.kError, vc: self)
            }
        }, dict: dict)
        }else{
            self.showAlert(Message: Global.macros.kInternetConnection, vc: self)
        }
      }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension ListingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
    return self.array_userList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_listing", for: indexPath) as! ListingTableViewCell
        
        if comingFromOcc == false
        {
        cell.dataToCell(dictionay: self.array_userList[indexPath.row] as! NSDictionary)
        }
        
        else {
            
            DispatchQueue.main.async {
                var user_dict = NSDictionary()
               
                if self.array_userList.count > 0
                {
                   print(self.array_userList[indexPath.row])
                    user_dict = self.array_userList[indexPath.row] as! NSDictionary
                    print(user_dict)
        
                }
                
      
                    //setting name
                    cell.lbl_username.text = (user_dict.value(forKey: "userName") as? String)?.capitalized
                
                
                //setting profile image
                if user_dict["profileImageUrl"] != nil{
                    let str_profileImage = user_dict.value(forKey: "profileImageUrl") as? String
                    if str_profileImage != nil {
                        
                        cell.imgView_Profile.sd_setImage(with: URL.init(string: str_profileImage!), placeholderImage: UIImage.init(named: "dummySearch"))
                    }
                }
                
                if user_dict["avgRating"] != nil {
                    let rating_number = "\(user_dict["avgRating"]!)"
                    
                    
                    //print(rating_number)
                    
                    let dbl = 2.0
                    if  dbl.truncatingRemainder(dividingBy: 1) == 0
                    {
                        cell.lbl_AvrRatingCount.text = rating_number + ".0"
                        
                    }
                    else {
                        cell.lbl_AvrRatingCount.text = rating_number
                    }
                    
                    
                    cell.lbl_ratingUsers.text = "\(user_dict["ratingCount"]!)"
                }
                
                
                    
                    if user_dict.value(forKey: "companyName") != nil  && user_dict.value(forKey: "companyName") as? String != ""  && user_dict.value(forKey: "companyName") as? String != " " {
                        
                       
                            
                            let companyName =  user_dict.value(forKey: "companyName") as! String
                            
                            if companyName != "" && user_dict.value(forKey: "companyName") != nil && companyName != " " {
                                cell.lbl_name_loc_com_school.text = companyName.capitalized
                                cell.imgView_Company_loc_school.image = UIImage.init(named: "company-icon")
                            }
                            else {
                                
                                cell.lbl_name_loc_com_school.text  = ""
                                cell.imgView_Company_loc_school.isHidden = true
                                
                            }
                        
                    }
                        
                    else {
                        
                        if user_dict.value(forKey: "schoolName") != nil && user_dict.value(forKey: "schoolName") as? String != "" && user_dict.value(forKey: "schoolName") as? String != " " {
                            
                            
                                let schoolName = user_dict.value(forKey: "schoolName") as! String
                                
                                if schoolName != "" && user_dict.value(forKey: "schoolName") != nil && schoolName != " "
                                {
                                    cell.lbl_name_loc_com_school.text = schoolName.capitalized
                                    cell.imgView_Company_loc_school.image = UIImage.init(named: "company-icon")
                                    
                                }
                                else {
                                    cell.lbl_name_loc_com_school.text = ""
                                    cell.imgView_Company_loc_school.isHidden = true
                                    
                                }

                        }
                            
                        else {
                            
                            cell.lbl_name_loc_com_school.isHidden = true
                            cell.imgView_Company_loc_school.isHidden = true
                            
                        }
                    }
          
        }
        }
        
        return cell
     
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        bool_ComingFromList = true
        bool_UserIdComingFromSearch = false

        var user_dict = NSDictionary()
        user_dict = self.array_userList[indexPath.row] as! NSDictionary
        if user_dict["userDTO"] != nil{
            
            user_dict = user_dict.value(forKey: "userDTO") as! NSDictionary
        }
       
        let role = user_dict.value(forKey: Global.macros.krole) as? String
        
        if role == "COMPANY" || role == "SCHOOL"
        {
            DispatchQueue.main.async {

            let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "company") as! ComapanySchoolViewController
                vc.userIdFromList = user_dict["userId"] as? NSNumber
  
            _ = self.navigationController?.pushViewController(vc, animated: true)
                
            vc.extendedLayoutIncludesOpaqueBars = true
            self.automaticallyAdjustsScrollViewInsets = false
            }
        }
        else {
            DispatchQueue.main.async {

                let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "user") as! ProfileVC
                vc.userIdFromList = user_dict["userId"] as? NSNumber

                _ = self.navigationController?.pushViewController(vc, animated: true)
                vc.extendedLayoutIncludesOpaqueBars = true
                self.automaticallyAdjustsScrollViewInsets = false
                //self.navigationController?.navigationBar.isTranslucent = false
            }
        }
  
        
    }
    
    
}
