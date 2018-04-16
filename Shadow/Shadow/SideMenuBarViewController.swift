//
//  SideMenuBarViewController.swift
//  Shadow
//
//  Created by Aditi on 24/07/17.
//  Copyright © 2017 Atinderjit Kaur. All rights reserved.
//

import UIKit

var sidebarMenuOpen : Bool = false

class SideMenuBarViewController: UIViewController  { //superAdminAccess
    
    @IBOutlet var tbl_View: UITableView!
    
    @IBOutlet weak var height_Header: NSLayoutConstraint!
    @IBOutlet weak var top_Header: NSLayoutConstraint!
    fileprivate var array_sideBarItems1 = ["Shadow Me","Edit Profile","Admin","Help","Log Out"]
    fileprivate var array_sideBarItems = ["Shadow Me","Edit Profile","Help","Log Out"]
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.tbl_View.tableFooterView = UIView()
        
        if Global.DeviceType.IS_IPHONE_X {
            
        self.top_Header.constant = 52
            
            self.height_Header.constant = 90
            
        }
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.navigationItem.hidesBackButton = true
        
    }
    
  
    
    
    //MARK:Button Actions
    
    @IBAction func Action_Switch(_ sender: UISwitch) {
        
        DispatchQueue.main.async {
            //changing color of unselected button
            let indexPath = NSIndexPath.init(row: sender.tag, section: 0)
            let cell = self.tbl_View.cellForRow(at: indexPath as IndexPath) as! SideMenuTableViewCell
            
            //you have on shadow me
            if cell.btn_Switch.isOn{
                self.shadowMe(switch_status: "true")
            }
            else{
                self.shadowMe(switch_status: "false")
            }
            
        }
       
        
    }
    
    @IBAction func Action_Back(_ sender: UIButton) {
        
        
    }
    
    func logout(){
        
        let dict = NSMutableDictionary()
        let  user_Id = SavedPreferences.value(forKey: Global.macros.kUserId) as? NSNumber
        dict.setValue(user_Id, forKey: Global.macros.kUserId)

        
        AuthenticationAPI.sharedInstance.LogOut(dict: dict, completion: {(response) in
            
            DispatchQueue.main.async {
                self.clearAllNotice()
            }
            
            
            
            QBRequest.logOut(successBlock: { (response) in
                
                
                QBChat.instance().disconnect(completionBlock: { (error) in
                    
                    print("DISCONNECT RESULT RECEIVED") // breakpoint here
                    
                    
                    
                    if let error = error {
                        
                        print("DISCONNECT ERROR\(error)")
                        
                    } else {
                        
                        print("DISCONNECTED SUCCESSFULLY")
                
                    }
                })
                
             
                print("success")
                bool_fromMobile             = false
                bool_NotVerified            = false
                bool_LocationFilter         = false
                bool_PlayFromProfile        = false
                bool_AllTypeOfSearches      = false
                bool_CompanySchoolTrends    = false
                bool_fromVerificationMobile = false
                bool_UserIdComingFromSearch = false
                bool_OpenProfile = false
                username = ""
                schoolName = ""
                companyName = ""
                Location = ""
                latitude = ""
                longitude = ""
                password = ""
                firstName = ""
                lastName = ""
                countryCode = ""
                allowShadow = true
                str_email = ""
                verifiedByAdminLoginUser = ""
                SavedPreferences.removeObject(forKey: "qb_UserId")
                SavedPreferences.removeObject(forKey: "user_verified")
                SavedPreferences.removeObject(forKey: "sessionToken")
                SavedPreferences.removeObject(forKey: Global.macros.kUserId)
                dict_userInfo = NSMutableDictionary()
                dictionary_user_Info = NSMutableDictionary()
                SavedPreferences.removeObject(forKey: "superAdminAccess")
                
              
                    self.navigationController?.navigationBar.isHidden = true
                    let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "Login")
                    Global.macros.kAppDelegate.window?.rootViewController = vc
                
                
                
            }, errorBlock: { (response) in
                
                print(response)
                //   self.showAlert(Message: "Please try again.", vc: self)
                
                self.navigationController?.navigationBar.isHidden = true
                let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "Login")
                Global.macros.kAppDelegate.window?.rootViewController = vc
                
            })
       
            
        }, errorBlock: {(err) in
            DispatchQueue.main.async {
                self.clearAllNotice()
                self.showAlert(Message: Global.macros.kError, vc: self)
            }
        })
        
    }
    
    
    //MARK: - Functions
    
    func shadowMe(switch_status:String) {
        
        let dict = NSMutableDictionary()
        let  user_Id = SavedPreferences.value(forKey: Global.macros.kUserId) as? NSNumber
        dict.setValue(user_Id, forKey: Global.macros.kUserId)
        dict.setValue(switch_status, forKey: Global.macros.kotherUsersShadowYou)
        
        if self.checkInternetConnection(){
            
            DispatchQueue.main.async {
                self.pleaseWait()
            }
            
            ServerCall.sharedInstance.postService({ (response) in
                
                DispatchQueue.main.async {
                    self.clearAllNotice()
                }
                let status = (response as! NSDictionary).value(forKey: "status") as? NSNumber
                if status == 200{
                    
                    DispatchQueue.main.async {
                        self.showAlert(Message: "Shadow status changed successfully.", vc: self)
                    }
                    
                }
                else{
                    
                    DispatchQueue.main.async {
                        self.showAlert(Message: Global.macros.kError, vc: self)
                    }
                }
                
                
            }, error_block: {(error) in
                
                DispatchQueue.main.async {
                    self.clearAllNotice()
                    self.showAlert(Message: Global.macros.kError, vc: self)
                }
                
            }, paramDict: dict, is_synchronous: false, url: "changeShadowStatus")
            
        }else{
            
            self.showAlert(Message: Global.macros.kError, vc: self)
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}

extension SideMenuBarViewController:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if SavedPreferences.value(forKey: "superAdminAccess") as? String == "true" || (SavedPreferences.value(forKey: "role") as? String) == "SCHOOL"  ||  (SavedPreferences.value(forKey: "role") as? String) == "COMPANY"{
            return array_sideBarItems1.count
        }
        else
        {
            return array_sideBarItems.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SideMenuTableViewCell
        
        cell.btn_Switch.tag = indexPath.row
        
          if SavedPreferences.value(forKey: "superAdminAccess") as? String == "true"  || (SavedPreferences.value(forKey: "role") as? String) == "SCHOOL"  ||  (SavedPreferences.value(forKey: "role") as? String) == "COMPANY" {
            cell.lbl_ItemName.text = self.array_sideBarItems1[indexPath.row]

        }
        else
        {
            cell.lbl_ItemName.text = self.array_sideBarItems[indexPath.row]
        }
        
        
        if cell.isSelected {
            cell.lbl_ItemName.textColor = UIColor.init(red: 242.0/255.0, green: 105.0/255.0, blue: 78.0/255.0, alpha: 1.0)
        } else {
            // change color back to whatever it was
            cell.lbl_ItemName.textColor = UIColor.init(red: 242.0/255.0, green: 105.0/255.0, blue: 78.0/255.0, alpha: 1.0)
        }
        
        //hiding switch button
        switch indexPath.row {
        case 0:
            DispatchQueue.main.async {
                cell.btn_Switch.isHidden = false
                
                let shadow_Status = SavedPreferences.value(forKey: Global.macros.kotherUsersShadowYou) as? NSNumber
                
                
                if shadow_Status == 1{
                    cell.btn_Switch.isOn = true
                    SavedPreferences.set(0, forKey: Global.macros.kotherUsersShadowYou)
                    
                }else{
                    cell.btn_Switch.isOn = false
                     SavedPreferences.set(1, forKey: Global.macros.kotherUsersShadowYou)
                }
                
            }
            break
        default:
            DispatchQueue.main.async {
                cell.btn_Switch.isHidden = true
            }
            
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tbl_View.cellForRow(at: indexPath) as! SideMenuTableViewCell
        cell.lbl_ItemName.textColor = Global.macros.themeColor_pink
        
        let role = SavedPreferences.value(forKey: Global.macros.krole) as? String
        switch indexPath.row {
            
        //Shadow me
        case 0:
            
           
            break
        //Edit profile
        case 1:
            
            DispatchQueue.main.async {
                
                if role == "USER"{
                    self.performSegue(withIdentifier: "sideBar_to_EditProfileUser", sender: self)
                }
                else{
                    self.performSegue(withIdentifier: "sideBar_to_EditProfileC", sender: self)
                }
            }
            
        //Admin
        case 2:
            
            
           if SavedPreferences.value(forKey: "superAdminAccess") as? String == "true"   {
            
            
            DispatchQueue.main.async{
                self.performSegue(withIdentifier: "side_menuTo_Admin", sender: self)
            }
            
           }
            
           else if (SavedPreferences.value(forKey: "role") as? String) == "SCHOOL"  ||  (SavedPreferences.value(forKey: "role") as? String) == "COMPANY"{  //ToSchoolCompanyAdmin
            DispatchQueue.main.async{
                self.performSegue(withIdentifier: "ToSchoolCompanyAdmin", sender: self)
            }
            
           }
           
           else {
            
            
           }
           
            
            break
            
        case 3:
            if SavedPreferences.value(forKey: "superAdminAccess") as? String == "true"  || (SavedPreferences.value(forKey: "role") as? String) == "SCHOOL"  ||  (SavedPreferences.value(forKey: "role") as? String) == "COMPANY" {
              
                
            }
            else
            {
                
                let TitleString = NSAttributedString(string: "Shadow", attributes: [
                    NSFontAttributeName : UIFont.systemFont(ofSize: 18),
                    NSForegroundColorAttributeName : Global.macros.themeColor_pink
                    ])
                let MessageString = NSAttributedString(string: "Do you want to logout?", attributes: [
                    NSFontAttributeName : UIFont.systemFont(ofSize: 15),
                    NSForegroundColorAttributeName : Global.macros.themeColor_pink
                    ])
                
                DispatchQueue.main.async {
                    self.clearAllNotice()
                }
                    let alert = UIAlertController(title: "Shadow", message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction.init(title: "Yes", style: .default, handler: { (alert) in
                        
                        if self.checkInternetConnection()
                        {
                            DispatchQueue.main.async {
                                self.pleaseWait()
                            }
                            
                            let deviceIdentifier: String = UIDevice.current.identifierForVendor!.uuidString
                            
                            QBRequest.unregisterSubscription(forUniqueDeviceIdentifier: deviceIdentifier, successBlock: { (QBResponse) in
                                self.logout()
                                
                            }, errorBlock: { (QBError) in
                                
                                self.logout()
                            })
                            
                        }
                        else{
                            self.showAlert(Message: Global.macros.kInternetConnection, vc: self)
                        }
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
            
            break
            //LogOut

                  case 4:
                    
                     if SavedPreferences.value(forKey: "superAdminAccess") as? String == "true"  || (SavedPreferences.value(forKey: "role") as? String) == "SCHOOL"  ||  (SavedPreferences.value(forKey: "role") as? String) == "COMPANY"{
                        
                        
                        let TitleString = NSAttributedString(string: "Shadow", attributes: [
                            NSFontAttributeName : UIFont.systemFont(ofSize: 18),
                            NSForegroundColorAttributeName : Global.macros.themeColor_pink
                            ])
                        let MessageString = NSAttributedString(string: "Do you want to logout?", attributes: [
                            NSFontAttributeName : UIFont.systemFont(ofSize: 15),
                            NSForegroundColorAttributeName : Global.macros.themeColor_pink
                            ])
                        
                        DispatchQueue.main.async {
                            self.clearAllNotice()
                            
                            let alert = UIAlertController(title: "Shadow", message: "", preferredStyle: .alert)
                            alert.addAction(UIAlertAction.init(title: "Yes", style: .default, handler: { (alert) in
                                
                                if self.checkInternetConnection()
                                {
                                    DispatchQueue.main.async {
                                        self.pleaseWait()
                                    }
                                    
                                    let deviceIdentifier: String = UIDevice.current.identifierForVendor!.uuidString
                                    
                                    QBRequest.unregisterSubscription(forUniqueDeviceIdentifier: deviceIdentifier, successBlock: { (QBResponse) in
                                        self.logout()
                                        
                                    }, errorBlock: { (QBError) in
                                        
                                        self.logout()
                                    })
                                    
                                }
                                else{
                                    self.showAlert(Message: Global.macros.kInternetConnection, vc: self)
                                }
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
                        
   
                    }
                    else
                    {
                        
                        
                    }
                    
            
            break
            
        default:
            break
        }
        
    }
 
    
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        
        
        let cell = tbl_View.cellForRow(at: indexPath ) as! SideMenuTableViewCell
  
        tbl_View.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
        
    }
     
}
