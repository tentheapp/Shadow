//
//  AdminPendingViewController.swift
//  Shadow
//
//  Created by Navaldeep Kaur on 1/23/18.
//  Copyright © 2018 Atinderjit Kaur. All rights reserved.
//

import UIKit

class AdminPendingViewController: UIViewController {

    @IBOutlet weak var btn_seeMore: UIButton!
    @IBOutlet weak var collectionView_topUsers: UICollectionView!
    @IBOutlet weak var collectionView_totalUsers: UICollectionView!
    @IBOutlet weak var scroll_View: UIScrollView!
    var arr_Users = NSMutableArray()

    @IBOutlet weak var lblNoDataFound: UILabel!
    
    var str_meetingCount : String?
    var str_TotalUsers : String?
    var str_VerifiedUserCount : String?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        let myBackButton:UIButton = UIButton()
        myBackButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        myBackButton.setImage(UIImage(named:"back-new"), for: UIControlState())
        myBackButton.addTarget(self, action: #selector(self.PopToProfile), for: UIControlEvents.touchUpInside)
        let leftBackBarButton:UIBarButtonItem = UIBarButtonItem(customView: myBackButton)
        self.navigationItem.leftBarButtonItem = leftBackBarButton
        
        
        // To add new chat contacts
        let myPlusButton:UIButton = UIButton()
        myPlusButton.frame = CGRect(x: 0, y: 0, width: 18, height: 18)
        myPlusButton.setImage(UIImage(named:"tickinsidecircle"), for: UIControlState())
        myPlusButton.addTarget(self, action: #selector(self.OpenSliderView), for: UIControlEvents.touchUpInside)
        let RightBackBarButton:UIBarButtonItem = UIBarButtonItem(customView: myPlusButton)
        self.navigationItem.rightBarButtonItem = RightBackBarButton
        
        
        DispatchQueue.main.async {
            
            UINavigationBar.appearance().tintColor = UIColor.black
            self.navigationController?.navigationBar.titleTextAttributes = [
                NSForegroundColorAttributeName : UIColor.black
            ]
            self.navigationController?.navigationBar.barTintColor = UIColor.white
            self.navigationController?.navigationBar.tintColor = UIColor.white
            self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Arial Rounded MT Bold", size: 16.0)!];
            
            UINavigationBar.appearance().isTranslucent = false
            Global.macros.statusBar.backgroundColor = UIColor.white
            UIApplication.shared.statusBarStyle = .default
            self.navigationItem.title = "Admin"
            
        }

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            
            self.scroll_View.contentSize = CGSize(width: self.view.frame.size.width, height:  750) }
        
          if (SavedPreferences.value(forKey: "role") as? String) == "COMPANY" {
        
        getAllUserCompanyApi()
            
            
        }
          else{
            
            
            getDataForSchoolAdmin()
        }
    }
    
    
    
    func getAllUserCompanyApi()
    {
        
         self.arr_Users.removeAllObjects()
        
        
        let dict = NSMutableDictionary()
        let user_Id = SavedPreferences.value(forKey: Global.macros.kUserId) as? NSNumber
        dict.setValue(user_Id, forKey: "userId")
        dict.setValue(0, forKey: "searchType")
        dict.setValue(0, forKey: "pageIndex")
        dict.setValue(9, forKey: "pageSize")
        print(dict)
        
        
        if self.checkInternetConnection(){
            
            DispatchQueue.main.async {
                self.pleaseWait()
            }
            
            Requests_API.sharedInstance.getTopUserAndCountForCompanyAdmin(completionBlock: {(status, dict_Info) in
                DispatchQueue.main.async {
                    self.clearAllNotice()
                }
                switch status{
                    
                case 200:
                    
                    DispatchQueue.main.async {
                        
                        print(dict_Info)
                        print("dic :- \(dict_Info)")
                        
                        let arr = dict_Info.value(forKey: "data") as! NSDictionary
                        self.arr_Users.addObjects(from: (arr.value(forKey: "UserList") as? NSArray as! [Any]))
                        self.str_meetingCount = "\(arr.value(forKey: "meetingCount")!)"
                        self.str_TotalUsers = "\(arr.value(forKey: "totalUsersCount")!)"
                        self.str_VerifiedUserCount = "\(arr.value(forKey: "verifiedUsersCount")!)"

                        
                        DispatchQueue.main.async {
                            self.collectionView_topUsers.reloadData()
                            self.collectionView_totalUsers.reloadData()
                        }
                        
                        if self.arr_Users.count == 0 {
                            
                            self.lblNoDataFound.isHidden = false
                        }
                        else{
                            
                             self.lblNoDataFound.isHidden = true
                            
                        }
                        
                        if self.arr_Users.count >= 9 {
                            
                            self.btn_seeMore.isHidden = false
                            
                        }
                        
                        print(self.arr_Users)
                        
                    }
                    
                    break
                    
                case 404:
                    
                    DispatchQueue.main.async {
                        self.showAlert(Message: "No data found.", vc: self)
                    }
                    
                //User unauthorized to get details
                case 400:
                    
                    DispatchQueue.main.async {
                        self.showAlert(Message: "User unauthorized to get details.", vc: self)
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
    
    
    func getDataForSchoolAdmin() {
        
        
        self.arr_Users.removeAllObjects()
        
        
        let dict = NSMutableDictionary()
        let user_Id = SavedPreferences.value(forKey: Global.macros.kUserId) as? NSNumber
        dict.setValue(user_Id, forKey: "userId")
        dict.setValue(0, forKey: "searchType")
        dict.setValue(0, forKey: "pageIndex")
        dict.setValue(9, forKey: "pageSize")
        print(dict)
        
        
        if self.checkInternetConnection(){
            
            DispatchQueue.main.async {
                self.pleaseWait()
            }
            
            Requests_API.sharedInstance.getTopUserAndCountForSchoolAdmin(completionBlock: {(status, dict_Info) in
                DispatchQueue.main.async {
                    self.clearAllNotice()
                }
                switch status{
                    
                case 200:
                    
                    DispatchQueue.main.async {
                        
                        print(dict_Info)
                        print("dic :- \(dict_Info)")
                        
                        let arr = dict_Info.value(forKey: "data") as! NSDictionary
                        self.arr_Users.addObjects(from: (arr.value(forKey: "UserList") as? NSArray as! [Any]))
                        self.str_meetingCount = "\(arr.value(forKey: "meetingCount")!)"
                        self.str_TotalUsers = "\(arr.value(forKey: "totalUsersCount")!)"
                        self.str_VerifiedUserCount = "\(arr.value(forKey: "verifiedUsersCount")!)"
                        
                        DispatchQueue.main.async {
                            self.collectionView_topUsers.reloadData()
                            self.collectionView_totalUsers.reloadData()
                        }
                        
                        if self.arr_Users.count == 0 {
                            
                            self.lblNoDataFound.isHidden = false
                        }
                        else{
                            
                            self.lblNoDataFound.isHidden = true
                            
                        }
                        
                        if self.arr_Users.count >= 9 {
                            
                            self.btn_seeMore.isHidden = false
                            
                        }
                        
                        print(self.arr_Users)
                        
                    }
                    
                    break
                    
                case 404:
                    
                    DispatchQueue.main.async {
                        self.showAlert(Message: "No data found.", vc: self)
                    }
                    
                //User unauthorized to get details
                case 400:
                    
                    DispatchQueue.main.async {
                        self.showAlert(Message: "User unauthorized to get details.", vc: self)
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
    
    
    
    
    
    func OpenSliderView() {
        
        DispatchQueue.main.async {
            
            let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "adminverified") as! AdminVerifiedViewController
            _ = self.navigationController?.pushViewController(vc, animated: true)
            vc.extendedLayoutIncludesOpaqueBars = true
            self.automaticallyAdjustsScrollViewInsets = false
            
        }

    }

    
    func PopToProfile()
    {
        DispatchQueue.main.async {
            self.view.endEditing(true)
            bool_ComingFromList = false
            let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "SWRevealViewController")as!  SWRevealViewController
            Global.macros.kAppDelegate.window?.rootViewController = vc
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Action
    
    
    @IBAction func Action_OpenStat(_ sender: UIButton) {
        
        
        if sender.tag == 1 {
            
            let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "MyRequests") as! RequestsListViewController
            if (SavedPreferences.value(forKey: "role") as? String) == "SCHOOL" {
                
                vc.user_Name = "\(SavedPreferences.value(forKey: Global.macros.kschoolName)!)"
                
            }
            else if (SavedPreferences.value(forKey: "role") as? String) == "COMPANY"  {
                
                vc.user_Name = "\(SavedPreferences.value(forKey: Global.macros.kcompanyName)!)"
                
                
                
            }
                
            else if (SavedPreferences.value(forKey: "role") as? String) == "USER"  {
                
                vc.user_Name = "\(SavedPreferences.value(forKey: Global.macros.kUserName)!)"
                
                
                
                
            }
            
            
            
            _ = self.navigationController?.pushViewController(vc, animated: true)
            
            
            
        }
            
        else if sender.tag == 0 || sender.tag == 2 {
            DispatchQueue.main.async {
                
                let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "stat") as! StatViewController
                vc.bool_ComingFromSuperAdmin = false
                vc.index_count = sender.tag
                _ = self.navigationController?.pushViewController(vc, animated: true)
                vc.extendedLayoutIncludesOpaqueBars = true
                self.automaticallyAdjustsScrollViewInsets = false
            }
            
        }
    }
    
    @IBAction func btnAction_seeMore(_ sender: UIButton) {
        
        DispatchQueue.main.async {
            
            let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "adminseemore") as! SeeMoreViewController
            _ = self.navigationController?.pushViewController(vc, animated: true)
            vc.extendedLayoutIncludesOpaqueBars = true
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
    }
    
    
    @IBAction func Action_OpenProfile(_ sender: UIButton) {
        
        let userData = self.arr_Users[sender.tag] as? NSDictionary
        bool_ComingFromList = true
        bool_UserIdComingFromSearch = false
        
        DispatchQueue.main.async {
            
            let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "user") as! ProfileVC
            vc.userIdFromList = userData?["userId"] as? NSNumber
            
            _ = self.navigationController?.pushViewController(vc, animated: true)
            vc.extendedLayoutIncludesOpaqueBars = true
            self.automaticallyAdjustsScrollViewInsets = false
            //self.navigationController?.navigationBar.isTranslucent = false
        }
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

extension AdminPendingViewController:UICollectionViewDataSource,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.collectionView_topUsers {
            
            return arr_Users.count
            
        }
            
        else {
            
            return 3
        }
        
        
        
    }
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellData", for: indexPath as IndexPath) as!  AdminPendingCollectionViewCell
        
        if collectionView == self.collectionView_topUsers {
            
            let userData = self.arr_Users[indexPath.row] as? NSDictionary
            let userDTO = userData?.value(forKey: "userDTO") as? NSDictionary
            let url =  userDTO?.value(forKey: "profileImageUrl") as? String
            cell.lbl_userName.text = userData?.value(forKey: "name") as? String
            cell.img_users.layer.cornerRadius = 34.0
            cell.img_users.clipsToBounds = true
            cell.btn_Profile.tag = indexPath.row
            
            if url != nil && url != "" {
                
                cell.img_users.sd_setImage(with: URL.init(string: url!), placeholderImage: UIImage.init(named: "dummySearch"))
            
            }
                
            else {
                
                cell.img_users.image = UIImage(named: "dummySearch")
                
            }
            
        }
            
        else {
            
            if indexPath.row == 0 {
                cell.lbl_users.text = "Total Users"
                cell.lbl_totalUsers.text = self.str_TotalUsers
                cell.btn_Stat.tag = 0

            }
                
            else if indexPath.row == 1 {
                cell.lbl_users.text = "Shadow Meeting"
                cell.lbl_totalUsers.text = self.str_meetingCount
                cell.btn_Stat.tag = 1

            }
                
            else{
                cell.lbl_users.text = "Verified Users"
                cell.lbl_totalUsers.text = self.str_VerifiedUserCount
                 cell.btn_Stat.tag = 2
            }
        }
        
        
        return cell
        
    }
    // MARK: - UICollectionViewDelegate protocol
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        
        
    }
    
}
