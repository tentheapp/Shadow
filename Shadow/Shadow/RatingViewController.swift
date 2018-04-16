//
//  RatingViewController.swift
//  Shadow
//
//  Created by Atinderjit Kaur on 19/06/17.
//  Copyright © 2017 Atinderjit Kaur. All rights reserved.
//

import UIKit

var ratingview_name : String?
var ratingview_imgurl : String?
var ratingview_imgurlProfile : String?

var ratingview_ratingNumber : String = ""


//var bool_ProfileOpenFromComment : Bool = false

class RatingViewController: UIViewController {
    
    @IBOutlet var lbl_RatingsCount: UILabel!
    @IBOutlet var lbl_ratings: UILabel!
    @IBOutlet weak var imgView_Profile: UIImageView!
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet var view_Behind_Profile: UIView!
    @IBOutlet weak var tblView_Rating: UITableView!
    @IBOutlet var lbl_totalRatingCount: UILabel!
    let myBackButton:UIButton = UIButton()
    
    var arr_GetRatingData : NSMutableArray = NSMutableArray()
    
    var imageView1 : UIImageView?
    var imageView2 : UIImageView?
    var imageView3 : UIImageView?
    var imageView4 : UIImageView?
    var imageView5 : UIImageView?
    var occ_id      :     NSNumber?
    var userIdForRating : NSNumber?
    var title_occ :       String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // self.automaticallyAdjustsScrollViewInsets = false
        self.tabBarController?.tabBar.isHidden = true
        self.tabBarController?.tabBar.isTranslucent = true

    }
    override func viewDidDisappear(_ animated: Bool) {
           ratingview_imgurl = nil
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        DispatchQueue.main.async {
            
            self.imgView_Profile.layer.cornerRadius = 60.0
            self.imgView_Profile.clipsToBounds = true
            
            //SETTING BORDER OF CUSTOM VIEWS(bOUNDARIES)
            self.customView(view: self.view_Behind_Profile)
            
            self.tblView_Rating.layer.cornerRadius = 4
            self.tblView_Rating.clipsToBounds = true
            self.tblView_Rating.layer.borderColor = UIColor.init(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 0.5).cgColor
            self.tblView_Rating.layer.borderWidth = 1.0
            
        }
        
        if  bool_PushComingFromAppDelegate == true {
            bool_PushComingFromAppDelegate = false
            myBackButton.addTarget(self, action: #selector(self.PopToRootVC), for: UIControlEvents.touchUpInside)
            userIdForRating = SavedPreferences.value(forKey: Global.macros.kUserId)as? NSNumber
        }
        else {
            
           myBackButton.addTarget(self, action: #selector(self.PopVC), for: UIControlEvents.touchUpInside)
            
        }

       
            
            if  userIdForRating != SavedPreferences.value(forKey: Global.macros.kUserId)as? NSNumber {
                
                let btn_addRating = UIButton(type: .custom)
                btn_addRating.setImage(UIImage(named: "add_purple"), for: .normal)
                btn_addRating.frame = CGRect(x: self.view.frame.size.width - 50, y: 0, width: 50, height: 50)
                btn_addRating.addTarget(self, action: #selector(PushAddRatingScreen), for: .touchUpInside)
                let item4 = UIBarButtonItem(customView: btn_addRating)
                self.navigationItem.setRightBarButton(item4, animated: true)
                
                
            }
                
        
            
        
        
        
        tblView_Rating.tableFooterView = UIView()
        
        self.navigationItem.setHidesBackButton(false, animated:true)
        
        myBackButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        myBackButton.setImage(UIImage(named:"back-new"), for: UIControlState())
        myBackButton.addTarget(self, action: #selector(self.PopVC), for: UIControlEvents.touchUpInside)
        let leftBackBarButton:UIBarButtonItem = UIBarButtonItem(customView: myBackButton)
        self.navigationItem.leftBarButtonItem = leftBackBarButton

        ShowRatingData()
           }
    
    
    
    func PopVC() {
        
        bool_FromOccupation = false
        bool_UserIdComingFromSearch = false
        bool_ComingRatingList = false
       
        
   
            _ = self.navigationController?.popViewController(animated: true)

            
        
        
    }
    
    
    func PopToRootVC() {
        DispatchQueue.main.async {
             bool_ComingFromList = false
            let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "SWRevealViewController") as!  SWRevealViewController
            Global.macros.kAppDelegate.window?.rootViewController = vc
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - Functions
    
    
    @IBAction func ActionDidSelectRow(_ sender: UIButton) {
        
       bool_ComingFromList = true
     //   bool_UserIdComingFromSearch = true
      //   bool_ProfileOpenFromComment = true
        
        
        var userId = NSNumber()
        
        let dict_Temp = (arr_GetRatingData[sender.tag] as! NSDictionary)["userDTO"] as? NSDictionary
        
        //setting name
        
        if (arr_GetRatingData[sender.tag] as! NSDictionary)["userDTO"] != nil {
            
            if dict_Temp?[Global.macros.krole] as? String == "COMPANY"  {
                
                userId = (dict_Temp?.value(forKey: "userId") as? NSNumber)!
            }
            else if dict_Temp?[Global.macros.krole] as? String == "SCHOOL"{
                
                userId = (dict_Temp?.value(forKey: "userId") as? NSNumber)!
            }
                
            else{
                
                userId = (dict_Temp?.value(forKey: "userId") as? NSNumber)!
            }
            
        }
        
        
        let role = dict_Temp?.value(forKey: Global.macros.krole) as? String
        
        if role == "COMPANY" || role == "SCHOOL"
        {
            DispatchQueue.main.async {
                
                let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "company") as! ComapanySchoolViewController
                vc.user_IdMyProfile = userId
                _ = self.navigationController?.pushViewController(vc, animated: true)
                
                vc.extendedLayoutIncludesOpaqueBars = true
                self.automaticallyAdjustsScrollViewInsets = false
            }
        }
        else {
            DispatchQueue.main.async {
                
                let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "user") as! ProfileVC
                vc.user_IdMyProfile = userId
                _ = self.navigationController?.pushViewController(vc, animated: true)
                vc.extendedLayoutIncludesOpaqueBars = true
                self.automaticallyAdjustsScrollViewInsets = false
                //self.navigationController?.navigationBar.isTranslucent = false
            }
        }

        
        
    }
    
    
    func ShowRatingData() {
        
        if self.checkInternetConnection()
        {
            DispatchQueue.main.async {
                self.pleaseWait()
            }
            
            let dic:NSMutableDictionary = NSMutableDictionary()
            dic.setValue(SavedPreferences.value(forKey: Global.macros.kUserId)as! NSNumber, forKey: Global.macros.kUserId)
          
           if bool_FromOccupation == true {
                
                dic.setValue(occ_id , forKey: "occupationId")

            }
           else {
            
            dic.setValue(self.userIdForRating , forKey: "otherUserId")

            
            }
            
          
            
            print(dic)
            
            ProfileAPI.sharedInstance.RatingList(dict: dic, completion: {(response) in
                
                DispatchQueue.main.async {
                    self.clearAllNotice()
                }
                
                let status = (response).value(forKey: Global.macros.KStatus)as! NSNumber
                switch status
                {
                case 200:
                    
                    print("success")
                    self.tblView_Rating.isHidden = false
                    let arr  = (response.value(forKey: "data") as? NSDictionary)?.mutableCopy() as! NSMutableDictionary
                    DispatchQueue.main.async {
                        
                        //setting rating
                        if arr.value(forKey: "avgRating") != nil {
                           
                            ratingview_ratingNumber = "\(arr.value(forKey: "avgRating")!)"
                            
                            if "\(arr.value(forKey: "avgRating")!)" != "" &&  (arr.value(forKey: "avgRating")) != nil {
                            
                            let dbl = 2.0
                            if  dbl.truncatingRemainder(dividingBy: 1) == 0
                            {
                                self.lbl_RatingsCount.text = "\(arr.value(forKey: "avgRating")!)" + ".0"
                                
                            }
                            else {
                                self.lbl_RatingsCount.text = "\(arr.value(forKey: "avgRating")!)"
                            }
                            }
                            else {
                              self.lbl_RatingsCount.text = "0.0"
                                
                            }
                         }
                        
                        //setting rating count members
                         self.lbl_totalRatingCount.text = "\(arr.value(forKey: "ratingCount")!)"
                        
                        //setting title
                        DispatchQueue.main.async {
                            if arr["ratedUserName"] != nil{
                                //if it is user
                                
                                self.title = ""
                                self.title = (arr.value(forKey: "ratedUserName") as? String)?.capitalized
                                
                            }
                            else {
                                //if it is school or company
                                self.title = ""
                                self.title = (arr.value(forKey: "name") as? String)?.capitalized
                                
                            }
                        }
                        
                      if  bool_FromOccupation == true {
                        
                        self.imgView_Profile.image = UIImage(named:"occupation_filter")!
                      }
                      else {
                        
                      if   self.userIdForRating != SavedPreferences.value(forKey: Global.macros.kUserId) as? NSNumber {
                      
                         if ratingview_imgurl != nil {
                            
                            self.imgView_Profile.sd_setImage(with: URL(string:ratingview_imgurl!), placeholderImage: UIImage(named: "profile-icon-1"))
                            
                        }
                            
                      }
                        
                        //set profile image
                       else  {
                     if ratingview_imgurlProfile != nil {
                            self.imgView_Profile.sd_setImage(with: URL(string:ratingview_imgurlProfile!), placeholderImage: UIImage(named: "profile-icon-1"))//image 
                        }
                            
                        }
                        }
                    }
                    
                    //getting array of users who rated
                    if (arr.value(forKey: "userRatings") as? NSArray) != nil {
                        
                        self.arr_GetRatingData = (arr.value(forKey: "userRatings") as? NSArray)?.mutableCopy() as! NSMutableArray
                        
                    }
                        
                    else if (arr.value(forKey: "companyRatings") as? NSArray) != nil {
                        
                        self.arr_GetRatingData = (arr.value(forKey: "companyRatings") as? NSArray)?.mutableCopy() as! NSMutableArray
                        
                    }
                    else if (arr.value(forKey: "schoolRatings") as? NSArray) != nil {
                        
                        self.arr_GetRatingData = (arr.value(forKey: "schoolRatings") as? NSArray)?.mutableCopy() as! NSMutableArray
                        
                    }
                        
                    else if (arr.value(forKey: "occupationRatings") as? NSArray) != nil {
                        
                        self.arr_GetRatingData = (arr.value(forKey: "occupationRatings") as? NSArray)?.mutableCopy() as! NSMutableArray
                        
                    }
                    
                   
                    //print(self.arr_GetRatingData)
                    
                    DispatchQueue.main.async {
                        
                        self.tblView_Rating.reloadData()
                        
                    }
                    
                case 210:
                    
                    DispatchQueue.main.async {
                        self.showAlert(Message: str_messageInWrongCeredentials!, vc: self)
                    }
                    
                case 400:
                    
                    DispatchQueue.main.async {

                    self.arr_GetRatingData.removeAllObjects()
                
                        if  bool_FromOccupation == true {
                            
                            self.imgView_Profile.image = UIImage(named:"occupation_filter")!
                        }
                        else {
                            
                            if   self.userIdForRating != SavedPreferences.value(forKey: Global.macros.kUserId) as? NSNumber {
                                
                                if ratingview_imgurl != nil {
                                    
                                    self.imgView_Profile.sd_setImage(with: URL(string:ratingview_imgurl!), placeholderImage: UIImage(named: "profile-icon-1"))
                                    
                                }
                                
                            }
                                
                                //set profile image
                            else  {
                                if ratingview_imgurlProfile != nil {
                                    self.imgView_Profile.sd_setImage(with: URL(string:ratingview_imgurlProfile!), placeholderImage: UIImage(named: "profile-icon-1"))//image
                                }
                                
                            }
                        }
                    
                    
                    if  bool_FromOccupation == true {
                        
                         self.navigationItem.title = self.title_occ
                        
                    } else {
                        
                        //set profile image
                        if ratingview_name != nil {
                             self.navigationItem.title = ratingview_name
                        }
                        
                    }
                    
                    
                    
                    
                        self.lbl_totalRatingCount.text = "0"
                        self.lbl_RatingsCount.text = "0.0"
                        self.tblView_Rating.isHidden = true
                        self.tblView_Rating.reloadData()
                        
                  
                    }
                case 401:
                    
                    
                    self.AlertSessionExpire()
                    
                    
                    
                 
                case 0 :
                    self.clearAllNotice()
 
                    
                default:
                    break
                }
               
                
            }, errorBlock: {(err) in
                DispatchQueue.main.async {
                    self.clearAllNotice()
                    self.showAlert(Message:(err?.localizedDescription)!, vc: self)
                    
                    
                }
                
                
                
            })
            
            
        }
        else
        {
            self.showAlert(Message: Global.macros.kInternetConnection, vc: self)
            
            
        }
        
        
        
    }
    
    func PushAddRatingScreen() {
        
        let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "addrating") as! AddRatingViewController

        if bool_FromOccupation == true {

            vc.userIdFromAddRating = occ_id
        }
        
        else {
            vc.userIdFromAddRating = userIdForRating

            
        }
        _ = self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func customView(view : UIView) {
        
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        view.layer.borderColor =  UIColor.init(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 0.5).cgColor
        view.layer.borderWidth = 1.0
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


//MARK: UITableview methods

extension RatingViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr_GetRatingData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)as! RatingTableViewCell
        cell.btn_DidSelect.tag = indexPath.row
        cell.txtView_Comment.text = (arr_GetRatingData[indexPath.row] as! NSDictionary)["comment"] as? String
        
        let dict_Temp = (arr_GetRatingData[indexPath.row] as! NSDictionary)["userDTO"] as? NSDictionary
        
        //setting name

        if (arr_GetRatingData[indexPath.row] as! NSDictionary)["userDTO"] != nil{
            
           if dict_Temp?[Global.macros.krole] as? String == "COMPANY"{
           
            cell.lbl_name.text = (dict_Temp?.value(forKey: Global.macros.kname) as? String)?.capitalized

            }
           else if dict_Temp?[Global.macros.krole] as? String == "SCHOOL"{
            
            cell.lbl_name.text = (dict_Temp?.value(forKey: Global.macros.kname) as? String)?.capitalized
            }
            
           else{
            
            cell.lbl_name.text = (dict_Temp?.value(forKey: "userName") as? String)?.capitalized
            }
            
        }
        
        
        
        //setting profile image
        var profileurl =  dict_Temp?.value(forKey: "profileImageUrl") as? String
        profileurl = profileurl?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        if profileurl != nil {
            cell.imgview_Profile.sd_setImage(with: URL(string:profileurl!), placeholderImage: UIImage(named: "profile-icon-1"))//image
        }
        
        
        
        //Setting time
        if (arr_GetRatingData[indexPath.row] as! NSDictionary)["timeAgo"] != nil {
        let time : NSString = (arr_GetRatingData[indexPath.row] as! NSDictionary)["timeAgo"] as! NSString

        print(time)
        let delimiter = " "
        var token = time.components(separatedBy: delimiter)
        
            if token[1].contains("m")
            {
                cell.lbl_time.text = (token[0]) + "m"
 
            }
            else if token[1].contains("d") {
  
               cell.lbl_time.text = (token[0]) + "d"
                
            }
            else if token[1].contains("h") {
                
                cell.lbl_time.text = (token[0]) + "h"
                
            }
            
            else {
                 cell.lbl_time.text = "Just now"
                
            }
        }
        
        
        let rating_number = "\((arr_GetRatingData[indexPath.row] as! NSDictionary)["rating"]!)"
        switch rating_number {
            
        case "0":
            cell.imgView_Rating1.image = UIImage(named: "StarEmpty")
            cell.imgView_Rating2.image = UIImage(named: "StarEmpty")
            cell.imgView_Rating3.image = UIImage(named: "StarEmpty")
            cell.imgView_Rating4.image = UIImage(named: "StarEmpty")
            cell.imgView_Rating5.image = UIImage(named: "StarEmpty")
            
        case "1":
            cell.imgView_Rating1.image = UIImage(named: "StarFull")
            cell.imgView_Rating2.image = UIImage(named: "StarEmpty")
            cell.imgView_Rating3.image = UIImage(named: "StarEmpty")
            cell.imgView_Rating4.image = UIImage(named: "StarEmpty")
            cell.imgView_Rating5.image = UIImage(named: "StarEmpty")
            
        case "2":
            cell.imgView_Rating1.image = UIImage(named: "StarFull")
            cell.imgView_Rating2.image = UIImage(named: "StarFull")
            cell.imgView_Rating3.image = UIImage(named: "StarEmpty")
            cell.imgView_Rating4.image = UIImage(named: "StarEmpty")
            cell.imgView_Rating5.image = UIImage(named: "StarEmpty")
            
        case "3":
            cell.imgView_Rating1.image = UIImage(named: "StarFull")
            cell.imgView_Rating2.image = UIImage(named: "StarFull")
            cell.imgView_Rating3.image = UIImage(named: "StarFull")
            cell.imgView_Rating4.image = UIImage(named: "StarEmpty")
            cell.imgView_Rating5.image = UIImage(named: "StarEmpty")
            
        case "4":
            cell.imgView_Rating1.image = UIImage(named: "StarFull")
            cell.imgView_Rating2.image = UIImage(named: "StarFull")
            cell.imgView_Rating3.image = UIImage(named: "StarFull")
            cell.imgView_Rating4.image = UIImage(named: "StarFull")
            cell.imgView_Rating5.image = UIImage(named: "StarEmpty")
            
        case "5":
            cell.imgView_Rating1.image = UIImage(named: "StarFull")
            cell.imgView_Rating2.image = UIImage(named: "StarFull")
            cell.imgView_Rating3.image = UIImage(named: "StarFull")
            cell.imgView_Rating4.image = UIImage(named: "StarFull")
            cell.imgView_Rating5.image = UIImage(named: "StarFull")
            
            
            
        default:
            break
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       bool_ComingFromList = true
//        bool_UserIdComingFromSearch = false
        var userId = NSNumber()
        
        let dict_Temp = (arr_GetRatingData[indexPath.row] as! NSDictionary)["userDTO"] as? NSDictionary
        
        //setting name
        
        if (arr_GetRatingData[indexPath.row] as! NSDictionary)["userDTO"] != nil{
            
            if dict_Temp?[Global.macros.krole] as? String == "COMPANY"  {
                
                userId = (dict_Temp?.value(forKey: "userId") as? NSNumber)!
            }
            else if dict_Temp?[Global.macros.krole] as? String == "SCHOOL"{
                
                userId = (dict_Temp?.value(forKey: "userId") as? NSNumber)!
            }
                
            else{
                
                userId = (dict_Temp?.value(forKey: "userId") as? NSNumber)!
            }
            
        }

        
        let role = dict_Temp?.value(forKey: Global.macros.krole) as? String
        
        if role == "COMPANY" || role == "SCHOOL"
        {
            DispatchQueue.main.async {
                
                let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "company") as! ComapanySchoolViewController
                vc.userIdFromList = userId
                _ = self.navigationController?.pushViewController(vc, animated: true)
                
                vc.extendedLayoutIncludesOpaqueBars = true
                self.automaticallyAdjustsScrollViewInsets = false
            }
        }
        else {
            DispatchQueue.main.async {
                
                let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "user") as! ProfileVC
                vc.userIdFromList = userId
                _ = self.navigationController?.pushViewController(vc, animated: true)
                vc.extendedLayoutIncludesOpaqueBars = true
                self.automaticallyAdjustsScrollViewInsets = false
                //self.navigationController?.navigationBar.isTranslucent = false
            }
        }
        
        
    }
    
}


