//
//  RequestDetailsViewController.swift
//  Shadow
//
//  Created by Aditi on 18/08/17.
//  Copyright © 2017 Atinderjit Kaur. All rights reserved.
//

import UIKit

var Pushrequest_Id:NSNumber?


class RequestDetailsViewController: UIViewController {
    
    @IBOutlet var scroll_View:           UIScrollView!
    @IBOutlet var imgView_UserProfile:   UIImageView!
    @IBOutlet var lbl_AverageRating:     UILabel!
    @IBOutlet var lbl_RatingPersonCount: UILabel!
    @IBOutlet var view_Location:         UIView!
    @IBOutlet var lbl_Location:          UILabel!
    @IBOutlet var view_VirtualMedium:    UIView!
    @IBOutlet var calender:              FSCalendar!
    @IBOutlet var txtView_Message:       UITextView!
    @IBOutlet var lbl_TxtView_Placeholder: UILabel!
    @IBOutlet var view_Buttons:          UIView!
    @IBOutlet var btn_Accept:            UIButton!
    @IBOutlet var btn_Decline:           UIButton!
    @IBOutlet var btn_AcceptedRejected:  UIButton!
    @IBOutlet var lbl_VirtualMedium:     UILabel!
    @IBOutlet var view_LblVirtualMedium: UIView!
    @IBOutlet var view_LblLocation:      UIView!
    var video_url :                      String?
    var logoButton :                     UIButton!
    
    @IBOutlet weak var lbl_time:         UILabel!
    @IBOutlet weak var view_time:        UIView!
    @IBOutlet weak var btn_CusBack:      UIButton!
    var username:                        String?
    var request_Id:                      NSNumber?
    fileprivate var Dict_Info  = NSDictionary()
    
    @IBOutlet weak var lbl_time2: UILabel!
    @IBOutlet weak var view_Time2: UIView!
    //Converts string into date
    let formatter: DateFormatter =
        {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter
    }()
    
    override func viewDidLayoutSubviews() {
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
            if self.revealViewController() != nil {
                self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
            }
        
            
            self.calender.appearance.headerMinimumDissolvedAlpha = 0.0
          
            self.txtView_Message.layer.borderColor =  UIColor.init(red: 104.0/255.0, green: 112.0/255.0, blue: 115.0/255.0, alpha: 1.0).cgColor
            self.txtView_Message.layer.cornerRadius = 8.0
            
            self.navigationItem.setHidesBackButton(false, animated:true)
            
            let myBackButton:UIButton = UIButton()
            myBackButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
            myBackButton.setImage(UIImage(named:"back-new"), for: UIControlState())
            let leftBackBarButton:UIBarButtonItem = UIBarButtonItem(customView: myBackButton)
            self.navigationItem.leftBarButtonItem = leftBackBarButton
            
            if  bool_PushComingFromAppDelegate == true {
                bool_PushComingFromAppDelegate = false
                   myBackButton.addTarget(self, action: #selector(self.PopToRootVC), for: UIControlEvents.touchUpInside)
                                       }
            else {
                myBackButton.addTarget(self, action: #selector(self.PopToRootViewController), for: UIControlEvents.touchUpInside)

            }

            self.imgView_UserProfile.layer.cornerRadius = 60.0
            self.imgView_UserProfile.clipsToBounds = true
            
            self.calender.layer.borderWidth = 1.0
            self.calender.layer.borderColor = UIColor.init(red: 104.0/255.0, green: 112.0/255.0, blue: 115.0/255.0, alpha: 1.0).cgColor
            self.calender.layer.cornerRadius = 8.0
            
            self.btn_Accept.layer.cornerRadius = 8.0
            self.btn_Accept.layer.borderWidth = 1.0
            self.btn_Accept.layer.borderColor = Global.macros.themeColor_Green.cgColor
            self.btn_Accept.setTitleColor(Global.macros.themeColor_Green, for: .normal)

            
            self.btn_Decline.layer.cornerRadius = 5.0
            self.btn_Decline.layer.borderWidth = 1.0
            self.btn_Decline.layer.borderColor = Global.macros.themeColor_pink.cgColor
            self.btn_Decline.setTitleColor(Global.macros.themeColor_pink, for: .normal)

            self.btn_AcceptedRejected.layer.cornerRadius = 8.0
         
            self.view_LblLocation.layer.cornerRadius = 5.0
            self.view_LblLocation.layer.borderWidth = 1.0
            self.view_LblLocation.layer.borderColor = UIColor.init(red: 104.0/255.0, green: 112.0/255.0, blue: 115.0/255.0, alpha: 1.0).cgColor
            
            self.view_LblVirtualMedium.layer.cornerRadius = 5.0
            self.view_LblVirtualMedium.layer.borderWidth = 1.0
            self.view_LblVirtualMedium.layer.borderColor = UIColor.init(red: 104.0/255.0, green: 112.0/255.0, blue: 115.0/255.0, alpha: 1.0).cgColor
            
            self.view_time.layer.cornerRadius = 5.0
            self.view_time.layer.borderWidth = 1.0
            self.view_time.layer.borderColor = UIColor.init(red: 104.0/255.0, green: 112.0/255.0, blue: 115.0/255.0, alpha: 1.0).cgColor
            
            self.view_Time2.layer.cornerRadius = 5.0
            self.view_Time2.layer.borderWidth = 1.0
            self.view_Time2.layer.borderColor = UIColor.init(red: 104.0/255.0, green: 112.0/255.0, blue: 115.0/255.0, alpha: 1.0).cgColor
            
            self.calender.isUserInteractionEnabled = false
            self.calender.reloadData()
            
            
      
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        bool_PushComingFromAppDelegate = false
        Pushrequest_Id = NSNumber()
    }
    
    func PopToRootVC() {
        DispatchQueue.main.async {
            let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "SWRevealViewController") as!  SWRevealViewController
            Global.macros.kAppDelegate.window?.rootViewController = vc
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {

            self.scroll_View.contentSize = CGSize.init(width: self.view.frame.width, height: 1000) }

           self.tabBarController?.tabBar.isHidden = true

            self.navigationController?.setNavigationBarHidden(false, animated: false)
            self.navigationItem.setHidesBackButton(false, animated:true)
            
            self.logoButton = UIButton()
        
            self.logoButton.frame = CGRect(x:30, y: 0, width: 300, height: 60)

            self.logoButton.addTarget(self, action: #selector(self.openProfile), for: .touchUpInside)
            self.logoButton.titleLabel?.font =  UIFont(name: "Arial Rounded MT Bold", size: 16)
           self.logoButton.titleLabel?.textAlignment =  .center
           self.logoButton.contentHorizontalAlignment = .center
            self.logoButton.setTitleColor(UIColor.black, for: .normal)

            self.navigationItem.titleView = self.logoButton
            let attributes = [NSFontAttributeName:  UIFont(name: "Arial Rounded MT Bold", size: 16)]
            UINavigationBar.appearance().titleTextAttributes = attributes
            
            self.view.backgroundColor = UIColor.white
            self.scroll_View.isHidden = false
            self.setRequestData()
        
      
        
        
    }
    
    func openProfile() {
        
             var userId = NSNumber()
        
        
        //setting name
        
        if (self.Dict_Info.value(forKey: "userDTO")as! NSDictionary).value(forKey: "userId") != nil {
            
            if (self.Dict_Info.value(forKey: "userDTO")as! NSDictionary).value(forKey: "role") as? String == "COMPANY"  {
                
                userId = ((self.Dict_Info.value(forKey: "userDTO")as! NSDictionary).value(forKey: "userId") as? NSNumber)!
            }
            else if (self.Dict_Info.value(forKey: "userDTO")as! NSDictionary).value(forKey: "role") as? String == "SCHOOL"{
                
                userId = ((self.Dict_Info.value(forKey: "userDTO")as! NSDictionary).value(forKey: "userId") as? NSNumber)!
            }
                
            else{
                
                userId = ((self.Dict_Info.value(forKey: "userDTO")as! NSDictionary).value(forKey: "userId") as? NSNumber)!
            }
            
        }
        
        
        let role = (self.Dict_Info.value(forKey: "userDTO")as! NSDictionary).value(forKey: "role") as? String
        
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Button Actions
    
    
    
    @IBAction func Action_OpenProfileUsingNav(_ sender: Any) {
        self.openProfile()
    }
    
    
    @IBAction func action_OpenVideo(_ sender: UIButton) {
        
        DispatchQueue.main.async {
            
          let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "Upload_Video") as! UploadViewController
            
            
            if (self.Dict_Info.value(forKey: "userDTO")as! NSDictionary).value(forKey: "videoUrl") as? String != ""  &&  (self.Dict_Info.value(forKey: "userDTO")as! NSDictionary).value(forKey: "videoUrl") != nil {
                let str_link = (self.Dict_Info.value(forKey: "userDTO")as! NSDictionary).value(forKey: "videoUrl") as? String
                vc.video_urlProfile = NSURL(string: str_link!) as URL?

            }

            
            if vc.video_urlProfile != nil {
                
                bool_PlayFromProfile = true
               
                self.navigationController?.setNavigationBarHidden(true, animated: false)
                self.navigationItem.setHidesBackButton(true, animated:true)
                self.tabBarController?.tabBar.isHidden = true
                self.present(vc, animated: true, completion: nil)

            }
                
            else{
                self.showAlert(Message: "No video to play yet.", vc: self)
            }

        }
           }
    
    
    @IBAction func Action_Back(_ sender: Any) {
        
           }
    
    
    @IBAction func action_Accept(_ sender: UIButton) {
        
        //selected button
        self.btn_Accept.setTitleColor(UIColor.init(red: 158.0/255.0, green: 226.0/255.0, blue: 124.0/255.0, alpha: 1.0), for: .normal)
       // self.btn_Accept.backgroundColor = UIColor.lightGray
        
        //deselected button
        self.btn_Decline.setTitleColor(Global.macros.themeColor_pink, for: .normal)
       // self.btn_Decline.backgroundColor = UIColor.white
        
        self.request_AcceptReject(acceptStatus: "true", rejectStatus: "false")
        
        
        
        
    }
    
    @IBAction func action_Decline(_ sender: UIButton) {
        
        //selected button
        self.btn_Decline.setTitleColor(Global.macros.themeColor_pink, for: .normal)
      //  self.btn_Decline.backgroundColor = UIColor.lightGray
        
        
        //deselected button
        self.btn_Accept.setTitleColor(UIColor.init(red: 158.0/255.0, green: 226.0/255.0, blue: 124.0/255.0, alpha: 1.0), for: .normal)
       // self.btn_Accept.backgroundColor = UIColor.white
        
        self.request_AcceptReject(acceptStatus: "false", rejectStatus: "true")
        
    }
    
    
    @IBAction func action_OpenRatings(_ sender: UIButton) {
        
        bool_UserIdComingFromSearch = true
        //ratingview_name = self.Dict_Info.value(forKey: "userId") as? String
        
        let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "ratingView") as! RatingViewController
        vc.userIdForRating = self.Dict_Info.value(forKey: "userId") as? NSNumber

        _ = self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    //MARK: - Functions
    func setRequestData()  {
        
        let dict = NSMutableDictionary()
        let  user_Id = SavedPreferences.value(forKey: Global.macros.kUserId) as? NSNumber
        dict.setValue(user_Id, forKey: Global.macros.kUserId)
        
        if self.request_Id != nil {
        dict.setValue(self.request_Id!, forKey: "id")
        }
        else {
            dict.setValue(Pushrequest_Id!, forKey: "id")
  
        }
        print(dict)
        
        if self.checkInternetConnection(){
            
            DispatchQueue.main.async {
                self.pleaseWait()
            }
            
            Requests_API.sharedInstance.viewRequest(completionBlock: { (status, dict_Info) in
                
                DispatchQueue.main.async {
                    self.clearAllNotice()
                }
                
                switch status {
                    
                case 200:
                    
                    DispatchQueue.main.async {
                        
                        self.Dict_Info = dict_Info
                        //Set Info of request
                        //setting location
                        if dict_Info[Global.macros.klocation] != nil && dict_Info[Global.macros.klocation] as! String != "" {
                            
                            self.view_Location.isHidden = false
                            self.view_VirtualMedium.isHidden = true
                            self.lbl_Location.text = dict_Info.value(forKey: Global.macros.klocation) as? String
                            
                        }
                            //setting virtual medium
                        else if  dict_Info[Global.macros.k_mediumOfCommunication] != nil && dict_Info[Global.macros.k_mediumOfCommunication] as! String != ""{
                            
                            self.view_Location.isHidden = true
                            self.view_VirtualMedium.isHidden = false
                            
                            if dict_Info.value(forKey: Global.macros.k_mediumOfCommunication) as? String == "VideoCall" {
                                
                              self.lbl_VirtualMedium.text = "Video Call"
                                
                                
                            }
                            
                            else{
                                
                                self.lbl_VirtualMedium.text = dict_Info.value(forKey: Global.macros.k_mediumOfCommunication) as? String

                                
                            }
                            
                        }
                        
                        if dict_Info["selectedTime"] != nil{
                            let str =   dict_Info.value(forKey: "selectedTime") as? String
                            self.lbl_time.text = str
                            self.lbl_time2.text = str
                            self.view_time.isHidden = false
                           self.view_Time2.isHidden = false
                        }

                        
                        //setting message
                        if dict_Info["message"] != nil &&  dict_Info["message"] as? String != ""{
                            
                            self.lbl_TxtView_Placeholder.isHidden = true
                            self.txtView_Message.text = dict_Info.value(forKey: "message") as? String
                        }
                        else{
                            self.lbl_TxtView_Placeholder.isHidden = false
                        }
                        
                        //request status(Accepted,Rejected or pending)
                        //pending
                        if dict_Info.value(forKey: "reject") as? NSNumber == 0 &&  dict_Info.value(forKey: "accept") as? NSNumber == 0{
                            
                            self.view_Buttons.isHidden = false
                            self.btn_AcceptedRejected.isHidden = true
                            
                            
                        }
                            //(Accepted)
                        else if dict_Info.value(forKey: "reject") as? NSNumber == 0 &&  dict_Info.value(forKey: "accept") as? NSNumber == 1{
                            
                            self.view_Buttons.isHidden = true
                            self.btn_AcceptedRejected.isHidden = false
                            self.btn_AcceptedRejected.setTitle("Accepted", for: .normal)
                            self.btn_AcceptedRejected.backgroundColor = Global.macros.themeColor_Green
                        }
                            //(rejected)
                        else if dict_Info.value(forKey: "reject") as? NSNumber == 1 &&  dict_Info.value(forKey: "accept") as? NSNumber == 0{
                            
                            self.view_Buttons.isHidden = true
                            self.btn_AcceptedRejected.isHidden = false
                            self.btn_AcceptedRejected.setTitle("Rejected", for: .normal)
                            self.btn_AcceptedRejected.backgroundColor = Global.macros.themeColor_Red
                            
                        }
                        
                        //set profile image
                        let str_profileImage = (dict_Info.value(forKey: "userDTO")as! NSDictionary).value(forKey: "profileImageUrl") as? String
                        if str_profileImage != nil{
                            
                            self.imgView_UserProfile.sd_setImage(with: URL.init(string: str_profileImage!), placeholderImage: UIImage.init(named: "dummySearch"))
                            
                        }
                        
                        ratingview_imgurl = str_profileImage
                        
                        //setting ratings
                        self.lbl_RatingPersonCount.text = "\((dict_Info.value(forKey: "userDTO")as! NSDictionary).value(forKey: "ratingCount")!)"
                        
                        //setting average rating
                        let str_avgRating = ((dict_Info.value(forKey: "userDTO")as! NSDictionary).value(forKey: "avgRating") as? NSNumber)?.stringValue
                        
                        let dbl = 2.0
                        
                        if  dbl.truncatingRemainder(dividingBy: 1) == 0{
                            self.lbl_AverageRating.text = str_avgRating! + ".0"
                        }
                        else{
                            self.lbl_AverageRating.text = str_avgRating!
                        }
                        
                        //setting username
                        
                        if  (dict_Info.value(forKey: "userDTO")as! NSDictionary).value(forKey: Global.macros.krole) as? String == "USER"{
                            
                            self.logoButton.setTitle(((dict_Info.value(forKey: "userDTO")as! NSDictionary).value(forKey: "userName") as? String)?.capitalized, for: .normal)
                            
                            
                        }
                        else if (dict_Info.value(forKey: "userDTO")as! NSDictionary).value(forKey: Global.macros.krole) as? String == "SCHOOL"{
                            
                            self.logoButton.setTitle((((dict_Info.value(forKey: "userDTO")as! NSDictionary).value(forKey: "schoolDTO") as? NSDictionary)?.value(forKey: "name") as? String)?.capitalized, for: .normal)
                            
                         
                            
                        }else if (dict_Info.value(forKey: "userDTO")as! NSDictionary).value(forKey: Global.macros.krole) as? String == "COMPANY"{
                            
                           self.logoButton.setTitle((((dict_Info.value(forKey: "userDTO")as! NSDictionary).value(forKey: "companyDTO") as? NSDictionary)?.value(forKey: "name") as? String)?.capitalized, for: .normal)
                            
                            
                            
                        }
                        
                        ratingview_name = self.logoButton.currentTitle
                        
                        //setting date on calender
                        if dict_Info[Global.macros.k_SelectedDate] != nil{
                        let str_date =   dict_Info.value(forKey: Global.macros.k_SelectedDate) as? String
                        let sdate = self.formatter.date(from: str_date!)
                        self.calender.deselect(sdate!)
                        self.calender.select(sdate!, scrollToDate: true)
                        
                        }
                        
                        if My_Request_Selected_Status == false {
                            
                             self.btn_Accept.isHidden = true
                             self.btn_Decline.isHidden = true
                            
                            if dict_Info.value(forKey: "reject") as? NSNumber == 0 &&  dict_Info.value(forKey: "accept") as? NSNumber == 0 {
                                
                                //Nav buttons if coming from shadow requests(requests you send) when they are pending
                                //nav buttons
                                let btn_chat = UIButton(type: .custom)
                                btn_chat.setImage(UIImage(named: "chat-icon"), for: .normal)
                                btn_chat.frame = CGRect(x: self.view.frame.size.width - 20, y: 0, width: 20, height: 25)
                                btn_chat.addTarget(self, action: #selector(self.chatBtnPressed), for: .touchUpInside)
                                let item_chat = UIBarButtonItem(customView: btn_chat)
                                
                                let btn_Edit = UIButton(type: .custom)
                                btn_Edit.setImage(UIImage(named: "pencil-edit-button"), for: .normal)
                                btn_Edit.frame = CGRect(x: self.view.frame.size.width - 40, y: 0, width: 20, height: 25)
                                btn_Edit.addTarget(self, action: #selector(self.editBtnPressed), for: .touchUpInside)
                                let item_Edit = UIBarButtonItem(customView: btn_Edit)
                                
                                //Right items
                              //  self.navigationItem.setRightBarButtonItems([item_chat,item_Edit], animated: true)
                            }
                                //Nav buttons if coming from shadow requests(requests you send) when they are not pending
                            else{
                                //nav buttons
                                let btn_chat = UIButton(type: .custom)
                                btn_chat.setImage(UIImage(named: "chat-icon"), for: .normal)
                                btn_chat.frame = CGRect(x: self.view.frame.size.width - 20, y: 0, width: 20, height: 25)
                                btn_chat.addTarget(self, action: #selector(self.chatBtnPressed), for: .touchUpInside)
                                let item_chat = UIBarButtonItem(customView: btn_chat)
                                self.navigationItem.setRightBarButtonItems([item_chat], animated: true)
                            }
                            
                        }
                        else{
                            
                            //nav buttons
                            let btn_chat = UIButton(type: .custom)
                            btn_chat.setImage(UIImage(named: "chat-icon"), for: .normal)
                            btn_chat.frame = CGRect(x: self.view.frame.size.width - 20, y: 0, width: 20, height: 25)
                            btn_chat.addTarget(self, action: #selector(self.chatBtnPressed), for: .touchUpInside)
                            let item_chat = UIBarButtonItem(customView: btn_chat)
                         //   self.navigationItem.setRightBarButtonItems([item_chat], animated: true)
                            
                        }
                     }
                    
                    break
                    
                case 404:
                    
                    DispatchQueue.main.async {
                        self.showAlert(Message: Global.macros.kError, vc: self)

                    }
                    
                    break
                default:
                    self.showAlert(Message: Global.macros.kError, vc: self)
                    break
                    
                }
                
                
            }, errorBlock: { (error) in
                DispatchQueue.main.async {
                    self.clearAllNotice()
                    self.showAlert(Message: Global.macros.kInternetConnection, vc: self)
                }
            }, dictionary: dict)
            
            
        }else{
            
            self.showAlert(Message: Global.macros.kInternetConnection, vc: self)
        }
        
        
    }
    
    func request_AcceptReject(acceptStatus:String,rejectStatus:String) {
        
        
        let request_id = (Dict_Info).value(forKey: "id") as? NSNumber
        let dict = NSMutableDictionary()
        let  user_Id = SavedPreferences.value(forKey: Global.macros.kUserId) as? NSNumber
        dict.setValue(user_Id, forKey: Global.macros.kUserId)
        dict.setValue(request_id, forKey: Global.macros.kId)
        dict.setValue(acceptStatus, forKey: Global.macros.kAccept)
        dict.setValue(rejectStatus, forKey: Global.macros.kSmallReject)
        
        print(dict)
        if self.checkInternetConnection(){
            
            DispatchQueue.main.async {
                self.pleaseWait()
            }
            
            Requests_API.sharedInstance.requestAcceptReject(completionBlock: { (status, dict_Info) in
                DispatchQueue.main.async {
                    self.clearAllNotice()
                }
                
                switch status {
                    
                case 200:
                    
                    DispatchQueue.main.async {
                        if acceptStatus == "true"{
                            self.showAlert(Message: "Successfully accepted", vc: self)
                        }else{
                            self.showAlert(Message: "Successfully rejected.", vc: self)
                        }
                        self.setRequestData()
                    }
                    
                    break
                    
                case 404:
                    
                    DispatchQueue.main.async {
                        self.showAlert(Message: Global.macros.kError, vc: self)
                        
                    }
                    
                    break
                default:
                    self.showAlert(Message: Global.macros.kError, vc: self)
                    break
                    
                }
                
                
                
            }, errorBlock: { (error) in
                DispatchQueue.main.async {
                    self.clearAllNotice()
                    self.showAlert(Message: Global.macros.kError, vc: self)
                }
                
            }, dict: dict)
            
        }else{
            self.showAlert(Message: Global.macros.kInternetConnection, vc: self)
        }
        
    }
    
    func chatBtnPressed(sender: AnyObject){
   //     self.showAlert(Message: "Coming Soon", vc: self)
        
    }
    
    func editBtnPressed(sender: AnyObject){
        
        
        let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "send_request") as! SendRequestViewController
        vc.user_Name =  self.logoButton.currentTitle
        

            
       
        if self.request_Id != nil {
        vc.request_id_fromRequestDetail = self.request_Id!
        }
        
        else {
            vc.request_id_fromRequestDetail = Pushrequest_Id

            
        }
        vc.check_comingFromRequestDetail = "YES"
        vc.userIdFromSendRequest = Dict_Info.value(forKey: Global.macros.kotherUserId) as? NSNumber
        _ = self.navigationController?.pushViewController(vc, animated: true)
        
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
extension RequestDetailsViewController:FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance{
    
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        
        if date == calender.today
        {
            return "Today"
        }
        else{
            return nil
        }
    }
    

}
