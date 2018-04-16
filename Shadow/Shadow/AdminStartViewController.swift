//
//  AdminStartViewController.swift
//  Shadow
//
//  Created by Navaldeep Kaur on 1/23/18.
//  Copyright © 2018 Atinderjit Kaur. All rights reserved.
//

import UIKit

class AdminStartViewController: UIViewController {

    @IBOutlet var CollectionView_fst: UICollectionView!
    @IBOutlet var CollectionView_users: UICollectionView!
    @IBOutlet var CollectionView_companies: UICollectionView!
    @IBOutlet var CollectionView_schools: UICollectionView!
    @IBOutlet weak var scroll_view: UIScrollView!
    var arr_Users = NSMutableArray()
    var arr_Company = NSMutableArray()
    var arr_School = NSMutableArray()
    
    @IBOutlet weak var lbl_UserNoData: UILabel!
    @IBOutlet weak var lbl_NoDataCompany: UILabel!
    @IBOutlet weak var lbl_SchoolNoData: UILabel!
    @IBOutlet weak var btn_UserSeeMore: UIButton!
    @IBOutlet weak var btn_CompanySeeMore: UIButton!
    @IBOutlet weak var btn_SchoolSeeMore: UIButton!
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
    
    func OpenSliderView() {
        
        DispatchQueue.main.async {
            
            let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "adminview") as! AdminViewController
            _ = self.navigationController?.pushViewController(vc, animated: true)
            vc.extendedLayoutIncludesOpaqueBars = true
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {

            self.scroll_view.contentSize = CGSize(width: self.view.frame.size.width, height:  750) }
 
            getAllUserApi()
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
    
    // MARK:- Actions
    
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
            vc.bool_ComingFromSuperAdmin = true
             vc.index_count = sender.tag
            _ = self.navigationController?.pushViewController(vc, animated: true)
            vc.extendedLayoutIncludesOpaqueBars = true
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        }
    }
    
    @IBAction func btn_topUsers(_ sender: Any) {
        
        DispatchQueue.main.async {
            
            let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "seemore") as! SeeMoreSuperAdminViewController
            vc.str_role = "User"
            _ = self.navigationController?.pushViewController(vc, animated: true)
            vc.extendedLayoutIncludesOpaqueBars = true
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
    }

    @IBAction func btn_topCompanies(_ sender: Any) {
        
        DispatchQueue.main.async {
            
            let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "seemore") as! SeeMoreSuperAdminViewController
            vc.str_role = "Company"
            _ = self.navigationController?.pushViewController(vc, animated: true)
            vc.extendedLayoutIncludesOpaqueBars = true
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
    }
    
    @IBAction func btn_topSchools(_ sender: Any) {
        
        DispatchQueue.main.async {
            
            let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "seemore") as! SeeMoreSuperAdminViewController
            vc.str_role = "School"
            _ = self.navigationController?.pushViewController(vc, animated: true)
            vc.extendedLayoutIncludesOpaqueBars = true
            self.automaticallyAdjustsScrollViewInsets = false
        }
       
    }
    
    @IBAction func Action_UserProfile(_ sender: UIButton) {
        
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
    
    
    @IBAction func Action_CompanyProfile(_ sender: UIButton) {
        
        bool_ComingFromList = true
        bool_UserIdComingFromSearch = false

        let userData = self.arr_Company[sender.tag] as? NSDictionary

        DispatchQueue.main.async {
            
            let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "company") as! ComapanySchoolViewController
            if userData?["userId"] != nil {
                vc.userIdFromList = userData?["userId"] as? NSNumber }
            
            
            _ = self.navigationController?.pushViewController(vc, animated: true)
            
            vc.extendedLayoutIncludesOpaqueBars = true
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
    }
    
    
    @IBAction func Action_SchoolProfile(_ sender: UIButton) {
        
        bool_ComingFromList = true
        bool_UserIdComingFromSearch = false
        
        let userData = self.arr_School[sender.tag] as? NSDictionary
        
        DispatchQueue.main.async {
            
            let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "company") as! ComapanySchoolViewController
            if userData?["userId"] != nil {
                vc.userIdFromList = userData?["userId"] as? NSNumber }
            
            _ = self.navigationController?.pushViewController(vc, animated: true)
            
            vc.extendedLayoutIncludesOpaqueBars = true
            self.automaticallyAdjustsScrollViewInsets = false
        }

    }
    
    
    // MARK:- Service function
    
    
    func getAllUserApi()
    {
        
        self.arr_School.removeAllObjects()
        self.arr_Company.removeAllObjects()
        self.arr_Users.removeAllObjects()

        let dict = NSMutableDictionary()
        let user_Id = SavedPreferences.value(forKey: Global.macros.kUserId) as? NSNumber
        dict.setValue(user_Id, forKey: "userId")
        dict.setValue(0, forKey: "searchType")
        dict.setValue(0, forKey: "pageIndex")  //"searchKeyword":"a",
        dict.setValue(10, forKey: "pageSize")
        print(dict)
        
        
        if self.checkInternetConnection(){
            
            DispatchQueue.main.async {
                self.pleaseWait()
            }
            
            Requests_API.sharedInstance.getTopThreeUserListForSuperAdmin(completionBlock: {(status, dict_Info) in
                DispatchQueue.main.async {
                    self.clearAllNotice()
                }
                switch status{
                    
                case 200:
                    
                    DispatchQueue.main.async {
                        
                        print(dict_Info)
                        print("dic :- \(dict_Info)")
                        
                        let arr = dict_Info.value(forKey: "data") as! NSDictionary
                        self.str_meetingCount = "\(arr.value(forKey: "meetingCount")!)"
                        self.str_TotalUsers = "\(arr.value(forKey: "totalUsersCount")!)"
                          self.str_VerifiedUserCount = "\(arr.value(forKey: "verifiedUsersCount")!)"
                        
                        self.arr_Users.addObjects(from: (arr.value(forKey: "UserList") as? NSArray as! [Any]))
                        if self.arr_Users.count > 0 {
                            
                            self.lbl_UserNoData.isHidden = true
                            
                             if self.arr_Users.count >= 1 {
                                
                                self.btn_UserSeeMore.isHidden = false
                            }
                           
                            
                        }
                        
                        else{
                            
                             self.btn_UserSeeMore.isHidden = true
                        }
                        
                        
                        
                        self.arr_Company.addObjects(from: (arr.value(forKey: "CompanyList") as? NSArray as! [Any]))
                        
                        if self.arr_Company.count > 0 {
                            self.lbl_NoDataCompany.isHidden = true
                            
                            if self.arr_Company.count >= 1 {
                                
                                self.btn_CompanySeeMore.isHidden = false
                            }
                        }
                        
                        else{
                            
                            self.btn_CompanySeeMore.isHidden = true
                        }
                        
                        self.arr_School.addObjects(from: (arr.value(forKey: "schoolList") as? NSArray as! [Any]))
                        
                        
                        if self.arr_School.count > 0 {
                            self.lbl_SchoolNoData.isHidden = true
                            if self.arr_School.count >= 1 {
                                
                                self.btn_SchoolSeeMore.isHidden = false
                            }
                            
                        }
                        else{
                            
                            self.btn_SchoolSeeMore.isHidden = true
                        }

                        

                        DispatchQueue.main.async {
                            self.CollectionView_fst.reloadData()
                            self.CollectionView_users.reloadData()
                            self.CollectionView_schools.reloadData()
                            self.CollectionView_companies.reloadData()
                        }
                       
                        print( self.arr_Users)
                        
                    }
                    
                    break
                    
                case 404:
                    
                    DispatchQueue.main.async {
                        
                        self.showAlert(Message: "No data found.", vc: self)
                        
                    }
                    
                case 404:
                    
                    DispatchQueue.main.async {
                        
                        self.showAlert(Message: "Session Expired! Please try to login again.", vc: self)
                        
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


    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension AdminStartViewController:UICollectionViewDataSource,UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.CollectionView_users {
            
            return arr_Users.count
            
        }
        else if collectionView == self.CollectionView_schools {
            
            return arr_School.count

            
        }
            
        else if collectionView == self.CollectionView_companies {
            
            return arr_Company.count

        }
            
        else {
            
            return 3
        }
        
        
        
    }
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellData", for: indexPath as IndexPath) as!TopUserCollectionViewCell
        
        if collectionView == self.CollectionView_users {
            
            let userData = self.arr_Users[indexPath.row] as? NSDictionary
            let userDTO = userData?.value(forKey: "userDTO") as? NSDictionary
            let url =  userDTO?.value(forKey: "profileImageUrl") as? String
            cell.lbl_userName.text = userData?.value(forKey: "name") as? String
            cell.imgView_topUsers.layer.cornerRadius = 34.0
            cell.imgView_topUsers.clipsToBounds = true
            cell.btn_Users.tag = indexPath.row
           

            
            if url != nil && url != "" {
                cell.imgView_topUsers.sd_setImage(with: URL.init(string: url!), placeholderImage: UIImage.init(named: "dummySearch"))
            }
            else{
                
                cell.imgView_topUsers.image = UIImage(named: "dummySearch")
                
            }
            
        }
        else if collectionView == self.CollectionView_schools {
            
            let userData = self.arr_School[indexPath.row] as? NSDictionary
            cell.lbl_schoolName.text = userData?.value(forKey: "name") as? String
            let userDTO = userData?.value(forKey: "userDTO") as? NSDictionary
            let url =  userDTO?.value(forKey: "profileImageUrl") as? String
            cell.btn_Schools.tag = indexPath.row

            cell.img_topSchool.layer.cornerRadius = 34.0
            cell.img_topSchool.clipsToBounds = true
            
            if url != nil && url != "" {
                
                cell.img_topSchool.sd_setImage(with: URL.init(string: url!), placeholderImage: UIImage.init(named: "dummySearch"))
            }
            else{
                
                cell.img_topSchool.image = UIImage(named: "dummySearch")
                
            }
            
        }
            
        else if collectionView == self.CollectionView_companies {
            
            let userData = self.arr_Company[indexPath.row] as? NSDictionary
            let userDTO = userData?.value(forKey: "userDTO") as? NSDictionary
            let url =  userDTO?.value(forKey: "profileImageUrl") as? String
            cell.img_topCompanies.layer.cornerRadius = 34.0
            cell.img_topCompanies.clipsToBounds = true
            cell.btn_Companies.tag = indexPath.row

            
            if url != nil && url != "" {
                
                cell.img_topCompanies.sd_setImage(with: URL.init(string: url!), placeholderImage: UIImage.init(named: "dummySearch"))
            }
            else{
                
                cell.img_topCompanies.image = UIImage(named: "dummySearch")
                
            }
            
            
            cell.lbl_companyName.text = userData?.value(forKey: "name") as? String

        }
            
        else {
            
            if indexPath.row == 0 {
                cell.lbl_users.text = "Total Users"
                cell.lbl_totalUsers.text = self.str_TotalUsers
                cell.btn_OpenStat.tag = 0
            }
            
            else if indexPath.row == 1 {
                cell.lbl_users.text = "Shadow Meeting"
                 cell.lbl_totalUsers.text = self.str_meetingCount
                 cell.btn_OpenStat.tag = 1
            }
            
            else{
                cell.lbl_users.text = "Verified Users"
                 cell.lbl_totalUsers.text = self.str_VerifiedUserCount
                 cell.btn_OpenStat.tag = 2
            }
        }

        
         return cell
        
    }
    // MARK: - UICollectionViewDelegate protocol
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        
        
    }
}
