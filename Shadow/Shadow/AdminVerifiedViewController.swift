//
//  AdminVerifiedViewController.swift
//  Shadow
//
//  Created by Navaldeep Kaur on 1/23/18.
//  Copyright © 2018 Atinderjit Kaur. All rights reserved.
//

import UIKit

class AdminVerifiedViewController: UIViewController {

    @IBOutlet weak var tableView_verified: UITableView!
    @IBOutlet weak var top_view: UIView!
    @IBOutlet weak var btn_pending: UIButton!
    @IBOutlet weak var btn_verified: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    var int_selectedBtn:Int = 1
    var arr_verified = NSMutableArray()
    
    fileprivate  var pageIndex :  Int = 0                     //Pagination Parameters
    fileprivate var pageSize :    Int = 0
    var pointNow :                CGPoint?
    var isFetching:               Bool =  false
    var str_searchText:           String = ""
    
    var bool_LastResultSearch :   Bool = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView_verified.tableFooterView = UIView()
        self.title = "Admin"
        
        let myBackButton:UIButton = UIButton()
        myBackButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        myBackButton.setImage(UIImage(named:"back-new"), for: UIControlState())
        myBackButton.addTarget(self, action: #selector(self.PopToProfile), for: UIControlEvents.touchUpInside)
        let leftBackBarButton:UIBarButtonItem = UIBarButtonItem(customView: myBackButton)
        self.navigationItem.leftBarButtonItem = leftBackBarButton
        
        let myPlusButton:UIButton = UIButton()
        myPlusButton.frame = CGRect(x: 0, y: 0, width: 18, height: 18)
        myPlusButton.setImage(UIImage(named:"Trends"), for: UIControlState())
        myPlusButton.addTarget(self, action: #selector(self.PopToProfile), for: UIControlEvents.touchUpInside)
        let RightBackBarButton:UIBarButtonItem = UIBarButtonItem(customView: myPlusButton)
        self.navigationItem.rightBarButtonItem = RightBackBarButton
        
        
        searchBar.backgroundColor = UIColor.init(red: 247.0/255.0, green: 249.0/255.0, blue: 251.0/255.0, alpha: 1.0)
        searchBar.layer.borderColor = UIColor.clear.cgColor
        
        if let textFieldInsideSearchBar = self.searchBar.value(forKey: "searchField") as? UITextField,
            let _ = textFieldInsideSearchBar.leftView as? UIImageView {
            
            textFieldInsideSearchBar.layer.borderColor = UIColor.clear.cgColor
            textFieldInsideSearchBar.backgroundColor = UIColor.init(red: 247.0/255.0, green: 249.0/255.0, blue: 251.0/255.0, alpha: 1.0)
 

            if (SavedPreferences.value(forKey: "role") as? String) == "COMPANY" {
                
                getAllVerifiedUserForCompanyAdmin()

                
                
            }
            else{
                
                
               getAllVerifiedUserListForSchoolAdmin()
            }
            
        // Do any additional setup after loading the view.
    }
      }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {

        self.int_selectedBtn  = 1
        
        if Global.DeviceType.IS_IPHONE_6P {
            
           
             self.top_view.frame = CGRect(x: 21, y: self.btn_pending.frame.origin.y + self.btn_pending.frame.size.height + 8, width: 124, height: 1)
        }
            
        else {
            
            self.top_view.frame = CGRect(x: 15, y: self.btn_pending.frame.origin.y + self.btn_pending.frame.size.height + 8, width: 124, height: 1)
            
        }
            
            
            self.top_view.backgroundColor = Global.macros.themeColor_pink
            //Showing line and color of accepted button
            self.btn_verified.setTitleColor(Global.macros.themeColor_pink, for: .normal)
            self.btn_pending.setTitleColor(UIColor.init(red: 104.0/255.0, green: 112.0/255.0, blue:115.0/255.0, alpha: 1.0), for: .normal)
          
            
        }
        self.tableView_verified.tableFooterView = UIView()
        let swipeleft = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeleft))
        swipeleft.direction = .left
        self.tableView_verified.addGestureRecognizer(swipeleft)
        self.view.addGestureRecognizer(swipeleft)
        
        
        let swiperight = UISwipeGestureRecognizer(target: self, action: #selector(self.swiperight))
        swiperight.direction = .right
        self.tableView_verified.addGestureRecognizer(swiperight)
        self.view.addGestureRecognizer(swiperight)
        
        
        

    }
    override func viewDidDisappear(_ animated: Bool) {
        
        bool_LastResultSearch = false
        self.searchBar.text = ""
        
    }
    
    
    func PopToProfile() {
        
        _ = self.navigationController?.popViewController(animated: true)
    }

 
    // MARK:- Action
    
    @IBAction func btn_verified(_ sender: Any) {
        
        DispatchQueue.main.async {

        if Global.DeviceType.IS_IPHONE_6P {
          
               self.top_view.frame = CGRect(x: 21, y: self.btn_pending.frame.origin.y + self.btn_pending.frame.size.height + 8, width: 124, height: 1)
        }
            
        else {
            
              self.top_view.frame = CGRect(x: 15, y: self.btn_pending.frame.origin.y + self.btn_pending.frame.size.height + 8, width: 124, height: 1)
            
        }
            
            
            self.btn_verified.setTitleColor(Global.macros.themeColor_pink, for: .normal)
            self.btn_pending.setTitleColor(UIColor.init(red: 104.0/255.0, green: 112.0/255.0, blue:115.0/255.0, alpha: 1.0), for: .normal)
        }
        
        
        
        int_selectedBtn  = 1
        self.arr_verified.removeAllObjects()
        if (SavedPreferences.value(forKey: "role") as? String) == "COMPANY" {
            
            getAllVerifiedUserForCompanyAdmin()
            
            
            
        }
        else{
            
            
            getAllVerifiedUserListForSchoolAdmin()
        }
        
    }

    @IBAction func btn_pending(_ sender: Any) {
        
      
        DispatchQueue.main.async {
            
             self.int_selectedBtn  = 2
            if Global.DeviceType.IS_IPHONE_6P {
                
                self.top_view.frame = CGRect(x: 276, y: self.btn_pending.frame.origin.y + self.btn_pending.frame.size.height + 8, width: 124, height: 1)
                
                
            }
                
            else {
                
                self.top_view.frame = CGRect(x: 238, y: self.btn_pending.frame.origin.y + self.btn_pending.frame.size.height + 8, width: 124, height: 1)
            }
           
            self.btn_pending.setTitleColor(Global.macros.themeColor_pink, for: .normal)
            self.btn_verified.setTitleColor(UIColor.init(red: 104.0/255.0, green: 112.0/255.0, blue:115.0/255.0, alpha: 1.0), for: .normal)
        }
        
    
        self.arr_verified.removeAllObjects()
        if (SavedPreferences.value(forKey: "role") as? String) == "COMPANY" {
            
            
             getAllPendingUserForCompanyAdmin()
            
        }
        else{
            
            
            getAllPendingUserListForSchoolAdmin()
        }
        
    }
    
    @IBAction func btn_remove(_ sender: UIButton) {
       
        if  self.int_selectedBtn  == 2 {
            
            let dictionary = arr_verified.object(at: sender.tag) as! NSDictionary
            //setting user info
            let dict_UserInfo = dictionary.value(forKey: "userDTO") as! NSDictionary
            
            let userId = dict_UserInfo["userId"] as? NSNumber
            
            verfied_User(userId: userId!,accept : 0) // to reject user

            
        }
            
        else {
            
            let dictionary = arr_verified.object(at: sender.tag) as! NSDictionary
            //setting user info
            let dict_UserInfo = dictionary.value(forKey: "userDTO") as! NSDictionary
            
            let userId = dict_UserInfo["userId"] as? NSNumber
            
            verfied_User(userId: userId!,accept : 0) // to reject user
            
        }
        
    }
    
    @IBAction func btn_schedule(_ sender: UIButton) {
        
        if  self.int_selectedBtn  == 2 {
            
            let dictionary = arr_verified.object(at: sender.tag) as! NSDictionary
            //setting user info
            let dict_UserInfo = dictionary.value(forKey: "userDTO") as! NSDictionary
            
            let userId = dict_UserInfo["userId"] as? NSNumber
            
            verfied_User(userId: userId!,accept : 1) // to verify user
            
            
        }
        
        else {
            
            let dictionary = arr_verified.object(at: sender.tag) as! NSDictionary
            //setting user info
            let dict_UserInfo = dictionary.value(forKey: "userDTO") as! NSDictionary
            
            let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "send_request") as! SendRequestViewController
            vc.user_Name =  dictionary["name"] as? String
            let userId = dict_UserInfo["userId"] as? NSNumber

            vc.userIdFromSendRequest = userId
            //userIdFromSearch
            _ = self.navigationController?.pushViewController(vc, animated: true)
            
            
        }
        
    }
    // MARk:- Services 
    
    
    func verfied_User(userId : NSNumber, accept : NSNumber) {
        
     
        var str_type : String = ""
        if (SavedPreferences.value(forKey: "role") as? String) == "COMPANY" {
            str_type = "COMPANY"
        }
        else{
            
             str_type = "SCHOOL"
        }
        
        let dict = NSMutableDictionary()
        let user_Id = SavedPreferences.value(forKey: Global.macros.kUserId) as? NSNumber
        dict.setValue(user_Id, forKey: Global.macros.kUserId)
        dict.setValue(userId, forKey: "otherUserId")
        dict.setValue(str_type, forKey: "type")
        dict.setValue(accept, forKey: "accept")
        print(dict)
        
        
        if self.checkInternetConnection(){
            
            DispatchQueue.main.async {
                self.pleaseWait()
            }
            
            Requests_API.sharedInstance.updateUserVerificationByType(completionBlock: { (status, dict_Info) in
                DispatchQueue.main.async {
                    self.clearAllNotice()
                }
                switch status{
                    
                case 200:
                    
                    DispatchQueue.main.async {
                        
                        self.tableView_verified.isHidden = false
                        self.showAlert(Message: "User has verified/removed successfully.", vc: self)

                        
                    }
                    
                    if  self.int_selectedBtn  == 2 {
                        
                         self.arr_verified.removeAllObjects()
                        self.getAllPendingUserForCompanyAdmin()
                        
                        
                        if (SavedPreferences.value(forKey: "role") as? String) == "COMPANY" {
                            
                            self.getAllPendingUserForCompanyAdmin()
                            
                            
                            
                        }
                        else{
                            
                            
                            self.getAllPendingUserListForSchoolAdmin()
                        }
 
                        
                        
                        
                        
                    }
                        
                    else {
                        self.arr_verified.removeAllObjects()

                        if (SavedPreferences.value(forKey: "role") as? String) == "COMPANY" {
                            
                            self.getAllVerifiedUserForCompanyAdmin()
                            
                            
                            
                        }
                        else{
                            
                            
                            self.getAllVerifiedUserListForSchoolAdmin()
                        }
                        
                    }
                    
                    break
                    
                case 404:
                    
                    DispatchQueue.main.async {
                        
                        self.showAlert(Message: Global.macros.kError, vc: self)
                        self.tableView_verified.isHidden = true
                        self.arr_verified = NSMutableArray()
                        self.tableView_verified.reloadData()
                    }
                    
                default:
                    DispatchQueue.main.async {
                        self.showAlert(Message: Global.macros.kError, vc: self)
                        self.tableView_verified.isHidden = true
                        self.arr_verified = NSMutableArray()
                        self.tableView_verified.reloadData()
                        
                    }
                    break
                }
                
            }, errorBlock: { (error) in
                DispatchQueue.main.async {
                    self.clearAllNotice()
                    self.showAlert(Message: Global.macros.kError, vc: self)
                }
            }, dict: dict)
        }
        else{
            self.showAlert(Message: Global.macros.kInternetConnection, vc: self)
        }
        
        
    }
    
    func getAllVerifiedUserForCompanyAdmin()
    {
        let dict = NSMutableDictionary()
        let user_Id = SavedPreferences.value(forKey: Global.macros.kUserId) as? NSNumber
        dict.setValue(user_Id, forKey: Global.macros.kUserId)
        dict.setValue(str_searchText, forKey: "searchKeyword")
        dict.setValue(0, forKey: "pageIndex")
        dict.setValue(100, forKey: "pageSize")
        print(dict)
        
         self.bool_LastResultSearch = true
        if self.checkInternetConnection(){
            if str_searchText  == ""             {
 
            DispatchQueue.main.async {
                self.pleaseWait()
            }
                
            }
            isFetching = false

            Requests_API.sharedInstance.getAllVerifiedUserForCompanyAdmin(completionBlock: { (status, dict_Info) in
                DispatchQueue.main.async {
                    self.clearAllNotice()
                }
                
                self.isFetching = true

                switch status{
                    
                case 200:
                    
                    DispatchQueue.main.async {
                        
                        self.tableView_verified.isHidden = false

                        let arr = dict_Info.value(forKey: "data") as? NSDictionary
                       
                        self.arr_verified.addObjects(from: dict_Info.value(forKey: "data") as? NSArray as! [Any])
                        self.tableView_verified.reloadData()
                        
                        self.bool_LastResultSearch = true
                        
                        if self.arr_verified.count == 0 {
                            
                            self.bool_LastResultSearch = false
                        }
                        
                    }
                    
                    break
                    
                case 404:
                    
                    DispatchQueue.main.async {
                        
                        self.showAlert(Message: "No data found.", vc: self)
                        self.tableView_verified.isHidden = true
                        self.arr_verified = NSMutableArray()
                        self.tableView_verified.reloadData()
                         self.bool_LastResultSearch = false
                    }
                    
                    
                case 400:
                    DispatchQueue.main.async {
                        
                        self.showAlert(Message: "User unauthorized to get details.", vc: self)
                        self.tableView_verified.isHidden = true
                        self.arr_verified = NSMutableArray()
                        self.tableView_verified.reloadData()
                        self.bool_LastResultSearch = false
                        
                    }
                    
                default:
                    DispatchQueue.main.async {
                        self.showAlert(Message: Global.macros.kError, vc: self)
                        self.tableView_verified.isHidden = true
                        self.arr_verified = NSMutableArray()
                        self.tableView_verified.reloadData()
                        self.bool_LastResultSearch = false

                        
                    }
                    break
                }
                
            }, errorBlock: { (error) in
                DispatchQueue.main.async {
                    self.clearAllNotice()
                    self.bool_LastResultSearch = false

                    self.showAlert(Message: Global.macros.kError, vc: self)
                }
            }, dict: dict)
        }
        else{
            self.showAlert(Message: Global.macros.kInternetConnection, vc: self)
        }
        
    }
    
    func getAllPendingUserForCompanyAdmin() {

        
        let dict = NSMutableDictionary()
        let user_Id = SavedPreferences.value(forKey: Global.macros.kUserId) as? NSNumber
        dict.setValue(user_Id, forKey: Global.macros.kUserId)
         dict.setValue(str_searchText, forKey: "searchKeyword")
        dict.setValue(0, forKey: "pageIndex")
        dict.setValue(100, forKey: "pageSize")
        print(dict)
        
         self.bool_LastResultSearch = true
        
        if self.checkInternetConnection(){
            if str_searchText  == ""             {
 
            DispatchQueue.main.async {
                self.pleaseWait()
            }
            }
            isFetching = false

            Requests_API.sharedInstance.getAllPendingUserListForCompanyAdmin(completionBlock: { (status, dict_Info) in
                DispatchQueue.main.async {
                    self.clearAllNotice()
                }
                
                self.isFetching = true

                switch status{
                    
                case 200:
                    
                    DispatchQueue.main.async {
                        self.tableView_verified.isHidden = false

                        let arr = dict_Info.value(forKey: "data") as? NSArray
                        self.arr_verified.addObjects(from: arr as! [Any])
                        self.tableView_verified.reloadData()
                        
                        self.bool_LastResultSearch = true
                        
                        if self.arr_verified.count == 0 {
                            
                            self.bool_LastResultSearch = false
                        }
                    }
                    
                    break
                    
                case 404:
                    
                    DispatchQueue.main.async {
                        
                        self.showAlert(Message: "No data found.", vc: self)
                        self.tableView_verified.isHidden = true
                        self.arr_verified = NSMutableArray()
                        self.tableView_verified.reloadData()
                        self.bool_LastResultSearch = false

                    }
                    
                    
                case 400:
                    DispatchQueue.main.async {
                        
                        self.showAlert(Message: "User unauthorized to get details.", vc: self)
                        self.tableView_verified.isHidden = true
                        self.arr_verified = NSMutableArray()
                        self.tableView_verified.reloadData()
                        self.bool_LastResultSearch = false
                        
                    }
                    
                default:
                    DispatchQueue.main.async {
                        self.showAlert(Message: Global.macros.kError, vc: self)
                        self.showAlert(Message: Global.macros.kError, vc: self)
                        self.tableView_verified.isHidden = true
                        self.arr_verified = NSMutableArray()
                        self.tableView_verified.reloadData()
                         self.bool_LastResultSearch = false
                        
                    }
                    break
                }
                
            }, errorBlock: { (error) in
                DispatchQueue.main.async {
                    self.clearAllNotice()
                    self.showAlert(Message: Global.macros.kError, vc: self)
                     self.bool_LastResultSearch = false
                }
            }, dict: dict)
        }
        else{
            self.showAlert(Message: Global.macros.kInternetConnection, vc: self)
        }
   
        
    }
    
    
    
    
    func getAllVerifiedUserListForSchoolAdmin() {
        
        let dict = NSMutableDictionary()
        let user_Id = SavedPreferences.value(forKey: Global.macros.kUserId) as? NSNumber
        dict.setValue(user_Id, forKey: Global.macros.kUserId)
        dict.setValue(str_searchText, forKey: "searchKeyword")
        dict.setValue(0, forKey: "pageIndex")
        dict.setValue(100, forKey: "pageSize")
        print(dict)
        
        self.bool_LastResultSearch = true
        if self.checkInternetConnection(){
            if str_searchText  == ""             {
                
                DispatchQueue.main.async {
                    self.pleaseWait()
                }
                
            }
            isFetching = false
            
            Requests_API.sharedInstance.getAllVerifiedUserListForSchoolAdmin(completionBlock: { (status, dict_Info) in
                DispatchQueue.main.async {
                    self.clearAllNotice()
                }
                
                self.isFetching = true
                
                switch status{
                    
                case 200:
                    
                    DispatchQueue.main.async {
                        
                        self.tableView_verified.isHidden = false
                        
                        let arr = dict_Info.value(forKey: "data") as? NSDictionary
                        
                        self.arr_verified.addObjects(from: dict_Info.value(forKey: "data") as? NSArray as! [Any])
                        self.tableView_verified.reloadData()
                        
                        self.bool_LastResultSearch = true
                        
                        if self.arr_verified.count == 0 {
                            
                            self.bool_LastResultSearch = false
                        }
                        
                    }
                    
                    break
                    
                case 404:
                    
                    DispatchQueue.main.async {
                        
                        self.showAlert(Message: "No data found.", vc: self)
                        self.tableView_verified.isHidden = true
                        self.arr_verified = NSMutableArray()
                        self.tableView_verified.reloadData()
                        self.bool_LastResultSearch = false
                    }
                    
                case 400:
                    DispatchQueue.main.async {
                        
                        self.showAlert(Message: "User unauthorized to get details.", vc: self)
                        self.tableView_verified.isHidden = true
                        self.arr_verified = NSMutableArray()
                        self.tableView_verified.reloadData()
                        self.bool_LastResultSearch = false
                        
                    }
                    
                default:
                    DispatchQueue.main.async {
                        self.showAlert(Message: Global.macros.kError, vc: self)
                        self.tableView_verified.isHidden = true
                        self.arr_verified = NSMutableArray()
                        self.tableView_verified.reloadData()
                        self.bool_LastResultSearch = false
                        
                        
                    }
                    break
                }
                
            }, errorBlock: { (error) in
                DispatchQueue.main.async {
                    self.clearAllNotice()
                    self.bool_LastResultSearch = false
                    
                    self.showAlert(Message: Global.macros.kError, vc: self)
                }
            }, dict: dict)
        }
        else{
            self.showAlert(Message: Global.macros.kInternetConnection, vc: self)
        }

        
        
    }
    
    
    func getAllPendingUserListForSchoolAdmin() {
        
  
        
        let dict = NSMutableDictionary()
        let user_Id = SavedPreferences.value(forKey: Global.macros.kUserId) as? NSNumber
        dict.setValue(user_Id, forKey: Global.macros.kUserId)
        dict.setValue(str_searchText, forKey: "searchKeyword")
        dict.setValue(0, forKey: "pageIndex")
        dict.setValue(100, forKey: "pageSize")
        print(dict)
        
        self.bool_LastResultSearch = true
        
        if self.checkInternetConnection(){
            if str_searchText  == ""             {
                
                DispatchQueue.main.async {
                    self.pleaseWait()
                }
            }
            isFetching = false
            
            Requests_API.sharedInstance.getAllPendingUserListForSchoolAdmin(completionBlock: { (status, dict_Info) in
                DispatchQueue.main.async {
                    self.clearAllNotice()
                }
                
                self.isFetching = true
                
                switch status{
                    
                case 200:
                    
                    DispatchQueue.main.async {
                        self.tableView_verified.isHidden = false
                        
                        let arr = dict_Info.value(forKey: "data") as? NSArray
                        self.arr_verified.addObjects(from: arr as! [Any])
                        self.tableView_verified.reloadData()
                        
                        self.bool_LastResultSearch = true
                        
                        if self.arr_verified.count == 0 {
                            
                            self.bool_LastResultSearch = false
                        }
                    }
                    
                    break
                    
                case 404:
                    
                    DispatchQueue.main.async {
                        
                        self.showAlert(Message: "No data found.", vc: self)
                        self.tableView_verified.isHidden = true
                        self.arr_verified = NSMutableArray()
                        self.tableView_verified.reloadData()
                        self.bool_LastResultSearch = false
                        
                    }
                    
                case 400:
                    DispatchQueue.main.async {
                        
                        self.showAlert(Message: "User unauthorized to get details.", vc: self)
                        self.tableView_verified.isHidden = true
                        self.arr_verified = NSMutableArray()
                        self.tableView_verified.reloadData()
                        self.bool_LastResultSearch = false
                        
                    }
                    
                    
                default:
                    DispatchQueue.main.async {
                        self.showAlert(Message: Global.macros.kError, vc: self)
                        self.showAlert(Message: Global.macros.kError, vc: self)
                        self.tableView_verified.isHidden = true
                        self.arr_verified = NSMutableArray()
                        self.tableView_verified.reloadData()
                        self.bool_LastResultSearch = false
                        
                    }
                    break
                }
                
            }, errorBlock: { (error) in
                DispatchQueue.main.async {
                    self.clearAllNotice()
                    self.showAlert(Message: Global.macros.kError, vc: self)
                    self.bool_LastResultSearch = false
                }
            }, dict: dict)
        }
        else{
            self.showAlert(Message: Global.macros.kInternetConnection, vc: self)
        }
        
        
    }

    
    
    func swipeleft(_ gestureRecognizer: UISwipeGestureRecognizer) { //NEXT
        
        
            self.top_view.frame.size.width = self.btn_pending.frame.size.width
        
            if self.int_selectedBtn < 2 {
                
                let transition = CATransition()
                transition.duration = 0.5
                transition.type = kCATransitionPush
                transition.subtype = kCATransitionFromRight
                DispatchQueue.main.async {

                
                UIView.animate(withDuration: 0.5, animations: { // 3.0 are the seconds
                    
                    // Write your code here for e.g. Increasing any Subviews height.
                    if self.int_selectedBtn == 1 {
                        self.int_selectedBtn = self.int_selectedBtn + 1
                        
                  
                        DispatchQueue.main.async {
                            
                            
                            if Global.DeviceType.IS_IPHONE_6P  {
                                
                               
                                  self.top_view.frame = CGRect(x: 276, y: self.btn_pending.frame.origin.y + self.btn_pending.frame.size.height + 8, width: 124, height: 1)
                                
                            }
                                
                            else {
                                self.top_view.frame = CGRect(x: 238, y: self.btn_pending.frame.origin.y + self.btn_pending.frame.size.height + 8, width: 124, height: 1)
                                
                              
                                
                            }
                            
                            self.btn_pending.setTitleColor(Global.macros.themeColor_pink, for: .normal)
                            self.btn_verified.setTitleColor(UIColor.init(red: 104.0/255.0, green: 112.0/255.0, blue:115.0/255.0, alpha: 1.0), for: .normal)
                        
                        }
                        
                        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                        self.tableView_verified.layer.add(transition, forKey: nil)
                    }

                    
                    
                })
                
                }
                self.arr_verified.removeAllObjects()
                if (SavedPreferences.value(forKey: "role") as? String) == "COMPANY" {
                    
                    
                    getAllPendingUserForCompanyAdmin()
                    
                }
                else{
                    
                    
                    
                    getAllPendingUserListForSchoolAdmin()
                }
                
                
            }
        
    }
    
    func swiperight(_ gestureRecognizer: UISwipeGestureRecognizer) { //PREVIOUS
        
        
            self.top_view.frame.size.width = self.btn_pending.frame.size.width
            
            
            if self.int_selectedBtn > 0   {
                
                let transition = CATransition()
                transition.duration = 0.5
                transition.type = kCATransitionPush
                transition.subtype = kCATransitionFromLeft
                
                DispatchQueue.main.async {

                UIView.animate(withDuration: 0.5, animations: { // 3.0 are the seconds
                    
                    // Write your code here for e.g. Increasing any Subviews height.
                    
                    if self.int_selectedBtn == 2 {
                        self.int_selectedBtn = self.int_selectedBtn - 1
                        
                 
                        DispatchQueue.main.async {
                            
                            
                            if Global.DeviceType.IS_IPHONE_6P {
                                
                                  self.top_view.frame = CGRect(x: 21, y: self.btn_pending.frame.origin.y + self.btn_pending.frame.size.height + 8, width: 124, height: 1)
                                
                            }
                                
                            else {
                                
                             
                                
                                 self.top_view.frame = CGRect(x: 15, y: self.btn_pending.frame.origin.y + self.btn_pending.frame.size.height + 8, width: 124, height: 1)
                                
                            }
                            
                            self.btn_verified.setTitleColor(Global.macros.themeColor_pink, for: .normal)
                            self.btn_pending.setTitleColor(UIColor.init(red: 104.0/255.0, green: 112.0/255.0, blue:115.0/255.0, alpha: 1.0), for: .normal)
                        
                        }
                        
                        
                        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                        self.tableView_verified.layer.add(transition, forKey: nil)
                        
                    }

                    
                }) }
                self.arr_verified.removeAllObjects()

                if (SavedPreferences.value(forKey: "role") as? String) == "COMPANY" {
                    
                    getAllVerifiedUserForCompanyAdmin()
                    
                    
                    
                }
                else{
                    
                    
                    getAllVerifiedUserListForSchoolAdmin()
                }
                

            }
        
        
    }
    
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        pointNow = scrollView.contentOffset
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        
        
        if scrollView == self.tableView_verified {       //Pagination for tableview
            
            print(scrollView.contentOffset.y)
            if (scrollView.contentOffset.y<(pointNow?.y)!) {
                print("down")
            } else if (scrollView.contentOffset.y>(pointNow?.y)!) {
                
                if isFetching {
                    self.pageIndex = self.pageIndex + 1
                    isFetching = true
                    
                    if  self.int_selectedBtn  == 2 {
                        
                   //     self.getAllPendingUserForCompanyAdmin()
                        
                    }
                        
                    else {
                        
                     //   self.getAllVerifiedUserForCompanyAdmin()
                        
                    }

                    
                    
                    
                }
            }
            
        }
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
extension AdminVerifiedViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! VerifiedTableViewCell
        
        cell.btn_schedule.tag = indexPath.section
        cell.btn_remove.tag = indexPath.section
         cell.imageView_user.image = UIImage(named: "dummySearch")
        
        
        if  self.int_selectedBtn  == 2 {
            
            DispatchQueue.main.async {
                cell.btn_schedule.setTitle("", for: UIControlState.normal)
                let image = UIImage(named: "admintick")
                cell.btn_schedule.setImage(image, for: .normal)
                cell.btn_schedule.backgroundColor = UIColor.white
                cell.btn_schedule.layer.borderColor = UIColor.init(red: 148.0/255.0, green: 226.0/255.0, blue: 124.0/255.0, alpha: 1.0).cgColor
                
                let image1 = UIImage(named: "admincross")
                cell.btn_remove.setImage(image1, for: .normal)
                cell.btn_remove.setTitle("", for: UIControlState.normal)
                cell.btn_remove.backgroundColor = UIColor.white
                cell.btn_remove.layer.borderColor = UIColor.init(red: 244.0/255.0, green: 131.0/255.0,blue: 111.0/255.0, alpha: 1.0).cgColor
                cell.btn_remove.setTitleColor(UIColor.init(red: 244.0/255.0, green: 131.0/255.0,blue: 111.0/255.0, alpha: 1.0), for: .normal)
            }
           
            let dictionary = arr_verified.object(at: indexPath.section) as! NSDictionary
            //setting user info
            let dict_UserInfo = dictionary.value(forKey: "userDTO") as! NSDictionary

            cell.lbl_userName.text = dictionary.value(forKey: "name") as? String
            
            if dict_UserInfo.value(forKey: "companyName") as? String != ""{

            
            cell.lbl_CompanyName.text = dict_UserInfo.value(forKey: "companyName") as? String
            
            
        }
                
            else {
                
                cell.lbl_CompanyName.text = dict_UserInfo.value(forKey: "schoolName") as? String

                
            }
            
            
            cell.lbl_rating.text = "\((dict_UserInfo).value(forKey: "ratingCount")!)"
            
            if cell.lbl_rating.text == "0" || cell.lbl_rating.text == "1" {
                cell.lbl_textRating.text = "rating"
            }
            else {
                cell.lbl_textRating.text = "ratings"
            }
            
            let str_avgRating = ((dict_UserInfo).value(forKey: "avgRating") as? NSNumber)?.stringValue
            
            let dbl = 2.0
            if  dbl.truncatingRemainder(dividingBy: 1) == 0{
                cell.lbl_star.text = str_avgRating! + ".0"
            }
            else{
                cell.lbl_star.text = str_avgRating!
            }
            
            let str_profileImage = dict_UserInfo.value(forKey: "profileImageUrl") as? String
            if str_profileImage != nil{
                cell.imageView_user.sd_setImage(with: URL.init(string: str_profileImage!), placeholderImage: UIImage.init(named: "dummySearch"))
            }
            if dictionary.value(forKey: "verifyTimeAgo") != nil  && dictionary.value(forKey: "verifyTimeAgo") as! NSString != "" {
                let time : NSString = dictionary.value(forKey: "verifyTimeAgo") as! NSString
                
                print(time)
                let delimiter = " "
                var token = time.components(separatedBy: delimiter)
                
                if token[1].contains("m")
                {
                    cell.lbl_Time.text = (token[0]) + "m"
                    
                }
                else if token[1].contains("d") {
                    
                    cell.lbl_Time.text = (token[0]) + "d"
                    
                }
                else if token[1].contains("h") {
                    
                    cell.lbl_Time.text = (token[0]) + "h"
                    
                }
                    
                else {
                    cell.lbl_Time.text = "Now"
                    
                }
                
            }
        }
        
        else {
         
            DispatchQueue.main.async {

            cell.btn_schedule.setTitle("  Schedule", for: UIControlState.normal)
            let image = UIImage(named: "calendernew")
            cell.btn_schedule.setImage(image, for: .normal)
            cell.btn_schedule.backgroundColor = UIColor.init(red: 148.0/255.0, green: 226.0/255.0, blue: 124.0/255.0, alpha: 1.0)
                cell.btn_schedule.layer.borderColor = UIColor.init(red: 148.0/255.0, green: 226.0/255.0, blue: 124.0/255.0, alpha: 1.0).cgColor
                
            
            
            cell.btn_remove.setTitle("Remove", for: UIControlState.normal)
                cell.btn_remove.setImage(nil, for: .normal)

            cell.btn_remove.backgroundColor = UIColor.white
           cell.btn_remove.layer.borderColor = UIColor.init(red: 244.0/255.0, green:131.0/255.0,blue: 111.0/255.0,alpha: 1.0).cgColor
            }
            
            let dictionary = arr_verified.object(at: indexPath.section) as! NSDictionary
            //setting user info
            let dict_UserInfo = dictionary.value(forKey: "userDTO") as! NSDictionary
            
            cell.lbl_userName.text = dictionary.value(forKey: "name") as? String
            
            if dict_UserInfo.value(forKey: "companyName") as? String != ""{
                
                
                cell.lbl_CompanyName.text = dict_UserInfo.value(forKey: "companyName") as? String
                
                
            }
                
            else {
                
                cell.lbl_CompanyName.text = dict_UserInfo.value(forKey: "schoolName") as? String
                
                
            }
            
            
            cell.lbl_rating.text = "\((dict_UserInfo).value(forKey: "ratingCount")!)"
            
            if cell.lbl_rating.text == "0" || cell.lbl_rating.text == "1" {
                cell.lbl_textRating.text = "rating"
            }
            else {
                cell.lbl_textRating.text = "ratings"
            }
            
            let str_avgRating = ((dict_UserInfo).value(forKey: "avgRating") as? NSNumber)?.stringValue
            
            let dbl = 2.0
            if  dbl.truncatingRemainder(dividingBy: 1) == 0{
                cell.lbl_star.text = str_avgRating! + ".0"
            }
            else{
                cell.lbl_star.text = str_avgRating!
            }
            
            let str_profileImage = dict_UserInfo.value(forKey: "profileImageUrl") as? String
            if str_profileImage != nil{
                cell.imageView_user.sd_setImage(with: URL.init(string: str_profileImage!), placeholderImage: UIImage.init(named: "dummySearch"))
            }
            if dictionary.value(forKey: "verifyTimeAgo") != nil && dictionary.value(forKey: "verifyTimeAgo") as! NSString != ""{
                let time : NSString = dictionary.value(forKey: "verifyTimeAgo") as! NSString
                
                print(time)
                let delimiter = " "
                var token = time.components(separatedBy: delimiter)
                
                if token[1].contains("m")
                {
                    cell.lbl_Time.text = (token[0]) + "m"
                    
                }
                else if token[1].contains("d") {
                    
                    cell.lbl_Time.text = (token[0]) + "d"
                    
                }
                else if token[1].contains("h") {
                    
                    cell.lbl_Time.text = (token[0]) + "h"
                    
                }
                    
                else {
                    cell.lbl_Time.text = "Now"
                    
                }
                
            }
        }

        
        
        // cell.contentView.layer.borderWidth = 1.0
        // cell.contentView.layer.borderColor = Global.macros.themeColor.cgColor
        cell.contentView.layer.cornerRadius = 5.0
      //  cell.DataToCell(dictionary: array_Requests.object(at: indexPath.section) as! NSDictionary)
        
         self.bool_LastResultSearch = false
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if arr_verified.count > 0 {
            return arr_verified.count
        }
        else{
            return 0
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        bool_ComingFromList = true
        bool_UserIdComingFromSearch = false
        
        var user_dict = NSDictionary()
        user_dict = self.arr_verified[indexPath.section] as! NSDictionary
        if user_dict["userDTO"] != nil{
            
            user_dict = user_dict.value(forKey: "userDTO") as! NSDictionary
        }
        
      //  let role = user_dict.value(forKey: Global.macros.krole) as? String
        
        
        
        DispatchQueue.main.async {
            
            let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "user") as! ProfileVC
            vc.userIdFromList = user_dict["userId"] as? NSNumber
            
            _ = self.navigationController?.pushViewController(vc, animated: true)
            vc.extendedLayoutIncludesOpaqueBars = true
            self.automaticallyAdjustsScrollViewInsets = false
            //self.navigationController?.navigationBar.isTranslucent = false
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 5.0
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = UIView()
        header.backgroundColor = UIColor.clear
        return header
        
        
    }
    
}

extension AdminVerifiedViewController:UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            self.searchBar.resignFirstResponder()
            return false
        }
        else {
            return true
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        
        
        self.searchBar.showsCancelButton = false
        str_searchText = searchText
        
        if ((self.str_searchText.characters.count) > 2 ) {
            
            if bool_LastResultSearch == false {
                
                pageIndex = 0
                self.arr_verified.removeAllObjects()
                
                if int_selectedBtn == 1 {
                    
                    self.getAllVerifiedUserForCompanyAdmin()
                }
                    
                else if int_selectedBtn == 2 {
                    
                    self.getAllPendingUserForCompanyAdmin()
                    
                }
                    
                
                
            }
            
            
            
            
        }
        else  if ((self.str_searchText.characters.count) == 0 ) {
            
            
            pageIndex = 0
            self.arr_verified.removeAllObjects()
            
            
            if int_selectedBtn == 1 {
                
                self.getAllVerifiedUserForCompanyAdmin()
            }
                
            else if int_selectedBtn == 2 {
                
                self.getAllPendingUserForCompanyAdmin()
                
            }
                
            
            
        }
        else{
            self.arr_verified.removeAllObjects()
            self.tableView_verified.reloadData()
        }
        
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.alpha = 1
        self.searchBar.showsCancelButton = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {}
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {}
    
}


