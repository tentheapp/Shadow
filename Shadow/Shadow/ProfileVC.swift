//
//  ProfileVC.swift
//  Shadow
//
//  Created by Sahil Arora on 5/31/17.
//  Copyright © 2017 Atinderjit Kaur. All rights reserved.


import UIKit



var bool_PlayFromProfile :      Bool?
var bool_VideoIsOfShortLength : Bool = false

public var bool_UserIdComingFromSearch :   Bool? = false//When we come from search screen
public var dic_DataOfProfileForOtherUser : NSMutableDictionary = NSMutableDictionary()
public var array_public_UserSocialSites =  [[String:Any]]()
var verifiedByAdminLoginUser : String? = ""


class ProfileVC: UIViewController, UIGestureRecognizerDelegate,SWRevealViewControllerDelegate   {
    
    @IBOutlet weak var kLeadingShadowbtn:    NSLayoutConstraint!
    @IBOutlet weak var kLeadingShadowIcon:   NSLayoutConstraint!
    @IBOutlet weak var btn_ShadowList:       UIButton!
    @IBOutlet weak var view_OnScrollView:    UIView!
    @IBOutlet weak var kDescripHeight:       NSLayoutConstraint!
    @IBOutlet weak var kcompanybtn:          NSLayoutConstraint!
    @IBOutlet weak var kCompanyImage:        NSLayoutConstraint!
    @IBOutlet weak var kCompanylbl:          NSLayoutConstraint!
    //Outlets for company objects
    @IBOutlet weak var k_topSchoolButton:    NSLayoutConstraint!
    @IBOutlet var btn_OverSchool:            UIButton!
    @IBOutlet var btn_overCompany:           UIButton!
    @IBOutlet var imgView_Company:           UIImageView!
    @IBOutlet var imgView_School:            UIImageView!
    @IBOutlet var k_Constraint_ViewDescHeight:     NSLayoutConstraint!
    @IBOutlet var k_Constraint_TopImageViewSchool: NSLayoutConstraint!
    @IBOutlet var k_Constraint_TopLblSchool:       NSLayoutConstraint!
    @IBOutlet var lbl_RatingCount:           UILabel!
    @IBOutlet var menu_btn:                  UIBarButtonItem!
    @IBOutlet weak var lbl_Placeholder:      UILabel!
    @IBOutlet var btn_VideoIcon:             UIButton!
    @IBOutlet var collectionView_Skills:     UICollectionView!
    @IBOutlet var lbl_shadowedTo:            UILabel!
    @IBOutlet var lbl_ShadowedBy:            UILabel!
    @IBOutlet var lbl_School:                UILabel!
    @IBOutlet var lbl_ProfileName:           UILabel!
    @IBOutlet var imageView_ProfilePic:      UIImageView!
    @IBOutlet var scrollbar:                 UIScrollView!
    @IBOutlet var lbl_Company:               UILabel!
    @IBOutlet var collectionView_Interests:  UICollectionView!
    @IBOutlet var lbl_NoOccupationsYet:      UILabel!
    @IBOutlet var lbl_NoInterestsYet:        UILabel!
    @IBOutlet var btn_SocialSite1:           UIButton!
    @IBOutlet var btn_SocialSite2:           UIButton!
    @IBOutlet var btn_SocialSite3:           UIButton!
    @IBOutlet weak var view_BehindImageView: UIView!
    @IBOutlet weak var view_BehindNumValues: UIView!
    @IBOutlet weak var view_BehindOccupation:UIView!
    @IBOutlet weak var view_BehindInterest:  UIView!
    @IBOutlet weak var view_BehindDescription:  UIView!
    @IBOutlet var tblView_SocialSites:        UITableView!
    @IBOutlet var k_Constraint_tblViewTop:    NSLayoutConstraint!
    @IBOutlet var k_Constraint_Height_TableView: NSLayoutConstraint!
    @IBOutlet var txtView_Description:        UILabel!
    @IBOutlet weak var lbl_NoOfRating:        UILabel!
    @IBOutlet weak var kheightViewBehindInterest:           NSLayoutConstraint!
    @IBOutlet weak var kheightViewBehindSkill:              NSLayoutConstraint!
    @IBOutlet weak var kheightCollectionViewOccupation:     NSLayoutConstraint!
    @IBOutlet weak var kheightCollectionViewInterestHeight: NSLayoutConstraint!
    var check_for_previousview :                            String?
    var userIdFromSearch :                                  NSNumber?
    var myview =                                            UIView()
    
    var imageView1 :         UIImageView?
    var imageView2 :         UIImageView?
    var imageView3 :         UIImageView?
    var imageView4 :         UIImageView?
    var imageView5 :         UIImageView?
    var linkForOpenWebsite : String?
    var rating_number  :     String?
    var user_IdMyProfile :   NSNumber?
    var sidebarMenuOpen :    Bool = false
    
    var nameForRating :      String? = ""
    
    var dicUrl: NSMutableDictionary = NSMutableDictionary()
    let array_URL = ["facebookUrl","linkedInUrl","instagramUrl","googlePlusUrl","gitHubUrl","twitterUrl"]
    
    var userIdFromList :     NSNumber? //For listing class
    var video_url :          URL?
    var  str_UserName : String? = ""
    
    fileprivate var array_ActualSocialSites = [
        ["name":"Facebook","name_url":"facebookUrl","image":UIImage(named: "facebookUrl")!],
        ["name":"LinkedIn","name_url":"linkedInUrl","image":UIImage(named: "linkedInUrl")!],
        ["name":"Twitter","name_url":"twitterUrl","image":UIImage(named: "twitterUrl")!],
        ["name":"gitHub","name_url":"gitHubUrl","image":UIImage(named: "gitHubUrl")!],
        ["name":"Google+","name_url":"googlePlusUrl","image":UIImage(named: "googlePlusUrl")!],
        ["name":"Instagram","name_url":"instagramUrl","image":UIImage(named: "instagramUrl")!]]
    
    
    //Array that stores actual list of skills
    fileprivate var array_UserSkills:NSMutableArray =  NSMutableArray()
    fileprivate var array_UserInterests:NSMutableArray = NSMutableArray()
    @IBOutlet weak var kheightShadowBtn: NSLayoutConstraint!
    @IBOutlet weak var kwidthShadowBtn: NSLayoutConstraint!
    
    @IBOutlet weak var ktopCalenderIcon: NSLayoutConstraint!
    //chat
    @IBOutlet weak var ktopShadowTextt: NSLayoutConstraint!
    var qb_id :       String?
    var img_profile : UIImage?
    var img_url :     String?
    
    var arr_Dialogs = Set<String>()
    var dialog_Chat : String? = ""
    var count_unreadMessage : UInt?
    var label : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        
        DispatchQueue.main.async {
            
            if Global.DeviceType.IS_IPHONE_6P  {
                
                self.kLeadingShadowbtn.constant = 20
                self.kLeadingShadowIcon.constant = 32
               
            }
            
            else if Global.DeviceType.IS_IPHONE_X || Global.DeviceType.IS_IPHONE_6 {
                
                self.kheightShadowBtn.constant = 34
                self.kLeadingShadowbtn.constant = 12
                self.kLeadingShadowIcon.constant = 22
                self.kwidthShadowBtn.constant = 97
                 self.ktopCalenderIcon.constant  = 27
                self.ktopShadowTextt.constant  = 27

            }
      
            
            self.imageView_ProfilePic.layer.cornerRadius = 60.0
            self.imageView_ProfilePic.clipsToBounds = true
            
            self.customView(view: self.view_BehindImageView)
            self.customView(view: self.view_BehindNumValues)
            self.customView(view: self.view_BehindOccupation)
            self.customView(view: self.view_BehindInterest)
            self.customView(view: self.view_BehindDescription)
           
            
            self.btn_ShadowList.layer.cornerRadius = 8.0
            self.btn_ShadowList.clipsToBounds = true
            //contentView.layer.borderWidth = 1.0
            
            if bool_PushComingFromAppDelegate == true {
                
             if  dict_notificationData.value(forKey: "chatDialogId") == nil{
                
                
                if dict_notificationData.value(forKey: "requestType") as! String == "Accept" || dict_notificationData.value(forKey: "requestType") as! String == "Send" || dict_notificationData.value(forKey: "requestType") as! String == "Update" || dict_notificationData.value(forKey: "requestType") as! String == "Reject"  {
                    
                    let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "Request_Details") as! RequestDetailsViewController
                    vc.username =  self.navigationItem.title
                    vc.request_Id = dict_notificationData.value(forKey: "requestId") as? NSNumber
                    _ = self.navigationController?.pushViewController(vc, animated: true)
                    
                }


                else  if dict_notificationData.value(forKey: "requestType") as! String == "Rating"  || dict_notificationData.value(forKey: "requestType") as! String == "rating" {
                    
                    let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "ratingView") as! RatingViewController
                    _ = self.navigationController?.pushViewController(vc, animated: true)
                    
                }
      
            }
         
                
             else if  dict_notificationData.value(forKey: "dialog_id") != nil {
                
                let str = "\(dict_notificationData.value(forKey: "dialog_id")!)"
                let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
                vc.str_DialogId = str
                _ = self.navigationController?.pushViewController(vc, animated: true)
                
             }
                
             else if  dict_notificationData.value(forKey: "chatDialogId") != nil {
                
                let str = "\(dict_notificationData.value(forKey: "chatDialogId")!)"
                let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
                vc.str_DialogId = str
                _ = self.navigationController?.pushViewController(vc, animated: true)
                
                }
            }
            
        }
        
        if bool_FirstTimeLogin == true {
            
            bool_FirstTimeLogin = false
            
            if bool_ComingFromList == false && bool_FromOccupation == false && bool_UserIdComingFromSearch == false {
                
         
                self.user_IdMyProfile = SavedPreferences.value(forKey: Global.macros.kUserId) as? NSNumber
                self.menu_btn.tintColor = UIColor.init(red: 242.0/255.0, green: 105.0/255.0, blue: 78.0/255.0, alpha: 1.0)
                self.menu_btn.isEnabled = true
                
                let btn1 = UIButton(type: .custom)
                btn1.setImage(UIImage(named: "orangechat"), for: .normal)
                btn1.frame = CGRect(x: self.view.frame.size.width - 25, y: 0, width: 20, height: 25)
                btn1.addTarget(self, action: #selector(self.chatBtnPressed), for: .touchUpInside)
                let item1 = UIBarButtonItem(customView: btn1)
                
                self.navigationItem.setRightBarButton(item1, animated: true)
                self.GetUserProfile()
                
               
            }
        }
        
        // Do any additional setup after loading the view.
        
    }
    
    func getunreadcountMessages() {
        
       
        
        let extendedRequest = ["sort_desc" : "last_message_date_sent"]
        
        let page = QBResponsePage(limit: 1000, skip: 0)
        
        QBRequest.dialogs(for: page, extendedRequest: extendedRequest, successBlock: { (response: QBResponse, dialogs: [QBChatDialog]?, dialogsUsersIDs: Set<NSNumber>?, page: QBResponsePage?) -> Void in
            
            for (_, value) in (dialogs?.enumerated())! {
                let dialog : QBChatDialog! = value
                
                self.dialog_Chat = dialog.id
                
                if dialog.lastMessageDate != nil {
                    
                    self.arr_Dialogs.insert(self.dialog_Chat!)
                    
                }
            }
            
            
            QBRequest.totalUnreadMessageCountForDialogs(withIDs: self.arr_Dialogs, successBlock: { (response: QBResponse, count : UInt, _: [String : Any]?) in
          
                print(count)
                self.count_unreadMessage = count
                
                if self.label != nil {
                    DispatchQueue.main.async {
                        
                        if  self.count_unreadMessage! > 0 {
                            self.label.isHidden = false
                       self.label.text = "\(self.count_unreadMessage!)"
                        }
                        else{
                            
                             self.label.isHidden = true
                        }
                    }
                    
                   
                    }
                
                
            }, errorBlock: { (QBResponse) in
               
            })
            
         
        }) { (response: QBResponse) -> Void in
           
        }
        
    }
    
    
    func revealController(_ revealController: SWRevealViewController!, didMoveTo position: FrontViewPosition) {
        
        switch position {
            
        case FrontViewPosition.leftSideMostRemoved:
            print("LeftSideMostRemoved")
            // Left most position, front view is presented left-offseted by rightViewRevealWidth+rigthViewRevealOverdraw
            
        case FrontViewPosition.leftSideMost:
            print("LeftSideMost")
            // Left position, front view is presented left-offseted by rightViewRevealWidth
            
        case FrontViewPosition.leftSide:
            print("LeftSide")
            
        // Center position, rear view is hidden behind front controller
        case FrontViewPosition.left:
            print("Left")
            //Closed
            //0 rotation
            myview.removeFromSuperview()
            
            
            
        // Right possition, front view is presented right-offseted by rearViewRevealWidth
        case FrontViewPosition.right:
            print("Right")
            revealViewController().frontViewController.view.addSubview(myview)
            
            
            
            // Right most possition, front view is presented right-offseted by rearViewRevealWidth+rearViewRevealOverdraw
            
        case FrontViewPosition.rightMost:
            print("RightMost")
            
        case FrontViewPosition.rightMostRemoved:
            print("RightMostRemoved")
            
        }
        
    }
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        bool_OpenProfile = true
        
        NotificationCenter.default.addObserver( self,selector: #selector(self.getunreadcountMessages),name: Notification.Name("ProfileVCOpened"), object: nil)
        
        if !QBChat.instance().isConnected {
            
            QBRequest.logIn(withUserLogin: SavedPreferences.value(forKey: "email") as! String, password: "mind@123", successBlock: { (response, user) in
                
                SavedPreferences.setValue(user?.id, forKey: "qb_UserId")
                
                            QBChat.instance().connect(with: user!, completion: { (error) in
                                print("Successful connected")
                            })
                
                
            }, errorBlock: { (response) in
                print("login")
                print("error: \(String(describing: response.error))")
            })
        }
        
        
        
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
            //self.title = "Admin"
            
        }
        
        self.view.backgroundColor = UIColor.init(red: 248.0/255.0, green: 250.0/255.0, blue: 251.0/255.0, alpha: 1.0)
        self.scrollbar.isHidden = false
        
        
        if self.revealViewController() != nil {
            
            self.revealViewController().delegate = self
            self.menu_btn.target = self.revealViewController()
            self.menu_btn.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
            
            myview.frame = CGRect(x: UIScreen.main.bounds.origin.x, y: self.view.frame.origin.y, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.height)
            
            let revealController: SWRevealViewController? = revealViewController()
            let tap: UITapGestureRecognizer? = revealController?.tapGestureRecognizer()
            tap?.delegate = self
            myview.addGestureRecognizer(tap!)

        }
        
        
        self.tabBarController?.delegate = self
        
        
        //  bool_Occupation = false
        bool_VideoFromGallary = false
        
        
        DispatchQueue.main.async {
            self.txtView_Description.frame.size.height = self.txtView_Description.intrinsicContentSize.height
        }
        
        self.navigationController?.navigationBar.isTranslucent = false
        
        if bool_UserIdComingFromSearch == true {
            
            DispatchQueue.main.async {
                
                if self.revealViewController() != nil {
                    
                    self.revealViewController().panGestureRecognizer().isEnabled = false
                    self.revealViewController().tapGestureRecognizer().isEnabled = false
                    
                }
                
                self.tabBarController?.tabBar.isHidden = true
                self.tabBarController?.tabBar.isTranslucent = true
                
                
                self.navigationController?.setNavigationBarHidden(false, animated: false)
                self.view.endEditing(true)
                self.CreateNavigationBackBarButton() //Create custom back button
                
                
                // self.scrollbar.contentInset = UIEdgeInsetsMake(44,0,0,0);
                self.automaticallyAdjustsScrollViewInsets = false
                //self.scrollbar.setContentOffset(CGPoint.init(x: 0, y: -44), animated: false)
                
                
                
                if self.user_IdMyProfile == nil {
                    
                    self.user_IdMyProfile = self.userIdFromSearch
                    
                    
                }
                
                if self.user_IdMyProfile != SavedPreferences.value(forKey: Global.macros.kUserId) as? NSNumber {
                    
                    
                    let btn2 = UIButton(type: .custom)
                    btn2.setImage(UIImage(named: "orangechat"), for: .normal)
                    btn2.frame = CGRect(x: self.view.frame.size.width - 83, y: 0, width: 28, height: 28)
                    btn2.addTarget(self, action: #selector(self.chatBtnPressed), for: .touchUpInside)
                    let item2 = UIBarButtonItem(customView: btn2)
                    
                    self.navigationItem.setRightBarButton(item2, animated: true)
                    
                }
                    
                else {
                    self.btn_ShadowList.isHidden = true
                }
                
                   self.GetUserProfile()
                
            }
        }
        else if bool_ComingFromList == true {
            
            DispatchQueue.main.async {
                
                
                if self.revealViewController() != nil {
                    
                    self.revealViewController().panGestureRecognizer().isEnabled = false
                    self.revealViewController().tapGestureRecognizer().isEnabled = false
                    
                }
                
                self.tabBarController?.tabBar.isHidden = true
                self.tabBarController?.tabBar.isTranslucent = true
                
                
                if self.user_IdMyProfile == nil {
                    
                    self.user_IdMyProfile = self.userIdFromList
                    
                }
                
                self.navigationController?.setNavigationBarHidden(false, animated: false)
                self.view.endEditing(true)
                self.CreateNavigationBackBarButton() //Create custom back button
                
           
                if self.user_IdMyProfile != SavedPreferences.value(forKey: Global.macros.kUserId) as? NSNumber {
                    let btn2 = UIButton(type: .custom)
                    btn2.setImage(UIImage(named: "orangechat"), for: .normal)
                    btn2.frame = CGRect(x: self.view.frame.size.width - 83, y: 0, width: 28, height: 28)
                    btn2.addTarget(self, action: #selector(self.chatBtnPressed), for: .touchUpInside)
                    let item2 = UIBarButtonItem(customView: btn2)
                    
                    self.navigationItem.setRightBarButton(item2, animated: true)
                    
                }
                    
                else {
                    self.btn_ShadowList.isHidden = true
                }
                
                
                self.GetUserProfile()
                bool_ComingFromList = false
            }
            
        }
        else {
            
            DispatchQueue.main.async {
                
                if self.revealViewController() != nil {
                    
                    self.revealViewController().panGestureRecognizer().isEnabled = true
                    self.revealViewController().tapGestureRecognizer().isEnabled = true
                    
                }
            
                
                if self.user_IdMyProfile != nil {
                    
                    if self.user_IdMyProfile == SavedPreferences.value(forKey: Global.macros.kUserId) as? NSNumber {
                        
                        let array = self.navigationController?.viewControllers
                        
                        print(array!)
                        
                        if (array?.count)! <= 1
                        {
                            self.tabBarController?.tabBar.isHidden = false
                            self.menu_btn.tintColor = UIColor.init(red: 242.0/255.0, green: 105.0/255.0, blue: 78.0/255.0, alpha: 1.0)
                            self.menu_btn.isEnabled = true
                            self.tabBarController?.tabBar.isHidden = false
                            self.tabBarController?.tabBar.isTranslucent = false
                            
                            
                            // badge label
                            self.label = UILabel(frame: CGRect(x: 10, y: -9, width: 20, height: 20))
                            self.label.layer.borderColor = UIColor.clear.cgColor
                            self.label.layer.borderWidth = 2
                            self.label.layer.cornerRadius = self.label.bounds.size.height / 2
                            self.label.textAlignment = .center
                            self.label.layer.masksToBounds = true
                            self.label.textColor = .white
                            self.label.backgroundColor = UIColor.init(red: 125.0/255.0, green: 208.0/255.0, blue: 244.0/255.0, alpha: 1.0)
                            self.label.font = UIFont(name: "SanFranciscoText-Light", size: 5)

                            
                            let btn2 = UIButton(type: .custom)
                            btn2.setImage(UIImage(named: "orangechat"), for: .normal)
                            btn2.frame = CGRect(x: self.view.frame.size.width - 80, y: 0, width: 25, height: 25)
                            btn2.addTarget(self, action: #selector(self.chatBtnPressed), for: .touchUpInside)
                            btn2.addSubview(self.label)
                            self.label.isHidden = true

                            let item2 = UIBarButtonItem(customView: btn2)
                            self.navigationItem.setRightBarButton(item2, animated: true)

                            
                        }
                            
                        else
                        {
                            self.tabBarController?.tabBar.isHidden = true
                            self.menu_btn.tintColor = UIColor.clear
                            self.menu_btn.isEnabled = false
                            self.tabBarController?.tabBar.isHidden = true
                            self.tabBarController?.tabBar.isTranslucent = true
                            self.CreateNavigationBackBarButton()
                            
                        }
                        
                        if bool_FirstTimeLogin != false {
                            self.GetUserProfile() }
                        
                    }
                        
                    else{
                        
                        self.menu_btn.tintColor = UIColor.clear
                        self.menu_btn.isEnabled = false
                        self.tabBarController?.tabBar.isHidden = true
                        self.tabBarController?.tabBar.isTranslucent = true
                        self.CreateNavigationBackBarButton()
                        
                        
                        if self.user_IdMyProfile != SavedPreferences.value(forKey: Global.macros.kUserId) as? NSNumber {
                            
                            // badge label
                            let btn2 = UIButton(type: .custom)
                            btn2.setImage(UIImage(named: "orangechat"), for: .normal)
                            btn2.frame = CGRect(x: self.view.frame.size.width - 80, y: 0, width: 25, height: 25)
                            btn2.addTarget(self, action: #selector(self.chatBtnPressed), for: .touchUpInside)
                            let item2 = UIBarButtonItem(customView: btn2)
                            self.navigationItem.setRightBarButton(item2, animated: true)
                        }
                        
                        self.GetUserProfile()
                    }
                    
                }  else {
                    
                    self.user_IdMyProfile = SavedPreferences.value(forKey: Global.macros.kUserId) as? NSNumber
                    self.menu_btn.tintColor = UIColor.init(red: 242.0/255.0, green: 105.0/255.0, blue: 78.0/255.0, alpha: 1.0)
                    self.menu_btn.isEnabled = true
                    
                    // badge label
                    self.label = UILabel(frame: CGRect(x: 10, y: -9, width: 20, height: 20))
                    self.label.layer.borderColor = UIColor.clear.cgColor
                    self.label.layer.borderWidth = 2
                    self.label.layer.cornerRadius = self.label.bounds.size.height / 2
                    self.label.textAlignment = .center
                    self.label.layer.masksToBounds = true
                    self.label.textColor = .white
                    self.label.backgroundColor = UIColor.init(red: 125.0/255.0, green: 208.0/255.0, blue: 244.0/255.0, alpha: 1.0)
                    self.label.font = UIFont(name: "SanFranciscoText-Light", size: 5)
                    
                    let btn2 = UIButton(type: .custom)
                    btn2.setImage(UIImage(named: "orangechat"), for: .normal)
                    btn2.frame = CGRect(x: self.view.frame.size.width - 80, y: 0, width: 25, height: 25)
                    btn2.addTarget(self, action: #selector(self.chatBtnPressed), for: .touchUpInside)
                    btn2.addSubview(self.label)
                    self.label.isHidden = true

                    
                    let item2 = UIBarButtonItem(customView: btn2)
                    self.navigationItem.setRightBarButton(item2, animated: true)
                    self.GetUserProfile()
                    
                }
            }
        }
        
        DispatchQueue.global(qos: .background).async {
            self.getunreadcountMessages()
        }
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        
        DispatchQueue.main.async {
            
            self.navigationController?.setNavigationBarHidden(false, animated: false)
            self.navigationItem.setHidesBackButton(false, animated:true)
            
            bool_ComingFromList = false
            self.dicUrl.removeAllObjects()
            ratingview_ratingNumber = ""
            bool_ComingRatingList = false
            self.myview.removeFromSuperview()
            bool_OpenProfile = false
              NotificationCenter.default.removeObserver(self)
            
        }
    }
    
    
    //MARK: - Functions
    
    func GetUserProfile() //ratingCount
    {
        let dict =  NSMutableDictionary()
        dict.setValue(SavedPreferences.value(forKey: Global.macros.kUserId) as? NSNumber, forKey: Global.macros.kUserId)
        dict.setValue(user_IdMyProfile, forKey:Global.macros.kotherUserId)
        
        
        if self.checkInternetConnection()
        {
            DispatchQueue.main.async {
                self.pleaseWait()
            }
            
            ProfileAPI.sharedInstance.RetrieveUserProfile(dict: dict, completion: { (response) in
                
                switch response.0
                {
                case 200 :
                    DispatchQueue.main.async {
                        
                        if self.user_IdMyProfile == SavedPreferences.value(forKey: Global.macros.kUserId) as? NSNumber {
                        
                            dictionary_user_Info = response.1
                        
                        }
                        
                        let shadow_Status = (response.1).value(forKey: "otherUsersShadowYou") as? NSNumber
                        SavedPreferences.set(shadow_Status, forKey: Global.macros.kotherUsersShadowYou)
                        
                    if bool_ComingFromList == false && bool_UserIdComingFromSearch == false && self.user_IdMyProfile == SavedPreferences.value(forKey: Global.macros.kUserId) as? NSNumber {
                        
                                            let verified = (response.1).value(forKey: "emailVerified")! as? NSNumber
                        
                                            if verified == 0 {
                        
                                                let deviceIdentifier: String = UIDevice.current.identifierForVendor!.uuidString
                                                
                                                QBRequest.unregisterSubscription(forUniqueDeviceIdentifier: deviceIdentifier, successBlock: { (QBResponse) in
                                                    
                                                    
                                                    self.logout()
                                                    
                                                }, errorBlock: {(err) in
                                                    DispatchQueue.main.async {
                                                        self.clearAllNotice()
                                                        
                                                    }
                                                    
                                                    self.logout()
                                                    
                                                })
                                            }
                                                
                                            }
                        
                        self.lbl_shadowedTo.text = (((response.1).value(forKey: "shadowersVerified") as? NSDictionary)?.value(forKey: Global.macros.kcount) as? NSNumber)?.stringValue
                        self.lbl_ShadowedBy.text = (((response.1).value(forKey: "shadowedByShadowUser") as? NSDictionary)?.value(forKey: Global.macros.kcount) as? NSNumber)?.stringValue
                        
                        
                        if (response.1).value(forKey: "qbId") != nil && (response.1).value(forKey: "qbId") as! String != ""  {
                            self.qb_id = (response.1).value(forKey: "qbId") as? String
                            print(self.qb_id!)
                        }
                        
                        self.lbl_NoOfRating.text = "\((response.1).value(forKey: "ratingCount")!)"
                        roleForShowingLoc = (response.1).value(forKey: "role") as? String
                        
                        array_public_UserSocialSites.removeAll()
                        //getting social sites urls from response
                        for v in self.array_ActualSocialSites
                        {
                            let value = v["name_url"] as? String
                            if (response.1[value!] != nil && response.1.value(forKey: value!) as? String != "")
                            {
                                
                                var dic = v
                                dic["url"] = (response.1).value(forKey: value!)!
                                array_public_UserSocialSites.append(dic)
                                
                            }
                        }
                        
                        print(array_public_UserSocialSites)
                        
                        
                        self.rating_number = "\((response.1).value(forKey: "avgRating")!)"
                        
//                        if self.user_IdMyProfile == SavedPreferences.value(forKey: Global.macros.kUserId) as? NSNumber {
//                         verifiedByAdminLoginUser = "\((response.1).value(forKey: "verifiedByAdmin")!)"
//                        }
//                        else{
//
//                          self.verifiedByAdmin  = "\((response.1).value(forKey: "verifiedByAdmin")!)"
//                        }
                        
                        
                        let dbl = 2.0
                        
                        if  dbl.truncatingRemainder(dividingBy: 1) == 0
                        {
                            self.lbl_RatingCount.text = self.rating_number! + ".0"
                            
                        }
                        else {
                            
                            self.lbl_RatingCount.text = self.rating_number!
                            
                        }
                        
                        ratingview_name = (response.1).value(forKey: Global.macros.kUserName) as? String
                        self.navigationItem.title = (((response.1).value(forKey: Global.macros.kUserName) as? String)?.capitalized)!
                        self.str_UserName = (response.1).value(forKey: Global.macros.kUserName) as? String
                        //profileImageUrl
                        
                        if self.user_IdMyProfile != SavedPreferences.value(forKey: Global.macros.kUserId) as? NSNumber {
                        var profileurl = (response.1).value(forKey: "profileImageUrl")as? String
                        profileurl = profileurl?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                        ratingview_imgurl = profileurl?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                            
                            if profileurl != nil {
                                self.imageView_ProfilePic.sd_setImage(with: URL(string:profileurl!), placeholderImage: UIImage(named: "profile-icon-1"))//image
                                self.img_url = profileurl
                                
                            }
                        }
                        else {
                            
                            
                            var profileurl = (response.1).value(forKey: "profileImageUrl")as? String
                            profileurl = profileurl?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                            ratingview_imgurlProfile = profileurl?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                            
                            if profileurl != nil {
                                self.imageView_ProfilePic.sd_setImage(with: URL(string:profileurl!), placeholderImage: UIImage(named: "profile-icon-1"))//image
                                
                                self.img_url = profileurl
                                
                            }

                        }
                        
                        let str =  (response.1).value(forKey: "videoUrl") as? String
                        
                        if str != nil {
                            self.video_url = NSURL(string: str!) as URL?
                        }
                        else{
                            self.video_url = nil
                        }
                        let str_bio = (response.1).value(forKey: Global.macros.kbio) as? String

                        //setting description
                        if (response.1).value(forKey: Global.macros.kbio)  != nil && (response.1).value(forKey: Global.macros.kbio) as? String != "" {
                            DispatchQueue.main.async {
                                
                                self.txtView_Description.frame.size.height = self.txtView_Description.intrinsicContentSize.height
                                self.txtView_Description.text = "\((response.1).value(forKey: Global.macros.kbio) as! String)"
                                
                            }
                            
                            self.lbl_Placeholder.isHidden = true
                            
                        }
                        
                        else {
                            DispatchQueue.main.async {
                                
                                self.txtView_Description.frame.size.height = self.txtView_Description.intrinsicContentSize.height
                                
                            }
                            
                        }
                    
                     
                        
                        
                     
                        
                        //setting company name
                        if (response.1).value(forKey: "companyName")as? String != ""  &&  (response.1).value(forKey: "companyName") != nil && (response.1).value(forKey: "companyName")as? String != " " {
                            
                            self.lbl_Company.text = ((response.1).value(forKey: "companyName")as? String)?.capitalized
                        }
                        
                        
                        //setting school name
                        if (response.1).value(forKey: "schoolName")as? String != "" &&  (response.1).value(forKey: "schoolName") != nil  && (response.1).value(forKey: "schoolName")as? String != " "{
                            
                            self.lbl_School.text = ((response.1).value(forKey: "schoolName")as? String)?.capitalized
                        }
                        
                        //setting constraints
                        //if company is not nil
                        if (response.1).value(forKey: "companyName")as? String != ""  &&  (response.1).value(forKey: "companyName") != nil && (response.1).value(forKey: "companyName")as? String != " " {
                            
                            self.lbl_Company.isHidden = false
                            self.imgView_Company.isHidden = false
                            self.btn_overCompany.isUserInteractionEnabled = true
                            
                            
                            if (response.1).value(forKey: "schoolName")as? String != "" &&  (response.1).value(forKey: "schoolName") != nil && (response.1).value(forKey: "schoolName")as? String != " "{
                                
                                self.lbl_School.isHidden = false
                                self.imgView_School.isHidden = false
                                self.btn_OverSchool.isUserInteractionEnabled = true
                                DispatchQueue.main.async {
                                    
                                    self.kcompanybtn.constant = 8.0
                                    self.kCompanylbl.constant = 8.0
                                    self.kCompanyImage.constant = 13.0
                                    self.k_Constraint_tblViewTop.constant = 0.0
                                    
                                }
                                
                                if array_public_UserSocialSites.count > 0 {
                                    DispatchQueue.main.async {
                                        
                                        self.tblView_SocialSites.isHidden = false
                                    }
                                    if array_public_UserSocialSites.count == 1 {//social site count 1
                                        
                                        DispatchQueue.main.async {
                                            self.tblView_SocialSites.reloadData()
                                            self.k_Constraint_Height_TableView.constant = 50.0
                                            self.k_Constraint_ViewDescHeight.constant = self.txtView_Description.intrinsicContentSize.height +  self.k_Constraint_Height_TableView.constant + 75
                                            
                                        }
                                    }
                                        
                                        
                                    else  if array_public_UserSocialSites.count == 2{//social site count 2
                                        
                                        DispatchQueue.main.async {
                                            self.tblView_SocialSites.reloadData()
                                            
                                            self.k_Constraint_Height_TableView.constant = 100.0
                                            self.k_Constraint_ViewDescHeight.constant = self.txtView_Description.intrinsicContentSize.height +  self.k_Constraint_Height_TableView.constant + 52
                                            
                                        }
                                    }
                                        
                                    else{//social site count 3
                                        DispatchQueue.main.async {
                                            self.tblView_SocialSites.reloadData()
                                            self.k_Constraint_Height_TableView.constant = 150.0
                                            self.k_Constraint_ViewDescHeight.constant = self.txtView_Description.intrinsicContentSize.height +  self.k_Constraint_Height_TableView.constant + 32
                                            
                                        }
                                        
                                        
                                    }
                                    
                                }else {
                                    DispatchQueue.main.async {
                                        self.tblView_SocialSites.reloadData()
                                        
                                        self.tblView_SocialSites.isHidden = true
                                        self.k_Constraint_ViewDescHeight.constant = self.txtView_Description.intrinsicContentSize.height + 102
                                        
                                    }
                                    
                                }
                                
                            }
                            else{

                                DispatchQueue.main.async {
                                    
                                    self.lbl_School.isHidden = true
                                    self.imgView_School.isHidden = true
                                    self.btn_OverSchool.isUserInteractionEnabled = false
                                    self.kcompanybtn.constant = 6.0
                                    self.kCompanylbl.constant = 6.0
                                    self.kCompanyImage.constant = 8.0
                                    
                                    
                                }
                                
                                
                                if array_public_UserSocialSites.count > 0 {//social site nil
                                    
                                    DispatchQueue.main.async {
                                        self.tblView_SocialSites.isHidden = false
                                        self.k_Constraint_tblViewTop.constant = -25.0
                                    }
                                    if array_public_UserSocialSites.count == 1 {//social site count 1
                                        
                                        DispatchQueue.main.async {
                                            
                                            self.tblView_SocialSites.reloadData()
                                            self.k_Constraint_Height_TableView.constant = 50.0
                                            self.k_Constraint_ViewDescHeight.constant = self.txtView_Description.intrinsicContentSize.height +  self.k_Constraint_Height_TableView.constant + 46
                                            
                                        }

                                    }
                                        
                                    else  if array_public_UserSocialSites.count == 2{//social site count 2
                                        
                                        DispatchQueue.main.async {
                                            self.tblView_SocialSites.reloadData()
                                            self.k_Constraint_Height_TableView.constant = 100.0
                                            self.k_Constraint_ViewDescHeight.constant = self.txtView_Description.intrinsicContentSize.height +  self.k_Constraint_Height_TableView.constant + 26
                                            
                                        }
                                    }
                                    else{//social site count 3
                                        DispatchQueue.main.async {
                                            self.tblView_SocialSites.reloadData()
                                            self.k_Constraint_Height_TableView.constant = 150.0
                                            self.k_Constraint_ViewDescHeight.constant = self.txtView_Description.intrinsicContentSize.height +  self.k_Constraint_Height_TableView.constant + 5
                                            
                                        }
                                        
                                    }
                                    
                                }
                                else{//social site nil
                                    
                                    DispatchQueue.main.async {
                                        
                                        self.tblView_SocialSites.reloadData()
                                        self.tblView_SocialSites.isHidden = true
                                        self.k_Constraint_ViewDescHeight.constant = self.txtView_Description.intrinsicContentSize.height + 70
                                        
                                    }
                                    
                                }
                            }
                            
                        }
                        else{//if company is nil
                            DispatchQueue.main.async {
                                
                                self.lbl_Company.isHidden = true
                                self.imgView_Company.isHidden = true
                                self.btn_overCompany.isUserInteractionEnabled = false
                            }
                            
                            if (response.1).value(forKey: "schoolName")as? String != "" &&  (response.1).value(forKey: "schoolName") != nil &&  (response.1).value(forKey: "schoolName")as? String != " " {
                                
                                DispatchQueue.main.async {
                                    
                                    self.lbl_School.isHidden = false
                                    self.imgView_School.isHidden = false
                                    self.k_Constraint_TopLblSchool.constant = -35
                                    self.k_Constraint_TopImageViewSchool.constant = -29
                                    self.k_topSchoolButton.constant = -35
                                    self.btn_OverSchool.isUserInteractionEnabled = true
                                    
                                }
                                
                                if array_public_UserSocialSites.count > 0 { //social site not nil
                                    DispatchQueue.main.async {
                                        
                                        self.k_Constraint_tblViewTop.constant = 2.0
                                        self.tblView_SocialSites.isHidden = false
                                    }
                                    
                                    if array_public_UserSocialSites.count == 1 { //social site count 1
                                        DispatchQueue.main.async {
                                            
                                            self.k_Constraint_Height_TableView.constant = 50.0
                                            self.k_Constraint_ViewDescHeight.constant = self.txtView_Description.intrinsicContentSize.height +  self.k_Constraint_Height_TableView.constant + 49
                                        }
                                    }
                                        
                                    else if array_public_UserSocialSites.count == 2 {//social site count 2
                                        DispatchQueue.main.async {
                                            
                                            self.k_Constraint_Height_TableView.constant = 100.0
                                            self.k_Constraint_ViewDescHeight.constant = self.txtView_Description.intrinsicContentSize.height +  self.k_Constraint_Height_TableView.constant + 34
                                        }
                                    }
                                    else{//social site count 3
                                        DispatchQueue.main.async {
                                            
                                            self.k_Constraint_Height_TableView.constant = 150.0
                                            self.k_Constraint_ViewDescHeight.constant = self.txtView_Description.intrinsicContentSize.height +  self.k_Constraint_Height_TableView.constant + 10
                                        }
                                    }
                                    self.tblView_SocialSites.reloadData()
                                    
                                }else{ //social site nil
                                    DispatchQueue.main.async {
                                        
                                        self.tblView_SocialSites.isHidden = true
                                        self.k_Constraint_ViewDescHeight.constant = self.txtView_Description.intrinsicContentSize.height + 73
                                    }
                                }
                            }
                            else{ //Company and school nil
                                
                                self.lbl_School.isHidden = true
                                self.imgView_School.isHidden = true
                                self.btn_OverSchool.isUserInteractionEnabled = false
                                
                                if array_public_UserSocialSites.count > 0 {
                                    DispatchQueue.main.async {
                                        self.tblView_SocialSites.isHidden = false
                                        self.k_Constraint_tblViewTop.constant = -62
                                    }
                                    
                                    if array_public_UserSocialSites.count == 1 {//social site count 1
                                        
                                        DispatchQueue.main.async {
                                            self.tblView_SocialSites.reloadData()
                                            self.k_Constraint_Height_TableView.constant = 50.0
                                            self.k_Constraint_ViewDescHeight.constant = self.txtView_Description.intrinsicContentSize.height +  self.k_Constraint_Height_TableView.constant + 24
                                            
                                        }
                                    }
                                        
                                        
                                    else  if array_public_UserSocialSites.count == 2{//social site count 2
                                        
                                        DispatchQueue.main.async {
                                            self.tblView_SocialSites.reloadData()
                                            self.k_Constraint_Height_TableView.constant = 80.0
                                            self.k_Constraint_ViewDescHeight.constant = self.txtView_Description.intrinsicContentSize.height +  self.k_Constraint_Height_TableView.constant + 24
                                            
                                        }
                                        
                                        
                                    }
                                    else{//social site count 3
                                        DispatchQueue.main.async {
                                            self.tblView_SocialSites.reloadData()
                                            self.k_Constraint_Height_TableView.constant = 130.0
                                            self.k_Constraint_ViewDescHeight.constant = self.txtView_Description.intrinsicContentSize.height +  self.k_Constraint_Height_TableView.constant
                                            
                                        }
                                        
                                        
                                    }
                                    
                                }else{
                                    DispatchQueue.main.async {
                                        self.tblView_SocialSites.reloadData()
                                        self.tblView_SocialSites.isHidden = true
                                        self.k_Constraint_ViewDescHeight.constant = self.txtView_Description.intrinsicContentSize.height  + 50
                                        
                                    }}}}
                        
                        
                        if (response.1).value(forKey: "occupations")as? NSArray != nil {
                            
                            self.array_UserSkills.removeAllObjects()
                            let tmp_arr_occ = ((response.1).value(forKey:  Global.macros.koccupation) as? NSArray)?.mutableCopy() as! NSMutableArray
                            
                            //deleting duplicacy of occupations if occur
                            
                            for value in tmp_arr_occ{
                                
                                let name = (value as! NSDictionary).value(forKey: "name") as? String
                                let id = (value as! NSDictionary).value(forKey: "occupationTypeId") as? NSNumber
                                let dict = NSMutableDictionary()
                                dict.setValue(name, forKey: "name")
                                dict.setValue(id, forKey: "id")
                                print(dict)
                                if self.array_UserSkills.contains(dict) {
                                    break
                                }
                                else{
                                    self.array_UserSkills.add(dict)
                                    
                                }
                            }
                            
                            if self.array_UserSkills.count > 0 {
                                
                                self.collectionView_Skills.isHidden = false
                                self.lbl_NoOccupationsYet.isHidden = true
                                self.collectionView_Skills.reloadData()
                                
                            }
                            else{
                                
                                self.collectionView_Skills.isHidden = true
                                self.lbl_NoOccupationsYet.isHidden = false
                                
                            }
                        }
                        else {
                            self.collectionView_Skills.isHidden = true
                            self.lbl_NoOccupationsYet.isHidden = false
                            
                        }
                        
                        
                        
                        if (response.1).value(forKey: "interest")as? NSArray != nil {
                            
                            self.array_UserInterests.removeAllObjects()
                            let tmp_arr_occ = ((response.1).value(forKey:  Global.macros.kinterest) as? NSArray)?.mutableCopy() as! NSMutableArray
                            
                            //deleting duplicacy of interests if occur
                            for value in tmp_arr_occ{
                                
                                let name = (value as! NSDictionary).value(forKey: "name") as? String
                                let id = (value as! NSDictionary).value(forKey: "interestTypeId") as? NSNumber
                                
                                let dict = NSMutableDictionary()
                                dict.setValue(name, forKey: "name")
                                dict.setValue(id, forKey: "id")
                                
                                if self.array_UserInterests.contains(dict) {
                                    break
                                }
                                else{
                                    self.array_UserInterests.add(dict)
                                    
                                }
                            }
                            
                            
                            if self.array_UserInterests.count > 0{
                                
                                self.collectionView_Interests.isHidden = false
                                self.lbl_NoInterestsYet.isHidden = true
                                self.collectionView_Interests.reloadData()
                                
                            }
                            else{
                                self.collectionView_Interests.isHidden = true
                                self.lbl_NoInterestsYet.isHidden = false
                            }
                        }
                        else {
                            self.collectionView_Interests.isHidden = true
                            self.lbl_NoInterestsYet.isHidden = false
                            
                            
                        }
                        
                     
//                        
//                        if  self.txtView_Description.text == ""  {
//                            
//                             if  self.lbl_School.text == ""  {
//                                
//                                 if  self.lbl_Company.text == ""  {
//                        
//                            DispatchQueue.main.async {
//
//                            self.txtView_Description.frame.size.height = self.txtView_Description.intrinsicContentSize.height
//                            self.txtView_Description.text = "No About Me yet."
//                            self.txtView_Description.font = UIFont(name: "Arial", size: 13)
//                            self.txtView_Description.textAlignment = .center
//                            self.txtView_Description.textColor = UIColor.darkGray
//                            self.k_Constraint_ViewDescHeight.constant =  self.k_Constraint_ViewDescHeight.constant + 35
//                            }
//                        
//                        }
//                                
//                            }
//                        }
                        
                        let rawString: String = ((response.1).value(forKey: "companyName") as? String)!
                        let whitespace = CharacterSet.whitespacesAndNewlines
                        var trimmed = rawString.trimmingCharacters(in: whitespace)
                        
                        let rawString1: String = ((response.1).value(forKey: "schoolName")as? String)!
                        let whitespace1 = CharacterSet.whitespacesAndNewlines
                        var trimmed1 = rawString1.trimmingCharacters(in: whitespace1)
                        
                        
                        if str_bio != nil {
                            if str_bio == "" && (trimmed.characters.count) == 0 &&  (trimmed1.characters.count) == 0 && array_public_UserSocialSites.count == 0 {
                                
                DispatchQueue.main.async {

                self.txtView_Description.frame.size.height = self.txtView_Description.intrinsicContentSize.height
                self.txtView_Description.text = "No About Me yet."
                self.txtView_Description.font = UIFont(name: "Arial", size: 13)
                self.txtView_Description.textAlignment = .center
                self.txtView_Description.textColor = UIColor.darkGray
                self.k_Constraint_ViewDescHeight.constant =  self.k_Constraint_ViewDescHeight.constant + 35
                }
                                
                                
                            }
                        }
                        else {
                            
                            if str_bio == nil && (trimmed.characters.count) == 0 &&  (trimmed1.characters.count) == 0 && array_public_UserSocialSites.count == 0 {
                                DispatchQueue.main.async {
                                    
                                    self.txtView_Description.frame.size.height = self.txtView_Description.intrinsicContentSize.height
                                    self.txtView_Description.text = "No About Me yet."
                                    self.txtView_Description.font = UIFont(name: "Arial", size: 13)
                                    self.txtView_Description.textAlignment = .center
                                    self.txtView_Description.textColor = UIColor.darkGray
                                    self.k_Constraint_ViewDescHeight.constant =  self.k_Constraint_ViewDescHeight.constant + 35
                                }
                                
                            }
                            
                        }
                        
                        
                        
                        
                        
                        
                    }
                case 401:
                   // self.AlertSessionExpire()
                    DispatchQueue.main.async {
                        self.clearAllNotice()
                    }
                    
                        let deviceIdentifier: String = UIDevice.current.identifierForVendor!.uuidString

                        QBRequest.unregisterSubscription(forUniqueDeviceIdentifier: deviceIdentifier, successBlock: { (QBResponse) in
                            
                            
                          self.logout()
                            
                        }, errorBlock: {(err) in
                            DispatchQueue.main.async {
                                self.clearAllNotice()
                                
                            }
                            self.logout()

                        })
                    
                    
                case 400 :
                    DispatchQueue.main.async {
                        self.clearAllNotice()
                    }
                    
                    let deviceIdentifier: String = UIDevice.current.identifierForVendor!.uuidString
                    
                    QBRequest.unregisterSubscription(forUniqueDeviceIdentifier: deviceIdentifier, successBlock: { (QBResponse) in
                        
                        
                        self.logout()
                        
                    }, errorBlock: {(err) in
                        DispatchQueue.main.async {
                            self.clearAllNotice()
                            
                        }
                        self.logout()
                        
                    })
                    
                    
                default:
                    break
                    
                }
                DispatchQueue.main.async {
                    self.clearAllNotice()
                }
            }, errorBlock: {(err) in
                
                DispatchQueue.main.async
                    {
                        self.clearAllNotice()
                        self.showAlert(Message: Global.macros.kError ,vc: self)
                }
            })
        }
        else{
            self.showAlert(Message: Global.macros.kInternetConnection, vc: self)
            
        }
    }
    
    
    
    func logout(){
        
    
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
                DispatchQueue.main.async {
                    self.navigationController?.navigationBar.isHidden = true
                    let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "Login")
                    Global.macros.kAppDelegate.window?.rootViewController = vc
                }
                
                
            }, errorBlock: { (response) in
                
                print(response)
                //   self.showAlert(Message: "Please try again.", vc: self)
                
                self.navigationController?.navigationBar.isHidden = true
                let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "Login")
                Global.macros.kAppDelegate.window?.rootViewController = vc
                
            })
            
    
    }

    
    func heightForView(_ text:String, width:CGFloat,font:UIFont) -> Int{
        
        let label:UILabel = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: width, height: label.intrinsicContentSize.height)
        label.numberOfLines = 20000
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return Int(label.frame.height)
    }
    
    //custom view to set borders of views
    func customView(view : UIView) {
        
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        view.layer.borderColor = UIColor.init(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 0.5).cgColor
        view.layer.borderWidth = 1.0
        
    }
    
    // Rating stars on navigation bar
    func custom_StarView () {
        
        let view_stars = UIView()
        view_stars.frame = CGRect(x: 0, y: 10, width: 110, height: 25)
        view_stars.backgroundColor = UIColor.clear
        self.view.addSubview(view_stars)
        
        let imageName = "StarEmpty"
        let image = UIImage(named: imageName)
        
        imageView1 = UIImageView(image: image!)
        imageView1?.frame = CGRect(x: 5, y: 0, width: 20, height: 20)
        
        imageView2 = UIImageView(image: image!)
        imageView2?.frame = CGRect(x: 25, y: 0, width: 20, height: 20)
        
        imageView3 = UIImageView(image: image!)
        imageView3?.frame = CGRect(x: 45, y: 0, width: 20, height: 20)
        
        
        imageView4 = UIImageView(image: image!)
        imageView4?.frame = CGRect(x: 65, y: 0, width: 20, height: 20)
        
        
        imageView5 = UIImageView(image: image!)
        imageView5?.frame = CGRect(x: 85, y: 0, width: 20, height: 20)
        
        
        let  btn_actionRating = UIButton(type: .custom)
        btn_actionRating.frame = CGRect(x: 0, y: 0, width: 110, height: 25)
        btn_actionRating.addTarget(self, action: #selector(ratingBtnPressed), for: .touchUpInside)
        
        view_stars.addSubview(imageView1!)
        view_stars.addSubview(imageView2!)
        view_stars.addSubview(imageView3!)
        view_stars.addSubview(imageView4!)
        view_stars.addSubview(imageView5!)
        view_stars.addSubview(btn_actionRating)
        
        self.navigationItem.titleView = view_stars
        
    }
    
    func ratingBtnPressed(sender: AnyObject){
        
        
    }
    
    
    func SetRatingView (Number:String) {
        
        switch Number {
            
        case "0":
            imageView1?.image = UIImage(named: "StarEmpty")
            imageView2?.image = UIImage(named: "StarEmpty")
            imageView3?.image = UIImage(named: "StarEmpty")
            imageView4?.image = UIImage(named: "StarEmpty")
            imageView5?.image = UIImage(named: "StarEmpty")
            
        case "1":
            imageView1?.image = UIImage(named: "StarFull")
            imageView2?.image = UIImage(named: "StarEmpty")
            imageView3?.image = UIImage(named: "StarEmpty")
            imageView4?.image = UIImage(named: "StarEmpty")
            imageView5?.image = UIImage(named: "StarEmpty")
            
        case "2":
            imageView1?.image = UIImage(named: "StarFull")
            imageView2?.image = UIImage(named: "StarFull")
            imageView3?.image = UIImage(named: "StarEmpty")
            imageView4?.image = UIImage(named: "StarEmpty")
            imageView5?.image = UIImage(named: "StarEmpty")
            
        case "3":
            imageView1?.image = UIImage(named: "StarFull")
            imageView2?.image = UIImage(named: "StarFull")
            imageView3?.image = UIImage(named: "StarFull")
            imageView4?.image = UIImage(named: "StarEmpty")
            imageView5?.image = UIImage(named: "StarEmpty")
            
        case "4":
            imageView1?.image = UIImage(named: "StarFull")
            imageView2?.image = UIImage(named: "StarFull")
            imageView3?.image = UIImage(named: "StarFull")
            imageView4?.image = UIImage(named: "StarFull")
            imageView5?.image = UIImage(named: "StarEmpty")
            
        case "5":
            imageView1?.image = UIImage(named: "StarFull")
            imageView2?.image = UIImage(named: "StarFull")
            imageView3?.image = UIImage(named: "StarFull")
            imageView4?.image = UIImage(named: "StarFull")
            imageView5?.image = UIImage(named: "StarFull")
            
            
            
        default:
            break
        } }
    
    
    func chatBtnPressed(sender: AnyObject){
       
     
        if (verifiedByAdminLoginUser?.contains("true"))! || verifiedByAdminLoginUser == ""  {
            
            
              //*******
                DispatchQueue.main.async {
                    self.pleaseWait()
                }
                // DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                
                if SavedPreferences.value(forKey: "qb_UserId") != nil {
                    
                    if self.user_IdMyProfile != SavedPreferences.value(forKey: Global.macros.kUserId) as? NSNumber{
                        
                        
                        if self.qb_id != nil  && self.qb_id != ""  {
                            
                            let dict = NSMutableDictionary()
                            let  user_Id = SavedPreferences.value(forKey: Global.macros.kUserId) as? NSNumber
                            
                            dict.setValue( user_Id, forKey: Global.macros.kUserId)
                            dict.setValue( user_Id, forKey: "senderUserId")
                            dict.setValue( self.user_IdMyProfile, forKey: "receiverUserId")
                            print(dict)
                            
                            
                            ProfileAPI.sharedInstance.CheckDialogId(dict: dict, completion: {(response) in
                                
                                let status = response.value(forKey: Global.macros.KStatus)as! NSNumber
                                
                                switch status {
                                    
                                case 200:
                                    DispatchQueue.main.async {
                                        self.clearAllNotice()
                                        
                                        let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
                                        let dic = response.value(forKey: "data") as! NSDictionary
                                        print(dic)
                                        vc.str_DialogId = dic.value(forKey: "dialogId") as? String
                                        print(vc.str_DialogId!)
                                        
                                        if vc.str_DialogId != "" && vc.str_DialogId != nil {
                                            
                                            vc.str_ReceiverName = "\(self.navigationItem.title!)"
                                            vc.str_OtherUserId = self.qb_id
                                            print(vc.str_ReceiverName!)
                                            
                                            if vc.str_ReceiverName == nil {
                                                vc.str_ReceiverName = self.title
                                            }
                                            
                                            _ = self.navigationController?.pushViewController(vc, animated: true)
                                            
                                        }
                                    }
                                    
                                case 400:
                                    
                                    DispatchQueue.main.async {
                                        
                                        
                                        let chatDialog: QBChatDialog = QBChatDialog(dialogID: nil, type: QBChatDialogType.group)
                                        // let dia:QBChatDialog = QBChatDialog.ini
                                        
                                        if self.qb_id != nil {
                                            
                                            
                                            if (SavedPreferences.value(forKey: "role") as? String) == "USER" {
                                                
                                                chatDialog.name  = "\( self.str_UserName!)" + "/" + "\(self.user_IdMyProfile!)" + "-" + "USER"  + "_" + "\(SavedPreferences.value(forKey: Global.macros.kUserName)!)" + "/" + "\(SavedPreferences.value(forKey: Global.macros.kUserId)!)" + "-" + "\(SavedPreferences.value(forKey: Global.macros.krole)!)"
                                                
                                            }
                                            else if (SavedPreferences.value(forKey: "role") as? String) == "COMPANY" {
                                                
                                                chatDialog.name  = "\(self.str_UserName!)" + "/" + "\(self.user_IdMyProfile!)" + "-" + "USER"  + "_" + "\(SavedPreferences.value(forKey: Global.macros.kcompanyName)!)" + "/" + "\(SavedPreferences.value(forKey: Global.macros.kUserId)!)" + "-" + "\(SavedPreferences.value(forKey: Global.macros.krole)!)"
                                                
                                            }
                                                
                                            else if (SavedPreferences.value(forKey: "role") as? String) == "SCHOOL" {
                                                
                                                chatDialog.name  = "\(self.str_UserName!)" + "/" + "\(self.user_IdMyProfile!)" + "-" + "USER"  + "_" + "\(SavedPreferences.value(forKey: Global.macros.kschoolName)!)" + "/" + "\(SavedPreferences.value(forKey: Global.macros.kUserId)!)" + "-" + "\(SavedPreferences.value(forKey: Global.macros.krole)!)"
                                                
                                            }
                                            
                                            
                                            // occupant id
                                            if let myInteger = Int(self.qb_id!) {
                                                let myNumber = NSNumber(value:myInteger)
                                                chatDialog.occupantIDs = [myNumber]
                                                
                                            }
                                            
                                            
                                            // creating dialogue
                                            QBRequest.createDialog(chatDialog, successBlock: {(response: QBResponse?, createdDialog: QBChatDialog?) in
                                                
                                                
                                                
                                                let created_DialogId  =  createdDialog?.id
                                                
                                                
                                                let dialog_Dict = NSMutableDictionary()
                                                let user_Id = SavedPreferences.value(forKey: Global.macros.kUserId) as? NSNumber
                                                
                                                dialog_Dict.setValue( user_Id, forKey: Global.macros.kUserId)
                                                dialog_Dict.setValue( user_Id, forKey: "senderUserId")
                                                dialog_Dict.setValue( self.user_IdMyProfile, forKey: "receiverUserId")
                                                dialog_Dict.setValue( created_DialogId, forKey: "dialogId")
                                                print(dialog_Dict)
                                                
                                                // saving dialogue in backend
                                                ProfileAPI.sharedInstance.CreateDialog(dict: dialog_Dict, completion: {(response) in
                                                    let status = response.value(forKey: Global.macros.KStatus)as! NSNumber
                                                    
                                                    switch status {
                                                        
                                                    case 200:
                                                        //push to chat controller
                                                        DispatchQueue.main.async {
                                                            self.clearAllNotice()
                                                            
                                                            let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
                                                            
                                                            let dic = response.value(forKey: "data") as! NSDictionary
                                                            vc.str_DialogId = dic.value(forKey: "dialogId") as? String
                                                            vc.dialog_Chat = createdDialog
                                                            
                                                            
                                                            print( vc.str_DialogId!)
                                                            if vc.str_DialogId != "" && vc.str_DialogId != nil {
                                                                
                                                                let str = createdDialog?.name
                                                                let str_obb :NSString = NSString(string:str!)
                                                                
                                                                let delimiter = "_"
                                                                let token = str_obb.components(separatedBy: delimiter)
                                                                
                                                                let str1: String = (token.first)!
                                                                let str2: String = (token.last)!
                                                                
                                                                // str1
                                                                let delimiter1 = "/"
                                                                let token1 = str1.components(separatedBy: delimiter1)
                                                                
                                                                let delimiter_role = "-"
                                                                let token_role = str1.components(separatedBy: delimiter_role)
                                                                let str_role: String = (token_role.last)!
                                                                
                                                                let str_name: String = (token1.first)!
                                                                
                                                                let token_userId = (token_role.first)!.components(separatedBy: delimiter1)
                                                                let str_Id: String = (token_userId.last)!
                                                                
                                                                
                                                                let token2 = str2.components(separatedBy: "/")
                                                                print(token2)
                                                                let token_id = (token2.last)!.components(separatedBy: "-")
                                                                
                                                                let str_name2: String = (token2.first)!
                                                                
                                                                let str_role2: String = (token_id.last)!
                                                                
                                                                let str_Id2: String = (token_id.first)!
                                                                
                                                                
                                                                if str_name != "\(SavedPreferences.value(forKey: Global.macros.kUserName)!)" {
                                                                    
                                                                    vc.str_ReceiverName = str_name
                                                                    if let myInteger = Int(str_Id) {
                                                                        let myNumber = NSNumber(value:myInteger)
                                                                        vc.local_otherUserId = myNumber
                                                                        vc.local_roleOtherUser = str_role
                                                                    }
                                                                    
                                                                    
                                                                }
                                                                    
                                                                else if str_name2 != "\(SavedPreferences.value(forKey: Global.macros.kUserName)!)" {
                                                                    vc.str_ReceiverName = str_name2
                                                                    if let myInteger = Int(str_Id2) {
                                                                        let myNumber = NSNumber(value:myInteger)
                                                                        vc.local_otherUserId = myNumber
                                                                        vc.local_roleOtherUser = str_role2
                                                                    }
                                                                    
                                                                    
                                                                    
                                                                }
                                                                
                                                                vc.str_OtherUserId = self.qb_id
                                                                
                                                               
                                                                
                                                                DispatchQueue.main.async {
                                                                 
                                                                    vc.dialog_Chat.join(completionBlock: { (error) in
                                                                        
                                                                        self.clearAllNotice()

                                                                        _ = self.navigationController?.pushViewController(vc, animated: true)
                                                                        
                                                                        print(error)
                                                                    })
                                                                   
                                                                    
                                                                }
                                                                
                                                            }
                                                                
                                                                
                                                                
                                                                
                                                            else {
                                                                DispatchQueue.main.async {
                                                                    self.clearAllNotice()
                                                                    
                                                                    self.showAlert(Message: "Please try again", vc: self)
                                                                    
                                                                }
                                                            }
                                                            
                                                        }
                                                        
                                                        
                                                    default:
                                                        self.clearAllNotice()
                                                        
                                                        break
                                                    }
                                                    
                                                }, errorBlock: {(err) in
                                                    
                                                    self.clearAllNotice()
                                                    self.showAlert(Message: Global.macros.kError, vc: self)
                                                    
                                                    
                                                })
                                                
                                                
                                                
                                                
                                                
                                            }, errorBlock: {(response: QBResponse!) in
                                                print(response.error!)
                                                
                                            })
                                            
                                        }
                                        
                                    }
                                    
                                    
                                    
                                default:
                                    break
                                }
                                
                                
                            }, errorBlock: {(err) in
                                
                                self.clearAllNotice()
                                self.showAlert(Message: Global.macros.kError, vc: self)
                                
                                
                            })
                        }
                            
                        else {
                            
                            
                            self.showAlert(Message: "Please register on quickblox to chat.", vc: self)
                            
                        }
                        
                        
                    }
                        
                        
                    else {
                        let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "dialogs") as! DialogsViewController
                        _ = self.navigationController?.pushViewController(vc, animated: true)
                        
                        
                    }
                }
                else {
                    
                    self.clearAllNotice()
                    self.showAlert(Message: "Please try again.", vc: self)
                    
                    
                }
                
                //*********
              
           
           
            
            
        }
        else{
            
            self.showAlert(Message: "You are not verified by admin yet.", vc: self)
        }
       
        
     
      
            
        
    }
    
    func Calender_SearchBtnPressed(sender: AnyObject){
        
        if self.revealViewController() != nil {
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
        
        
        
    }
    
    
    
    @IBAction func Action_ToSeeMyRequests(_ sender: UIButton) {
        
        
        if self.revealViewController() != nil {
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
        
        
        if self.user_IdMyProfile == SavedPreferences.value(forKey: Global.macros.kUserId) as? NSNumber   {
            
            let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "MyRequests") as! RequestsListViewController
            vc.user_Name =  self.navigationItem.title
            
            _ = self.navigationController?.pushViewController(vc, animated: true)
        }
            
            
        else{
            
           
            
            
            let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "send_request") as! SendRequestViewController
            vc.user_Name =  self.navigationItem.title
            vc.userIdFromSendRequest = user_IdMyProfile
            //userIdFromSearch
            _ = self.navigationController?.pushViewController(vc, animated: true)
            
            
            
        }
        
    }
    
    
    
    
    
    //MARK: - Button Actions
    
    
    @IBAction func Action_OpenRatingView(_ sender: Any) {
        
        
        if self.revealViewController() != nil {
            self.revealViewController().rightRevealToggle(animated: false)
        }
        
        
        
        DispatchQueue.main.async {
            
            
            if self.user_IdMyProfile == SavedPreferences.value(forKey: Global.macros.kUserId) as? NSNumber {
                if self.lbl_NoOfRating.text != "0"{
                    
                    let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "ratingView") as! RatingViewController
                    vc.userIdForRating = self.user_IdMyProfile
                    ratingview_name = self.navigationItem.title
                    _ = self.navigationController?.pushViewController(vc, animated: true)
                    
                }else{
                    self.showAlert(Message: "No ratings yet.", vc: self)
                }
            }
                
            else {
                let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "ratingView") as! RatingViewController
                vc.userIdForRating = self.user_IdMyProfile
                ratingview_name = self.navigationItem.title
                
                _ = self.navigationController?.pushViewController(vc, animated: true)
                
            }
            
        }
        
    }
    
    
    @IBAction func Open_ProfileImage(_ sender: UIButton) {
        
        if self.revealViewController() != nil {
            self.revealViewController().rightRevealToggle(animated: false)
        }
        
        Global.macros.statusBar.isHidden = true
        let imgdata = UIImageJPEGRepresentation(imageView_ProfilePic.image!, 0.5)
        let photos = self.ArrayOfPhotos(data: imgdata!)
        let vc: NYTPhotosViewController = NYTPhotosViewController(photos: photos as? [NYTPhoto])
        vc.rightBarButtonItem = nil
        
        self.present(vc, animated: true, completion: nil)
        
        
        
    }
    
    
    func ArrayOfPhotos(data:Data)->(NSArray)
    {
        self.scrollbar.contentInset = UIEdgeInsets.init(top: 10, left: 0, bottom: 0, right: 0)
        let photos:NSMutableArray = NSMutableArray()
        let photo:NYTExamplePhoto = NYTExamplePhoto()
        photo.imageData = data
        photos.add(photo)
        return photos
      
        
    }
    
    @IBAction func Action_LogOut(_ sender: UIButton) {
        
    }
    
    @IBAction func Action_SelectSocialIcons(_ sender: UIButton) {
        
          }
    
    @IBAction func Action_PlayVideo(_ sender: UIButton) {
        
        DispatchQueue.main.async {
            
            let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "Upload_Video") as! UploadViewController
            
            
            //            self.view.backgroundColor = UIColor.black
            //            self.scrollbar.isHidden = true
            
            
            if  self.video_url != nil {
                bool_VideoFromGallary = false
                bool_PlayFromProfile = true
                
                vc.video_urlProfile = self.video_url
                _ = self.navigationController?.present(vc, animated: true, completion: nil)
                //_ = self.navigationController?.pushViewController(vc, animated: true)
                
                
            }
            else {
                
                self.showAlert(Message: "No video to play yet.", vc: self)
                
            }
            
        }
        
    }
    
    @IBAction func ActionSocialMedia1(_ sender: Any) {
        SetWebViewUrl (index: 0)
        
    }
    
    @IBAction func ActionSocialMedia2(_ sender: Any) {
        
        SetWebViewUrl (index: 1)
        
    }
    
    
    @IBAction func Action_openSchoolCompany(_ sender: UIButton) {
        
        
        
        if self.revealViewController() != nil {
            self.revealViewController().rightRevealToggle(animated: false)
        }
        
        
        //   if bool_UserIdComingFromSearch == false {
        
        if sender.tag == 0{
            
            idFromProfileVC = (dictionary_user_Info.value(forKey: "companyDTO") as? NSDictionary)?.value(forKey: "companyUserId") as? NSNumber
            
        }
        else if sender.tag == 1{
            idFromProfileVC = (dictionary_user_Info.value(forKey: "schoolDTO") as? NSDictionary)?.value(forKey: "schoolUserId") as? NSNumber
            
        }
        
        if idFromProfileVC != nil  {
            
            let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "company") as! ComapanySchoolViewController//UINavigationController
            //   bool_ProfileOpenFromComment = true
            vc.user_IdMyProfile = idFromProfileVC
            _ = self.navigationController?.pushViewController(vc, animated: true)
            
            
            
        }
            
        else {
            
            self.showAlert(Message: "Company/School is not registered.", vc: self)
            
        }
        
    }
    
    
    
    func SetWebViewUrl (index:Int) {
        
        
        let tempArray = self.dicUrl.allKeys as! [String]
        
        
        let socialStr:String = tempArray[index]
        
        switch socialStr {
        case "facebookUrl":
            linkForOpenWebsite = self.dicUrl.value(forKey: "facebookUrl") as? String
        case "linkedInUrl":
            linkForOpenWebsite = self.dicUrl.value(forKey: "linkedInUrl") as? String
            
        case "twitterUrl":
            linkForOpenWebsite = self.dicUrl.value(forKey: "twitterUrl") as? String
            
        case "googlePlusUrl":
            linkForOpenWebsite = self.dicUrl.value(forKey: "googlePlusUrl") as? String
            
            
        case "instagramUrl":
            linkForOpenWebsite = self.dicUrl.value(forKey: "instagramUrl") as? String
            
        case "gitHubUrl":
            linkForOpenWebsite = self.dicUrl.value(forKey: "gitHubUrl") as? String
            
        default: break
            
        }
        
        
        if let checkURL = NSURL(string: linkForOpenWebsite!) {
            if  UIApplication.shared.openURL(checkURL as URL){
                print("URL Successfully Opened")
                linkForOpenWebsite = ""
            }
            else {
                print("Invalid URL")
            }
        } else {
            print("Invalid URL")
        }
        
    }
    
    
    @IBAction func action_OpenShadowers(_ sender: UIButton) {
        
        if self.revealViewController() != nil {
            self.revealViewController().rightRevealToggle(animated: false)
        }
        //  if bool_UserIdComingFromSearch == false {
        var type:String?
        var navigationTitle:String?
        if sender.tag == 0{//shadowers
            
            type = Global.macros.kShadow
            navigationTitle = "Shadowers"
            
            
        }else if sender.tag == 1{//shadowed
            
            type = Global.macros.kShadowed
            navigationTitle = "Shadowed Users"
            
            
        }
        
        
        let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "listing") as! ListingViewController
        vc.type = type
        vc.ListuserId = self.user_IdMyProfile
        vc.navigation_title = navigationTitle
        
        _ = self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.revealViewController() != nil {
            self.revealViewController().rightRevealToggle(animated: false)
        }
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "userProfile_to_usereditProfile"{
            
            let vc = segue.destination as! UserEditProfileViewController
            vc.dict_Url = self.dicUrl
            
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
extension ProfileVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 8
        let size:CGSize?
        if Global.DeviceType.IS_IPHONE_6 || Global.DeviceType.IS_IPHONE_6P || Global.DeviceType.IS_IPHONE_X {
            size = CGSize(width: ((collectionView.frame.width/3 - 5) ), height: 45)
        }
        else{
            size = CGSize(width: ((collectionView.frame.width/2 - 5) ), height: 45)
            
        }
        return size!
    }
    
 
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        var cell = UICollectionViewCell()
        
        
        if collectionView == collectionView_Skills{
            let skills_cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "skill", for: indexPath)as! SkillsNInterestCollectionViewCell
            if array_UserSkills.count > 0 {
                
                skills_cell.lbl_Skill.text = (array_UserSkills[indexPath.row]as! NSDictionary).value(forKey: "name")as? String
            }
            
            cell = skills_cell
            
        }
        
        if collectionView == collectionView_Interests{
            let interest_cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "interest_cell", for: indexPath)as! Profile_UserInterestsCollectionViewCell
            
            
            if array_UserInterests.count > 0 {
                
                interest_cell.lbl_InterestName.text = (array_UserInterests[indexPath.row]as! NSDictionary).value(forKey: "name")as? String
                
            }
            
            cell = interest_cell
            
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        var count:Int?
        
        if collectionView == collectionView_Skills{
            
            count = array_UserSkills.count
            if count! <= 2 {
                self.kheightViewBehindSkill.constant = 100
                
            }
                
                
            else if count == 4 {
                self.kheightViewBehindSkill.constant = 150
                
            }
            else {
                
                
                DispatchQueue.main.async {
                    
                    self.kheightCollectionViewOccupation.constant = self.collectionView_Skills.contentSize.height
                    
                    self.kheightViewBehindSkill.constant = self.collectionView_Skills.contentSize.height + 30
                }
                
                
            }
            
            if Global.DeviceType.IS_IPHONE_5 {
                
                if count == 3 {
                    self.kheightViewBehindSkill.constant = 150
                }
            }
        }
        
        if collectionView == collectionView_Interests{
            
            count = array_UserInterests.count
            
            if count! <= 2 {
                self.kheightViewBehindInterest.constant = 100
            }
            else if count == 4 {
                self.kheightViewBehindInterest.constant = 150
                
            }
            else {
                DispatchQueue.main.async {
                    self.kheightCollectionViewInterestHeight.constant = self.collectionView_Interests.contentSize.height
                    self.kheightViewBehindInterest.constant = self.collectionView_Interests.contentSize.height + 30
                }
            }
            
            if Global.DeviceType.IS_IPHONE_5 {
                
                if count == 3 {
                    self.kheightViewBehindInterest.constant = 150
                    
                }
                
                
            }
            
        }
        DispatchQueue.main.async {
            if bool_UserIdComingFromSearch == true || bool_ComingFromList == true {
                self.scrollbar.contentSize = CGSize(width: self.view.frame.size.width, height: 360 + self.k_Constraint_ViewDescHeight.constant + self.kheightViewBehindSkill.constant + self.kheightViewBehindInterest.constant)
            }
                
            else {
                self.scrollbar.contentSize = CGSize(width: self.view.frame.size.width, height: 380 + self.k_Constraint_ViewDescHeight.constant + self.kheightViewBehindSkill.constant + self.kheightViewBehindInterest.constant)
            }        }
        
        return count!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)                                                                                                                          {
        
        if self.revealViewController() != nil {
            self.revealViewController().rightRevealToggle(animated: false)
        }
        
        
        if collectionView == collectionView_Skills {
            
            let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "OccupationDetail") as! OccupationDetailViewController
            vc.occupationId = (array_UserSkills[indexPath.row] as! NSDictionary)["id"]! as? NSNumber
            _ = self.navigationController?.pushViewController(vc, animated: true)
            
        }
        else {
            let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "OccupationDetail") as! OccupationDetailViewController
            vc.occupationId = (array_UserInterests[indexPath.row] as! NSDictionary)["id"]! as? NSNumber
            _ = self.navigationController?.pushViewController(vc, animated: true)
            
            
        }
        
    }
    
    
}

extension ProfileVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array_public_UserSocialSites.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UserProfileSocialSiteTableViewCell
        
        cell.layer.borderColor = UIColor.init(red: 125.0/255.0, green: 208.0/255.0, blue: 244.0/255.0, alpha: 1.0).cgColor
        
        cell.imgView_UserSocialSite.image = (array_public_UserSocialSites[indexPath.row] as NSDictionary).value(forKey: "image") as? UIImage
        let site_url = (array_public_UserSocialSites[indexPath.row] as NSDictionary).value(forKey: "url") as? String
        let site = (array_public_UserSocialSites[indexPath.row] as NSDictionary).value(forKey: "name_url") as? String
        switch (site!){
        case "facebookUrl":
            //https://www.facebook.com/ 25
            let index = site_url?.index((site_url?.startIndex)!, offsetBy: 25)
            cell.lbl_UserSocialSite.text = site_url?.substring(from: index!)
            
            break
            
        case "linkedInUrl":
            //https://www.linkedin.com/ 25
            
            let index = site_url?.index((site_url?.startIndex)!, offsetBy: 25)
            cell.lbl_UserSocialSite.text = site_url?.substring(from: index!)
            break
            
            
        case "instagramUrl":
            //https://www.instagram.com/ 26
            let index = site_url?.index((site_url?.startIndex)!, offsetBy: 26)
            cell.lbl_UserSocialSite.text = site_url?.substring(from: index!)
            
            break
            
            
        case "googlePlusUrl":
            //https://www.googleplus.com/ 27
            let index = site_url?.index((site_url?.startIndex)!, offsetBy: 27)
            cell.lbl_UserSocialSite.text = site_url?.substring(from: index!)
            
            break
            
            
        case "gitHubUrl":
            //https://www.github.com/ 23
            
            let index = site_url?.index((site_url?.startIndex)!, offsetBy: 23)
            cell.lbl_UserSocialSite.text = site_url?.substring(from: index!)
            
            break
            
            
        case "twitterUrl":
            //https://www.twitter.com/ 24
            let index = site_url?.index((site_url?.startIndex)!, offsetBy: 24)
            cell.lbl_UserSocialSite.text = site_url?.substring(from: index!)
            
            break
            
        default:
            break
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.revealViewController() != nil {
            self.revealViewController().rightRevealToggle(animated: false)
        }
        
        
        if array_public_UserSocialSites.count > 0 {
            
            let site_url = (array_public_UserSocialSites[indexPath.row] as NSDictionary).value(forKey: "url") as? String
            let trimmedString = site_url?.trimmingCharacters(in: .whitespacesAndNewlines)
            
            print(trimmedString!)
            
            DispatchQueue.main.async {
                if let checkURL = NSURL(string: trimmedString!) {
                    
                    if  UIApplication.shared.openURL(checkURL as URL){
                        print("URL Successfully Opened")
                    }
                    else {
                        print("Invalid URL")
                    }
                } else {
                    print("Invalid URL")
                }
                
            }}}}

extension ProfileVC:UITabBarControllerDelegate{
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        bool_ComingRatingList = false
        
        if self.revealViewController() != nil {
            self.revealViewController().rightRevealToggle(animated: false)
        }
        
        if tabBarController.selectedIndex == 0{
            if self.revealViewController() != nil {
                self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
                self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
                
            }}}
}

