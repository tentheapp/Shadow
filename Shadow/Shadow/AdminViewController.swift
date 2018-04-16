//
//  AdminViewController.swift
//  Shadow
//
//  Created by Navaldeep Kaur on 1/23/18.
//  Copyright © 2018 Atinderjit Kaur. All rights reserved.
//

import UIKit

class AdminViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var btn_school: UIButton!
    @IBOutlet var adminTable_view: UITableView!
    @IBOutlet var btn_Company: UIButton!
    @IBOutlet var view_Line: UIView!
    var str_searchText:   String = ""
    @IBOutlet weak var btn_User: UIButton!
   
    var int_selectedBtn:Int = 1
    var arr_Users = NSMutableArray()
    
    
    fileprivate  var pageIndex :  Int = 0                     //Pagination Parameters
    fileprivate var pageSize :    Int = 0
    var pointNow :                CGPoint?
    var isFetching:               Bool =  false
    var bool_LastResultSearch :   Bool = false
    
   // var str_role : String? = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.adminTable_view.tableFooterView = UIView()
        self.title = "Admin"
        
        let myBackButton:UIButton = UIButton()
        myBackButton.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
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
            
        }
        
        DispatchQueue.main.async {
            self.int_selectedBtn  = 1
            if Global.DeviceType.IS_IPHONE_6P {
              
                  self.view_Line.frame = CGRect(x: 148, y: self.btn_User.frame.origin.y + self.btn_User.frame.size.height + 10, width: 124, height: 1)
            }
                
            else {
                
                self.view_Line.frame = CGRect(x: 126, y: self.btn_User.frame.origin.y + self.btn_User.frame.size.height + 10, width: 124, height: 1)
                
            }
            self.view_Line.backgroundColor = Global.macros.themeColor_pink
            self.btn_school.setTitleColor(Global.macros.themeColor_pink, for: .normal)
            //hiding the lines and changing color unselected buttons
            self.btn_User.setTitleColor(UIColor.init(red: 104.0/255.0, green: 112.0/255.0, blue:115.0/255.0, alpha: 1.0), for: .normal)
            self.btn_Company.setTitleColor(UIColor.init(red: 104.0/255.0, green: 112.0/255.0, blue:115.0/255.0, alpha: 1.0), for: .normal)
            self.adminTable_view.tableFooterView = UIView()
            let swipeleft = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeleft))
            swipeleft.direction = .left
            self.adminTable_view.addGestureRecognizer(swipeleft)
            self.view.addGestureRecognizer(swipeleft)
        }

        
        
        let swiperight = UISwipeGestureRecognizer(target: self, action: #selector(self.swiperight))
        swiperight.direction = .right
        self.adminTable_view.addGestureRecognizer(swiperight)
        self.view.addGestureRecognizer(swiperight)
        self.getAllPendingUserByTypeForSuperAdmin(str_role: "School")

       
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        
    }
    
    func PopToProfile() {
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        bool_LastResultSearch = false
        self.searchBar.text = ""
        
    }
   
    
    // MARK:- Action
    
    @IBAction func btn_User(_ sender: Any) {
       // searchFilterService()
        
        DispatchQueue.main.async {
             self.view_Line.frame = CGRect(x: 1, y: self.btn_User.frame.origin.y + self.btn_User.frame.size.height + 10, width: 124, height: 1)
            
            self.int_selectedBtn = 0
            self.view_Line.backgroundColor = Global.macros.themeColor_pink
            //Showing line and color of accepted button
            self.btn_User.setTitleColor(Global.macros.themeColor_pink, for: .normal)
            self.btn_school.setTitleColor(UIColor.init(red: 104.0/255.0, green: 112.0/255.0, blue:115.0/255.0, alpha: 1.0), for: .normal)
            self.btn_Company.setTitleColor(UIColor.init(red: 104.0/255.0, green: 112.0/255.0, blue:115.0/255.0, alpha: 1.0), for: .normal)
            
           
            self.arr_Users.removeAllObjects()
        }
      
        getAllVerifiedUserByTypeForSuperAdmin()
        
    }
    
    
    @IBAction func btn_School(_ sender: Any) {
        
        
        DispatchQueue.main.async {
            
            
            
            if Global.DeviceType.IS_IPHONE_6P  {
                
              
                
                  self.view_Line.frame = CGRect(x: 148, y: self.btn_User.frame.origin.y + self.btn_User.frame.size.height + 10, width: 124, height: 1)
            }
                
            else {
                
                self.view_Line.frame = CGRect(x: 126, y: self.btn_User.frame.origin.y + self.btn_User.frame.size.height + 10, width: 124, height: 1)

                
                
            }
            self.int_selectedBtn = 1

            self.btn_school.setTitleColor(Global.macros.themeColor_pink, for: .normal)
            self.btn_User.setTitleColor(UIColor.init(red: 104.0/255.0, green: 112.0/255.0, blue:115.0/255.0, alpha: 1.0), for: .normal)
            self.btn_Company.setTitleColor(UIColor.init(red: 104.0/255.0, green: 112.0/255.0, blue:115.0/255.0, alpha: 1.0), for: .normal)
            self.view_Line.backgroundColor = Global.macros.themeColor_pink
        }
        
     

        self.arr_Users.removeAllObjects()
        self.getAllPendingUserByTypeForSuperAdmin(str_role: "School")
  
    }

    @IBAction func btn_Company(_ sender: Any) {
        
      
            DispatchQueue.main.async {
                
                if Global.DeviceType.IS_IPHONE_6P {
                    
                    self.view_Line.frame = CGRect(x: 290, y: self.btn_User.frame.origin.y + self.btn_User.frame.size.height + 10 , width: 124, height: 1)

                }
                    
                else {
                    
                     self.view_Line.frame = CGRect(x: 260, y: self.btn_User.frame.origin.y + self.btn_User.frame.size.height + 10 , width: 124, height: 1)
                }
                
                self.int_selectedBtn = 2

                self.btn_Company.setTitleColor(Global.macros.themeColor_pink, for: .normal)
                //hiding the lines and changing color unselected buttons
                self.btn_User.setTitleColor(UIColor.init(red: 104.0/255.0, green: 112.0/255.0, blue:115.0/255.0, alpha: 1.0), for: .normal)
                self.btn_school.setTitleColor(UIColor.init(red: 104.0/255.0, green: 112.0/255.0, blue:115.0/255.0, alpha: 1.0), for: .normal)
                self.view_Line.backgroundColor = Global.macros.themeColor_pink
            }
        
        
        
           self.arr_Users.removeAllObjects()
        self.getAllPendingUserByTypeForSuperAdmin(str_role: "Company")

    }
    
    
    
    @IBAction func CompanySchool_Verify(_ sender: UIButton) {
        
     if int_selectedBtn == 0 {
        
        let data1: Data? = UIImagePNGRepresentation(sender.currentImage!)
        let data2 : Data? = UIImagePNGRepresentation(UIImage(named: "unlocked")!)
        
        
        if data1 == data2 {
            
            UnblockUserByTypeForSuperAdmin(sender: sender)

        }
         else {
        blockUserByTypeForSuperAdmin(sender: sender)
        }
        
        }
        
     else {
        
        updateUserVerificationByType(sender, accept: 1)
        
        }
        
    }
    
    
    @IBAction func SchoolCompanyDelete(_ sender: UIButton) {
        
        if int_selectedBtn == 0 {
            
            
            let TitleString = NSAttributedString(string: "Shadow", attributes: [
                NSFontAttributeName : UIFont.systemFont(ofSize: 18),
                NSForegroundColorAttributeName : Global.macros.themeColor_pink
                ])
            let MessageString = NSAttributedString(string: "Do you want to delete this user?", attributes: [
                NSFontAttributeName : UIFont.systemFont(ofSize: 15),
                NSForegroundColorAttributeName : Global.macros.themeColor_pink
                ])
            
            let alert = UIAlertController(title: "Shadow", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "Yes", style: .default, handler: { (alert) in
                
                
                    self.deleteUserByTypeForSuperAdmin(sender: sender)

                    
                
                
            }))
            
            alert.addAction(UIAlertAction.init(title: "No", style: .default, handler:nil))
            alert.view.layer.cornerRadius = 10.0
            alert.view.clipsToBounds = true
            alert.view.backgroundColor = UIColor.white
            alert.view.tintColor = Global.macros.themeColor_pink
            
            alert.setValue(TitleString, forKey: "attributedTitle")
            alert.setValue(MessageString, forKey: "attributedMessage")
            self.present(alert, animated: true, completion: nil)
            
            
            
            
        }
            
        else {
            
            updateUserVerificationByType(sender, accept: 0)
            
        }
        
        
        
            
    }
    
    
    func updateUserVerificationByType(_ sender: UIButton, accept : NSNumber) {
        
        let dictionary = arr_Users.object(at: sender.tag) as! NSDictionary
        let dict_UserInfo = dictionary.value(forKey: "userDTO") as! NSDictionary
        let userId = dict_UserInfo["userId"] as? NSNumber
        
        var str_type : String = ""
            str_type = "ADMIN"
        
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
                        
                        self.adminTable_view.isHidden = false
                        self.showAlert(Message: "User has verified/removed successfully.", vc: self)
                        
                        
                    }
                    
                    if  self.int_selectedBtn  == 2 {
                        
                        self.arr_Users.removeAllObjects()
                       self.getAllPendingUserByTypeForSuperAdmin(str_role: "Company")
                        
                    }
                        
                    else if self.int_selectedBtn  == 1 {
                        self.arr_Users.removeAllObjects()
                       self.getAllPendingUserByTypeForSuperAdmin(str_role: "School")
                        
                    }
                    
                    break
                    
                case 404:
                    
                    DispatchQueue.main.async {
                        
                        self.showAlert(Message: Global.macros.kError, vc: self)
                        self.adminTable_view.isHidden = true
                        self.arr_Users = NSMutableArray()
                        self.adminTable_view.reloadData()
                    }
                    
                default:
                    DispatchQueue.main.async {
                        self.showAlert(Message: Global.macros.kError, vc: self)
                        self.adminTable_view.isHidden = true
                        self.arr_Users = NSMutableArray()
                        self.adminTable_view.reloadData()
                        
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
    
    func deleteUserByTypeForSuperAdmin(sender: UIButton) {
        
        let dictionary = arr_Users.object(at: sender.tag) as! NSDictionary
        let dict_UserInfo = dictionary.value(forKey: "userDTO") as! NSDictionary
        
        let userId = dict_UserInfo["userId"] as? NSNumber
        let str_ratingType =  dict_UserInfo["role"] as? String
        
        
        let dict = NSMutableDictionary()
        let user_Id = SavedPreferences.value(forKey: Global.macros.kUserId) as? NSNumber
        dict.setValue(user_Id, forKey: Global.macros.kUserId)
        dict.setValue("USER", forKey: "ratingType")
        dict.setValue(userId, forKey: "ratedUserId")
        print(dict)
        
        
        if self.checkInternetConnection(){
            
            DispatchQueue.main.async {
                self.pleaseWait()
            }
            
            Requests_API.sharedInstance.deleteUserByTypeForSuperAdmin(completionBlock: { (status, dict_Info) in
                DispatchQueue.main.async {
                    self.clearAllNotice()
                }
                switch status{
                    
                case 200:
                    
                    DispatchQueue.main.async {
                        
                        self.adminTable_view.isHidden = false
                        self.showAlert(Message: "User has deleted successfully.", vc: self)
                        
                        
                    }
                    
                    self.arr_Users.removeAllObjects()
                     self.getAllVerifiedUserByTypeForSuperAdmin()
                    
                    break
                    
                case 404:
                    
                    DispatchQueue.main.async {
                        
                        self.showAlert(Message: Global.macros.kError, vc: self)
                        self.adminTable_view.isHidden = true
                        self.arr_Users = NSMutableArray()
                        self.adminTable_view.reloadData()
                    }
                    
                default:
                    DispatchQueue.main.async {
                        self.showAlert(Message: Global.macros.kError, vc: self)
                        self.adminTable_view.isHidden = true
                        self.arr_Users = NSMutableArray()
                        self.adminTable_view.reloadData()
                        
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
    
    
    //Block User
    
    func blockUserByTypeForSuperAdmin(sender: UIButton) {
        
        let dictionary = arr_Users.object(at: sender.tag) as! NSDictionary
        //setting user info
        let dict_UserInfo = dictionary.value(forKey: "userDTO") as! NSDictionary
        
        let userId = dict_UserInfo["userId"] as? NSNumber
        let str_ratingType =  dict_UserInfo["role"] as? String
       
        
        let dict = NSMutableDictionary()
        let user_Id = SavedPreferences.value(forKey: Global.macros.kUserId) as? NSNumber
        dict.setValue(user_Id, forKey: Global.macros.kUserId)
        dict.setValue("USER", forKey: "ratingType")
        dict.setValue(userId, forKey: "ratedUserId")
        print(dict)
        
        
        if self.checkInternetConnection(){
            
            DispatchQueue.main.async {
                self.pleaseWait()
            }
            
            Requests_API.sharedInstance.blockUserByTypeForSuperAdmin(completionBlock: { (status, dict_Info) in
                DispatchQueue.main.async {
                    self.clearAllNotice()
                }
                switch status{
                    
                case 200:
                    
                    DispatchQueue.main.async {
                        
                        
                        self.adminTable_view.isHidden = false
                        self.showAlert(Message: "User has blocked successfully.", vc: self)
                        
                        
                    }
                    self.arr_Users.removeAllObjects()

                    self.getAllVerifiedUserByTypeForSuperAdmin()

                    
                    break
                    
                case 404:
                    
                    DispatchQueue.main.async {
                        
                        self.showAlert(Message: Global.macros.kError, vc: self)
                        self.adminTable_view.isHidden = true
                        self.arr_Users = NSMutableArray()
                        self.adminTable_view.reloadData()
                    }
                    
                default:
                    DispatchQueue.main.async {
                        self.showAlert(Message: Global.macros.kError, vc: self)
                        self.adminTable_view.isHidden = true
                        self.arr_Users = NSMutableArray()
                        self.adminTable_view.reloadData()
                        
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
    //Unblock 
    func UnblockUserByTypeForSuperAdmin(sender: UIButton) {
        
        let dictionary = arr_Users.object(at: sender.tag) as! NSDictionary
        //setting user info
        let dict_UserInfo = dictionary.value(forKey: "userDTO") as! NSDictionary
        
        let userId = dict_UserInfo["userId"] as? NSNumber
        let str_ratingType =  dict_UserInfo["role"] as? String

        
        
        let dict = NSMutableDictionary()
        let user_Id = SavedPreferences.value(forKey: Global.macros.kUserId) as? NSNumber
        dict.setValue(user_Id, forKey: Global.macros.kUserId)
        dict.setValue("USER", forKey: "ratingType")
        dict.setValue(userId, forKey: "ratedUserId")
        print(dict)
        
        
        if self.checkInternetConnection(){
            
            DispatchQueue.main.async {
                self.pleaseWait()
            }
            
            Requests_API.sharedInstance.unBlockUserByTypeForSuperAdmin(completionBlock: { (status, dict_Info) in
                DispatchQueue.main.async {
                    self.clearAllNotice()
                }
                switch status{
                    
                case 200:
                    
                    DispatchQueue.main.async {
                        
                        self.adminTable_view.isHidden = false
                        self.showAlert(Message: "User has unblocked successfully.", vc: self)
                        
                        
                    }
                    self.arr_Users.removeAllObjects()

                    self.getAllVerifiedUserByTypeForSuperAdmin()

                    
                    break
                    
                case 404:
                    
                    DispatchQueue.main.async {
                        
                        self.showAlert(Message: Global.macros.kError, vc: self)
                        self.adminTable_view.isHidden = true
                        self.arr_Users = NSMutableArray()
                        self.adminTable_view.reloadData()
                    }
                    
                default:
                    DispatchQueue.main.async {
                        self.showAlert(Message: Global.macros.kError, vc: self)
                        self.adminTable_view.isHidden = true
                        self.arr_Users = NSMutableArray()
                        self.adminTable_view.reloadData()
                        
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
    
    
    
    
    
    // MARK:- Services
    
    func getAllVerifiedUserByTypeForSuperAdmin() //getAllVerifiedUserByTypeForSuperAdmin
    {
     
        let dict = NSMutableDictionary()
        let user_Id = SavedPreferences.value(forKey: Global.macros.kUserId) as? NSNumber
        dict.setValue(user_Id, forKey: Global.macros.kUserId)
        dict.setValue("AllBlocked", forKey: "ratingType")
        dict.setValue(str_searchText, forKey: "searchKeyword")
        dict.setValue(0, forKey: "searchType")
        dict.setValue(0, forKey: "pageIndex")
        dict.setValue(100, forKey: "pageSize")
        print(dict)
        
        self.bool_LastResultSearch = true
        
        if self.checkInternetConnection(){
            
            DispatchQueue.main.async {
                self.pleaseWait()
            }
            
            isFetching = false
            
            Requests_API.sharedInstance.getAllVerifiedUserByTypeForSuperAdmin(completionBlock: { (status, dict_Info) in
                DispatchQueue.main.async {
                    self.clearAllNotice()
                }
                
                
                self.isFetching = true
                switch status{
                    
                case 200:
                    
                    DispatchQueue.main.async {
                        
                        print(dict_Info)
                        self.arr_Users.addObjects(from: (dict_Info.value(forKey: "data") as? NSArray as! [Any]))
                        print("array :- \(self.arr_Users)")
                        self.adminTable_view.reloadData()
                        self.adminTable_view.isHidden = false
                        self.bool_LastResultSearch = true
                        if self.arr_Users.count == 0 {
                            
                            self.bool_LastResultSearch = false
                        }

                    }
                    
                    break
                    
                case 404:
                    
                    DispatchQueue.main.async {
                        
                        self.showAlert(Message: "No data found.", vc: self)
                        self.adminTable_view.isHidden = true
                        self.arr_Users = NSMutableArray()
                        self.adminTable_view.reloadData()
                         self.bool_LastResultSearch = false
                    }
                    
                default:
                    DispatchQueue.main.async {
                        self.showAlert(Message: Global.macros.kError, vc: self)
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
             self.bool_LastResultSearch = false
        }
        
    }
  
    
    func getAllPendingUserByTypeForSuperAdmin(str_role : String)
    {
        let dict = NSMutableDictionary()
        let user_Id = SavedPreferences.value(forKey: Global.macros.kUserId) as? NSNumber
        dict.setValue(user_Id, forKey: Global.macros.kUserId)
        dict.setValue(str_role, forKey: "ratingType")
        dict.setValue(str_searchText, forKey: "searchKeyword")
        dict.setValue(0, forKey: "pageIndex")
        dict.setValue(100, forKey: "pageSize")
        print(dict)
        print("atinder")
       
        
        
        self.bool_LastResultSearch = true
        
        
        if self.checkInternetConnection() {
            
            DispatchQueue.main.async {
                self.pleaseWait()
            }
            
            isFetching = false
            
            Requests_API.sharedInstance.getAllPendingUserByTypeForSuperAdmin(completionBlock: { (status, dict_Info) in
                DispatchQueue.main.async {
                    self.clearAllNotice()
                }
                 self.isFetching = true
                
                switch status{
                    
                case 200:
                    
                    DispatchQueue.main.async {
                        
                        print(dict_Info)
                        self.arr_Users = dict_Info as! NSMutableArray
                        self.adminTable_view.isHidden = false
                        self.adminTable_view.reloadData()
                        self.bool_LastResultSearch = true
                        
                        if self.arr_Users.count == 0 {
                            
                             self.bool_LastResultSearch = false
                        }
                        
                        }
                    
                    break
                    
                case 404:
                    
                    DispatchQueue.main.async {
                        
                        self.showAlert(Message: "No data found.", vc: self)
                        self.adminTable_view.isHidden = true
                        self.arr_Users = NSMutableArray()
                        self.adminTable_view.reloadData()
                         self.bool_LastResultSearch = false
                    }
                    break
                    
                    
                case 400:
                    
                    DispatchQueue.main.async {
                        
                        self.showAlert(Message: "No data found.", vc: self)
                        self.adminTable_view.isHidden = true
                        self.arr_Users = NSMutableArray()
                        self.adminTable_view.reloadData()
                         self.bool_LastResultSearch = false
                    }
                    break
                    
                    
                    
                case 401:
                    
                    DispatchQueue.main.async {
                        self.AlertSessionExpire()
                        self.bool_LastResultSearch = false
                    }
                    break
                    
                default:
                    DispatchQueue.main.async {
                        self.showAlert(Message: Global.macros.kError, vc: self)
                        self.bool_LastResultSearch = false
                        
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

    
    // MARK:- functions
    
    
    
    
    func swipeleft(_ gestureRecognizer: UISwipeGestureRecognizer) { //NEXT
        
        DispatchQueue.main.async {
            
            self.view_Line.frame.size.width = self.btn_school.frame.size.width
            self.arr_Users.removeAllObjects()

            if self.int_selectedBtn < 3 {
                
                let transition = CATransition()
                transition.duration = 0.5
                transition.type = kCATransitionPush
                transition.subtype = kCATransitionFromRight
                
                
                UIView.animate(withDuration: 0.5, animations: { // 3.0 are the seconds
                    
                    // Write your code here for e.g. Increasing any Subviews height.
                    if self.int_selectedBtn == 1 {
                        self.int_selectedBtn = self.int_selectedBtn + 1
                        
                        
                    
                        if Global.DeviceType.IS_IPHONE_6P {
                            
                        
                            
                            self.view_Line.frame = CGRect(x: 290, y: self.btn_User.frame.origin.y + self.btn_User.frame.size.height + 10, width: 124, height: 1)
                            
                        }
                            
                        else {
                            
                                self.view_Line.frame = CGRect(x: 260, y: self.btn_User.frame.origin.y + self.btn_User.frame.size.height + 10, width: 124, height: 1)
                            
                        }
                        
                        self.btn_Company.setTitleColor(Global.macros.themeColor_pink, for: .normal)
                        self.btn_school.setTitleColor(UIColor.init(red: 104.0/255.0, green: 112.0/255.0, blue:115.0/255.0, alpha: 1.0), for: .normal)
                        self.btn_User.setTitleColor(UIColor.init(red: 104.0/255.0, green: 112.0/255.0, blue:115.0/255.0, alpha: 1.0), for: .normal)
                        
                        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                        self.adminTable_view.layer.add(transition, forKey: nil)
                        self.getAllPendingUserByTypeForSuperAdmin(str_role: "Company")
                    }
                    else if self.int_selectedBtn == 0 {
                        
                        self.int_selectedBtn = self.int_selectedBtn + 1
                        
                        
                   
                        
                        if Global.DeviceType.IS_IPHONE_6P {
                            
                         
                             self.view_Line.frame = CGRect(x: 148, y: self.btn_User.frame.origin.y + self.btn_User.frame.size.height + 10, width: 124, height: 1)
                        }
                            
                        else {
                            
                            self.view_Line.frame = CGRect(x: 126, y: self.btn_User.frame.origin.y + self.btn_User.frame.size.height + 10, width: 124, height: 1)
                            
                            
                        }
                        self.btn_school.setTitleColor(Global.macros.themeColor_pink, for: .normal)
                        self.btn_Company.setTitleColor(UIColor.init(red: 104.0/255.0, green: 112.0/255.0, blue:115.0/255.0, alpha: 1.0), for: .normal)
                        self.btn_User.setTitleColor(UIColor.init(red: 104.0/255.0, green: 112.0/255.0, blue:115.0/255.0, alpha: 1.0), for: .normal)
                        
                        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                        self.adminTable_view.layer.add(transition, forKey: nil)
                       self.getAllPendingUserByTypeForSuperAdmin(str_role: "School")
                    }
                    
                    
                })
                
            }
        }
    }
    
    func swiperight(_ gestureRecognizer: UISwipeGestureRecognizer) { //PREVIOUS
        
        DispatchQueue.main.async {
            
            self.view_Line.frame.size.width = self.btn_school.frame.size.width
            self.arr_Users.removeAllObjects()

            
            if self.int_selectedBtn > 0   {
                
                let transition = CATransition()
                transition.duration = 0.5
                transition.type = kCATransitionPush
                transition.subtype = kCATransitionFromLeft
                
                UIView.animate(withDuration: 0.5, animations: { // 3.0 are the seconds
                    
                    // Write your code here for e.g. Increasing any Subviews height.
                    
                    if self.int_selectedBtn == 2 {
                        self.int_selectedBtn = self.int_selectedBtn - 1
                        
                        
                        if Global.DeviceType.IS_IPHONE_6P {
                            
                           self.view_Line.frame = CGRect(x: 148, y: self.btn_User.frame.origin.y + self.btn_User.frame.size.height + 10, width: 124, height: 1)
                            
                        }
                            
                        else {
                            
                              self.view_Line.frame = CGRect(x: 126, y: self.btn_User.frame.origin.y + self.btn_User.frame.size.height + 10, width: 124, height: 1)
                            
                           
                            
                        }
                        
                        self.btn_school.setTitleColor(Global.macros.themeColor_pink, for: .normal)
                        self.btn_Company.setTitleColor(UIColor.init(red: 104.0/255.0, green: 112.0/255.0, blue:115.0/255.0, alpha: 1.0), for: .normal)
                        self.btn_User.setTitleColor(UIColor.init(red: 104.0/255.0, green: 112.0/255.0, blue:115.0/255.0, alpha: 1.0), for: .normal)
                        
                        
                        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                        self.adminTable_view.layer.add(transition, forKey: nil)
                         self.getAllPendingUserByTypeForSuperAdmin(str_role: "School")
                        
                    }
                    else if self.int_selectedBtn == 1 {
                        
                        self.int_selectedBtn = self.int_selectedBtn - 1
                        self.view_Line.frame.origin.x = 1
                        
                        
                        
                            self.view_Line.frame = CGRect(x: 1, y: self.btn_User.frame.origin.y + self.btn_User.frame.size.height + 10, width: 124, height: 1)
                            
                        self.btn_User.setTitleColor(Global.macros.themeColor_pink, for: .normal)
                        self.btn_Company.setTitleColor(UIColor.init(red: 104.0/255.0, green: 112.0/255.0, blue:115.0/255.0, alpha: 1.0), for: .normal)
                        self.btn_school.setTitleColor(UIColor.init(red: 104.0/255.0, green: 112.0/255.0, blue:115.0/255.0, alpha: 1.0), for: .normal)
                        
                        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                        self.adminTable_view.layer.add(transition, forKey: nil)
                        self.getAllVerifiedUserByTypeForSuperAdmin()
                        
                    }
                    
                    
                })
                
            }
        }
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}

// MARK:- Extension

extension AdminViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RequestsListTableViewCell
         cell.imgView_UserProfile.image = UIImage(named: "dummySearch")
        
        cell.btn_Accept.tag = indexPath.section
        cell.btn_Decline.tag = indexPath.section
       
        // cell.contentView.layer.borderWidth = 1.0
        // cell.contentView.layer.borderColor = Global.macros.themeColor.cgColor
        cell.contentView.layer.cornerRadius = 5.0
        let dictionary = arr_Users.object(at: indexPath.section) as! NSDictionary
        //setting user info
        let dict_UserInfo = dictionary.value(forKey: "userDTO") as! NSDictionary
        
        
        if  self.int_selectedBtn  == 2 || self.int_selectedBtn  == 1 {
            
            DispatchQueue.main.async {
                cell.btn_Accept.setTitle("", for: UIControlState.normal)
                let image = UIImage(named: "admintick")
                cell.btn_Accept.setImage(image, for: .normal)
                cell.btn_Accept.backgroundColor = UIColor.white
                cell.btn_Accept.layer.borderColor = UIColor.init(red: 148.0/255.0, green: 226.0/255.0, blue: 124.0/255.0, alpha: 1.0).cgColor
                
                let image1 = UIImage(named: "admincross")
                cell.btn_Decline.setImage(image1, for: .normal)
                cell.btn_Decline.setTitle("", for: UIControlState.normal)
                cell.btn_Decline.backgroundColor = UIColor.white
                cell.btn_Decline.layer.borderColor = UIColor.init(red: 244.0/255.0, green: 131.0/255.0,blue: 111.0/255.0, alpha: 1.0).cgColor
                cell.btn_Decline.setTitleColor(UIColor.init(red: 244.0/255.0, green: 131.0/255.0,blue: 111.0/255.0, alpha: 1.0), for: .normal)
            }
        }
            else {
                
                
                DispatchQueue.main.async {
                    
                    if dict_UserInfo.value(forKey: "blocked") as? String == "N" {
                    
                    cell.btn_Accept.setTitle("", for: UIControlState.normal)
                    let image = UIImage(named: "adminlock")
                    cell.btn_Accept.setImage(image, for: .normal)
                    cell.btn_Accept.backgroundColor = UIColor.white
                    cell.btn_Accept.layer.borderColor = UIColor.init(red: 244.0/255.0, green: 131.0/255.0,blue: 111.0/255.0, alpha: 1.0).cgColor
                   
                    }
                    else {
                        
                        cell.btn_Accept.setTitle("", for: UIControlState.normal)
                        let image = UIImage(named: "unlocked")
                        cell.btn_Accept.setImage(image, for: .normal)
                        cell.btn_Accept.backgroundColor = UIColor.white
                        cell.btn_Accept.layer.borderColor = UIColor.init(red: 244.0/255.0, green: 131.0/255.0,blue: 111.0/255.0, alpha: 1.0).cgColor
                        
                        
                    }
                    
                    
                    
                    let image1 = UIImage(named: "admindel")
                    cell.btn_Decline.setImage(image1, for: .normal)
                    cell.btn_Decline.setTitle("", for: UIControlState.normal)
                    cell.btn_Decline.backgroundColor = UIColor.white
                    cell.btn_Decline.layer.borderColor = UIColor.init(red: 244.0/255.0, green: 131.0/255.0,blue: 111.0/255.0, alpha: 1.0).cgColor
                   // cell.btn_Decline.setTitleColor(UIColor.init(red: 244.0/255.0, green: 131.0/255.0,blue: 111.0/255.0, alpha: 1.0), for: .normal)
                }
                
                
                
                
            }
            
        
        
        
        
        if dict_UserInfo.value(forKey: Global.macros.krole) as? String == "USER"{
            cell.lbl_UserName.text = (dict_UserInfo.value(forKey: "userName") as? String)?.capitalized
        }
        else if dict_UserInfo.value(forKey: Global.macros.krole) as? String == "SCHOOL"{
            
            cell.lbl_UserName.text = (dict_UserInfo.value(forKey: "schoolDTO") as? NSDictionary)?.value(forKey: "name") as? String
            
        }else if dict_UserInfo.value(forKey: Global.macros.krole) as? String == "COMPANY"{
            
            cell.lbl_UserName.text = (dict_UserInfo.value(forKey: "companyDTO") as? NSDictionary)?.value(forKey: "name") as? String
        }
        
        if dict_UserInfo.value(forKey: Global.macros.krole) as? String == "SCHOOL" || dict_UserInfo.value(forKey: Global.macros.krole) as? String == "COMPANY" {
            
            
            if dict_UserInfo.value(forKey: "location") != nil && dict_UserInfo.value(forKey: "location") as? String != ""  && dict_UserInfo.value(forKey: "location") as? String != " " {
                
                let loc =  dict_UserInfo.value(forKey: "location") as! String
                
                if loc != "" && dict_UserInfo.value(forKey: "location") != nil && companyName != " " {
                    //  cell.lbl_name_loc_com_school.text = loc.capitalized

                    let str = loc
                    print(str)
                    var strArry = str.components(separatedBy: ",")
                    
                    
                    if strArry.count == 1 {
                        var tempStr:String = ""
                        
                        tempStr = (strArry.first)!
                        
                        let stringWithoutDigit = (tempStr.components(separatedBy: NSCharacterSet.decimalDigits) as NSArray).componentsJoined(by: "")
                        cell.lbl_Date.text = stringWithoutDigit
                        
                    }
                        
                    else if strArry.count == 2 {
                        strArry.removeLast()
                        var tempStr:String = ""
                        
                        tempStr = (strArry.first)!
                        
                        let stringWithoutDigit = (tempStr.components(separatedBy: NSCharacterSet.decimalDigits) as NSArray).componentsJoined(by: "")
                        cell.lbl_Date.text = stringWithoutDigit
                        
                        
                    }
                        
                    else if strArry.count == 3 {
                        
                        strArry.removeLast()
                        
                        var tempStr:String = ""
                        
                        if strArry.count > 0 {
                            for (index,element) in (strArry.enumerated())
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
                                cell.lbl_Date.text = stringWithoutDigit
                                
                                
                            }
                            
                        }
                    }
                    else if strArry.count > 3 {
                        
                        print(strArry)
                        strArry.removeLast()
                        strArry.removeFirst()
                        
                        var tempStr:String = ""
                        for (index,element) in (strArry.enumerated())
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
                            cell.lbl_Date.text = stringWithoutDigit
                            
                        }
                    }
                    
                    
                }
                else {
                    
                    cell.lbl_Date.text  = ""
                    
                    
                }
                
            }
     
        }
        else{
            
            let str_email = dict_UserInfo.value(forKey: "email") as? String
           cell.lbl_Date.text = str_email
            
            
        }
        
        let str_profileImage = dict_UserInfo.value(forKey: "profileImageUrl") as? String
        if str_profileImage != nil{
            cell.imgView_UserProfile.sd_setImage(with: URL.init(string: str_profileImage!), placeholderImage: UIImage.init(named: "dummySearch"))
        }
        
        cell.lbl_TotalRatingCount.text = "\((dict_UserInfo).value(forKey: "ratingCount")!)"
        
        if cell.lbl_TotalRatingCount.text == "0" || cell.lbl_TotalRatingCount.text == "1" {
            cell.lbl_Ratings.text = "rating"
        }
        else {
            cell.lbl_Ratings.text = "ratings"
        }
        
        let str_avgRating = ((dict_UserInfo).value(forKey: "avgRating") as? NSNumber)?.stringValue
        
        let dbl = 2.0
        if  dbl.truncatingRemainder(dividingBy: 1) == 0{
            cell.lbl_AverageRating.text = str_avgRating! + ".0"
        }
        else{
            cell.lbl_AverageRating.text = str_avgRating!
        }
        
    
        
        //Setting time
        if dict_UserInfo["userTimeAgo"] != nil {
            let time : NSString = dict_UserInfo["userTimeAgo"] as! NSString
            
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

         self.bool_LastResultSearch = false
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if arr_Users.count > 0 {
            return arr_Users.count
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
        
        var user_dictFinal = NSDictionary()
        
        
        print(self.arr_Users[indexPath.section] as! NSDictionary)
       let user_dict = self.arr_Users[indexPath.section] as! NSDictionary
        if user_dict["userDTO"] != nil{
            
            user_dictFinal = user_dict.value(forKey: "userDTO") as! NSDictionary
        }
        
        let role = user_dictFinal.value(forKey: Global.macros.krole) as? String
        
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 5.0
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = UIView()
        header.backgroundColor = UIColor.clear
        return header
        
        
    }
    
    
    
    
}


extension AdminViewController : UISearchBarDelegate{
    
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
                            self.arr_Users.removeAllObjects()
        
                            if int_selectedBtn == 1 {
                                
                                getAllPendingUserByTypeForSuperAdmin(str_role: "School")
                                
                            }
                            
                            else if int_selectedBtn == 2 {
                                
                               
                                getAllPendingUserByTypeForSuperAdmin(str_role: "Company")
 
                            }
                            
                            else{
                                
                                 getAllVerifiedUserByTypeForSuperAdmin()

                                
                            }
        
                        }
        
        
        
        
                }
                else  if ((self.str_searchText.characters.count) == 0 ) {
        
        
                        pageIndex = 0
                        self.arr_Users.removeAllObjects()
        
                        
                    if int_selectedBtn == 1 {
                        
                        getAllPendingUserByTypeForSuperAdmin(str_role: "School")
                        
                    }
                        
                    else if int_selectedBtn == 2 {
                        
                        
                        getAllPendingUserByTypeForSuperAdmin(str_role: "Company")
                        
                    }
                        
                    else{
                        
                        getAllVerifiedUserByTypeForSuperAdmin()
                        
                        
                    }
        
        
                }
                else{
                    self.arr_Users.removeAllObjects()
                    self.adminTable_view.reloadData()
                }
        
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.alpha = 1
        self.searchBar.showsCancelButton = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {}
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {}}
