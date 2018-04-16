//
//  StatViewController.swift
//  Shadow
//
//  Created by Atinderjit Kaur on 2/21/18.
//  Copyright © 2018 Atinderjit Kaur. All rights reserved.
//

import UIKit

class StatViewController: UIViewController {

    var bool_ComingFromSuperAdmin : Bool = false
    var index_count : Int = 0
    fileprivate  var pageIndex :  Int = 0             //Pagination Parameters
    fileprivate var pageSize :    Int = 0
    var pointNow :                CGPoint?
    var isFetching:               Bool =  false
    var str_role:                 String = ""
    var bool_LastResultSearch :   Bool = false

     var array_userList = NSMutableArray()
    @IBOutlet weak var tblView_List: UITableView!
    
    // View cycle Methods
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.tblView_List.tableFooterView = UIView() // Set the footer view
        let myBackButton:UIButton = UIButton()       // back button
        myBackButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        myBackButton.setImage(UIImage(named:"back-new"), for: UIControlState())
        myBackButton.addTarget(self, action: #selector(self.PopToProfile), for: UIControlEvents.touchUpInside)
        let leftBackBarButton:UIBarButtonItem = UIBarButtonItem(customView: myBackButton)
        self.navigationItem.leftBarButtonItem = leftBackBarButton
        // Do any additional setup after loading the view.
        
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        
        self.array_userList.removeAllObjects()
        
        if index_count == 0 {
           if bool_ComingFromSuperAdmin == true {
             self.title = "Total Users"
               GetData()
            
           }
            else{
            self.title = "Total Users"
            
            if (SavedPreferences.value(forKey: "role") as? String) == "SCHOOL" {
                
              getSchoolData()
                
            }
            else if (SavedPreferences.value(forKey: "role") as? String) == "COMPANY"  {
                
                getDataForCompanyAdmin()
                
                
            }
            }
        }
        else {
            
              self.title = "Verified Users"
             if bool_ComingFromSuperAdmin == true {
                
                verifiedList()
                
             }
             else {
                
                if (SavedPreferences.value(forKey: "role") as? String) == "SCHOOL" {
                    
                    getAllVerifiedUserListForSchoolAdmin()
                    
                }
                else if (SavedPreferences.value(forKey: "role") as? String) == "COMPANY"  {
                    
                    getAllVerifiedUserForCompanyAdmin()
                    
                    
                }
           
        }
        }
    }
   
    
    func PopToProfile() {
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: API CAllS
    
    
    func getAllVerifiedUserListForSchoolAdmin() {
        
        let dict = NSMutableDictionary()
        let user_Id = SavedPreferences.value(forKey: Global.macros.kUserId) as? NSNumber
        dict.setValue(user_Id, forKey: Global.macros.kUserId)
        dict.setValue("", forKey: "searchKeyword")
        dict.setValue(0, forKey: "pageIndex")
        dict.setValue(100, forKey: "pageSize")
        print(dict)
        
        self.bool_LastResultSearch = true
        if self.checkInternetConnection(){
//            if str_searchText  == ""             {
//
//                DispatchQueue.main.async {
//                    self.pleaseWait()
//                }
//
//            }
            
            DispatchQueue.main.async {
                self.pleaseWait()
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
                        
                        self.tblView_List.isHidden = false
                        
                        _ = dict_Info.value(forKey: "data") as? NSDictionary
                        
                        self.array_userList.addObjects(from: dict_Info.value(forKey: "data") as? NSArray as! [Any])
                        self.tblView_List.reloadData()
                        
                        self.bool_LastResultSearch = true
                        
                        if self.array_userList.count == 0 {
                            
                            self.bool_LastResultSearch = false
                        }
                        
                    }
                    
                    break
                    
                case 404:
                    
                    DispatchQueue.main.async {
                        
                        self.showAlert(Message: "No data found.", vc: self)
                        self.tblView_List.isHidden = true
                        self.array_userList = NSMutableArray()
                        self.tblView_List.reloadData()
                        self.bool_LastResultSearch = false
                    }
                    
                case 400:
                   
                    DispatchQueue.main.async {
                        
                        self.showAlert(Message: "User unauthorized to get details.", vc: self)
                        self.tblView_List.isHidden = true
                        self.array_userList = NSMutableArray()
                        self.tblView_List.reloadData()
                        self.bool_LastResultSearch = false
                        
                    }
                    
                default:
                    DispatchQueue.main.async {
                        
                        self.showAlert(Message: Global.macros.kError, vc: self)
                        self.tblView_List.isHidden = true
                        self.array_userList = NSMutableArray()
                        self.tblView_List.reloadData()
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
    
    func getAllVerifiedUserForCompanyAdmin()
    {
        let dict = NSMutableDictionary()
        let user_Id = SavedPreferences.value(forKey: Global.macros.kUserId) as? NSNumber
        dict.setValue(user_Id, forKey: Global.macros.kUserId)
        dict.setValue("", forKey: "searchKeyword")
        dict.setValue(0, forKey: "pageIndex")
        dict.setValue(100, forKey: "pageSize")
        print(dict)
        
        self.bool_LastResultSearch = true
        if self.checkInternetConnection(){

            isFetching = false
            DispatchQueue.main.async {
                self.pleaseWait()
            }
            
            
            Requests_API.sharedInstance.getAllVerifiedUserForCompanyAdmin(completionBlock: { (status, dict_Info) in
                DispatchQueue.main.async {
                    self.clearAllNotice()
                }
                
                self.isFetching = true
                
                switch status{
                    
                case 200:
                    
                    DispatchQueue.main.async {
                        
                        self.tblView_List.isHidden = false
                        
                        _ = dict_Info.value(forKey: "data") as? NSDictionary
                        
                        self.array_userList.addObjects(from: dict_Info.value(forKey: "data") as? NSArray as! [Any])
                        self.tblView_List.reloadData()
                        
                        self.bool_LastResultSearch = true
                        
                        if self.array_userList.count == 0 {
                            
                            self.bool_LastResultSearch = false
                        }
                        
                    }
                    
                    break
                    
                case 404:
                    
                    DispatchQueue.main.async {
                        
                        self.showAlert(Message: "No data found.", vc: self)
                        self.tblView_List.isHidden = true
                        self.array_userList = NSMutableArray()
                        self.tblView_List.reloadData()
                        self.bool_LastResultSearch = false
                    }
                    
                    
                case 400:
                    DispatchQueue.main.async {
                        
                        self.showAlert(Message: "User unauthorized to get details.", vc: self)
                        self.tblView_List.isHidden = true
                        self.array_userList = NSMutableArray()
                        self.tblView_List.reloadData()
                        self.bool_LastResultSearch = false
                        
                    }
                    
                default:
                    DispatchQueue.main.async {
                        self.showAlert(Message: Global.macros.kError, vc: self)
                        self.tblView_List.isHidden = true
                        self.array_userList = NSMutableArray()
                        self.tblView_List.reloadData()
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

    
    func GetData() {
        
        let dict = NSMutableDictionary()
        let user_Id = SavedPreferences.value(forKey: Global.macros.kUserId) as? NSNumber
        dict.setValue(user_Id, forKey: "userId")
        dict.setValue("AllBlocked", forKey: "ratingType")
        dict.setValue(0, forKey: "searchType")
        dict.setValue(0, forKey: "pageIndex")
        dict.setValue(100, forKey: "pageSize")
        print(dict)
        
        
        if self.checkInternetConnection() {
            
            DispatchQueue.main.async {
                self.pleaseWait()
            }
            isFetching = false
            Requests_API.sharedInstance.getAllUserByTypeForSuperAdmin(completionBlock: {(status, dict_Info) in
                DispatchQueue.main.async {
                    self.clearAllNotice()
                }
                self.isFetching = true
                switch status{
                    
                case 200:
                    
                    
                    print(dict_Info)
                    
                    self.array_userList.addObjects(from: (dict_Info.value(forKey: "data") as? NSArray as! [Any]))
                    print(self.array_userList)
                    
                    DispatchQueue.main.async {
                        self.tblView_List.reloadData()
                    }
              
                    break
                    
                case 210:
                    
                    DispatchQueue.main.async {
                        self.clearAllNotice()
                        self.showAlert(Message: "Please try again", vc: self)
                    }
                    
                case 400:
                    
                    self.clearAllNotice()
                    DispatchQueue.main.async {
                        
                        self.tblView_List.reloadData()
                        
                        
                    }
                    
                case 401 :
                    DispatchQueue.main.async {
                        self.clearAllNotice()
                        self.AlertSessionExpire()
                    }
                    
                case 404 :
                    DispatchQueue.main.async {
                        self.clearAllNotice()
                        self.showAlert(Message: "No data found.", vc: self)

                    }
                    
                    
                    
                case 500:
                    
                    self.clearAllNotice()
                    // self.arr_SearchData.removeAllObjects()
                    DispatchQueue.main.async {
                        self.tblView_List.reloadData()
                        
                    }
                    
                    
                default:
                    DispatchQueue.main.async {
                        self.showAlert(Message: Global.macros.kError, vc: self)
                        
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
        else {
            self.showAlert(Message: Global.macros.kInternetConnection, vc: self)
        }
        
    }
    
    func verifiedList() {
        
     
        let dict = NSMutableDictionary()
        let user_Id = SavedPreferences.value(forKey: Global.macros.kUserId) as? NSNumber
        dict.setValue(user_Id, forKey: Global.macros.kUserId)
        dict.setValue("All", forKey: "ratingType")
        dict.setValue("", forKey: "searchKeyword")
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
                        self.array_userList.addObjects(from: (dict_Info.value(forKey: "data") as? NSArray as! [Any]))
                        self.tblView_List.reloadData()
                        self.tblView_List.isHidden = false
                        self.bool_LastResultSearch = true
                        if self.array_userList.count == 0 {
                            
                            self.bool_LastResultSearch = false
                        }
                        
                    }
                    
                    break
                    
                case 404:
                    
                    DispatchQueue.main.async {
                        
                        self.showAlert(Message: "No data found.", vc: self)
                        self.tblView_List.isHidden = true
                        self.array_userList = NSMutableArray()
                        self.tblView_List.reloadData()
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
    func getDataForCompanyAdmin() {
        
        self.array_userList.removeAllObjects()
        let dict = NSMutableDictionary()
        let user_Id = SavedPreferences.value(forKey: Global.macros.kUserId) as? NSNumber
        dict.setValue(user_Id, forKey: "userId")
        dict.setValue(0, forKey: "searchType")
        dict.setValue(0, forKey: "pageIndex")
        dict.setValue(100, forKey: "pageSize")
        print(dict)
        
        
        if self.checkInternetConnection(){
            
            DispatchQueue.main.async {
                self.pleaseWait()
            }
            isFetching = false
            
            Requests_API.sharedInstance.getTopUserAndCountForCompanyAdmin(completionBlock: {(status, dict_Info) in
                DispatchQueue.main.async {
                    self.clearAllNotice()
                }
                
                self.isFetching = true
                
                switch status{
                    
                case 200:
                    
                    DispatchQueue.main.async {
                        
                        print(dict_Info)
                        print("dic :- \(dict_Info)")
                        
                        let arr = dict_Info.value(forKey: "data") as? NSDictionary
                        self.array_userList.addObjects(from: (arr?.value(forKey: "UserList") as? NSArray as! [Any]))
                        
                        
                        DispatchQueue.main.async {
                            self.tblView_List.reloadData()
                            
                        }
                        
                        if self.array_userList.count == 0 {
                            
                             self.showAlert(Message: "No data found.", vc: self)
                        }
                        
                        print( self.array_userList)
                        
                    }
                    
                    break
                    
                case 404:
                    
                    DispatchQueue.main.async {
                        
                        self.showAlert(Message: "No data found.", vc: self)
                        
                    }
                    
                default:
                    DispatchQueue.main.async {
                        self.showAlert(Message: Global.macros.kError, vc: self)
                        
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
        else {
            self.showAlert(Message: Global.macros.kInternetConnection, vc: self)
        }
        
    }
    
    func getSchoolData() {
        
        self.array_userList.removeAllObjects()
        let dict = NSMutableDictionary()
        let user_Id = SavedPreferences.value(forKey: Global.macros.kUserId) as? NSNumber
        dict.setValue(user_Id, forKey: "userId")
        dict.setValue(0, forKey: "searchType")
        dict.setValue(0, forKey: "pageIndex")
        dict.setValue(100, forKey: "pageSize")
        print(dict)
        
        
        if self.checkInternetConnection(){
            
            DispatchQueue.main.async {
                self.pleaseWait()
            }
            isFetching = false
            
            Requests_API.sharedInstance.getTopUserAndCountForSchoolAdmin(completionBlock: {(status, dict_Info) in
                DispatchQueue.main.async {
                    self.clearAllNotice()
                }
                
                self.isFetching = true
                
                switch status{
                    
                case 200:
                    
                    DispatchQueue.main.async {
                        
                        print(dict_Info)
                        print("dic :- \(dict_Info)")
                        
                        let arr = dict_Info.value(forKey: "data") as? NSDictionary
                        self.array_userList.addObjects(from: (arr?.value(forKey: "UserList") as? NSArray as! [Any]))
                        
                        
                        DispatchQueue.main.async {
                            self.tblView_List.reloadData()
                            
                        }
                        if self.array_userList.count == 0 {
                            
                            self.showAlert(Message: "No data found.", vc: self)
                        }

                        print( self.array_userList)
                        
                    }
                    
                    break
                    
                case 404:
                    
                    DispatchQueue.main.async {
                        
                        self.showAlert(Message: "No data found.", vc: self)
                        
                    }
                    
                default:
                    DispatchQueue.main.async {
                        self.showAlert(Message: Global.macros.kError, vc: self)
                        
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
        else {
            self.showAlert(Message: Global.macros.kInternetConnection, vc: self)
        }
        
        
        
    }
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        pointNow = scrollView.contentOffset
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        
        
        if scrollView == self.tblView_List {       //Pagination for tableview
            
            print(scrollView.contentOffset.y)
            if (scrollView.contentOffset.y<(pointNow?.y)!) {
                print("down")
            } else if (scrollView.contentOffset.y>(pointNow?.y)!) {
                
                if isFetching {
                    self.pageIndex = self.pageIndex + 1
                    isFetching = true
   
                    
                }
            }
            
        }
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}



extension StatViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.array_userList.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 81
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_listing", for: indexPath) as! ListingTableViewCell
        
        cell.imgView_Company_loc_school.image = UIImage(named: "dummySearch")
        cell.imgView_Profile.image = UIImage(named: "dummySearch")
        var userDTO = NSDictionary()
        
        if self.array_userList.count > 0
        {
            print(self.array_userList[indexPath.row])
            userDTO = self.array_userList[indexPath.row] as! NSDictionary
            let user_dict = userDTO.value(forKey: "userDTO") as! NSDictionary
            
            
            let role = user_dict.value(forKey: "role") as? String
            
            //setting name
            
            if role == "USER" {
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
                
            else if role == "COMPANY" || role == "SCHOOL" {
                
                
                cell.lbl_username.text = (userDTO.value(forKey: "name") as? String)?.capitalized
                
                
                
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
                
                
                
                if user_dict.value(forKey: "location") != nil  && user_dict.value(forKey: "location") as? String != ""  && user_dict.value(forKey: "location") as? String != " " {
                    
                    
                    
                    let loc =  user_dict.value(forKey: "location") as! String
                    
                    if loc != "" && user_dict.value(forKey: "location") != nil && companyName != " " {
                        //  cell.lbl_name_loc_com_school.text = loc.capitalized
                        cell.imgView_Company_loc_school.image = UIImage.init(named: "location-pin")
                        
                        
                        let str = loc
                        print(str)
                        var strArry = str.components(separatedBy: ",")
                        
                        
                        if strArry.count == 1 {
                            var tempStr:String = ""
                            
                            tempStr = (strArry.first)!
                            
                            let stringWithoutDigit = (tempStr.components(separatedBy: NSCharacterSet.decimalDigits) as NSArray).componentsJoined(by: "")
                            cell.lbl_name_loc_com_school.text = stringWithoutDigit
                            
                        }
                            
                        else if strArry.count == 2 {
                            strArry.removeLast()
                            var tempStr:String = ""
                            
                            tempStr = (strArry.first)!
                            
                            let stringWithoutDigit = (tempStr.components(separatedBy: NSCharacterSet.decimalDigits) as NSArray).componentsJoined(by: "")
                            cell.lbl_name_loc_com_school.text = stringWithoutDigit
                            
                            
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
                                    cell.lbl_name_loc_com_school.text = stringWithoutDigit
                                    
                                    
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
                                cell.lbl_name_loc_com_school.text = stringWithoutDigit
                                
                            }
                        }
                        
                        
                    }
                    else {
                        
                        cell.lbl_name_loc_com_school.text  = ""
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
