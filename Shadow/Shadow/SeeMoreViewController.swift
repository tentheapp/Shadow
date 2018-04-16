//
//  SeeMoreViewController.swift
//  Shadow
//
//  Created by Atinderjit Kaur on 13/02/18.
//  Copyright © 2018 Atinderjit Kaur. All rights reserved.
//

import UIKit

class SeeMoreViewController: UIViewController {
    
    var array_userList = NSMutableArray()

    @IBOutlet weak var tblView_SeeMore: UITableView!
    
    
    fileprivate  var pageIndex :  Int = 0                     //Pagination Parameters
    fileprivate var pageSize :    Int = 0
    var pointNow :                CGPoint?
    var isFetching:               Bool =  false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tblView_SeeMore.tableFooterView = UIView()

       
        
        if (SavedPreferences.value(forKey: "role") as? String) == "COMPANY" {
           
            getDataForCompanyAdmin()
        }
        else{
            
           getSchoolData()
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
                            self.tblView_SeeMore.reloadData()
                            
                        }
                        
                        print( self.array_userList)
                        
                    }
                    
                    break
                    
                case 404:
                    
                    DispatchQueue.main.async {
                        
                        self.showAlert(Message: Global.macros.kError, vc: self)
                        
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
                            self.tblView_SeeMore.reloadData()
                            
                        }
                        
                        print( self.array_userList)
                        
                    }
                    
                    break
                    
                case 404:
                    
                    DispatchQueue.main.async {
                        
                        self.showAlert(Message: Global.macros.kError, vc: self)
                        
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
        
        
        
        if scrollView == self.tblView_SeeMore {       //Pagination for tableview
            
            print(scrollView.contentOffset.y)
            if (scrollView.contentOffset.y<(pointNow?.y)!) {
                print("down")
            } else if (scrollView.contentOffset.y>(pointNow?.y)!) {
                
                if isFetching {
                    self.pageIndex = self.pageIndex + 1
                    isFetching = true
                    
                 //   self.getDataForCompanyAdmin()
                    
                    
                    
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


extension SeeMoreViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.array_userList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_listing", for: indexPath) as! ListingTableViewCell
        cell.imgView_Profile.image = UIImage(named: "dummySearch")
         cell.imgView_Company_loc_school.image = UIImage(named: "dummySearch")
        
        var userDTO = NSDictionary()
        
        if self.array_userList.count > 0
        {
            print(self.array_userList[indexPath.row])
            userDTO = self.array_userList[indexPath.row] as! NSDictionary
            let user_dict = userDTO.value(forKey: "userDTO") as! NSDictionary
            
            
            let role = user_dict.value(forKey: "role") as? String
            
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
