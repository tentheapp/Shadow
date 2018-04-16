//
//  ComapanySchoolViewController.swift
//  Shadow
//
//  Created by Atinderjit Kaur on 28/06/17.
//  Copyright © 2017 Atinderjit Kaur. All rights reserved.
//

import UIKit

var idFromProfileVC:        NSNumber?
var bool_ComingRatingList : Bool = false

class ComapanySchoolViewController: UIViewController, UIGestureRecognizerDelegate,SWRevealViewControllerDelegate {
    
    
    @IBOutlet weak var KLeadingCalenderIcon:      NSLayoutConstraint!
    @IBOutlet weak var kTopLinkOpenSchoolCompany: NSLayoutConstraint!
    @IBOutlet weak var btn_LinkOpenSchoolCompany: UIButton!
    @IBOutlet weak var btn_Shadow:                UIButton!
    
    @IBOutlet var tblView_SocialSites:            UITableView!
    @IBOutlet var k_Constraint_Height_tblView:    NSLayoutConstraint!
    @IBOutlet var k_Constraint_Top_yblView:       NSLayoutConstraint!
    @IBOutlet var k_Constraint_Top_imgViewUrl:    NSLayoutConstraint!
    @IBOutlet var k_Constraint_Top_lblUrl:        NSLayoutConstraint!
    @IBOutlet var imgView_Url:                    UIImageView!
    @IBOutlet var imgView_Location:               UIImageView!
    @IBOutlet var lbl_Rating:                     UILabel!
    @IBOutlet var lbl_RatingCount:                UILabel!
    @IBOutlet var k_Constraint_ViewDescriptionHeight: NSLayoutConstraint!
    @IBOutlet var menuButton:                     UIBarButtonItem!
    @IBOutlet var Scroll_View:                    UIScrollView!
    @IBOutlet var imgView_ProfilePic:             UIImageView!
    @IBOutlet var btn_SocialSite1:                UIButton!
    @IBOutlet var btn_SocialSite2:                UIButton!
    @IBOutlet var btn_SocialSite3:                UIButton!
    @IBOutlet var lbl_company_schoolName:         UILabel!
    @IBOutlet var lbl_company_schoolLocation:     UILabel!
    @IBOutlet var lbl_company_schoolUrl:          UILabel!
    @IBOutlet var lbl_CountverifiedShadowers:     UILabel!
    @IBOutlet var lbl_CountshadowedYou:           UILabel!
    @IBOutlet var lbl_Count_cmpnyschool_withthesesoccupation: UILabel!
    @IBOutlet var lbl_Count_Users:                UILabel!
    @IBOutlet var lbl_title__cmpnyschool_withthesesoccupation: UILabel!
    @IBOutlet var lbl_title_Users:             UILabel!
    @IBOutlet var lbl_description:             UILabel!
    @IBOutlet var lbl_Placeholder_description: UILabel!
    @IBOutlet var lbl_NoOccupationYet:         UILabel!
    @IBOutlet var collection_View:             UICollectionView!
    @IBOutlet weak var view_BehindProfile:     UIView!
    @IBOutlet weak var view_BehindNumValues:   UIView!
    @IBOutlet weak var view_BehindDescription: UIView!
    @IBOutlet weak var view_BehindOccupation:  UIView!
    @IBOutlet var txtView_Description:         UILabel!
    @IBOutlet var lbl_totalRatingCount:        UILabel!
    @IBOutlet weak var kheightViewBehindOccupation: NSLayoutConstraint!
    var check_for_previousview :               String?
    var userIdFromList :                       NSNumber? //For listing class
    var userIdFromSearch :                     NSNumber? //FRom search class
    var myview =                               UIView()
    var video_url :                            URL?
    @IBOutlet weak var kHeightCollectionView:  NSLayoutConstraint!
    @IBOutlet weak var kleadingBtn:            NSLayoutConstraint!
    
    
    //MARK: - Variables
    var linkForOpenWebsite :        String?
    var rating_number  :            String?
    var user_IdMyProfile :          NSNumber?
    fileprivate var item1 =         UIBarButtonItem()
    fileprivate var array_UserOccupations:NSMutableArray = NSMutableArray()
    
    var img_url :                   String?
    var img_profile :               UIImage?
    var str_SchoolCompany :         String? = ""
    var str_roleSchoolCompany :     String? = ""
    
    var dicUrl: NSMutableDictionary = NSMutableDictionary()
    let array_URL = ["facebookUrl","linkedInUrl","instagramUrl","googlePlusUrl","gitHubUrl","twitterUrl"]
    var verifiedByAdmin : String? = ""
    
    fileprivate var array_ActualSocialSites = [
        ["name":"Facebook","name_url":"facebookUrl","image":UIImage(named: "facebookUrl")!],
        ["name":"LinkedIn","name_url":"linkedInUrl","image":UIImage(named: "linkedInUrl")!],
        ["name":"Twitter","name_url":"twitterUrl","image":UIImage(named: "twitterUrl")!],
        ["name":"gitHub","name_url":"gitHubUrl","image":UIImage(named: "gitHubUrl")!],
        ["name":"Google+","name_url":"googlePlusUrl","image":UIImage(named: "googlePlusUrl")!],
        ["name":"Instagram","name_url":"instagramUrl","image":UIImage(named: "instagramUrl")!]]
    
    
    var imageView1 : UIImageView?
    var imageView2 : UIImageView?
    var imageView3 : UIImageView?
    var imageView4 : UIImageView?
    var imageView5 : UIImageView?
    
    //chat
    var qb_id :       String?
    var arr_Dialogs = Set<String>()
    var dialog_Chat : String? = ""
    var count_unreadMessage : UInt?
    var label :        UILabel!
    var  str_UserName : String? = ""

    @IBOutlet weak var kheightShadowBtn: NSLayoutConstraint!
    @IBOutlet weak var kwidthShadowBtn: NSLayoutConstraint!
    
    @IBOutlet weak var ktopCalenderIcon: NSLayoutConstraint!
    //chat
    @IBOutlet weak var ktopShadowTextt: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        DispatchQueue.main.async {
            if Global.DeviceType.IS_IPHONE_6P  {
                self.kleadingBtn.constant = 20
                self.KLeadingCalenderIcon.constant = 32
            }
            
            else if Global.DeviceType.IS_IPHONE_X || Global.DeviceType.IS_IPHONE_6{
                
                self.kheightShadowBtn.constant = 34
                self.kleadingBtn.constant = 12
                self.KLeadingCalenderIcon.constant = 22
                self.kwidthShadowBtn.constant = 97
                self.ktopCalenderIcon.constant  = 99
                self.ktopShadowTextt.constant  = 99
                
            }
            
            //giving border to Profile image
            self.imgView_ProfilePic.layer.cornerRadius = 60.0
            self.imgView_ProfilePic.clipsToBounds = true
            self.tabBarController?.delegate = self
            self.btn_Shadow.layer.cornerRadius = 8.0
            self.btn_Shadow.clipsToBounds = true
            
            //setting border to custom views(Boundaries)
            self.customView(view: self.view_BehindProfile)
            self.customView(view: self.view_BehindNumValues)
            self.customView(view: self.view_BehindOccupation)
            self.customView(view: self.view_BehindDescription)
            
        }
        
        
        if bool_PushComingFromAppDelegate == true {
            
            if  dict_notificationData.value(forKey: "chatDialogId") == nil && dict_notificationData.value(forKey: "dialog_id") == nil {
                
                if dict_notificationData.value(forKey: "requestType") as! String == "Accept" || dict_notificationData.value(forKey: "requestType") as! String == "Send" || dict_notificationData.value(forKey: "requestType") as! String == "Update" || dict_notificationData.value(forKey: "requestType") as! String == "Reject" {
                    
                    
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
        
        
        if bool_FirstTimeLogin == true {
            
            bool_FirstTimeLogin = false
            
            if bool_ComingFromList == false && bool_FromOccupation == false && bool_UserIdComingFromSearch == false {
                
                self.user_IdMyProfile = SavedPreferences.value(forKey: Global.macros.kUserId) as? NSNumber
                self.menuButton.tintColor = UIColor.init(red: 242.0/255.0, green: 105.0/255.0, blue: 78.0/255.0, alpha: 1.0)
                self.menuButton.isEnabled = true
                
                let btn1 = UIButton(type: .custom)
                btn1.setImage(UIImage(named: "orangechat"), for: .normal)
                btn1.frame = CGRect(x: self.view.frame.size.width - 25, y: 0, width: 20, height: 25)
                btn1.addTarget(self, action: #selector(self.chatBtnPressed), for: .touchUpInside)
                let item1 = UIBarButtonItem(customView: btn1)
                
                //Right items
                self.navigationItem.setRightBarButton(item1, animated: true)
                
                self.GetCompanySchoolProfile()
                
            } }
        
        
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
            
            
        }
        
    }
    
    
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        if (touch.view?.isDescendant(of: collection_View))!   {
            return false
        }
        return true
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        
        DispatchQueue.main.async {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationItem.setHidesBackButton(false, animated:true)
        idFromProfileVC = nil
        self.dicUrl.removeAllObjects()
        ratingview_ratingNumber = ""
        bool_ComingFromList = false
        bool_ComingRatingList = false
         bool_OpenProfile = false
            NotificationCenter.default.removeObserver(self) }
        
        
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
            myview.removeFromSuperview()
            
        // Right possition, front view is presented right-offseted by rearViewRevealWidth
        case FrontViewPosition.right:
            print("Right")
            revealViewController().frontViewController.view.addSubview(myview)
            
        case FrontViewPosition.rightMost:
            print("RightMost")
            
            
        case FrontViewPosition.rightMostRemoved:
            print("RightMostRemoved")
            
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        bool_OpenProfile = true
        NotificationCenter.default.addObserver( self,selector: #selector(self.getunreadcountMessages),name: Notification.Name("ProfileVCOpened"), object: nil)
      //   NotificationCenter.default.addObserver( self,selector: #selector(self.Message),name: Notification.Name("Message"), object: nil)
        
        if !QBChat.instance().isConnected {
            
            QBRequest.logIn(withUserLogin: SavedPreferences.value(forKey: "email") as! String, password: "mind@123", successBlock: { (response, user) in
                
                SavedPreferences.setValue(user?.id, forKey: "qb_UserId")
                
                QBChat.instance().connect(with: user!, completion: { (error) in
                    print("Successful connected")
                })
            }, errorBlock: { (response) in
                print("login")
                print("error: \(response.error)")
            })
        }
        
        if self.revealViewController() != nil {
            self.revealViewController().delegate = self
            
            self.menuButton.target = self.revealViewController()
            self.menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
            
            myview.frame = CGRect(x: UIScreen.main.bounds.origin.x, y: self.view.frame.origin.y, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.height)
            // revealViewController().frontViewController.view.addSubview(myview)
            
            let revealController: SWRevealViewController? = revealViewController()
            let tap: UITapGestureRecognizer? = revealController?.tapGestureRecognizer()
            tap?.delegate = self
            myview.addGestureRecognizer(tap!)
        }
        
      
        
        
        if bool_UserIdComingFromSearch == true {            //if coming from search view
            
            DispatchQueue.main.async {
                
                if self.revealViewController() != nil {
                    
                    self.revealViewController().panGestureRecognizer().isEnabled = false
                    self.revealViewController().tapGestureRecognizer().isEnabled = false
                    
                }
                self.tabBarController?.tabBar.isHidden = true
                self.tabBarController?.tabBar.isTranslucent = true
                
                self.navigationController?.setNavigationBarHidden(false, animated: false)
                self.navigationItem.setHidesBackButton(false, animated:true)
                self.CreateNavigationBackBarButton()        //Create custom back button
                self.tabBarController?.tabBar.isHidden = true
                
                
                if self.user_IdMyProfile == nil {
                    self.user_IdMyProfile = self.userIdFromSearch
                }
                
                
                if self.user_IdMyProfile != SavedPreferences.value(forKey: Global.macros.kUserId) as? NSNumber {
                    
                    let btn2 = UIButton(type: .custom)
                    btn2.setImage(UIImage(named: "orangechat"), for: .normal)
                    btn2.frame = CGRect(x: self.view.frame.size.width - 80, y: 0, width: 25, height: 25)
                    btn2.addTarget(self, action: #selector(self.chatBtnPressed), for: .touchUpInside)
                    let item2 = UIBarButtonItem(customView: btn2)
                    self.navigationItem.setRightBarButton(item2, animated: true)
                    
                }
                    
                else {
                    
                    self.btn_Shadow.isHidden = true
                }
                
                self.GetCompanySchoolProfile()
                
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
                
                
                
                
                self.navigationController?.setNavigationBarHidden(false, animated: false)
                self.navigationItem.setHidesBackButton(false, animated:true)
                self.CreateNavigationBackBarButton()        //Create custom back button
                self.tabBarController?.tabBar.isHidden = true
                
                if self.user_IdMyProfile == nil {
                    
                    self.user_IdMyProfile = self.userIdFromList
                    
                    
                }
                
                if self.user_IdMyProfile != SavedPreferences.value(forKey: Global.macros.kUserId) as? NSNumber {
                    
                    
                    let btn2 = UIButton(type: .custom)
                    btn2.setImage(UIImage(named: "orangechat"), for: .normal)
                    btn2.frame = CGRect(x: self.view.frame.size.width - 80, y: 0, width: 25, height: 25)
                    btn2.addTarget(self, action: #selector(self.chatBtnPressed), for: .touchUpInside)
                    let item2 = UIBarButtonItem(customView: btn2)
                    
                    
                    self.navigationItem.setRightBarButton(item2, animated: true)
                    
                }
                    
                else {
                    self.btn_Shadow.isHidden = true
                }
                
                
                self.GetCompanySchoolProfile()
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
                            self.menuButton.tintColor = UIColor.init(red: 242.0/255.0, green: 105.0/255.0, blue: 78.0/255.0, alpha: 1.0)
                            self.menuButton.isEnabled = true
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
                            self.menuButton.tintColor = UIColor.clear
                            self.menuButton.isEnabled = false
                            self.tabBarController?.tabBar.isHidden = true
                            self.tabBarController?.tabBar.isTranslucent = true
                            self.CreateNavigationBackBarButton()
                            
                            
                        }
                        if bool_FirstTimeLogin != false {
                            
                            self.GetCompanySchoolProfile()
                            
                        }
                        
                    }
                        
                    else{
                        
                        self.menuButton.tintColor = UIColor.clear
                        self.menuButton.isEnabled = false
                        self.tabBarController?.tabBar.isHidden = true
                        self.tabBarController?.tabBar.isTranslucent = true
                        
                        
                        let btn2 = UIButton(type: .custom)
                        btn2.setImage(UIImage(named: "orangechat"), for: .normal)
                        btn2.frame = CGRect(x: self.view.frame.size.width - 80, y: 0, width: 25, height: 25)
                        btn2.addTarget(self, action: #selector(self.chatBtnPressed), for: .touchUpInside)
                        
                        let item2 = UIBarButtonItem(customView: btn2)
                        self.navigationItem.setRightBarButton(item2, animated: true)
                        
                        
                        self.CreateNavigationBackBarButton()
                        self.GetCompanySchoolProfile()
                        
                    }
                }
                    
                else{
                    
                    self.user_IdMyProfile = SavedPreferences.value(forKey: Global.macros.kUserId) as? NSNumber
                    self.menuButton.tintColor = UIColor.init(red: 242.0/255.0, green: 105.0/255.0, blue: 78.0/255.0, alpha: 1.0)
                    self.menuButton.isEnabled = true
                    
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
                    self.GetCompanySchoolProfile()
                    
                    
                }
                
            }
        }
        
        DispatchQueue.global(qos: .background).async {
            self.getunreadcountMessages()
        }
    }
    
    //MARK: - Functions
    
//    func Message() {
//        
//     self.showAlert(Message: "check 1", vc: self)
//        verifiedByAdminLoginUser = "true"
//        
//    }
    
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
        }
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
        
        let btn_actionRating = UIButton(type: .custom)
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
        
        let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "ratingView") as! RatingViewController
        vc.userIdForRating = user_IdMyProfile
        _ = self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func customView(view : UIView) {
        
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        view.layer.borderColor = UIColor.init(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 0.5).cgColor
        view.layer.borderWidth = 1.0
        
    }
    
    
    func notificationBtnPressed(sender: AnyObject){
        
        let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "Notifications") as! NotificationsViewController
        _ = self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func chatBtnPressed(sender: AnyObject){
        
        
        if (verifiedByAdminLoginUser?.contains("true"))! || verifiedByAdminLoginUser == "" {
            
            if (self.verifiedByAdmin?.contains("true"))! || self.verifiedByAdmin == ""  {
               
                //****
                
                DispatchQueue.main.async {
                    self.pleaseWait()
                }
                
                
                //  DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                
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
                                        
                                        
                                        if self.qb_id != nil {
                                            
                                            
                                            if (SavedPreferences.value(forKey: "role") as? String) == "SCHOOL" {
                                                
                                                chatDialog.name  = "\(self.str_UserName!)" + "/" + "\(self.user_IdMyProfile!)" + "-" + "\(self.str_roleSchoolCompany!)" + "_" + "\(SavedPreferences.value(forKey: Global.macros.kschoolName)!)" + "/" + "\(SavedPreferences.value(forKey: Global.macros.kUserId)!)" + "-" + "\(SavedPreferences.value(forKey: Global.macros.krole)!)"
                                                
                                                print(chatDialog.name!)
                                            }
                                                
                                            else if (SavedPreferences.value(forKey: "role") as? String) == "USER"  {
                                                
                                                chatDialog.name  = "\(self.str_UserName!)" + "/" + "\(self.user_IdMyProfile!)" + "-" + "\(self.str_roleSchoolCompany!)" + "_" + "\(SavedPreferences.value(forKey: Global.macros.kUserName)!)" + "/" + "\(SavedPreferences.value(forKey: Global.macros.kUserId)!)" + "-" + "\(SavedPreferences.value(forKey: Global.macros.krole)!)"
                                                
                                            }
                                                
                                                
                                                
                                            else{
                                                
                                                chatDialog.name  = "\(self.str_UserName!)" + "/" + "\(self.user_IdMyProfile!)" + "-" + "\(self.str_roleSchoolCompany!)" + "_" + "\(SavedPreferences.value(forKey: Global.macros.kcompanyName)!)" + "/" + "\(SavedPreferences.value(forKey: Global.macros.kUserId)!)" + "-" + "\(SavedPreferences.value(forKey: Global.macros.krole)!)"
                                                
                                            }
                                            
                                            // occupant id
                                            if let myInteger = Int(self.qb_id!) {
                                                let myNumber = NSNumber(value:myInteger)
                                                chatDialog.occupantIDs = [myNumber]
                                                
                                            }
                                            var imageData : Data!
                                            
                                            
                                            if self.img_url != nil  && self.img_url != "" {
                                                
                                                let data = try? Data(contentsOf: URL(string:self.img_url!)!)
                                                self.img_profile = UIImage(data: data!)
                                                imageData = UIImageJPEGRepresentation(self.img_profile! , 0.1) }
                                            else {
                                                
                                                imageData = UIImageJPEGRepresentation(self.imgView_ProfilePic.image! , 0.1)
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
                                                                let str_obb : NSString = NSString(string:str!)
                                                                
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
                                                                
                                                                
                                                                if str1 != "\(SavedPreferences.value(forKey: Global.macros.kUserName)!)" {
                                                                    vc.str_ReceiverName = str_name
                                                                    
                                                                    
                                                                    if let myInteger = Int(str_Id) {
                                                                        let myNumber = NSNumber(value:myInteger)
                                                                        vc.local_otherUserId = myNumber
                                                                        vc.local_roleOtherUser = str_role
                                                                    }
                                                                }
                                                                    
                                                                else if str2 != "\(SavedPreferences.value(forKey: Global.macros.kUserName)!)" {
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
                                                                    
                                                                }}
                                                                
                                                            else {
                                                                DispatchQueue.main.async {
                                                                    self.clearAllNotice()
                                                                    self.showAlert(Message: "Please try again", vc: self)
                                                                    
                                                                } }}
                                                        
                                                        
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
                                                
                                            })} }
                                    
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
                
                
                //*****
                
            }
            else{
                
                self.showAlert(Message: "User are not verified by admin yet.", vc: self)
            }
            
            
        }
        else{
            
            self.showAlert(Message: "You are not verified by admin yet.", vc: self)
        }
        
        
        
        
       
        //    })
    }
    
    func shadowBtnPressed(sender: AnyObject){
        // self.showAlert(Message: "Coming Soon", vc: self)
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
            SavedPreferences.removeObject(forKey: "superAdminAccess")
            SavedPreferences.removeObject(forKey: "qb_UserId")
            SavedPreferences.removeObject(forKey: "user_verified")
            SavedPreferences.removeObject(forKey: "sessionToken")
            SavedPreferences.removeObject(forKey: Global.macros.kUserId)
            dict_userInfo = NSMutableDictionary()
            SavedPreferences.removeObject(forKey: "superAdminAccess")                //value(forKey: "superAdminAccess")
            
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
    
    //MARK: Get Profile Data
    
    func GetCompanySchoolProfile()
    {
        let dict =  NSMutableDictionary()
        dict.setValue(SavedPreferences.value(forKey: Global.macros.kUserId)as! NSNumber, forKey: Global.macros.kUserId)
        dict.setValue(user_IdMyProfile, forKey: "otherUserId")
        
        print(dict)
        if self.checkInternetConnection()
        {
            DispatchQueue.main.async {
                self.pleaseWait()
            }
            
            ProfileAPI.sharedInstance.RetrieveUserProfile(dict: dict, completion: { (response) in
                
                switch response.0
                {
                case 200:
                    DispatchQueue.main.async {
                        
                        if self.user_IdMyProfile == SavedPreferences.value(forKey: Global.macros.kUserId) as? NSNumber {
                            print(self.user_IdMyProfile!)
                            
                            dict_userInfo = response.1
                            print(dictionary_user_Info)
                            
                        }
                        let shadow_Status = (response.1).value(forKey: "otherUsersShadowYou") as? NSNumber
                        SavedPreferences.set(shadow_Status, forKey: Global.macros.kotherUsersShadowYou)
                        array_public_UserSocialSites.removeAll()
                        
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
                        
                        
                        let str =  (response.1).value(forKey: "videoUrl") as? String
                        
                        
                        if str != nil {
                            
                            self.video_url = NSURL(string: str!) as URL?
                        }
                        if (response.1).value(forKey: Global.macros.kbio) as? String
                            != nil && (response.1).value(forKey: Global.macros.kbio) as? String
                            != "" {
                            DispatchQueue.main.async {
                                self.txtView_Description.frame.size.height = self.txtView_Description.intrinsicContentSize.height
                                self.txtView_Description.text = "\((response.1).value(forKey: Global.macros.kbio) as! String)"
                                
                            }
                            // self.txtView_Description.isenable
                            self.lbl_Placeholder_description.isHidden = true
                            
                        }
                        
                       
                            
                            else {
                                DispatchQueue.main.async {
                                    
                                    self.txtView_Description.frame.size.height = self.txtView_Description.intrinsicContentSize.height
                                    self.txtView_Description.text = ""
                                    
                                }
                        }
                        
                       
                        
                        
                        if (response.1).value(forKey: "qbId") != nil {
                            self.qb_id = (response.1).value(forKey: "qbId") as? String
                            print(self.qb_id!)
                        }
                        
                        self.str_roleSchoolCompany = (response.1).value(forKey: Global.macros.krole) as? String
                        
                        //if coming from search class
                        if bool_UserIdComingFromSearch == true{ //opening direct profile
                            
                            // if company
                            if (response.1).value(forKey: Global.macros.krole) as? String == "COMPANY"{
                                
                                //setting titles of labels
                                self.lbl_title__cmpnyschool_withthesesoccupation.text = "School with these occupations"
                                
                                self.lbl_title_Users.text = "Users Employed"
                                
                                // setting company name on direct profile
                                if (response.1).value(forKey: Global.macros.kcompanyName) as? String != nil {
                                    self.navigationItem.title = ((response.1).value(forKey: Global.macros.kcompanyName) as? String)?.capitalized
                                    self.str_UserName  = (response.1).value(forKey: Global.macros.kcompanyName) as? String

                                }
                                
                                //setting company url on direct profile
                                if (response.1).value(forKey: Global.macros.kCompanyURL) as? String != nil &&  (response.1).value(forKey: Global.macros.kCompanyURL) as? String != "" &&  (response.1).value(forKey: Global.macros.kCompanyURL) as? String != " "{
                                    self.btn_LinkOpenSchoolCompany.isHidden = false
                                    
                                    self.lbl_company_schoolUrl.isHidden = false
                                    self.imgView_Url.isHidden = false
                                    self.lbl_company_schoolUrl.text = (response.1).value(forKey: Global.macros.kCompanyURL) as? String
                                    
                                    
                                    
                                    if array_public_UserSocialSites.count > 0 {//social sites not nil
                                        
                                        self.tblView_SocialSites.isHidden = false
                                        
                                        if array_public_UserSocialSites.count == 1 {//social site count 1
                                            
                                            DispatchQueue.main.async {
                                                
                                                self.k_Constraint_Height_tblView.constant = 50.0
                                                self.k_Constraint_ViewDescriptionHeight.constant = self.txtView_Description.intrinsicContentSize.height +  self.k_Constraint_Height_tblView.constant + 84
                                                
                                            }
                                            
                                            
                                        }
                                        else  if array_public_UserSocialSites.count == 2{//social site count 2
                                            DispatchQueue.main.async {
                                                
                                                self.k_Constraint_Height_tblView.constant = 100.0
                                                self.k_Constraint_ViewDescriptionHeight.constant = self.txtView_Description.intrinsicContentSize.height +  self.k_Constraint_Height_tblView.constant + 55
                                            }
                                        }
                                        else{//social site count 3
                                            DispatchQueue.main.async {
                                                
                                                self.k_Constraint_Height_tblView.constant = 150.0
                                                self.k_Constraint_ViewDescriptionHeight.constant = self.txtView_Description.intrinsicContentSize.height +  self.k_Constraint_Height_tblView.constant + 40
                                            } }
                                        
                                        
                                        self.tblView_SocialSites.reloadData()
                                    }
                                    else{//social sites nil
                                        DispatchQueue.main.async {
                                            
                                            self.tblView_SocialSites.isHidden = true
                                            self.k_Constraint_ViewDescriptionHeight.constant = self.txtView_Description.intrinsicContentSize.height + 100
                                        }
                                    }
                                    
                                }
                                else {
                                    self.btn_LinkOpenSchoolCompany.isHidden = true
                                    
                                    self.lbl_company_schoolUrl.isHidden = true
                                    self.imgView_Url.isHidden = true
                                    
                                    
                                    if array_public_UserSocialSites.count > 0{//social sites not nil
                                        self.tblView_SocialSites.isHidden = false
                                        self.k_Constraint_Top_yblView.constant = -25
                                        
                                        if array_public_UserSocialSites.count == 1 {//social site count 1
                                            
                                            DispatchQueue.main.async {
                                                
                                                self.k_Constraint_Height_tblView.constant = 50.0
                                                self.k_Constraint_ViewDescriptionHeight.constant = self.txtView_Description.intrinsicContentSize.height + 120
                                            }
                                            
                                        }
                                        else  if array_public_UserSocialSites.count == 2{//social site count 2
                                            DispatchQueue.main.async {
                                                
                                                self.k_Constraint_Height_tblView.constant = 100.0
                                                self.k_Constraint_ViewDescriptionHeight.constant = self.txtView_Description.intrinsicContentSize.height + 145
                                            }
                                        }
                                        else{//social site count 3
                                            DispatchQueue.main.async {
                                                
                                                self.k_Constraint_Height_tblView.constant = 150.0
                                                self.k_Constraint_ViewDescriptionHeight.constant = self.txtView_Description.intrinsicContentSize.height + 167
                                            } }
                                        
                                        
                                        self.tblView_SocialSites.reloadData()
                                    }
                                    else{//social sites nil
                                        DispatchQueue.main.async {
                                            
                                            self.tblView_SocialSites.isHidden = true
                                            self.k_Constraint_ViewDescriptionHeight.constant = self.txtView_Description.intrinsicContentSize.height + 75
                                        }
                                    }
                                    
                                }
                            }
                            else{
                                
                                
                                //setting titles of labels
                                self.lbl_title__cmpnyschool_withthesesoccupation.text = "Company with these occupations"
                                self.lbl_title_Users.text = "Users attended this school"
                                
                                // setting school name on direct profile
                                if (response.1).value(forKey: Global.macros.kschoolName) as? String != nil  && (response.1).value(forKey: Global.macros.kschoolName) as? String != "" {
                                    
                                    
                                    self.navigationItem.title = ((response.1).value(forKey: Global.macros.kschoolName) as? String)?.capitalized
                                    self.str_SchoolCompany = self.navigationItem.title
                                      self.str_UserName  = (response.1).value(forKey: Global.macros.kschoolName) as? String
                                    
                                }
                                
                                if (response.1).value(forKey: Global.macros.kschoolName) as? String != nil  && (response.1).value(forKey: Global.macros.kcompanyName) as? String != "" {
                                    
                                    
                                    self.navigationItem.title = ((response.1).value(forKey: Global.macros.kcompanyName) as? String)?.capitalized
                                    self.str_SchoolCompany = self.navigationItem.title
                                    self.str_UserName  = (response.1).value(forKey: Global.macros.kcompanyName) as? String

                                    
                                }
                                
                                
                                //setting school url on direct profile
                                if (response.1).value(forKey: Global.macros.kSchoolURL) as? String != nil && (response.1).value(forKey: Global.macros.kSchoolURL) as? String != "" &&  (response.1).value(forKey: Global.macros.kSchoolURL) as? String != " "{
                                    
                                    
                                    self.btn_LinkOpenSchoolCompany.isHidden = false
                                    self.lbl_company_schoolUrl.isHidden = false
                                    self.imgView_Url.isHidden = false
                                    self.lbl_company_schoolUrl.text = (response.1).value(forKey: Global.macros.kSchoolURL) as? String
                                    
                                    if array_public_UserSocialSites.count > 0{//social sites not nil
                                        self.tblView_SocialSites.isHidden = false
                                        
                                        
                                        if array_public_UserSocialSites.count == 1 {//social site count 1
                                            DispatchQueue.main.async {
                                                self.k_Constraint_Height_tblView.constant = 50.0
                                                self.k_Constraint_ViewDescriptionHeight.constant = self.txtView_Description.intrinsicContentSize.height
                                                    + self.k_Constraint_Height_tblView.constant + 80
                                                
                                            }
                                            
                                            
                                            
                                        }
                                        else  if array_public_UserSocialSites.count == 2{//social site count 2
                                            DispatchQueue.main.async {
                                                
                                                self.k_Constraint_Height_tblView.constant = 100.0
                                                self.k_Constraint_ViewDescriptionHeight.constant = self.txtView_Description.intrinsicContentSize.height
                                                    + self.k_Constraint_Height_tblView.constant + 55                                            }
                                        }
                                        else{//social site count 3
                                            DispatchQueue.main.async {
                                                
                                                self.k_Constraint_Height_tblView.constant = 150.0
                                                self.k_Constraint_ViewDescriptionHeight.constant =   self.txtView_Description.intrinsicContentSize.height
                                                    + self.k_Constraint_Height_tblView.constant + 35
                                            }
                                        }
                                        
                                        self.tblView_SocialSites.reloadData()
                                    }
                                    else{//social sites nil
                                        DispatchQueue.main.async {
                                            
                                            self.tblView_SocialSites.isHidden = true
                                            self.k_Constraint_ViewDescriptionHeight.constant = self.txtView_Description.intrinsicContentSize.height
                                                + 100
                                        }
                                    }
                                }
                                    
                                    
                                    
                                else {
                                    
                                    self.btn_LinkOpenSchoolCompany.isHidden = true
                                    
                                    self.lbl_company_schoolUrl.isHidden = true
                                    self.imgView_Url.isHidden = true
                                    
                                    
                                    if array_public_UserSocialSites.count > 0{//social sites not nil
                                        self.tblView_SocialSites.isHidden = false
                                        self.k_Constraint_Top_yblView.constant = -25
                                        
                                        if array_public_UserSocialSites.count == 1 {//social site count 1
                                            DispatchQueue.main.async {
                                                
                                                self.k_Constraint_Height_tblView.constant = 50.0
                                                self.k_Constraint_ViewDescriptionHeight.constant = self.txtView_Description.intrinsicContentSize.height
                                                    + 110
                                                
                                            }
                                        }
                                        else  if array_public_UserSocialSites.count == 2{//social site count 2
                                            DispatchQueue.main.async {
                                                
                                                self.k_Constraint_Height_tblView.constant = 100.0
                                                self.k_Constraint_ViewDescriptionHeight.constant = self.txtView_Description.intrinsicContentSize.height
                                                    + 145
                                                
                                            }
                                        }
                                        else{//social site count 3
                                            DispatchQueue.main.async {
                                                
                                                self.k_Constraint_Height_tblView.constant = 150.0
                                                self.k_Constraint_ViewDescriptionHeight.constant = self.txtView_Description.intrinsicContentSize.height
                                                    + 167
                                            }
                                        }
                                        
                                        self.tblView_SocialSites.reloadData()
                                    }
                                    else{//social sites nil
                                        DispatchQueue.main.async {
                                            
                                            self.tblView_SocialSites.isHidden = true
                                            self.k_Constraint_ViewDescriptionHeight.constant = self.txtView_Description.intrinsicContentSize.height + 75
                                        }
                                        
                                    }
                                }
                            }
                            
                        }       else if bool_ComingFromList == true { //opening direct profile
                            
                            // if company
                            if (response.1).value(forKey: Global.macros.krole) as? String == "COMPANY"{
                                
                                //setting titles of labels
                                self.lbl_title__cmpnyschool_withthesesoccupation.text = "School with these occupations"
                                
                                self.lbl_title_Users.text = "Users Employed"
                                
                                
                                
                                // setting company name on direct profile
                                if (response.1).value(forKey: Global.macros.kcompanyName) as? String != nil {
                                    
                                    self.navigationItem.title = ((response.1).value(forKey: Global.macros.kcompanyName) as? String)?.capitalized
                                    self.str_SchoolCompany = self.navigationItem.title
                                  self.str_UserName  = (response.1).value(forKey: Global.macros.kcompanyName) as? String

                                }
                                
                                //setting company url on direct profile
                                if (response.1).value(forKey: Global.macros.kCompanyURL) as? String != nil &&  (response.1).value(forKey: Global.macros.kCompanyURL) as? String != "" &&  (response.1).value(forKey: Global.macros.kCompanyURL) as? String != " "{
                                    self.btn_LinkOpenSchoolCompany.isHidden = false
                                    
                                    self.lbl_company_schoolUrl.isHidden = false
                                    self.imgView_Url.isHidden = false
                                    self.lbl_company_schoolUrl.text = (response.1).value(forKey: Global.macros.kCompanyURL) as? String
                                    
                                    
                                    
                                    if array_public_UserSocialSites.count > 0{//social sites not nil
                                        self.tblView_SocialSites.isHidden = false
                                        
                                        
                                        if array_public_UserSocialSites.count == 1 {//social site count 1
                                            
                                            DispatchQueue.main.async {
                                                self.k_Constraint_Height_tblView.constant = 50.0
                                                self.k_Constraint_ViewDescriptionHeight.constant = self.txtView_Description.intrinsicContentSize.height +  self.k_Constraint_Height_tblView.constant + 84
                                                
                                            }
                                            
                                            
                                            
                                        }
                                        else  if array_public_UserSocialSites.count == 2{//social site count 2
                                            DispatchQueue.main.async {
                                                
                                                self.k_Constraint_Height_tblView.constant = 100.0
                                                self.k_Constraint_ViewDescriptionHeight.constant = self.txtView_Description.intrinsicContentSize.height +  self.k_Constraint_Height_tblView.constant + 55
                                            }
                                        }
                                        else{//social site count 3
                                            DispatchQueue.main.async {
                                                
                                                self.k_Constraint_Height_tblView.constant = 150.0
                                                self.k_Constraint_ViewDescriptionHeight.constant = self.txtView_Description.intrinsicContentSize.height +  self.k_Constraint_Height_tblView.constant + 40
                                            } }
                                        
                                        
                                        self.tblView_SocialSites.reloadData()
                                    }
                                    else{//social sites nil
                                        DispatchQueue.main.async {
                                            
                                            self.tblView_SocialSites.isHidden = true
                                            self.k_Constraint_ViewDescriptionHeight.constant = self.txtView_Description.intrinsicContentSize.height + 100
                                        }
                                    }
                                    
                                }
                                else {
                                    self.btn_LinkOpenSchoolCompany.isHidden = true
                                    
                                    self.lbl_company_schoolUrl.isHidden = true
                                    self.imgView_Url.isHidden = true
                                    
                                    
                                    if array_public_UserSocialSites.count > 0{//social sites not nil
                                        self.tblView_SocialSites.isHidden = false
                                        self.k_Constraint_Top_yblView.constant = -25
                                        
                                        if array_public_UserSocialSites.count == 1 {//social site count 1
                                            
                                            DispatchQueue.main.async {
                                                
                                                self.k_Constraint_Height_tblView.constant = 50.0
                                                self.k_Constraint_ViewDescriptionHeight.constant = self.txtView_Description.intrinsicContentSize.height + 120
                                            }
                                            
                                        }
                                        else  if array_public_UserSocialSites.count == 2{//social site count 2
                                            DispatchQueue.main.async {
                                                
                                                self.k_Constraint_Height_tblView.constant = 100.0
                                                self.k_Constraint_ViewDescriptionHeight.constant = self.txtView_Description.intrinsicContentSize.height + 145
                                            }
                                        }
                                        else{//social site count 3
                                            DispatchQueue.main.async {
                                                
                                                self.k_Constraint_Height_tblView.constant = 150.0
                                                self.k_Constraint_ViewDescriptionHeight.constant = self.txtView_Description.intrinsicContentSize.height + 167
                                            } }
                                        
                                        
                                        self.tblView_SocialSites.reloadData()
                                    }
                                    else{//social sites nil
                                        DispatchQueue.main.async {
                                            
                                            self.tblView_SocialSites.isHidden = true
                                            self.k_Constraint_ViewDescriptionHeight.constant = self.txtView_Description.intrinsicContentSize.height + 75
                                        }
                                    }
                                    
                                }
                            }
                            else{
                                
                                
                                //setting titles of labels
                                self.lbl_title__cmpnyschool_withthesesoccupation.text = "Company with these occupations"
                                self.lbl_title_Users.text = "Users attended this school"
                                
                                // setting school name on direct profile
                                if (response.1).value(forKey: Global.macros.kschoolName) as? String != nil  && (response.1).value(forKey: Global.macros.kschoolName) as? String != "" {
                                    
                                    
                                    self.navigationItem.title = ((response.1).value(forKey: Global.macros.kschoolName) as? String)?.capitalized
                                    self.str_SchoolCompany = self.navigationItem.title
                                 self.str_UserName  = (response.1).value(forKey: Global.macros.kschoolName) as? String

                                }
                                
                                if (response.1).value(forKey: Global.macros.kschoolName) as? String != nil  && (response.1).value(forKey: Global.macros.kcompanyName) as? String != "" {
                                    
                                    
                                    self.navigationItem.title = ((response.1).value(forKey: Global.macros.kcompanyName) as? String)?.capitalized
                                    self.str_SchoolCompany = self.navigationItem.title
                                    self.str_UserName  = (response.1).value(forKey: Global.macros.kcompanyName) as? String


                                }
                                
                                
                                //setting school url on direct profile
                                if (response.1).value(forKey: Global.macros.kSchoolURL) as? String != nil && (response.1).value(forKey: Global.macros.kSchoolURL) as? String != "" &&  (response.1).value(forKey: Global.macros.kSchoolURL) as? String != " "{
                                    
                                    
                                    self.btn_LinkOpenSchoolCompany.isHidden = false
                                    self.lbl_company_schoolUrl.isHidden = false
                                    self.imgView_Url.isHidden = false
                                    self.lbl_company_schoolUrl.text = (response.1).value(forKey: Global.macros.kSchoolURL) as? String
                                    
                                    if array_public_UserSocialSites.count > 0{//social sites not nil
                                        self.tblView_SocialSites.isHidden = false
                                        
                                        
                                        if array_public_UserSocialSites.count == 1 {//social site count 1
                                            DispatchQueue.main.async {
                                                self.k_Constraint_Height_tblView.constant = 50.0
                                                self.k_Constraint_ViewDescriptionHeight.constant = self.txtView_Description.intrinsicContentSize.height
                                                    + self.k_Constraint_Height_tblView.constant + 80
                                                
                                            }
                                            
                                            
                                            
                                        }
                                        else  if array_public_UserSocialSites.count == 2{//social site count 2
                                            DispatchQueue.main.async {
                                                
                                                self.k_Constraint_Height_tblView.constant = 100.0
                                                self.k_Constraint_ViewDescriptionHeight.constant = self.txtView_Description.intrinsicContentSize.height
                                                    + self.k_Constraint_Height_tblView.constant + 55                                            }
                                        }
                                        else{//social site count 3
                                            DispatchQueue.main.async {
                                                
                                                self.k_Constraint_Height_tblView.constant = 150.0
                                                self.k_Constraint_ViewDescriptionHeight.constant =   self.txtView_Description.intrinsicContentSize.height
                                                    + self.k_Constraint_Height_tblView.constant + 35
                                            }
                                        }
                                        
                                        self.tblView_SocialSites.reloadData()
                                    }
                                    else{//social sites nil
                                        DispatchQueue.main.async {
                                            
                                            self.tblView_SocialSites.isHidden = true
                                            self.k_Constraint_ViewDescriptionHeight.constant = self.txtView_Description.intrinsicContentSize.height
                                                + 100
                                        }
                                    }
                                }
                                    
                                    
                                    
                                else {
                                    
                                    self.btn_LinkOpenSchoolCompany.isHidden = true
                                    
                                    self.lbl_company_schoolUrl.isHidden = true
                                    self.imgView_Url.isHidden = true
                                    
                                    
                                    if array_public_UserSocialSites.count > 0{//social sites not nil
                                        self.tblView_SocialSites.isHidden = false
                                        self.k_Constraint_Top_yblView.constant = -25
                                        
                                        if array_public_UserSocialSites.count == 1 {//social site count 1
                                            DispatchQueue.main.async {
                                                
                                                self.k_Constraint_Height_tblView.constant = 50.0
                                                self.k_Constraint_ViewDescriptionHeight.constant = self.txtView_Description.intrinsicContentSize.height
                                                    + 110
                                                
                                            }
                                        }
                                        else  if array_public_UserSocialSites.count == 2{//social site count 2
                                            DispatchQueue.main.async {
                                                
                                                self.k_Constraint_Height_tblView.constant = 100.0
                                                self.k_Constraint_ViewDescriptionHeight.constant = self.txtView_Description.intrinsicContentSize.height
                                                    + 145
                                                
                                            }
                                        }
                                        else{//social site count 3
                                            DispatchQueue.main.async {
                                                
                                                self.k_Constraint_Height_tblView.constant = 150.0
                                                self.k_Constraint_ViewDescriptionHeight.constant = self.txtView_Description.intrinsicContentSize.height
                                                    + 167
                                            }
                                        }
                                        
                                        self.tblView_SocialSites.reloadData()
                                    }
                                    else{//social sites nil
                                        DispatchQueue.main.async {
                                            
                                            self.tblView_SocialSites.isHidden = true
                                            self.k_Constraint_ViewDescriptionHeight.constant = self.txtView_Description.intrinsicContentSize.height + 75
                                        }
                                        
                                    }
                                }
                            }
                            
                        }
                            
                            
                        else{ //opening direct profile
                            
                            // if company
                          if (response.1).value(forKey: Global.macros.krole) as? String == "COMPANY" {
                                
                                //setting titles of labels
                                self.lbl_title__cmpnyschool_withthesesoccupation.text = "School with these occupations"
                                
                                self.lbl_title_Users.text = "Users Employed"
                                
                                // setting company name on direct profile
                                if (response.1).value(forKey: Global.macros.kcompanyName) as? String != nil {
                                    
                                    self.navigationItem.title = ((response.1).value(forKey: Global.macros.kcompanyName) as? String)?.capitalized
                                    self.str_SchoolCompany = self.navigationItem.title
                                    self.str_UserName  = (response.1).value(forKey: Global.macros.kcompanyName) as? String

                                }
                                
                                //setting company url on direct profile
                                if (response.1).value(forKey: Global.macros.kCompanyURL) as? String != nil &&  (response.1).value(forKey: Global.macros.kCompanyURL) as? String != "" &&  (response.1).value(forKey: Global.macros.kCompanyURL) as? String != " "{
                                    self.btn_LinkOpenSchoolCompany.isHidden = false
                                    
                                    self.lbl_company_schoolUrl.isHidden = false
                                    self.imgView_Url.isHidden = false
                                    self.lbl_company_schoolUrl.text = (response.1).value(forKey: Global.macros.kCompanyURL) as? String
                                    
                                    
                                    if array_public_UserSocialSites.count > 0{//social sites not nil
                                        self.tblView_SocialSites.isHidden = false
                                        
                                        
                                        if array_public_UserSocialSites.count == 1 {//social site count 1
                                            
                                            DispatchQueue.main.async {
                                                self.k_Constraint_Height_tblView.constant = 50.0
                                                self.k_Constraint_ViewDescriptionHeight.constant = self.txtView_Description.intrinsicContentSize.height +  self.k_Constraint_Height_tblView.constant + 84
                                                
                                            }
                                        }
                                        else  if array_public_UserSocialSites.count == 2{//social site count 2
                                            DispatchQueue.main.async {
                                                
                                                self.k_Constraint_Height_tblView.constant = 100.0
                                                self.k_Constraint_ViewDescriptionHeight.constant = self.txtView_Description.intrinsicContentSize.height +  self.k_Constraint_Height_tblView.constant + 55
                                            }
                                        }
                                        else{//social site count 3
                                            DispatchQueue.main.async {
                                                
                                                self.k_Constraint_Height_tblView.constant = 150.0
                                                self.k_Constraint_ViewDescriptionHeight.constant = self.txtView_Description.intrinsicContentSize.height +  self.k_Constraint_Height_tblView.constant + 35
                                            } }
                                        
                                        
                                        self.tblView_SocialSites.reloadData()
                                    }
                                    else{//social sites nil
                                        DispatchQueue.main.async {
                                            
                                            self.tblView_SocialSites.isHidden = true
                                            self.k_Constraint_ViewDescriptionHeight.constant = self.txtView_Description.intrinsicContentSize.height + 100
                                        }
                                    }
                                    
                                }
                                else {
                                    self.btn_LinkOpenSchoolCompany.isHidden = true
                                    
                                    self.lbl_company_schoolUrl.isHidden = true
                                    self.imgView_Url.isHidden = true
                                    
                                    
                                    if array_public_UserSocialSites.count > 0{//social sites not nil
                                        self.tblView_SocialSites.isHidden = false
                                        self.k_Constraint_Top_yblView.constant = -25
                                        
                                        if array_public_UserSocialSites.count == 1 {//social site count 1
                                            
                                            DispatchQueue.main.async {
                                                
                                                self.k_Constraint_Height_tblView.constant = 50.0
                                                self.k_Constraint_ViewDescriptionHeight.constant = self.txtView_Description.intrinsicContentSize.height + 120
                                            }
                                            
                                        }
                                        else  if array_public_UserSocialSites.count == 2{//social site count 2
                                            DispatchQueue.main.async {
                                                
                                                self.k_Constraint_Height_tblView.constant = 100.0
                                                self.k_Constraint_ViewDescriptionHeight.constant = self.txtView_Description.intrinsicContentSize.height + 145
                                            }
                                        }
                                        else{//social site count 3
                                            DispatchQueue.main.async {
                                                
                                                self.k_Constraint_Height_tblView.constant = 150.0
                                                self.k_Constraint_ViewDescriptionHeight.constant = self.txtView_Description.intrinsicContentSize.height + 167
                                            } }
                                        
                                        
                                        self.tblView_SocialSites.reloadData()
                                    }
                                    else{//social sites nil
                                        DispatchQueue.main.async {
                                            
                                            self.tblView_SocialSites.isHidden = true
                                            self.k_Constraint_ViewDescriptionHeight.constant = self.txtView_Description.intrinsicContentSize.height + 75
                                        }
                                    }
                                    
                                }
                            }
                            else{
                                
                                
                                //setting titles of labels
                                self.lbl_title__cmpnyschool_withthesesoccupation.text = "Company with these occupations"
                                self.lbl_title_Users.text = "Users attended this school"
                                
                                
                                
                                // setting school name on direct profile
                                if (response.1).value(forKey: Global.macros.kschoolName) as? String != nil  && (response.1).value(forKey: Global.macros.kschoolName) as? String != "" {
                                    
                                    
                                    self.navigationItem.title = ((response.1).value(forKey: Global.macros.kschoolName) as? String)?.capitalized
                                    self.str_SchoolCompany = self.navigationItem.title
                                    self.str_UserName  = (response.1).value(forKey: Global.macros.kschoolName) as? String


                                }
                                
                                if (response.1).value(forKey: Global.macros.kschoolName) as? String != nil  && (response.1).value(forKey: Global.macros.kcompanyName) as? String != "" {
                                    
                                    
                                    self.navigationItem.title = ((response.1).value(forKey: Global.macros.kcompanyName) as? String)?.capitalized
                                    self.str_SchoolCompany = self.navigationItem.title
                                     self.str_UserName  = (response.1).value(forKey: Global.macros.kcompanyName) as? String

                                    
                                }
                                
                                
                                //setting school url on direct profile
                                if (response.1).value(forKey: Global.macros.kSchoolURL) as? String != nil && (response.1).value(forKey: Global.macros.kSchoolURL) as? String != "" &&  (response.1).value(forKey: Global.macros.kSchoolURL) as? String != " "{
                                    
                                    
                                    self.btn_LinkOpenSchoolCompany.isHidden = false
                                    self.lbl_company_schoolUrl.isHidden = false
                                    self.imgView_Url.isHidden = false
                                    self.lbl_company_schoolUrl.text = (response.1).value(forKey: Global.macros.kSchoolURL) as? String
                                    
                                    if array_public_UserSocialSites.count > 0{//social sites not nil
                                        self.tblView_SocialSites.isHidden = false
                                        
                                        
                                        if array_public_UserSocialSites.count == 1 {//social site count 1
                                            DispatchQueue.main.async {
                                                self.k_Constraint_Height_tblView.constant = 50.0
                                                self.k_Constraint_ViewDescriptionHeight.constant = self.txtView_Description.intrinsicContentSize.height
                                                    + self.k_Constraint_Height_tblView.constant + 80
                                                
                                            }
                                            
                                            
                                            
                                        }
                                        else  if array_public_UserSocialSites.count == 2{//social site count 2
                                            DispatchQueue.main.async {
                                                
                                                self.k_Constraint_Height_tblView.constant = 100.0
                                                self.k_Constraint_ViewDescriptionHeight.constant = self.txtView_Description.intrinsicContentSize.height
                                                    + self.k_Constraint_Height_tblView.constant + 55                                            }
                                        }
                                        else{//social site count 3
                                            DispatchQueue.main.async {
                                                
                                                self.k_Constraint_Height_tblView.constant = 150.0
                                                self.k_Constraint_ViewDescriptionHeight.constant =   self.txtView_Description.intrinsicContentSize.height
                                                    + self.k_Constraint_Height_tblView.constant + 35
                                            }
                                        }
                                        
                                        self.tblView_SocialSites.reloadData()
                                    }
                                    else{//social sites nil
                                        DispatchQueue.main.async {
                                            
                                            self.tblView_SocialSites.isHidden = true
                                            self.k_Constraint_ViewDescriptionHeight.constant = self.txtView_Description.intrinsicContentSize.height
                                                + 100
                                        }
                                    }
                                }
                                    
                                    
                                    
                                else {
                                    
                                    self.btn_LinkOpenSchoolCompany.isHidden = true
                                    
                                    self.lbl_company_schoolUrl.isHidden = true
                                    self.imgView_Url.isHidden = true
                                    
                                    
                                    if array_public_UserSocialSites.count > 0{//social sites not nil
                                        self.tblView_SocialSites.isHidden = false
                                        self.k_Constraint_Top_yblView.constant = -25
                                        
                                        if array_public_UserSocialSites.count == 1 {//social site count 1
                                            DispatchQueue.main.async {
                                                
                                                self.k_Constraint_Height_tblView.constant = 50.0
                                                self.k_Constraint_ViewDescriptionHeight.constant = self.txtView_Description.intrinsicContentSize.height
                                                    + 110
                                                
                                            }
                                        }
                                        else  if array_public_UserSocialSites.count == 2{//social site count 2
                                            DispatchQueue.main.async {
                                                
                                                self.k_Constraint_Height_tblView.constant = 100.0
                                                self.k_Constraint_ViewDescriptionHeight.constant = self.txtView_Description.intrinsicContentSize.height
                                                    + 145
                                                
                                            }
                                        }
                                        else{//social site count 3
                                            DispatchQueue.main.async {
                                                
                                                self.k_Constraint_Height_tblView.constant = 150.0
                                                self.k_Constraint_ViewDescriptionHeight.constant = self.txtView_Description.intrinsicContentSize.height
                                                    + 167
                                            }
                                        }
                                        
                                        self.tblView_SocialSites.reloadData()
                                    }
                                    else{//social sites nil
                                        DispatchQueue.main.async {
                                            
                                            self.tblView_SocialSites.isHidden = true
                                            self.k_Constraint_ViewDescriptionHeight.constant = self.txtView_Description.intrinsicContentSize.height + 75
                                        }
                                        
                                    }
                                }
                            }
                            
                        }
                        
                        
                        let dbl = 2.0
                        self.rating_number = "\((response.1).value(forKey: "avgRating")!)"
                        
                        if self.user_IdMyProfile == SavedPreferences.value(forKey: Global.macros.kUserId) as? NSNumber {
                            verifiedByAdminLoginUser = "\((response.1).value(forKey: "verifiedByAdmin")!)"
                            
                          
                        }
                        else{
                            
                            self.verifiedByAdmin  = "\((response.1).value(forKey: "verifiedByAdmin")!)"
                        }
                        
                        
                        if  dbl.truncatingRemainder(dividingBy: 1) == 0
                        {
                            self.lbl_RatingCount.text = self.rating_number! + ".0"
                            
                        }
                        else {
                            
                            self.lbl_RatingCount.text = self.rating_number!
                            
                        }
                        
                        self.lbl_totalRatingCount.text = "\((response.1).value(forKey: "ratingCount")!)"
                        
                        
                        if self.user_IdMyProfile != SavedPreferences.value(forKey: Global.macros.kUserId) as? NSNumber {
                            var profileurl = (response.1).value(forKey: "profileImageUrl")as? String
                            profileurl = profileurl?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                            ratingview_imgurl = profileurl?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                            
                            if profileurl != nil {
                                self.imgView_ProfilePic.sd_setImage(with: URL(string:profileurl!), placeholderImage: UIImage(named: "profile-icon-1"))//image
                                
                                self.img_url = profileurl
                                
                            }
                        }
                        else {
                            
                            
                            var profileurl = (response.1).value(forKey: "profileImageUrl")as? String
                            profileurl = profileurl?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                            ratingview_imgurlProfile = profileurl?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                            
                            if profileurl != nil {
                                self.imgView_ProfilePic.sd_setImage(with: URL(string:profileurl!), placeholderImage: UIImage(named: "profile-icon-1"))//image
                                
                                self.img_url = profileurl
                                
                            }
                            
                            
                        }
                        
                        if (response.1).value(forKey: Global.macros.klocation) as? String != "" && (response.1).value(forKey: Global.macros.klocation) != nil {
                            
                            if (((response.1).value(forKey: Global.macros.klocation) as? String)?.contains("United States"))! || (((response.1).value(forKey: Global.macros.klocation) as? String)?.contains("USA"))!
                            {
                                let str = (response.1).value(forKey: Global.macros.klocation) as? String
                                let formattedString = str?.replacingOccurrences(of: "   ", with: "")

                                var strArry = formattedString?.components(separatedBy: ",")
                                print(strArry!)
                                strArry?.removeLast()
                                print(strArry!)
                                var tempStr:String = ""
                                for (index,element) in (strArry?.enumerated())!
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
                                    
                                    
                                    self.lbl_company_schoolLocation.text = tempStr
                                    
                                    if bool_ComingFromList == false && bool_UserIdComingFromSearch == false {
                                        if self.user_IdMyProfile == SavedPreferences.value(forKey: Global.macros.kUserId) as? NSNumber {
                                            SavedPreferences.set(self.lbl_company_schoolLocation.text, forKey: "locComSchoolForUser")
                                            
                                        }
                                    }
                                    
                                }
                                
                                print(tempStr)
                                
                            }
                                
                            else {
                                let str = (response.1).value(forKey: Global.macros.klocation) as? String
                                let formattedString = str?.replacingOccurrences(of: "   ", with: "")

                                self.lbl_company_schoolLocation.text = formattedString
                                
                                
                                if bool_ComingFromList == false && bool_UserIdComingFromSearch == false {
                                    if self.user_IdMyProfile == SavedPreferences.value(forKey: Global.macros.kUserId) as? NSNumber {
                                        SavedPreferences.set(self.lbl_company_schoolLocation.text, forKey: "locComSchoolForUser")
                                        
                                    }
                                }
                                
                            }
                            
                            
                        }
                        
                        self.lbl_CountverifiedShadowers.text = (((response.1).value(forKey: "shadowersVerified") as? NSDictionary)?.value(forKey: Global.macros.kcount) as? NSNumber)?.stringValue //shadowersVerified
                        self.lbl_CountshadowedYou.text = "\((response.1).value(forKey: "totalUserCountForCompanyAndSchool")!)"
                        
                        
                        self.lbl_Count_cmpnyschool_withthesesoccupation.text = (((response.1).value(forKey: Global.macros.kschoolCompanyWithTheseOccupations) as? NSDictionary)?.value(forKey: Global.macros.kcount) as? NSNumber)?.stringValue
                        
                        if  self.lbl_Count_cmpnyschool_withthesesoccupation.text == "" ||  self.lbl_Count_cmpnyschool_withthesesoccupation.text == " " || self.lbl_Count_cmpnyschool_withthesesoccupation.text == nil {
                            self.lbl_Count_cmpnyschool_withthesesoccupation.text = "0"
                        }
                        
                        self.lbl_Count_Users.text = (((response.1).value(forKey: Global.macros.kschoolCompanyWithTheseUsers) as? NSDictionary)?.value(forKey: Global.macros.kcount) as? NSNumber)?.stringValue
                        
                        
                        
                        //getting occupations of company or school
                        let tmp_arr_occ = (response.1.value(forKey: Global.macros.koccupation) as? NSArray)?.mutableCopy() as! NSMutableArray
                        
                        for value in tmp_arr_occ{
                            
                            let name_interest = (value as! NSDictionary).value(forKey: "name") as? String
                            let id = (value as! NSDictionary).value(forKey: "occupationTypeId") as? NSNumber
                            
                            let dict = NSMutableDictionary()
                            dict.setValue(name_interest, forKey: "name")
                            dict.setValue(id, forKey: "id")
                            
                            
                            if self.array_UserOccupations.contains(dict) {
                                break
                            }
                            else{
                                self.array_UserOccupations.add(dict)
                                
                            }
                        }
                        
                        if self.array_UserOccupations.count > 0{
                            self.collection_View.isHidden = false
                            self.lbl_NoOccupationYet.isHidden = true
                            self.collection_View.reloadData()
                        }
                        else{
                            self.lbl_NoOccupationYet.isHidden = false
                            self.collection_View.isHidden = true
                        }
                        
                        
//                        if (response.1).value(forKey: Global.macros.kbio) == nil || (response.1).value(forKey: Global.macros.kbio) as? String == "" && self.lbl_company_schoolName.text == "" && self.lbl_company_schoolLocation.text == "" && array_public_UserSocialSites.count == 0 {
//
//
//
//
//                                self.txtView_Description.frame.size.height = self.txtView_Description.intrinsicContentSize.height
//                                self.txtView_Description.text = "No About Me yet."
//                                self.txtView_Description.font = UIFont(name: "Arial", size: 13)
//                                self.txtView_Description.textAlignment = .center
//                                self.txtView_Description.textColor = UIColor.darkGray
//                                self.k_Constraint_ViewDescriptionHeight.constant =  self.k_Constraint_ViewDescriptionHeight.constant + 30
//
//
//                        }
                        
                    }
                case 401:
                    //self.AlertSessionExpire()
                    
                    DispatchQueue.main.async {
                        self.clearAllNotice()}
                    
                    let deviceIdentifier: String = UIDevice.current.identifierForVendor!.uuidString
                    
                    QBRequest.unregisterSubscription(forUniqueDeviceIdentifier: deviceIdentifier, successBlock: { (QBResponse) in
                        
                        
                        self.logout()
                        
                    }, errorBlock: {(err) in
                        DispatchQueue.main.async {
                            self.clearAllNotice()
                            
                        }
                        
                        self.logout()
                        
                    })
                    
                case 400:
                    //self.AlertSessionExpire()
                    
                    DispatchQueue.main.async {
                        self.clearAllNotice()}
                    
                    let deviceIdentifier: String = UIDevice.current.identifierForVendor!.uuidString
                    
                    QBRequest.unregisterSubscription(forUniqueDeviceIdentifier: deviceIdentifier, successBlock: { (QBResponse) in
                        
                        
                        self.logout()
                        
                    }, errorBlock: {(err) in
                        DispatchQueue.main.async {
                            self.clearAllNotice()
                            
                        }
                        
                        self.logout()
                        
                    })
                    
                    
                case 304:
                    
                    let TitleString = NSAttributedString(string: "Shadow", attributes: [
                        NSFontAttributeName : UIFont.systemFont(ofSize: 18),
                        NSForegroundColorAttributeName : Global.macros.themeColor_pink
                        ])
                    let MessageString = NSAttributedString(string: "User does not exist.", attributes: [
                        NSFontAttributeName : UIFont.systemFont(ofSize: 15),
                        NSForegroundColorAttributeName : Global.macros.themeColor_pink
                        ])
                    
                    DispatchQueue.main.async {
                        self.clearAllNotice()
                        
                        let alert = UIAlertController(title: "Shadow", message: "", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action) in
                            
                            _ = self.navigationController?.popViewController(animated: true)
                            
                            
                        }))
                        alert.view.layer.cornerRadius = 10.0
                        alert.view.clipsToBounds = true
                        alert.view.backgroundColor = UIColor.white
                        alert.view.tintColor = Global.macros.themeColor_pink
                        
                        alert.setValue(TitleString, forKey: "attributedTitle")
                        alert.setValue(MessageString, forKey: "attributedMessage")
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                    
                    
                    
                    
                    break
                    
                default:
                    self.showAlert(Message: Global.macros.kError, vc: self)
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
                        else {
                            self.label.isHidden = true
                        }
                        
                    }
                    
                    
                }
                
                
            }, errorBlock: { (QBResponse) in
                
            })
            
            
        }) { (response: QBResponse) -> Void in
            
        }
        
    }
    
    
    func ArrayOfPhotos(data:Data)->(NSArray)
    {
        
        let photos:NSMutableArray = NSMutableArray()
        let photo:NYTExamplePhoto = NYTExamplePhoto()
        photo.imageData = data
        photos.add(photo)
        return photos
        
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
    
    
    func Calender_SearchBtnPressed(sender: AnyObject){
        
        
        let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "send_request") as! SendRequestViewController
        vc.user_Name =  self.navigationItem.title
        vc.userIdFromSendRequest = user_IdMyProfile
        
        if self.lbl_company_schoolLocation.text != nil {
            vc.location_comSchool = self.lbl_company_schoolLocation.text!
            
        }
        _ = self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func calenderBtnPressed(sender: AnyObject){
        
        
        
        let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "MyRequests") as! RequestsListViewController
        vc.user_Name =  self.navigationItem.title
        _ = self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.revealViewController() != nil {
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
    }
    
    
    
    //MARK: - Button Actions
    
    
    @IBAction func Action_OpenRatingView(_ sender: Any) {
        
        
        if self.revealViewController() != nil {
            self.revealViewController().rightRevealToggle(animated: false)
        }
        
        
        
        DispatchQueue.main.async {
            
            if self.user_IdMyProfile == SavedPreferences.value(forKey: Global.macros.kUserId) as? NSNumber {
                
                if self.lbl_totalRatingCount.text != "0"{
                    
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
    
    
    @IBAction func Action_Shadow(_ sender: UIButton) {
        
        if self.user_IdMyProfile == SavedPreferences.value(forKey: Global.macros.kUserId) as? NSNumber   {
            
            let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "MyRequests") as! RequestsListViewController
            vc.user_Name =  self.navigationItem.title
            _ = self.navigationController?.pushViewController(vc, animated: true) }
            
        else{
            
        
            
            
//            if (verifiedByAdminLoginUser?.contains("true"))! {
//
//                if (self.verifiedByAdmin?.contains("true"))! {
                    let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "send_request") as! SendRequestViewController
                    vc.user_Name =  self.navigationItem.title
                    vc.userIdFromSendRequest = user_IdMyProfile
                    
                    if self.lbl_company_schoolLocation.text != nil {
                        vc.location_comSchool = self.lbl_company_schoolLocation.text!
                        
                    }
                    _ = self.navigationController?.pushViewController(vc, animated: true)
                    
//                }
//                else{
//
//                    self.showAlert(Message: "User is not verified by admin yet.", vc: self)
//                }
            
                
//            }
//            else{
//
//                self.showAlert(Message: "You are not verified by admin yet.", vc: self)
//            }
            
            
            
        }
        
    }
    
    @IBAction func Action_OpenCompaniesSchoolList(_ sender: UIButton) {
        
    }
    
    
    @IBAction func Open_ProfileImage(_ sender: UIButton) {
        if self.revealViewController() != nil {
            self.revealViewController().rightRevealToggle(animated: false)
        }
        
        //    else {
        Global.macros.statusBar.isHidden = true
        let imgdata = UIImageJPEGRepresentation(imgView_ProfilePic.image!, 0.5)
        let photos = self.ArrayOfPhotos(data: imgdata!)
        let vc: NYTPhotosViewController = NYTPhotosViewController(photos: photos as? [NYTPhoto])
        vc.rightBarButtonItem = nil
        self.present(vc, animated: true, completion: nil)
        // }
    }
    
    @IBAction func PlayVideo(_ sender: UIButton) {
        
        DispatchQueue.main.async {
            
            let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "Upload_Video") as! UploadViewController
            
            
            
            
            if self.video_url != nil {
                
                bool_PlayFromProfile = true
                bool_VideoFromGallary = false
                
                DispatchQueue.main.async {
                    
                    vc.video_urlProfile   =  self.video_url
                    self.navigationController?.setNavigationBarHidden(true, animated: false)
                    self.navigationItem.setHidesBackButton(true, animated:true)
                    self.tabBarController?.tabBar.isHidden = true
                    self.present(vc, animated: true, completion: nil)
                    
                }
            }
            else {
                
                self.showAlert(Message: "No video to play yet.", vc: self)
                
            }
        }
    }
    
    @IBAction func ActionSocialMedia1(_ sender: UIButton) {
        
        SetWebViewUrl (index: 0)
    }
    
    @IBAction func ActionSocialMedia2(_ sender: UIButton) {
        
        SetWebViewUrl (index: 1)
    }
    
    @IBAction func ActionSocialMedia3(_ sender: UIButton) {
        
        SetWebViewUrl (index: 2)
    }
    
    
    @IBAction func action_OpenList(_ sender: UIButton) {
        
        
        if self.revealViewController() != nil {
            self.revealViewController().rightRevealToggle(animated: false)
        }
        
        //  else {
        //   if bool_UserIdComingFromSearch == false {
        
        var type:String?
        var navigation_title:String?
        
        
        if sender.tag == 0{//shadowers
            
            type = Global.macros.kShadow
            navigation_title =  "Shadowed Me"
            
        }else if sender.tag == 1{//shadowed
            
            type = Global.macros.kVerifyUsers
            navigation_title = "Verified Users"
            
            
        }else if sender.tag == 2{//occupations
            
            type = Global.macros.k_Occupation
            navigation_title = "Users with these Occupations"
            
            
        }
        else {//users
            
            type = Global.macros.k_User
            navigation_title = "Users List"
            
            
        }
        
        
        let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "listing") as! ListingViewController
        vc.type = type
        vc.ListuserId = self.user_IdMyProfile
        vc.navigation_title = navigation_title
        _ = self.navigationController?.pushViewController(vc, animated: true)
        
        
        //  }
    }
    
    
    @IBAction func Action_LinkOpenSchoolCompany(_ sender: UIButton) {
        
        if let checkURL = NSURL(string: lbl_company_schoolUrl.text!) {
            if  UIApplication.shared.openURL(checkURL as URL){
                print("URL Successfully Opened")
            }
            else {
                print("Invalid URL")
            }
        } else {
            print("Invalid URL")
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK: - Class Extensions

extension ComapanySchoolViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    
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
        
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "skill", for: indexPath)as! SkillsNInterestCollectionViewCell
        
        if array_UserOccupations.count > 0 {
            
            cell.lbl_Skill.text = (array_UserOccupations[indexPath.row]as! NSDictionary).value(forKey: "name")as? String
            
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        var count:Int?
        count = array_UserOccupations.count
        
        if count! <= 2 {
            self.kheightViewBehindOccupation.constant = 100
            
        }
            
            
        else if count == 4 {
            
            self.kheightViewBehindOccupation.constant = 160
            
        }
        else {
            
            //  self.kheightViewBehindOccupation.constant = CGFloat(count! * 32) + CGFloat(18)
            DispatchQueue.main.async {
                self.kHeightCollectionView.constant = self.collection_View.contentSize.height
                self.kheightViewBehindOccupation.constant = self.collection_View.contentSize.height + 30
                
            }
        }
        
        if Global.DeviceType.IS_IPHONE_5 {
            
            if count == 3 {
                
                self.kheightViewBehindOccupation.constant = 160
                
            }
            
        }
        
        DispatchQueue.main.async {
            
            self.Scroll_View.contentSize = CGSize(width: self.view.frame.size.width, height:  self.k_Constraint_ViewDescriptionHeight.constant + self.kheightViewBehindOccupation.constant + 400)
        }
        return count!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if self.revealViewController() != nil {
            self.revealViewController().rightRevealToggle(animated: false)
        }
        
        //  else {
        
        let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "OccupationDetail") as! OccupationDetailViewController
        vc.occupationId = (array_UserOccupations[indexPath.row] as! NSDictionary)["id"]! as? NSNumber
        _ = self.navigationController?.pushViewController(vc, animated: true)
        //    }
        
        
    }
    
    
}

extension ComapanySchoolViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array_public_UserSocialSites.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UserProfileSocialSiteTableViewCell
        
        cell.imgView_UserSocialSite.image = (array_public_UserSocialSites[indexPath.row] as NSDictionary).value(forKey: "image") as? UIImage
        
        let site_url = (array_public_UserSocialSites[indexPath.row] as NSDictionary).value(forKey: "url") as? String
        
        let site = (array_public_UserSocialSites[indexPath.row] as NSDictionary).value(forKey: "name_url") as? String
        
        switch (site!){
        case "facebookUrl":
            //https://www.facebook.com/ 25
            if (site_url?.contains("https://www.facebook.com/"))!{
                let index = site_url?.index((site_url?.startIndex)!, offsetBy: 25)
                cell.lbl_UserSocialSite.text = site_url?.substring(from: index!)
            }else
            {
                cell.lbl_UserSocialSite.text = site_url!
            }
            break
            
        case "linkedInUrl":
            //https://www.linkedin.com/ 25
            if (site_url?.contains("https://www.linkedin.com/"))!{
                
                let index = site_url?.index((site_url?.startIndex)!, offsetBy: 25)
                cell.lbl_UserSocialSite.text = site_url?.substring(from: index!)
            }else{
                cell.lbl_UserSocialSite.text = site_url!
                
            }
            break
            
            
        case "instagramUrl":
            //https://www.instagram.com/ 26
            if (site_url?.contains("https://www.instagram.com/"))!{
                let index = site_url?.index((site_url?.startIndex)!, offsetBy: 26)
                cell.lbl_UserSocialSite.text = site_url?.substring(from: index!)
            }else{
                cell.lbl_UserSocialSite.text = site_url!
            }
            break
            
            
        case "googlePlusUrl":
            //https://www.googleplus.com/ 27
            if (site_url?.contains("https://www.googleplus.com/"))!{
                
                let index = site_url?.index((site_url?.startIndex)!, offsetBy: 27)
                cell.lbl_UserSocialSite.text = site_url?.substring(from: index!)
            }else{
                cell.lbl_UserSocialSite.text = site_url!
                
            }
            break
            
            
        case "gitHubUrl":
            //https://www.github.com/ 23
            if (site_url?.contains("https://www.github.com/"))!{
                
                let index = site_url?.index((site_url?.startIndex)!, offsetBy: 23)
                cell.lbl_UserSocialSite.text = site_url?.substring(from: index!)
            }else{
                cell.lbl_UserSocialSite.text = site_url!
            }
            break
            
            
        case "twitterUrl":
            //https://www.twitter.com/ 24
            if (site_url?.contains("https://www.twitter.com/"))!{
                
                let index = site_url?.index((site_url?.startIndex)!, offsetBy: 24)
                cell.lbl_UserSocialSite.text = site_url?.substring(from: index!)
            }else{
                cell.lbl_UserSocialSite.text = site_url!
            }
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
            
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 28
    }
}

extension ComapanySchoolViewController:UITabBarControllerDelegate{
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        bool_ComingRatingList = false
        
        if self.revealViewController() != nil {
            self.revealViewController().rightRevealToggle(animated: false)
        }
        
        if tabBarController.selectedIndex == 0{
            if self.revealViewController() != nil {
                self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
                self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
                
            }
        }
    }
}
