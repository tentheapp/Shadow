//
//  EditProfileViewController.swift
//  Shadow
//
//  Created by Atinderjit Kaur on 02/06/17.
//  Copyright © 2017 Atinderjit Kaur. All rights reserved.
//

import UIKit
import GooglePlaces
import GooglePlacePicker
import RSKImageCropper
import MobileCoreServices
import AVKit
import AVFoundation

var dict_userInfo:NSDictionary = NSDictionary()

class EditProfileViewController: UIViewController, GMSAutocompleteViewControllerDelegate{
    
    
    @IBOutlet weak var img_PlusIconProfile:    UIImageView!
    @IBOutlet var scroll_view:                 UIScrollView!
    @IBOutlet weak var imgView_Profile:        UIImageView!
    @IBOutlet weak var txtview_Description:    UITextView!
    @IBOutlet weak var lbl_PlaceholderTxtview: UILabel!
    @IBOutlet weak var view_PickerView:        UIView!
    @IBOutlet var pickerView_SchoolOccupation: UIPickerView!
    @IBOutlet var view_BlurrView:              UIView!
    @IBOutlet var view_Skills:                 UIView!
    @IBOutlet var search_Bar:                  UISearchBar!
    @IBOutlet var tblView_MySkills:            UITableView!
    @IBOutlet var tblView_ActualSkills:        UITableView!
    @IBOutlet var lbl_SchoolCompanyName:       UILabel!
    @IBOutlet var txfield_SchoolName:          UITextField!
    @IBOutlet var txtfield_Location:           UITextField!
    @IBOutlet var txtfield_SchoolName:         UITextField!
    @IBOutlet var txtfield_Url:                UITextField!
    @IBOutlet var lbl_SchoolCompanyUrl:        UILabel!
    @IBOutlet var btn_SchoolComanyName:        UIButton!
    @IBOutlet var collection_View_Occupation:  UICollectionView!
    @IBOutlet var tblView_SocialSites:         UITableView!
    @IBOutlet var view_tableViews_SocialSites: UIView!
    @IBOutlet var search_Bar_SocialSites:      UISearchBar!
    @IBOutlet var tblView_UserSites:           UITableView!
    @IBOutlet var tblView_ActualSocialSites:   UITableView!
    @IBOutlet var k_contraint_ViewFields_Height: NSLayoutConstraint!
    @IBOutlet var btn_Done_Occupations:        UIButton!
    @IBOutlet weak var btn_Done_SocialSite:    UIButton!
    @IBOutlet var view_Behind_ImgviewProfile:  UIView!
    @IBOutlet var view_Behind_Fields:          UIView!
    @IBOutlet var view_Behind_txtview_Description: UIView!
    @IBOutlet var view_Behind_Occupations:      UIView!
    @IBOutlet var k_Constraint_ViewTxtview_Top: NSLayoutConstraint!
    @IBOutlet weak var lbl_Counter:             UILabel!
    
    @IBOutlet weak var lbl_noOccupation:        UILabel!
    @IBOutlet weak var kheightViewBehindOccupation: NSLayoutConstraint!
    @IBOutlet weak var kheightCollection_View: NSLayoutConstraint!
    
    //MARK: - Variables
    fileprivate var arrsearchActualOccupation : NSMutableArray = NSMutableArray()
    fileprivate var temp_arrOccupation :        NSMutableArray = NSMutableArray()
    fileprivate var array_ActualOccupations:    NSMutableArray = NSMutableArray()
    fileprivate var array_UserOccupations:      NSMutableArray = NSMutableArray()
    fileprivate var array_Schools:NSMutableArray = NSMutableArray()
    
    fileprivate var array_ActualSocialSites = [
        ["name":"Facebook","name_url":"facebookUrl","image":UIImage(named:"facebookUrl")!,"url":"" ],
        ["name":"LinkedIn","name_url":"linkedInUrl","image":UIImage(named:"linkedInUrl")!,"url":""],
        ["name":"Twitter","name_url":"twitterUrl","image":UIImage(named: "twitterUrl")!,"url":"" ],
        ["name":"gitHub","name_url":"gitHubUrl","image":UIImage(named: "gitHubUrl")!,"url":""],
        ["name":"Google+","name_url":"googlePlusUrl","image":UIImage(named: "googlePlusUrl")!,"url":""],
        ["name":"Instagram","name_url":"instagramUrl","image":UIImage(named: "instagramUrl")!,"url":""]]
    
    fileprivate let array_urls = ["https://www.facebook.com/",
                                  "https://www.linkedin.com/",
                                  "https://www.twitter.com/",
                                  "https://www.github.com/",
                                  "https://www.googleplus.com/",
                                  "https://www.instagram.com/"]
    
    fileprivate var array_UserSocialSites =  [[String:Any]]()// = NSMutableArray()
    fileprivate var str_profileImage:        String?
    fileprivate var str_latitude:            String =    ""
    fileprivate var str_longitude:           String =   ""
    fileprivate var sender_Tag:              Int?
    var dict_Url:NSMutableDictionary =       NSMutableDictionary()//from previous view(social sites url)
    fileprivate var Save =                   UIButton()
    var bool_SelectImage :                   Bool = false
    var searchTextField:                     UITextField!
    
    //MARK: - View default Methods
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Creating back button
        let myBackButton:UIButton = UIButton()
        myBackButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        myBackButton.setImage(UIImage(named:"back-new"), for: UIControlState())
        myBackButton.addTarget(self, action: #selector(self.PopToProfile), for: UIControlEvents.touchUpInside)
        let leftBackBarButton:UIBarButtonItem = UIBarButtonItem(customView: myBackButton)
        self.navigationItem.leftBarButtonItem = leftBackBarButton
        
        DispatchQueue.main.async {
            
            self.imgView_Profile.layer.cornerRadius = 60.0
            self.imgView_Profile.clipsToBounds = true
            
            //setting borders
            self.customView(view: self.view_Behind_ImgviewProfile)
            self.customView(view: self.view_Behind_Fields)
            self.customView(view: self.view_Behind_txtview_Description)
            self.customView(view: self.view_Behind_Occupations)
            
            self.tblView_SocialSites.layer.cornerRadius = 4
            self.tblView_SocialSites.clipsToBounds = true
            self.tblView_SocialSites.layer.borderColor = UIColor.init(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 0.5).cgColor
            self.tblView_SocialSites.layer.borderWidth = 1.0
            
            //Save navigation bar button
            self.Save = UIButton(type: .custom)
            self.Save.setImage(UIImage(named: "upload-icon"), for: .normal)
            self.Save.frame = CGRect(x: self.view.frame.size.width - 25, y: 0, width: 25, height: 25)
            self.Save.addTarget(self, action: #selector(self.saveProfile), for: .touchUpInside)
            let item1 = UIBarButtonItem(customView: self.Save)
            self.navigationItem.setRightBarButtonItems([item1], animated: true)
            
            //getiing occupations of company or school
            if dict_userInfo.count > 0 {
                let tmp_arr_occ = (dict_userInfo.value(forKey: Global.macros.koccupation) as? NSArray)?.mutableCopy() as! NSMutableArray
                
                for value in tmp_arr_occ{
                    
                    let name_interest = (value as! NSDictionary).value(forKey: "name") as? String
                    let dict = NSMutableDictionary()
                    dict.setValue(name_interest, forKey: "name")
                    if self.array_UserOccupations.contains(dict) {  //checking if array already have that item
                        break
                    }
                    else{
                        self.array_UserOccupations.add(dict)
                    }}
            }
            if self.array_UserOccupations.count  > 0{
                self.collection_View_Occupation.reloadData()
            }
            else {
                self.lbl_noOccupation.isHidden = false
            }
            
            if self.bool_SelectImage == false {
                
                //setting profile pic
                let profileurl = dict_userInfo.value(forKey: "profileImageUrl")as? String
                if profileurl != nil {
                    self.imgView_Profile.sd_setImage(with: URL(string:profileurl!), placeholderImage: UIImage(named: "profile-icon-1"))//image
                    self.img_PlusIconProfile.isHidden = true
                }
            }
            
            //setting user social sites
            print(array_public_UserSocialSites)
            self.array_UserSocialSites = array_public_UserSocialSites
            
            //setting table view height according to array count
            if self.array_UserSocialSites.count > 0 {
                
                var name1:String?
                for value in self.array_UserSocialSites{
                    
                    let temp_dict = value as NSDictionary
                    name1 = temp_dict.value(forKey: "name") as? String
                    
                    for (idx,val) in self.array_ActualSocialSites.enumerated(){
                        
                        let dict = val as NSDictionary
                        let name2 = dict.value(forKey: "name") as? String
                        
                        if name2 == name1 {
                            
                            self.array_ActualSocialSites.remove(at: idx)
                            break
                            
                        }}}
                
                self.tblView_SocialSites.isHidden = false
                self.tblView_SocialSites.isScrollEnabled = false
                
                if self.array_UserSocialSites.count == 1{
                    
                    self.k_Constraint_ViewTxtview_Top.constant = 45.0
                    self.k_contraint_ViewFields_Height.constant = 290.0
                    
                }
                else if self.array_UserSocialSites.count == 2{
                    
                    self.k_Constraint_ViewTxtview_Top.constant = 80.0
                    self.k_contraint_ViewFields_Height.constant = 328.0
                    
                }
                else if self.array_UserSocialSites.count == 3{
                    
                    self.k_Constraint_ViewTxtview_Top.constant = 115.0
                    self.k_contraint_ViewFields_Height.constant = 360.0
                    
                }
                self.tblView_SocialSites.reloadData()
                
            } else{
                
                self.tblView_SocialSites.isHidden = true
                self.k_Constraint_ViewTxtview_Top.constant = 9.0
                self.k_contraint_ViewFields_Height.constant = 262.0
                
            }
            
            
            if dict_userInfo.value(forKey: Global.macros.kbio) as? String == "" || dict_userInfo.value(forKey: Global.macros.kbio) as? String == nil{
                self.lbl_PlaceholderTxtview.isHidden = false
            }
            else {
                self.lbl_PlaceholderTxtview.isHidden = true
                self.txtview_Description.text = dict_userInfo.value(forKey: Global.macros.kbio) as? String
                
            }
            
            
            //setting data according to role
            let role = SavedPreferences.value(forKey: Global.macros.krole) as? String
            if role == "COMPANY"{
                
                self.title = (dict_userInfo.value(forKey: Global.macros.kcompanyName) as? String)?.capitalized
                
                self.lbl_SchoolCompanyName.text = "Company Name:"
                self.btn_SchoolComanyName.isHidden = true
                self.lbl_SchoolCompanyUrl.text  = "Company URL:"
                self.txtfield_SchoolName.text = (dict_userInfo.value(forKey: Global.macros.kcompanyName) as? String)?.capitalized
                
                if dict_userInfo.value(forKey: Global.macros.kCompanyURL) as? String == " "{
                    self.txtfield_Url.text = ""
                }else{
                    self.txtfield_Url.text = dict_userInfo.value(forKey: Global.macros.kCompanyURL) as? String
                }
                
            }else{
                
                self.title = (dict_userInfo.value(forKey: Global.macros.kschoolName) as? String)?.capitalized
                
                self.lbl_SchoolCompanyName.text = "School Name:"
                self.btn_SchoolComanyName.isHidden = true
                self.lbl_SchoolCompanyUrl.text  = "School URL:"
                self.txtfield_SchoolName.text = (dict_userInfo.value(forKey: Global.macros.kschoolName) as? String)?.capitalized
                self.txtfield_Url.text = dict_userInfo.value(forKey: Global.macros.kSchoolURL) as? String
                
                
                if dict_userInfo.value(forKey: Global.macros.kSchoolURL) as? String == " "{
                    self.txtfield_Url.text = ""
                }else{
                    self.txtfield_Url.text = dict_userInfo.value(forKey: Global.macros.kSchoolURL) as? String
                }
                
            }
            
            if dict_userInfo.count > 0 {
                if ((dict_userInfo.value(forKey: Global.macros.klocation) as? String)!.contains("United States")) || ((dict_userInfo.value(forKey: Global.macros.klocation) as? String)!.contains("USA"))
                {
                    let str = dict_userInfo.value(forKey: Global.macros.klocation) as? String
                    
                    var strArry = str?.components(separatedBy: ",")
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
                        self.txtfield_Location.text = tempStr
                        
                    }
                    print(tempStr)
                }
                else {
                    self.txtfield_Location.text = dict_userInfo.value(forKey: Global.macros.klocation) as? String
                }
                
            }
            
            //social site done button
            self.btn_Done_SocialSite.layer.cornerRadius = 5.0
            self.btn_Done_SocialSite.layer.borderWidth = 1.0
            self.btn_Done_SocialSite.layer.borderColor = Global.macros.themeColor_pink.cgColor
            
            self.CustomBorder(searchbar : self.search_Bar)
            
            //for Occupation
            self.tblView_MySkills.tableFooterView = UIView()
            self.tblView_ActualSkills.tableFooterView = UIView()
            
            self.btn_Done_Occupations.layer.cornerRadius = 5.0
            self.btn_Done_Occupations.layer.borderWidth = 1.0
            self.btn_Done_Occupations.layer.borderColor = Global.macros.themeColor_pink.cgColor
            
            
            self.view_Skills.layer.cornerRadius = 8.0
            self.view_Skills.clipsToBounds = true
            self.view_Skills.layer.borderColor = UIColor.init(red: 104.0/255.0, green: 112.0/255.0, blue: 115.0/255.0, alpha: 1.0).cgColor//Global.macros.themeColor_pink.cgColor
            self.view_Skills.layer.borderWidth = 1.0
            self.tblView_MySkills.layer.cornerRadius = 5.0
            self.tblView_MySkills.clipsToBounds = true
            self.tblView_ActualSkills.layer.cornerRadius = 5.0
            self.tblView_ActualSkills.clipsToBounds = true
            
            self.tblView_ActualSkills.layer.borderWidth = 1.0
            self.tblView_ActualSkills.layer.borderColor = UIColor.init(red: 104.0/255.0, green: 112.0/255.0, blue: 115.0/255.0, alpha: 1.0).cgColor// Global.macros.themeColor_pink.cgColor
            self.tblView_MySkills.layer.borderWidth = 1.0
            self.tblView_MySkills.layer.borderColor = UIColor.init(red: 104.0/255.0, green: 112.0/255.0, blue: 115.0/255.0, alpha: 1.0).cgColor// Global.macros.themeColor_pink.cgColor
            
            self.tblView_MySkills.delegate = self
            self.tblView_MySkills.dataSource = self
            self.tblView_ActualSkills.delegate = self
            self.tblView_ActualSkills.dataSource = self
            
            //social sites table in main view
            self.tblView_SocialSites.delegate = self
            self.tblView_SocialSites.dataSource = self
            
            //social sites tables in social view
            self.tblView_UserSites.tableFooterView = UIView()
            self.tblView_ActualSocialSites.tableFooterView = UIView()
            
            self.view_tableViews_SocialSites.layer.cornerRadius = 5.0
            self.view_tableViews_SocialSites.clipsToBounds = true
            self.view_tableViews_SocialSites.layer.borderColor = UIColor.init(red: 104.0/255.0, green: 112.0/255.0, blue: 115.0/255.0, alpha: 1.0).cgColor//Global.macros.themeColor_pink.cgColor
            self.view_tableViews_SocialSites.layer.borderWidth = 1.0
            self.tblView_ActualSocialSites.layer.cornerRadius = 5.0
            self.tblView_ActualSocialSites.clipsToBounds = true
            self.tblView_UserSites.layer.cornerRadius = 5.0
            self.tblView_UserSites.clipsToBounds = true
            
            self.tblView_UserSites.layer.borderWidth = 1.0
            self.tblView_UserSites.layer.borderColor = UIColor.init(red: 104.0/255.0, green: 112.0/255.0, blue: 115.0/255.0, alpha: 1.0).cgColor//Global.macros.themeColor_pink.cgColor
            self.tblView_ActualSocialSites.layer.borderWidth = 1.0
            self.tblView_ActualSocialSites.layer.borderColor = UIColor.init(red: 104.0/255.0, green: 112.0/255.0, blue: 115.0/255.0, alpha: 1.0).cgColor//Global.macros.themeColor_pink.cgColor
            
        }
        
        let tap = UITapGestureRecognizer()
        self.view_BlurrView.addGestureRecognizer(tap)
        tap.delegate = self
        
        
        DispatchQueue.global(qos: .background).async {
            self.getallOccupation()
        }
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        bool_VideoFromGallary = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Arial Rounded MT Bold", size: 16.0)!];
        
        
        bool_SelectVideoFromGallary = false
        Global.macros.statusBar.isHidden = false
        
        self.navigationController?.navigationItem.hidesBackButton = true
        self.tabBarController?.tabBar.isHidden = true
        
        
        if bool_VideoFromGallary == true {
            self.showAlert(Message: "Please select video of minimum 10 seconds.", vc: self)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    
    //MARK: - FUNCTIONS
    
    func PopToProfile()
    {
        DispatchQueue.main.async {
            self.view.endEditing(true)
            let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "SWRevealViewController")as!  SWRevealViewController
            Global.macros.kAppDelegate.window?.rootViewController = vc
            
        }
    }
    
    
    func customView(view : UIView) {
        
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        view.layer.borderColor = UIColor.init(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 0.5).cgColor
        view.layer.borderWidth = 1.0
    }
    
    
    func CustomBorder(searchbar : UISearchBar){
        
        if let textFieldInsideSearchBar = searchbar.value(forKey: "searchField") as? UITextField,
            let glassIconView = textFieldInsideSearchBar.leftView as? UIImageView {
            
            //Magnifying glass
            glassIconView.frame = CGRect(x: 40, y: glassIconView.frame.origin.y , width: 16, height: 16)
            glassIconView.tintColor = UIColor.purple
            textFieldInsideSearchBar.layer.borderColor = UIColor.darkGray.cgColor
            textFieldInsideSearchBar.layer.cornerRadius = 6.0
            textFieldInsideSearchBar.layer.borderWidth = 1.0
        }
        
        searchTextField = searchbar.subviews[0].subviews.last as! UITextField
        searchTextField.layer.cornerRadius = 15
        searchTextField.textAlignment = NSTextAlignment.left
        let image:UIImage = UIImage(named: "customsearch")!
        let imageView:UIImageView = UIImageView.init(image: image)
        searchTextField.leftView = imageView
        
        searchTextField.attributedPlaceholder = NSAttributedString(string: "Search",attributes: [NSForegroundColorAttributeName: Global.macros.themeColor_pink])
        searchTextField.leftViewMode = UITextFieldViewMode.always
        
    }
    
    func takeNewPhotoFromCamera()
    {
        if UIImagePickerController.isSourceTypeAvailable(.camera)
        {
            let controller = UIImagePickerController()
            controller.sourceType = .camera
            controller.allowsEditing = false
            controller.delegate = self
            Global.macros.statusBar.isHidden = true
            
            self.navigationController?.present(controller, animated: true, completion: nil)
            
        }
    }
    
    func choosePhotoFromExistingImages()
    {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
        {
            let controller = UIImagePickerController()
            controller.sourceType = .savedPhotosAlbum
            controller.allowsEditing = false
            controller.delegate = self
            
            self.navigationController!.present(controller, animated: true, completion: { _ in })
            
        }
    }
    
    func getallOccupation(){
        
        let dict = NSMutableDictionary()
        
        dict.setValue(SavedPreferences.value(forKey: Global.macros.kUserId)as! NSNumber, forKey: Global.macros.kUserId)
        
        if checkInternetConnection(){
            
            DispatchQueue.main.async {
                // self.pleaseWait()
                
                ServerCall.sharedInstance.postService({ (response) in
                    print(response!)
                    
                    //self.clearAllNotice()
                    let status =  ((response as! NSDictionary).value(forKey: "status")) as! NSNumber
                    
                    switch(status){
                        
                    case 200:
                        self.array_ActualOccupations.removeAllObjects()
                        self.array_ActualOccupations = ((((response as! NSDictionary).value(forKey: "data") as! NSDictionary).value(forKey: "occupations") as! NSArray).mutableCopy() as? NSMutableArray)!
                        
                        var name1:String?
                        if self.array_UserOccupations.count > 0{
                            
                            for value in self.array_UserOccupations {
                                
                                let temp_dict = value as! NSDictionary
                                name1 = temp_dict.value(forKey: "name") as? String
                                
                                for (idx,val) in self.array_ActualOccupations.enumerated(){
                                    
                                    let dict = val as! NSDictionary
                                    let name2 = dict.value(forKey: "name") as? String
                                    
                                    if name2 == name1 {
                                        self.array_ActualOccupations.removeObject(at: idx)
                                        break
                                        
                                    }}}}
                        
                        self.arrsearchActualOccupation = self.array_ActualOccupations.mutableCopy() as! NSMutableArray
                        DispatchQueue.main.async {
                            self.tblView_ActualSkills.reloadData()
                        }
                        break
                    default:
                        break
                        
                    }
                    
                }, error_block: { (error) in
                    
                    DispatchQueue.main.async {
                        //self.clearAllNotice()
                        self.showAlert(Message: Global.macros.kError, vc: self)
                    }
                    
                }, paramDict: dict, is_synchronous: false, url: Global.macros.api_getoccupation)
            }
            
        }else{
            self.showAlert(Message: Global.macros.kInternetConnection, vc: self)
        }
    }
    
    
    func lat_long(string:String){
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(string, completionHandler: {
            
            (placemark,error) -> Void in
            
            if (error != nil) {
                
                print("Error" + (error?.localizedDescription)!)
                self.showAlert(Message: "Invalid address.Can't find your location.", vc: self)
            }
                
            else if (placemark?.count)! > 0 {
                let pl = (placemark?.last)! as CLPlacemark
                let numLat = NSNumber(value: (pl.location?.coordinate.latitude)! as Double)
                self.str_latitude = numLat.stringValue
                let numLong = NSNumber(value: (pl.location?.coordinate.longitude)! as Double)
                self.str_longitude = numLong.stringValue
                print("latitude:\(latitude) longitude:\(longitude)")
            }
                
            else{
                
                self.showAlert(Message: "Can't find your location.Try again later.", vc: self)
            }
        })
    }
    
    func hit_EditProfile(dict:NSMutableDictionary)  {
        
        self.view.endEditing(true)
        if checkInternetConnection(){//companyName
            
            DispatchQueue.main.async{
                
                self.pleaseWait()
            }
            ServerCall.sharedInstance.postService({ (response) in
                //print(response!)
                
                let status = (response as! NSDictionary).value(forKey: "status") as? NSNumber
                switch Int(status!){
                    
                case 200:
                    
                    DispatchQueue.main.async{
                        self.clearAllNotice()
                    }
                    DispatchQueue.main.async{
                        
                        
                        let tempDict = (response as! NSDictionary).value(forKey: "data")as! NSDictionary
                        
                        if tempDict.value(forKey: "profileImageUrl") != nil {
                            
                            let updateUserParams = QBUpdateUserParameters()
                            updateUserParams.customData = tempDict.value(forKey: "profileImageUrl") as? String
                            
                            QBRequest.updateCurrentUser(updateUserParams, successBlock: {(_ response: QBResponse, _ user: QBUUser?) -> Void in
                                // User updated successfully
                                
                                print("success")
                                
                            }, errorBlock: {(_ response: QBResponse) -> Void in
                                
                                print(response)
                                
                            })
                            
                            
                            
                        }
                        
                        
                        if  SavedPreferences.value(forKey: Global.macros.krole) as? String == "COMPANY" {
                            
                            SavedPreferences.set(self.txtfield_SchoolName.text!, forKey: Global.macros.kcompanyName)
                        }
                        
                        let TitleString = NSAttributedString(string: "Shadow", attributes: [
                            NSFontAttributeName : UIFont.systemFont(ofSize: 18),
                            NSForegroundColorAttributeName : Global.macros.themeColor_pink
                            ])
                        let MessageString = NSAttributedString(string: "Profile has been updated successfully.", attributes: [
                            NSFontAttributeName : UIFont.systemFont(ofSize: 15),
                            NSForegroundColorAttributeName : Global.macros.themeColor_pink
                            ])
                        
                        let alert = UIAlertController(title: "Shadow", message: "Profile has been updated successfully.", preferredStyle: .alert)
                        
                        alert.view.layer.cornerRadius = 10.0
                        alert.view.clipsToBounds = true
                        alert.view.backgroundColor = UIColor.white
                        alert.view.tintColor = Global.macros.themeColor_pink
                        
                        alert.setValue(TitleString, forKey: "attributedTitle")
                        alert.setValue(MessageString, forKey: "attributedMessage")
                        
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {
                            
                            
                            (action) in
                            let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "SWRevealViewController")as!  SWRevealViewController
                            Global.macros.kAppDelegate.window?.rootViewController = vc
                            
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                    break
                    
                case 401:
                    DispatchQueue.main.async{
                        self.clearAllNotice()
                        self.AlertSessionExpire()
                        
                    }
                    break
                    
                case 226:
                    DispatchQueue.main.async{
                        self.showAlert(Message: "Company already exist in system.", vc: self)
                    }
                    break
                    
                default:
                    DispatchQueue.main.async{
                        self.clearAllNotice()
                        self.showAlert(Message: Global.macros.kError, vc: self)
                    }
                    break
                }
                
                
            }, error_block: { (error) in
                DispatchQueue.main.async {
                    self.clearAllNotice()
                    self.showAlert(Message: Global.macros.kError, vc: self)
                }
                
                
            }, paramDict: dict, is_synchronous: false, url: "editProfile")
            
        }else{
            self.showAlert(Message: Global.macros.kInternetConnection, vc: self)
        }
        
    }
    
    func saveProfile(){
        
        
        let dict = NSMutableDictionary()
        dict.setValue(SavedPreferences.value(forKey: Global.macros.kUserId)as! NSNumber, forKey: Global.macros.kUserId)
        dict.setValue(str_profileImage, forKey: Global.macros.kprofileImage)
        
        let role = SavedPreferences.value(forKey: Global.macros.krole) as? String
        if role == "COMPANY"{
            
            let trimmedString = txtfield_SchoolName.text!.trimmingCharacters(in: .whitespacesAndNewlines)

            //checking if company name is same or not
            if  ( trimmedString.caseInsensitiveCompare("\( SavedPreferences.value(forKey: Global.macros.kcompanyName)!)".capitalized ) != ComparisonResult.orderedSame) {
//            if txtfield_SchoolName.text! != SavedPreferences.value(forKey: Global.macros.kcompanyName) as? String
//            {
                dict.setValue(trimmedString, forKey: Global.macros.kcompanyName)
            }
            
            if self.txtfield_Url.text != "" {
                dict.setValue(self.txtfield_Url.text!, forKey: Global.macros.kCompanyURL)
            }else{
                dict.setValue(" ", forKey: Global.macros.kCompanyURL)
                
            }
            
        }else if role == "SCHOOL"{
            
            dict.setValue(self.txtfield_SchoolName.text!, forKey: Global.macros.kschoolName)
            
            if self.txtfield_Url.text != "" {
                dict.setValue(self.txtfield_Url.text!, forKey: Global.macros.kSchoolURL)
                
            }else{
                dict.setValue(" ", forKey: Global.macros.kSchoolURL)
                
            }
        }
        dict.setValue(self.txtfield_Location.text!, forKey: Global.macros.klocation)
        dict.setValue(self.txtview_Description.text!, forKey: Global.macros.kbio)
        dict.setValue(array_UserOccupations, forKey: Global.macros.koccupation)
        
        if array_UserSocialSites.count > 0{
            for value in array_UserSocialSites{
                
                let temp_d = value as NSDictionary
                let url = temp_d.value(forKey: "url") as? String
                let n = temp_d.value(forKey: Global.macros.kname) as? String
                
                print(url!)
                
                if n == "Facebook"
                {
                    let final_url:String?
                    if (url?.contains(self.array_urls[0]))!{
                        final_url = url!
                    }else{
                        final_url = "\(self.array_urls[0])\(url!)"
                    }
                    dict.setValue(final_url!, forKey: Global.macros.kfacebookURL)
                }
                else if n == "LinkedIn"
                {
                    
                    let final_url:String?
                    if (url?.contains(self.array_urls[1]))!{
                        final_url = url!
                    }else{
                        final_url = "\(self.array_urls[1])\(url!)"
                    }
                    
                    dict.setValue(final_url!, forKey: Global.macros.klinkedInURL)
                }
                else if n == "Twitter"
                {
                    
                    let final_url:String?
                    if (url?.contains(self.array_urls[2]))!{
                        final_url = url!
                    }else{
                        final_url = "\(self.array_urls[2])\(url!)"
                    }
                    
                    dict.setValue(final_url!, forKey: Global.macros.ktwitterURL)
                }
                else if n == "gitHub"
                {
                    let final_url:String?
                    if (url?.contains(self.array_urls[3]))!{
                        final_url = url!
                    }else{
                        final_url = "\(self.array_urls[3])\(url!)"
                    }
                    dict.setValue(final_url!, forKey: Global.macros.kgitHubURL)
                }
                else if n == "Google+"
                {
                    
                    let final_url:String?
                    if (url?.contains(self.array_urls[4]))!{
                        final_url = url!
                    }else{
                        final_url = "\(self.array_urls[4])\(url!)"
                    }
                    dict.setValue(final_url!, forKey: Global.macros.kgooglePlusURL)
                }
                else if n == "Instagram"
                {
                    let final_url:String?
                    if (url?.contains(self.array_urls[5]))!{
                        final_url = url!
                    }else{
                        final_url = "\(self.array_urls[5])\(url!)"
                    }
                    dict.setValue(final_url!, forKey: Global.macros.kinstagramURL)
                }
                
            }
        }
        
        print(dict)
        
        if self.txtfield_Url.text! != ""{
            
            if self.verifyUrl(urlString: self.txtfield_Url.text!){
                if array_UserSocialSites.count > 0{
                    
                    for value in  array_UserSocialSites{
                        
                        let dic = value
                        if (dic["url"] as? String)?.characters.count != 0 && (dic["url"] as? String) != nil {
                            
                            self.hit_EditProfile(dict: dict)
                            
                        }
                        else{
                            self.showAlert(Message: "Please fill url.", vc: self)
                            break
                        }
                    }
                }
                else{
                    self.hit_EditProfile(dict: dict)
                }
            }
            else{
                
                if role == "COMPANY" {
                    self.showAlert(Message: "Please fill valid company url.", vc: self)
                }else{
                    
                    self.showAlert(Message: "Please fill valid school url.", vc: self)
                    
                }
                
            }
        }
        else{
            
            if array_UserSocialSites.count > 0{
                
                for value in  array_UserSocialSites{
                    
                    let dic = value
                    
                    print(dic)
                    if ((dic["url"] as? String)?.characters.count)! != 0 && (dic["url"] as? String) != nil {
                        
                        self.hit_EditProfile(dict: dict)
                        
                    }
                    else{
                        self.showAlert(Message: "Please fill url.", vc: self)
                        break
                    }
                }
            }
            else{
                self.hit_EditProfile(dict: dict)
                
            }
        }
        
        
    }
    
    
    //MARK: - BUTTON ACTIONS
    
    @IBAction func Action_SelectProfile(_ sender: Any) {
        
        self.view.endEditing(true)
        ///calling UIAction Sheet
        let actionSheet1 = UIAlertController(title: "Choose Photo", message: nil, preferredStyle: .actionSheet)
        
        actionSheet1.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction) -> Void in
            // take photo button tapped.
            self.takeNewPhotoFromCamera()
        }))
        actionSheet1.addAction(UIAlertAction(title: "Gallery", style: .default, handler: {(action: UIAlertAction) -> Void in
            // choose photo button tapped.
            self.choosePhotoFromExistingImages()
        }))
        actionSheet1.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: {(action: UIAlertAction) -> Void in
            // Destructive button tapped.
            
        }))
        DispatchQueue.main.async {
            self.present(actionSheet1, animated: true, completion: { _ in })
        }
    }
    
    
    @IBAction func Action_RecordVideo(_ sender: Any) {
        self.view.endEditing(true)
        
        DispatchQueue.main.async {
            let MessageString = NSAttributedString(string: "Choose Video", attributes: [
                NSFontAttributeName : UIFont.systemFont(ofSize: 20),
                NSForegroundColorAttributeName : UIColor.black
                ])
            
            self.clearAllNotice()
            
            let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Gallery", style: UIAlertActionStyle.default, handler: {(action) in
                
                
                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary){
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
                    imagePicker.mediaTypes = [kUTTypeMovie as String]
                    imagePicker.videoMaximumDuration = 1.00
                    Global.macros.statusBar.backgroundColor = UIColor.white
                    UIApplication.shared.statusBarStyle = .default
                    
                    imagePicker.allowsEditing = false
                    self.present(imagePicker, animated: true, completion: nil)
                    bool_SelectVideoFromGallary = true
                    
                }
                
            }))
            alert.addAction(UIAlertAction(title: "Camera", style: UIAlertActionStyle.default, handler: {(action) in
                
                bool_PlayFromProfile = false
                let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "CameraView") as! CameraViewController
                self.present(vc, animated: true, completion: nil)
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: {(action) in
                
            }))
            
            alert.view.layer.cornerRadius = 10.0
            alert.view.clipsToBounds = true
            alert.view.backgroundColor = UIColor.white
            alert.view.tintColor = Global.macros.themeColor_pink
            alert.setValue(MessageString, forKey: "attributedMessage")
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    
    @IBAction func Action_SelectSchool(_ sender: UIButton) {
        self.view.endEditing(true)
        sender_Tag = sender.tag
    }
    
    
    @IBAction func Action_AddOccupation(_ sender: UIButton) {
        
        DispatchQueue.global(qos: .background).async {
            
            self.getallOccupation()
            
            DispatchQueue.main.async {
                
                self.view.endEditing(true)
                self.view_BlurrView.isHidden = false
                self.view_Skills.isHidden = false
                self.view_tableViews_SocialSites.isHidden = true
                self.view.bringSubview(toFront:  self.view_BlurrView)
                self.view.bringSubview(toFront:  self.view_Skills)
                self.Save.isUserInteractionEnabled = false
                self.tblView_ActualSkills.reloadData()
                self.tblView_MySkills.reloadData()
                
            }
        }
    }
    
    
    @IBAction func Action_Done_Occupation(_ sender: UIButton) {
        
        self.view.endEditing(true)
        self.Save.isUserInteractionEnabled = true
        self.view_BlurrView.isHidden = true
        self.view_Skills.isHidden = true
        self.search_Bar.text = ""
        self.collection_View_Occupation.reloadData()
        
    }
    
    
    @IBAction func Action_MySkillsMinus(_ sender: UIButton) {
        
        self.view.endEditing(true)
        let value = array_UserOccupations[sender.tag]
        array_UserOccupations.removeObject(at: sender.tag)
        array_ActualOccupations.insert(value, at: 0)
        tblView_ActualSkills.reloadData()
        tblView_MySkills.reloadData()
    }
    
    @IBAction func Action_ActualSkillsPlus(_ sender: UIButton) {
        
        
        self.view.endEditing(true)
        let value = array_ActualOccupations[sender.tag]
        array_ActualOccupations.removeObject(at: sender.tag)
        array_UserOccupations.insert(value, at: 0)
        tblView_ActualSkills.reloadData()
        tblView_MySkills.reloadData()
        
    }
    
    @IBAction func Action_DonePickerview(_ sender: UIButton) {
        self.view.endEditing(true)
        view_PickerView.isHidden = true
    }
    
    @IBAction func Action_CancelPickerview(_ sender: UIButton) {
        self.view.endEditing(true)
        view_PickerView.isHidden = true
    }
    
    @IBAction func Action_SocialSites(_ sender: UIButton) {
        self.view.endEditing(true)
        
        self.view_BlurrView.isHidden = false
        self.view_tableViews_SocialSites.isHidden = false
        self.view_Skills.isHidden = true
        
        self.view.bringSubview(toFront:  self.view_BlurrView)
        self.view.bringSubview(toFront:  self.view_tableViews_SocialSites)
        self.Save.isUserInteractionEnabled = false
        
        self.tblView_UserSites.reloadData()
        self.tblView_ActualSocialSites.reloadData()
        
        
    }
    
    @IBAction func Action_Done_SocialSites(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        self.view_BlurrView.isHidden = true
        self.view_tableViews_SocialSites.isHidden = true
        self.Save.isUserInteractionEnabled = true
        
        
        if array_UserSocialSites.count > 0 {
            
            tblView_SocialSites.isHidden = false
            tblView_SocialSites.isScrollEnabled = false
            
            if array_UserSocialSites.count == 1{
                self.k_Constraint_ViewTxtview_Top.constant = 45.0
                self.k_contraint_ViewFields_Height.constant = 290.0
            }
            else if array_UserSocialSites.count == 2{
                self.k_Constraint_ViewTxtview_Top.constant = 80.0
                self.k_contraint_ViewFields_Height.constant = 325.0
            }
            else if array_UserSocialSites.count == 3{
                
                self.k_Constraint_ViewTxtview_Top.constant = 115.0
                self.k_contraint_ViewFields_Height.constant = 360.0
                
            }
            self.tblView_SocialSites.reloadData()
        }else{
            
            self.tblView_SocialSites.isHidden = true
            self.k_Constraint_ViewTxtview_Top.constant = 9.0
            self.k_contraint_ViewFields_Height.constant = 262.0
            
        }
    }
    
    
    //MARK: - Google Location Delegate
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        if place.formattedAddress != nil && "\(String(describing: place.formattedAddress))" != "" {
            
            txtfield_Location.text =  "\(String(describing: place.formattedAddress!))"

        }
        else{
            txtfield_Location.text =  "\(place.name)"

            
        }
        
        
       // txtfield_Location.text =  "\(place.name)" + " " + "\(String(describing: place.formattedAddress))"
        self.lat_long(string: "\(place.name)")
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        //handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}




//MARK: - CLASS EXTENSIONS

extension EditProfileViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate,RSKImageCropViewControllerDelegate{
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        Global.macros.statusBar.backgroundColor = UIColor.white
        UIApplication.shared.statusBarStyle = .default
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        if image != nil {
            Global.macros.statusBar.isHidden = false
            
            picker.dismiss(animated: false, completion: { () -> Void in
                
                var imageCropVC : RSKImageCropViewController!
                
                imageCropVC = RSKImageCropViewController(image: image!, cropMode: RSKImageCropMode.circle)
                
                
                
                imageCropVC.delegate = self
                
                self.navigationController?.pushViewController(imageCropVC, animated: true)
                
            })
        }
        else {
            
            
            let tempImage = info[UIImagePickerControllerMediaURL] as! URL!
            let pathString = tempImage?.relativePath
            
            
            if(pathString != "")
            {
                DispatchQueue.main.async {
                    bool_VideoFromGallary = true
                    bool_PlayFromProfile = false
                    let url_video=URL(fileURLWithPath: pathString! as String)
                    
                    //
                    
                    var path_String = pathString! as NSString
                    let asset: AVAsset = AVAsset(url: url_video)
                    
                    var durationInSeconds: TimeInterval = 0.0
                    durationInSeconds = CMTimeGetSeconds(asset.duration)
                    
                    if durationInSeconds <= 10.0 {
                        DispatchQueue.main.async {
                            bool_VideoIsOfShortLength = true
                            picker.dismiss(animated: true, completion: nil)
                            
                        }
                        
                    }
                    else {
                        
                        let imageGenerator = AVAssetImageGenerator(asset: asset);
                        //
                        imageGenerator.appliesPreferredTrackTransform = true
                        let time = CMTimeMakeWithSeconds(0.0, 600)
                        
                        var actualTime : CMTime = CMTimeMake(0, 1)
                        //        var error : NSError?
                        let myImage:CGImage? = (try? imageGenerator.copyCGImage(at: time, actualTime: &actualTime))
                        
                        let snapshot = UIImage(cgImage: myImage!)
                        thumbnail = snapshot
                        
                        let avassest:AVURLAsset=AVURLAsset(url: URL(fileURLWithPath: (path_String as? String)!), options: nil)
                        let compatiblepreset:NSArray=AVAssetExportSession.exportPresets(compatibleWith: avassest) as NSArray
                        let exportsession:AVAssetExportSession=AVAssetExportSession(asset: avassest, presetName: AVAssetExportPresetHighestQuality)!
                        
                        let formatter:DateFormatter=DateFormatter()
                        formatter.dateFormat = "dd-MM-yyyy-HH-mm-ss"
                        path_String = NSHomeDirectory().appending("/Documents/output-\(formatter.string(from: NSDate() as Date)).mov") as NSString
                        // self.videodelegate.videoplayerpath=NSHomeDirectory() + "/Documents/output-\(formatter.string(from: Date())).mp4"
                        exportsession.outputURL=URL(fileURLWithPath: path_String as String)
                        exportsession.outputFileType = AVFileTypeMPEG4;
                        exportsession.exportAsynchronously(completionHandler: { () -> Void in
                            switch (exportsession.status)
                            {
                            case AVAssetExportSessionStatus.failed:
                                //print("error is  \(exportsession.error)")
                                
                                break;
                                
                            case AVAssetExportSessionStatus.cancelled:
                                
                                NSLog("Export canceled");
                                
                                break;
                                
                            case AVAssetExportSessionStatus.completed:
                                
                                NSLog("Successful! %@",path_String);
                                
                                
                                
                                path_String=path_String.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) as NSString
                                
                                NSLog("after triming = %@",  path_String);
                                
                                
                                break;
                                
                            default:
                                
                                break;
                                
                            }
                            
                            let url1=URL(fileURLWithPath: path_String as String)
                            
                            DispatchQueue.main.async {
                                let videodata:Data?=try! Data(contentsOf: url1)
                                
                                let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "Upload_Video") as! UploadViewController
                                vc.videoPath = path_String as String
                                vc.video_urlProfile = url_video
                                picker.pushViewController(vc, animated: true)
                            }
                        })
                    }}}}}
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
        _ =  self.navigationController?.popViewController(animated: true)
        
    }
    func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect) {
        
        self.bool_SelectImage = true
        let imageData = UIImageJPEGRepresentation(croppedImage , 0.1)
        let resultiamgedata = imageData!.base64EncodedData(options: NSData.Base64EncodingOptions.lineLength64Characters)
        self.str_profileImage = (NSString(data: resultiamgedata, encoding: String.Encoding.utf8.rawValue) as String?)!
        self.img_PlusIconProfile.isHidden = true
        self.imgView_Profile.image = croppedImage
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    
}

extension EditProfileViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count = Int()
        
        if tableView == tblView_MySkills{
            count = array_UserOccupations.count
        }
            
        else if tableView == tblView_ActualSkills{
            count = array_ActualOccupations.count
        }
            //on main view
        else if tableView == tblView_SocialSites{
            count = array_UserSocialSites.count
        }
            //on social sites table view
        else if tableView == tblView_UserSites{
            count = array_UserSocialSites.count
            
        }
        else if tableView == tblView_ActualSocialSites{
            count = array_ActualSocialSites.count
            
        }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell!
        
        //Occupation view tables
        if tableView == tblView_MySkills {
            
            let Myskill_cell = tableView.dequeueReusableCell(withIdentifier: "tableView1", for: indexPath)as! MySkillsTableViewCell
            Myskill_cell.DataOfMySkills(dict: (self.array_UserOccupations[indexPath.row]as! NSDictionary ))
            cell = Myskill_cell
        }
        
        if tableView == self.tblView_ActualSkills {
            
            let Actualskill_cell  = tableView.dequeueReusableCell(withIdentifier: "tableView2", for: indexPath) as! ActualSkillsTableViewCell
            Actualskill_cell.DataOfActualSkills(dict:(self.array_ActualOccupations[indexPath.row] as! NSDictionary ))
            cell = Actualskill_cell
        }
        
        //For social sites
        //On MAIN VIEW
        if tableView == self.tblView_SocialSites {
            
            let Socialsites_cell  = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SocialSitesTableViewCell
            
            Socialsites_cell.imgView_SocialSites.image = (array_UserSocialSites[indexPath.row] as NSDictionary).value(forKey: "image") as? UIImage
            
            let site_url = (array_UserSocialSites[indexPath.row] as NSDictionary).value(forKey: "url") as? String
            
            let site = (array_UserSocialSites[indexPath.row] as NSDictionary).value(forKey: "name_url") as? String
            
            print(site_url!)
            switch (site!){
            case "facebookUrl":
                //https://www.facebook.com/ 25
                
                if (site_url?.contains("https://www.facebook.com/"))!{
                    let index = site_url?.index((site_url?.startIndex)!, offsetBy: 25)
                    Socialsites_cell.txtfield_SocialSiteUrl.text = site_url?.substring(from: index!)
                }
                else{
                    Socialsites_cell.txtfield_SocialSiteUrl.text = site_url!
                }
                
                break
                
            case "linkedInUrl":
                //https://www.linkedin.com/ 25
                
                
                if (site_url?.contains("https://www.linkedin.com/"))!{
                    let index = site_url?.index((site_url?.startIndex)!, offsetBy: 25)
                    Socialsites_cell.txtfield_SocialSiteUrl.text = site_url?.substring(from: index!)
                }
                else{
                    Socialsites_cell.txtfield_SocialSiteUrl.text = site_url!
                }
                
                break
                
                
            case "instagramUrl":
                //https://www.instagram.com/ 26
                
                
                if (site_url?.contains("https://www.instagram.com/"))!{
                    let index = site_url?.index((site_url?.startIndex)!, offsetBy: 26)
                    Socialsites_cell.txtfield_SocialSiteUrl.text = site_url?.substring(from: index!)
                }
                else{
                    Socialsites_cell.txtfield_SocialSiteUrl.text = site_url!
                }
                
                break
                
                
            case "googlePlusUrl":
                //https://www.googleplus.com/ 27
                
                
                if (site_url?.contains("https://www.googleplus.com/"))!{
                    let index = site_url?.index((site_url?.startIndex)!, offsetBy: 27)
                    Socialsites_cell.txtfield_SocialSiteUrl.text = site_url?.substring(from: index!)
                }
                else{
                    Socialsites_cell.txtfield_SocialSiteUrl.text = site_url!
                }
                
                break
                
            case "gitHubUrl":
                //https://www.github.com/ 23
                
                
                if (site_url?.contains("https://www.github.com/"))!{
                    let index = site_url?.index((site_url?.startIndex)!, offsetBy: 23)
                    Socialsites_cell.txtfield_SocialSiteUrl.text = site_url?.substring(from: index!)
                }
                else{
                    Socialsites_cell.txtfield_SocialSiteUrl.text = site_url!
                }
                
                break
                
                
            case "twitterUrl":
                //https://www.twitter.com/ 24
                
                if (site_url?.contains("https://www.twitter.com/"))!{
                    let index = site_url?.index((site_url?.startIndex)!, offsetBy: 24)
                    Socialsites_cell.txtfield_SocialSiteUrl.text = site_url?.substring(from: index!)
                }
                else{
                    Socialsites_cell.txtfield_SocialSiteUrl.text = site_url!
                }
                
                break
                
            default:
                break
            }
            
            Socialsites_cell.txtfield_SocialSiteUrl.tag = indexPath.row
            cell = Socialsites_cell
        }
        
        if tableView == self.tblView_UserSites {
            
            let UserSites_cell  = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! UserSocialSitesTableViewCell
            UserSites_cell.lbl_UserSocialSites.text = (array_UserSocialSites[indexPath.row] as NSDictionary).value(forKey: "name") as? String
            UserSites_cell.img_View_UserSocialSites.image = (array_UserSocialSites[indexPath.row] as NSDictionary).value(forKey: "image") as? UIImage
            
            cell = UserSites_cell
        }
        
        
        if tableView == self.tblView_ActualSocialSites {
            
            let ActualSocialSites  = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! ActualSocialSitesTableViewCell
            ActualSocialSites.lbl_UserSocialSites.text = (array_ActualSocialSites[indexPath.row] as NSDictionary).value(forKey: "name") as? String
            ActualSocialSites.img_View_UserSocialSites.image = (array_ActualSocialSites[indexPath.row] as NSDictionary).value(forKey: "image") as? UIImage
            cell = ActualSocialSites
        }
        
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Social Sites Tables
        if tableView == tblView_ActualSocialSites{
            
            if array_UserSocialSites.count < 3{
                
                let value = array_ActualSocialSites[indexPath.row]
                array_ActualSocialSites.remove(at: indexPath.row)
                array_UserSocialSites.insert(value, at: 0)
                tblView_ActualSocialSites.reloadData()
                tblView_UserSites.reloadData()
                
            }
        }
            
        else if tableView == tblView_UserSites{
            
            let value = array_UserSocialSites[indexPath.row]
            array_UserSocialSites.remove(at: indexPath.row)
            array_ActualSocialSites.insert(value , at: 0)
            tblView_ActualSocialSites.reloadData()
            tblView_UserSites.reloadData()
            
        }
            
            //Occupations
        else if tableView == tblView_MySkills{
            
            let value = array_UserOccupations[indexPath.row]
            array_UserOccupations.removeObject(at: indexPath.row)
            array_ActualOccupations.insert(value , at: 0)
            self.arrsearchActualOccupation = self.array_ActualOccupations.mutableCopy() as! NSMutableArray
            tblView_MySkills.reloadData()
            tblView_ActualSkills.reloadData()
            
        }
        else if tableView == tblView_ActualSkills{
            
            let value = array_ActualOccupations[indexPath.row]
            array_ActualOccupations.removeObject(at: indexPath.row)
            array_UserOccupations.insert(value, at: 0)
            self.arrsearchActualOccupation = self.array_ActualOccupations.mutableCopy() as! NSMutableArray
            tblView_MySkills.reloadData()
            tblView_ActualSkills.reloadData()
            
        }
    }
}



extension EditProfileViewController:UIGestureRecognizerDelegate
{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        
        self.view.endEditing(true)
        self.Save.isUserInteractionEnabled = true
        
        self.view_BlurrView.isHidden = true
        self.view_Skills.isHidden = true
        self.view_tableViews_SocialSites.isHidden = true
        self.collection_View_Occupation.reloadData()
        self.search_Bar.text = ""
        
        if array_UserSocialSites.count > 0 {
            
            tblView_SocialSites.isHidden = false
            tblView_SocialSites.isScrollEnabled = false
            
            if array_UserSocialSites.count == 1{
                self.k_Constraint_ViewTxtview_Top.constant = 45.0
                self.k_contraint_ViewFields_Height.constant = 290.0
            }
            else if array_UserSocialSites.count == 2{
                self.k_Constraint_ViewTxtview_Top.constant = 80.0
                self.k_contraint_ViewFields_Height.constant = 328.0
            }
            else if array_UserSocialSites.count == 3{
                
                self.k_Constraint_ViewTxtview_Top.constant = 115.0
                self.k_contraint_ViewFields_Height.constant = 360.0
                
            }
            self.tblView_SocialSites.reloadData()
        }else{
            
            self.tblView_SocialSites.isHidden = true
            self.k_Constraint_ViewTxtview_Top.constant = 9.0
            self.k_contraint_ViewFields_Height.constant = 262.0
            
        }
        
        return true
        
    }
}



extension EditProfileViewController :  UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        lbl_PlaceholderTxtview.isHidden = true
        
        if Global.DeviceType.IS_IPHONE_5 || Global.DeviceType.IS_IPHONE_4_OR_LESS{
            self.animateTextView(textView: textView, up: true, movementDistance: textView.frame.maxY, scrollView:self.scroll_view)
        }
        else{
            self.animateTextView(textView: textView, up: true, movementDistance: 210, scrollView:self.scroll_view)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if txtview_Description.text == ""
        {
            lbl_PlaceholderTxtview.isHidden = false
        }
        else {
            
            lbl_PlaceholderTxtview.isHidden = true
        }
        
        self.animateTextView(textView: textView, up: true, movementDistance: textView.frame.minY, scrollView:self.scroll_view)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        
        let maxLimit = 255
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = maxLimit - newText.characters.count // for Swift use count(newText)
        self.lbl_Counter.text = "\(numberOfChars)"
        print(self.lbl_Counter.text!)
        
        if numberOfChars == 0 {
            
            return false
            
        }
        
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        lbl_PlaceholderTxtview.isHidden = !textView.text.isEmpty
    }
}


/* These are delegate methods for UITextFieldDelegate */


extension  EditProfileViewController : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == txtfield_Location {
            txtfield_Location.resignFirstResponder()
            
            let autocompleteController = GMSAutocompleteViewController()
            autocompleteController.delegate = self
            present(autocompleteController, animated: true, completion: nil)
            
        }
        
        if Global.DeviceType.IS_IPHONE_5 || Global.DeviceType.IS_IPHONE_4_OR_LESS
        {
            if  textField == txtfield_Url {
                
                self.animateTextField(textField: textField, up:true,movementDistance: 100,scrollView: self.scroll_view)  //scroll up when keyboard appears
            }
            else if textField != txtfield_Url && textField != txtfield_SchoolName && textField != txtfield_Location{
                
                self.animateTextField(textField: textField, up:true,movementDistance: 180,scrollView: self.scroll_view)
            }
            
        }
        else{
            
            if  textField != txtfield_Url && textField != txtfield_SchoolName && textField != txtfield_Location{
                
                self.animateTextField(textField: textField, up:true,movementDistance: 150,scrollView: self.scroll_view)
            }
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == txtfield_SchoolName{
            txtfield_Location.becomeFirstResponder()
        }
        else if textField == txtfield_Location{
            txtfield_Url.becomeFirstResponder()
        }
        else if textField == txtfield_Url{
            txtfield_Url.resignFirstResponder()
        }
        else{
            textField.resignFirstResponder()
        }
        
        DispatchQueue.main.async {
            
            self.scroll_view.isUserInteractionEnabled = true
            self.scroll_view.contentSize = CGSize(width: self.view.frame.size.width, height: 210
                + self.k_contraint_ViewFields_Height.constant + self.kheightViewBehindOccupation.constant )
            
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        let string: NSString = (textField.text! as NSString).replacingCharacters(in: range, with: string) as NSString
        if textField == txtfield_SchoolName {
            
            if (string.length <= 30) {
                
                return true
            }
            else{
                return false
            }
        }
            
        else if textField == txtfield_Url {
            if (string.length <= 30) {
                
                return true
            }
            else{
                return false
            }
        }
        
        
        let index = textField.tag
        switch index {
        case 0:
            
            var dic = array_UserSocialSites[index]
            dic["url"] = string
            array_UserSocialSites[index] = dic
            // print(array_UserSocialSites)
            break
            
        case 1:
            
            var dic = array_UserSocialSites[index]
            dic["url"] = string
            array_UserSocialSites[index] = dic
            // print(array_UserSocialSites)
            break
            
        case 2:
            
            var dic = array_UserSocialSites[index]
            dic["url"] = string
            array_UserSocialSites[index] = dic
            // print(array_UserSocialSites)
            
            break
            
        default:
            break
        }
        
        return true
    }
    
}

extension EditProfileViewController:UIPickerViewDelegate,UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return array_Schools.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if sender_Tag == 0{
            txtfield_SchoolName.text = "Community College of the Air Force"
        }
        let str = (array_Schools[row] as! NSDictionary).value(forKey: "name")as! String
        return str
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if sender_Tag == 0{
            
            self.txtfield_SchoolName.text = ((array_Schools[row] as! NSDictionary).value(forKey: "name") as? String)?.capitalized
        }
    }
}

extension EditProfileViewController:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! Com_SchoolOccupationCollectionViewCell
        
        if array_UserOccupations.count > 0 {
            
            cell.lbl_Occupationname.text = (array_UserOccupations[indexPath.row]as! NSDictionary).value(forKey: "name")as? String
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        var count:Int?
        count = array_UserOccupations.count
        
        if count! <= 2 {
            
            self.kheightViewBehindOccupation.constant = 100
            
        }
            
            
        else if count == 4 {
            self.kheightViewBehindOccupation.constant = 160
            
        }
        else {
            
            DispatchQueue.main.async {
                
                self.kheightCollection_View.constant =  self.collection_View_Occupation.contentSize.height
                self.kheightViewBehindOccupation.constant =  self.collection_View_Occupation.contentSize.height + 35
            }
        }
        
        if Global.DeviceType.IS_IPHONE_5 {
            
            if count == 3 {
                self.kheightViewBehindOccupation.constant = 160
                
            }
            
        }
        
        DispatchQueue.main.async {
            
            self.scroll_view.contentSize = CGSize(width: self.view.frame.size.width, height: 210
                + self.k_contraint_ViewFields_Height.constant + self.kheightViewBehindOccupation.constant )
            
        }
        return count!
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 10
        let size:CGSize?
        if Global.DeviceType.IS_IPHONE_6 || Global.DeviceType.IS_IPHONE_6P  || Global.DeviceType.IS_IPHONE_X {
            size = CGSize(width: ((collectionView.frame.width/3 - 5) ), height: 45)
        }
        else{
            size = CGSize(width: ((collectionView.frame.width/2 - 5) ), height: 45)
            
        }
        return size!
        // return CGSize(width: ((collectionView.frame.width/2 - 5) ), height: 45)
        
    }
}
extension UIImage {
    func fix_Orientation() -> UIImage {
        if self.imageOrientation == UIImageOrientation.up {
            return self
        }
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        if let normalizedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            return normalizedImage
        } else {
            return self
        }
    }
}

extension EditProfileViewController:UISearchBarDelegate {
    
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            searchBar.resignFirstResponder()
            return false
        }
        
        var txtAfterUpdate = searchBar.text! as NSString
        txtAfterUpdate = txtAfterUpdate.replacingCharacters(in: range, with: text) as NSString
        
        if(txtAfterUpdate.length == 0) {
            
            self.getallOccupation()
        }
        else {
            
            let predicate = NSPredicate(format: "(name contains[cd] %@)", txtAfterUpdate)
            temp_arrOccupation.removeAllObjects()
            temp_arrOccupation.addObjects(from: self.arrsearchActualOccupation.filtered(using: predicate))
            
            
            array_ActualOccupations.removeAllObjects()
            array_ActualOccupations = temp_arrOccupation.mutableCopy() as! NSMutableArray
            self.tblView_ActualSkills.reloadData()
        }
        
        return true
        
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        temp_arrOccupation = NSMutableArray()
        temp_arrOccupation = self.arrsearchActualOccupation.mutableCopy() as! NSMutableArray
        
        array_ActualOccupations = temp_arrOccupation.mutableCopy() as! NSMutableArray
        self.tblView_ActualSkills.reloadData()
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        
        //   searchBar.resignFirstResponder()
        
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        DispatchQueue.main.async {
            if searchBar.text == "" {
                self.searchTextField.resignFirstResponder()
                searchBar.resignFirstResponder()
            } }}
}
