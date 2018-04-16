
//
//  CustomSearchViewController.swift
//  Shadow
//
//  Created by Atinderjit Kaur on 03/07/17.
//  Copyright © 2017 Atinderjit Kaur. All rights reserved.
//

import UIKit

class CustomSearchViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var topCollectionView:       NSLayoutConstraint!
    @IBOutlet weak var topHeaderHeight:         NSLayoutConstraint!
    @IBOutlet weak var view_BehindSearchView:   UIView!                          //Custom View
    @IBOutlet weak var tblview_AllSearchResult: UITableView!
    @IBOutlet weak var view_CollectionView:     UIView!                         // View behind collection view
    @IBOutlet weak var customCollectionView:    UICollectionView!              //Custom Collection View
    @IBOutlet weak var kHeightTopView:          NSLayoutConstraint!           // Height of top view i.e. behind navigation bar
    @IBOutlet weak var view_BehindProfile:      UIView!                      //These are the views of only UI(white views)
    @IBOutlet weak var view_BehindBio:          UIView!
    @IBOutlet weak var btn_HorizontalView:      UIButton!                    //Outlets of buttons
    @IBOutlet weak var btn_VerticalView:        UIButton!
    @IBOutlet weak var btn_FilterLocation:      UIButton!                   //For Location filter
    @IBOutlet weak var img_DropDrown:           UIImageView!
    @IBOutlet weak var view_Black:              UIView!                     //For Location filter UI
    @IBOutlet weak var view_PopUp:              UIView!
    @IBOutlet weak var custom_slider:           UISlider!
    @IBOutlet weak var btn_Apply:               UIButton!
    @IBOutlet weak var btn_Cancel:              UIButton!
    @IBOutlet weak var lbl_Filter:              UILabel!
    @IBOutlet weak var ktopToggleBtn:           NSLayoutConstraint!
    
    var user_IdMyProfile :                      NSNumber? // To open chat messages
    var qb_id :                                 String?
    var str_roleSchoolCompany :                 String? = ""
    
    
    fileprivate var array_ActualSocialSites = [
        ["name":"Facebook","name_url":"facebookUrl","image":UIImage(named: "facebookUrl")!],
        ["name":"LinkedIn","name_url":"linkedInUrl","image":UIImage(named: "linkedInUrl")!],
        ["name":"Twitter","name_url":"twitterUrl","image":UIImage(named: "twitterUrl")!],
        ["name":"gitHub","name_url":"gitHubUrl","image":UIImage(named: "gitHubUrl")!],
        ["name":"Google+","name_url":"googlePlusUrl","image":UIImage(named: "googlePlusUrl")!],
        ["name":"Instagram","name_url":"instagramUrl","image":UIImage(named: "instagramUrl")!]]
    
    
    fileprivate  var pageIndex :  Int = 0                     //Pagination Parameters
    fileprivate var pageSize :    Int = 0
    var pointNow :                CGPoint?
    var isFetching:               Bool =  false
    var bool_Search :             Bool = false                //This param for the cell for row at collection view to set data for first time.
    var bool_LastResultSearch :   Bool = false                //When the pagination gives no data at last
    
    var searchBar =               UISearchBar()               //Making secondary Searchbar
    var barBtn_Search:            UIBarButtonItem?
    var str_searchText:           String = ""
    var str_searchTextForCompare: NSString = ""
    
    var arr_SearchData :          NSMutableArray = NSMutableArray()
    var linkForOpenWebsite :      String?                        //On collection view to open link of facebook, instagram and twitter etc.
    
    fileprivate var dicUrl:       NSMutableDictionary = NSMutableDictionary()  //For social icons
    let array_URL =               ["facebookUrl","linkedInUrl","instagramUrl","googlePlusUrl","gitHubUrl","twitterUrl"]
    var str_radiusInMiles :        String?
    var video_url :               URL?
    var str_comingfromDialogue :  String = ""
    var arr_ToChatWithoutOcc   :  NSMutableArray = NSMutableArray()

    
    //MARK: Views default functions
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if Global.DeviceType.IS_IPHONE_X {
            self.topHeaderHeight.constant = 25
        }
        
        
        self.showSearchBar()    //Custom search bar
        let searchTextField:UITextField = self.searchBar.subviews[0].subviews.last as! UITextField         //Custom Designs for search bar
        searchTextField.layer.cornerRadius = 16
        searchTextField.textAlignment = NSTextAlignment.left
        searchTextField.textColor = UIColor.black
        
        searchTextField.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        searchTextField.leftViewMode = UITextFieldViewMode.always
        searchTextField.textAlignment = .center
        searchTextField.rightView = nil
        searchTextField.backgroundColor = UIColor.init(red: 247.0/255.0, green: 249.0/255.0, blue: 251.0/255.0, alpha: 1.0)
        self.searchBar.endEditing(true)
        searchTextField.clipsToBounds = true
        
        tblview_AllSearchResult.tableFooterView = UIView()  //Set table extra rows eliminate
        str_radiusInMiles = "10000"    //Set default miles on start
        btn_FilterLocation.setTitle("Select distance", for: .normal)
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        DispatchQueue.main.async {
            if bool_LocationFilter == true {   //Check if location filter is selected then hit location api
                
                
                self.kHeightTopView.constant = 92
                self.ktopToggleBtn.constant = 22
                
                self.btn_FilterLocation.isHidden = false
                self.img_DropDrown.isHidden = false
                self.GetSearchDataAccordingToLocation()
                
            }
                
            else if  bool_CompanySchoolTrends == true {  //Check if company,school,trends and occupation filter is selected then hit location api
                self.kHeightTopView.constant = 64
                self.ktopToggleBtn.constant = 19
                self.btn_FilterLocation.isHidden = true
                self.img_DropDrown.isHidden = true
                self.GetOnlyCompanyData()
                
            }
                
            else {   //Check if no filter applies
                
                self.kHeightTopView.constant = 64
                self.ktopToggleBtn.constant = 19
                self.btn_FilterLocation.isHidden = true
                self.img_DropDrown.isHidden = true
                self.getSearchData()
            }
            
        }
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationItem.setHidesBackButton(true, animated:true)
        self.tabBarController?.tabBar.isHidden = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        if str_comingfromDialogue.contains("true") {
            self.btn_HorizontalView.isHidden = true
            }
            
        else {
            self.btn_HorizontalView.isHidden = false
        }
        
        DispatchQueue.main.async {
            
            self.view.backgroundColor = UIColor.white
            self.customCollectionView.isHidden = false
            self.tblview_AllSearchResult.isHidden = false
            
        }
        
        self.bool_Search = true           //When we come back from view full profile.
        bool_UserIdComingFromSearch = false
        dic_DataOfProfileForOtherUser.removeAllObjects()
        SetButtonCustomAttributes(btn_Cancel)    //Designs changes of the location filter pop up
        SetButtonCustomAttributesGreen(btn_Apply)
        
        custom_slider.addTarget(self, action: #selector(adjustLabelForSlider), for: .valueChanged)  //Custom slider on location filter action
        tblview_AllSearchResult.keyboardDismissMode = UIScrollViewKeyboardDismissMode.onDrag        //Hide keyboard on uitableview dragging
        tblview_AllSearchResult.keyboardDismissMode = UIScrollViewKeyboardDismissMode.interactive
        
        if self.revealViewController() != nil {
            
            self.revealViewController().panGestureRecognizer().isEnabled = false
            self.revealViewController().tapGestureRecognizer().isEnabled = false
            
        }
        
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        
        bool_LastResultSearch = false
        self.searchBar.text = ""
        
    }
    
    
    //MARK: Action of slider
    func adjustLabelForSlider(_ sender: UISlider) {
        
        let trackRect : CGRect = sender.trackRect(forBounds: sender.bounds)
        let thumbRect : CGRect = sender.thumbRect(forBounds: sender.bounds, trackRect: trackRect, value: sender.value)
        lbl_Filter.center = CGPoint(x: thumbRect.origin.x + sender.frame.origin.x + 5, y: sender.frame.origin.y - 7)
        
        let currentValue = Int(sender.value)
        lbl_Filter.text = "\(currentValue)"
        
    }
    
    
    
    // MARK: Tap gesture to hide keyboard
    func handle_Tap(_ sender: UITapGestureRecognizer) {
        
        self.view.endEditing(true)
        view_Black.isHidden = true
        view_PopUp.isHidden = true
        
    }
    
    //MARK: Custom ShowSearchBar
    func showSearchBar() {
        
        let btn_back = UIButton(type: .custom)    // Custom back button
        
        if bool_LocationFilter == true {
            
            searchBar.frame = CGRect(x: 40, y: self.view_BehindSearchView.frame.origin.y + 18, width: self.view_BehindSearchView.frame.width - 140, height: 45)
            
            let btn_back = UIButton(type: .custom)    // Custom back button
            btn_back.frame = CGRect(x: 0, y: 18, width: 42, height: 42)
            btn_back.setImage(UIImage(named:"back-new"), for: .normal)
            _ = UIBarButtonItem(customView: btn_back)
            btn_back.addTarget(self, action: #selector(self.PopView), for: .touchUpInside)
            view_BehindSearchView.addSubview(btn_back)
            
            
            if Global.DeviceType.IS_IPHONE_6  {  //Check of frame of search bar
                searchBar.frame = CGRect(x: 40, y: self.view_BehindSearchView.frame.origin.y + 18, width: self.view_BehindSearchView.frame.width - 80, height: 45)
            }
                
            else if  Global.DeviceType.IS_IPHONE_6P {
                
                searchBar.frame = CGRect(x: 40, y: self.view_BehindSearchView.frame.origin.y + 18, width: self.view_BehindSearchView.frame.width - 50, height: 45)
            }
            
            else  if Global.DeviceType.IS_IPHONE_X {

                  searchBar.frame = CGRect(x: 35, y: self.view_BehindSearchView.frame.origin.y + 18, width: self.view_BehindSearchView.frame.width - 70, height: 45)
            }
            
        }
            
        else {
            
            searchBar.frame = CGRect(x: 40, y: self.view_BehindSearchView.frame.origin.y + 18, width: self.view_BehindSearchView.frame.width - 140, height: 45)
            
            btn_back.frame = CGRect(x: 0, y: 18, width: 42, height: 42)
            btn_back.setImage(UIImage(named:"back-new"), for: .normal)
            _ = UIBarButtonItem(customView: btn_back)
            btn_back.addTarget(self, action: #selector(self.PopView), for: .touchUpInside)
            view_BehindSearchView.addSubview(btn_back)
            
            if Global.DeviceType.IS_IPHONE_6 {  //Check of frame of search bar
                searchBar.frame = CGRect(x: 40, y: self.view_BehindSearchView.frame.origin.y + 18, width: self.view_BehindSearchView.frame.width - 80, height: 45)
            }
                
            else if  Global.DeviceType.IS_IPHONE_6P {
                
                searchBar.frame = CGRect(x: 40, y: self.view_BehindSearchView.frame.origin.y + 18, width: self.view_BehindSearchView.frame.width - 50, height: 45)
            }
            
            else  if Global.DeviceType.IS_IPHONE_X {

                 searchBar.frame = CGRect(x: 35, y: self.view_BehindSearchView.frame.origin.y + 18, width: self.view_BehindSearchView.frame.width - 70, height: 45)
            }
        }
        
        searchBar.backgroundImage = UIImage()
        searchBar.returnKeyType = .done
        searchBar.delegate = self
        
        if let textFieldInsideSearchBar = self.searchBar.value(forKey: "searchField") as? UITextField,
            let _ = textFieldInsideSearchBar.leftView as? UIImageView {
            
            textFieldInsideSearchBar.layer.borderColor = UIColor.clear.cgColor
            textFieldInsideSearchBar.backgroundColor = UIColor.init(red: 247.0/255.0, green: 249.0/255.0, blue: 251.0/255.0, alpha: 1.0)
            textFieldInsideSearchBar.layer.cornerRadius = 16.0
            textFieldInsideSearchBar.layer.borderWidth = 1.0
            textFieldInsideSearchBar.clipsToBounds = true
            
        }
        
        view_BehindSearchView.addSubview(searchBar)
        self.searchBar.alpha = 1
        self.searchBar.spellCheckingType = .yes
        self.searchBar.autocorrectionType = .yes
    }
    
    //Action of back icon near to search
    func PopView() {
        
        _ = self.navigationController?.popViewController(animated: true)
        bool_AllTypeOfSearches = false
        bool_LocationFilter = false
        bool_CompanySchoolTrends = false
        arr_SearchData.removeAllObjects()
        bool_Occupation = false
        
        
    }
    
    func SetWebViewUrl (index:Int) {
        
        let tempArray = self.dicUrl.allKeys as! [String]
        
        if tempArray.count > 0 {
            
            let socialStr:String = tempArray[index]
            
            switch socialStr {
            case "facebookUrl":
                
                linkForOpenWebsite = self.dicUrl.value(forKey: "facebookUrl") as? String
                break
            case "linkedInUrl":
                
                linkForOpenWebsite = self.dicUrl.value(forKey: "linkedInUrl") as? String
                break
                
            case "twitterUrl":
                
                linkForOpenWebsite = self.dicUrl.value(forKey: "twitterUrl") as? String
                break
                
            case "googlePlusUrl":
                
                linkForOpenWebsite = self.dicUrl.value(forKey: "googlePlusUrl") as? String
                break
                
                
            case "instagramUrl":
                linkForOpenWebsite = self.dicUrl.value(forKey: "instagramUrl") as? String
                break
                
            case "gitHubUrl":
                linkForOpenWebsite = self.dicUrl.value(forKey: "gitHubUrl") as? String
                
            default: break
                
            }
        }
        
        
        if linkForOpenWebsite != nil && linkForOpenWebsite != ""{
            if let checkURL = NSURL(string: linkForOpenWebsite!) {
                
                if  UIApplication.shared.openURL(checkURL as URL){
                    print("URL Successfully Opened")
                }
                else {
                    self.showAlert(Message: "Invalid URL. Unable to open in browser.", vc: self)
                }
            }
            else {
                
                self.showAlert(Message:"Invalid URL. Unable to open in browser.", vc: self)
            }
        }
        else {
            self.showAlert(Message: "Invalid URL. Unable to open in browser.", vc: self)
        }
        
    }
    
    
    //MARK: Api to search the data from all options
    func getSearchData() {
        
        
        self.bool_LastResultSearch = true
        
        
        
        if self.checkInternetConnection()
        {
            
            if str_searchText  == ""             {
                
                DispatchQueue.main.async {
                    self.pleaseWait()
                }
            }
            isFetching = false
            
            let dic:NSMutableDictionary = NSMutableDictionary()
            dic.setValue(SavedPreferences.value(forKey: Global.macros.kUserId)as! NSNumber, forKey: Global.macros.kUserId)
            dic.setValue(str_searchText, forKey: "searchKeyword") //string for search
            dic.setValue(pageIndex, forKey: "pageIndex")   //pageIndex
            dic.setValue( 10, forKey: "pageSize")    //pageSize
            
            print(dic)
            ProfileAPI.sharedInstance.AllSearchData(dict: dic, completion: {(response) in
                let status = (response).value(forKey: Global.macros.KStatus)as! NSNumber
                self.isFetching = true
                
                switch status
                {
                case 200:
                    DispatchQueue.main.async {
                        
                        self.clearAllNotice()
                    }
                        if self.str_searchText != self.searchBar.text {
                            
                            return
                            
                        }
                        self.arr_SearchData.addObjects(from: (response.value(forKey: "data") as? NSArray as! [Any]))
                        
                        
                        if self.str_comingfromDialogue.contains("true") {
                            
                            for (_, value) in (self.arr_SearchData.enumerated()) {
                            
                              if (value as! NSDictionary)["occupationDTO"] == nil   {
                                if  !self.arr_ToChatWithoutOcc.contains(value) {
                                self.arr_ToChatWithoutOcc.addObjects(from: [value])
                                }
                                }
                            }
                            print(self.arr_ToChatWithoutOcc)
                        }
                        
                        
                        
                        
                        if self.arr_SearchData.count == 0 {
                            self.bool_LastResultSearch = false
                        }
                        DispatchQueue.main.async {
                        self.tblview_AllSearchResult.reloadData()
                            self.customCollectionView.reloadData() }
                    
                    self.bool_LastResultSearch = false
                    
                case 210:
                    
                    DispatchQueue.main.async {
                        self.clearAllNotice()
                        self.bool_LastResultSearch = false
                        self.showAlert(Message: str_messageInWrongCeredentials!, vc: self)
                    }
                    
                case 400:
                    
                    self.clearAllNotice()
                    DispatchQueue.main.async {
                        self.bool_LastResultSearch = false
                        self.bool_Search = true
                        self.tblview_AllSearchResult.reloadData()
                        self.customCollectionView.reloadData()
                        //   self.showAlert(Message: "No more data to show.", vc: self)
                        
                        
                    }
                    
                case 401 :
                    DispatchQueue.main.async {
                        self.clearAllNotice()
                        self.AlertSessionExpire()
                    }
                    
                    
                case 500:
                    
                    self.clearAllNotice()
                    // self.arr_SearchData.removeAllObjects()
                    DispatchQueue.main.async {
                        self.bool_LastResultSearch = false
                        self.tblview_AllSearchResult.reloadData()
                        self.customCollectionView.reloadData()
                    }
                    
                default:
                    break
                }
                
                
            }, errorBlock: {(err) in
                DispatchQueue.main.async {
                    self.bool_LastResultSearch = false
                    self.clearAllNotice()
                  //  self.showAlert(Message:(err?.localizedDescription)!, vc: self)
                }
            })
        }
        else
        {
            self.showAlert(Message: Global.macros.kInternetConnection, vc: self)
            
        }
    }
    
    //MARK: Api to search the data from location
    
    func GetSearchDataAccordingToLocation() {
        
        self.bool_LastResultSearch = true
        
        if self.checkInternetConnection()
        {
            if str_searchText  == ""
            {
                DispatchQueue.main.async {
                    self.pleaseWait()
                }
            }
            isFetching = false
            let dic:NSMutableDictionary = NSMutableDictionary()
            dic.setValue(SavedPreferences.value(forKey: Global.macros.kUserId)as! NSNumber, forKey: Global.macros.kUserId)
            dic.setValue(str_searchText, forKey: "searchKeyword")
            dic.setValue(str_radiusInMiles, forKey: "radiusInMiles")
            dic.setValue(myCurrentLat, forKey: "latitude")
            dic.setValue(myCurrentLong, forKey: "longitude")
            dic.setValue(0, forKey: "searchType")
            dic.setValue(pageIndex, forKey: "pageIndex")   //pageIndex
            dic.setValue( 10, forKey: "pageSize")          //pageSize
            print(dic)
            
            ProfileAPI.sharedInstance.AllSearchDataAsLocation(dict: dic, completion: {(response) in
                let status = (response).value(forKey: Global.macros.KStatus)as! NSNumber
                self.isFetching = true
                switch status
                {
                case 200:
                    DispatchQueue.main.async {
                        
                        self.clearAllNotice()
                        self.arr_SearchData.addObjects(from: (response.value(forKey: "data") as? NSArray as! [Any]))
                        print(self.arr_SearchData)
                        self.bool_LastResultSearch = true
                        if self.arr_SearchData.count == 0 {
                            self.arr_SearchData.removeAllObjects()
                            self.bool_LastResultSearch = false
                        }
                        
                        self.tblview_AllSearchResult.reloadData()
                        self.customCollectionView.reloadData()
                        
                    }
                    
                case 210:
                    
                    DispatchQueue.main.async {
                        self.clearAllNotice()
                        self.bool_LastResultSearch = false
                        self.showAlert(Message: str_messageInWrongCeredentials!, vc: self)
                    }
                    
                case 400:
                    
                    DispatchQueue.main.async {
                        self.clearAllNotice()
                        self.bool_LastResultSearch = false
                        self.bool_Search = true
                        self.tblview_AllSearchResult.reloadData()
                        self.customCollectionView.reloadData()
                        //  self.showAlert(Message: "No more data to show.", vc: self)
                    }
                    
                case 401 :
                    DispatchQueue.main.async {
                        self.clearAllNotice()
                        self.AlertSessionExpire()
                    }
                    
                    
                case 500:
                    
                    //  self.arr_SearchData.removeAllObjects()
                    DispatchQueue.main.async {
                        self.clearAllNotice()
                        self.bool_LastResultSearch = false
                        self.tblview_AllSearchResult.reloadData()
                        self.customCollectionView.reloadData()
                        
                    }
                    
                default:
                    break
                }
                
                
            }, errorBlock: {(err) in
                DispatchQueue.main.async {
                    self.clearAllNotice()
                    self.bool_LastResultSearch = false
                  //  self.showAlert(Message:(err?.localizedDescription)!, vc: self)
                }
            })
        }
        else
        {
            self.showAlert(Message: Global.macros.kInternetConnection, vc: self)
        }
    }
    
    //MARK: Api to search the data from Company,school,trends and occupation
    
    func GetOnlyCompanyData() {
        
        self.bool_LastResultSearch = true
        
        if self.checkInternetConnection()
        {
            if str_searchText  == ""
            {
                DispatchQueue.main.async {
                    self.pleaseWait()
                }
            }
            isFetching = false
            let dic:NSMutableDictionary = NSMutableDictionary()
            dic.setValue(SavedPreferences.value(forKey: Global.macros.kUserId)as! NSNumber, forKey: Global.macros.kUserId)
            dic.setValue(ratingType, forKey: "ratingType")
            dic.setValue(str_searchText, forKey: "searchKeyword")
            dic.setValue(0, forKey: "searchType")
            dic.setValue(pageIndex, forKey: "pageIndex")   //pageIndex
            dic.setValue( 10, forKey: "pageSize")    //pageSize
            
            print(dic)
            
            ProfileAPI.sharedInstance.getAllTypeTopRatingListbyType(dict: dic, completion: {(response) in
              
                let status = (response).value(forKey: Global.macros.KStatus)as! NSNumber
                self.isFetching = true
                switch status
                {
                case 200:
                    DispatchQueue.main.async {
                        
                        self.clearAllNotice()
                        self.arr_SearchData.addObjects(from: (response.value(forKey: "data") as? NSArray as! [Any]))
                        print(self.arr_SearchData)
                        self.bool_LastResultSearch = true
                        if self.arr_SearchData.count == 0 {
                            self.bool_LastResultSearch = false
                        }
                        
                        self.tblview_AllSearchResult.reloadData()
                        self.customCollectionView.reloadData()
                    }
                    
                case 210:
                    
                    DispatchQueue.main.async {
                        self.clearAllNotice()
                        self.bool_LastResultSearch = false
                        self.showAlert(Message: str_messageInWrongCeredentials!, vc: self)
                    }
                    
                case 400:
                    
                    DispatchQueue.main.async {
                        self.bool_Search = true
                        self.clearAllNotice()
                        self.bool_LastResultSearch = false
                        self.tblview_AllSearchResult.reloadData()
                        self.customCollectionView.reloadData()
                        //  self.showAlert(Message: "No data to show.", vc: self)
                    }
                    
                case 401 :
                    
                    DispatchQueue.main.async {
                        self.clearAllNotice()
                        self.AlertSessionExpire()
                    }
                    
                case 500:
                    
                    //self.arr_SearchData.removeAllObjects()
                    DispatchQueue.main.async {
                        self.clearAllNotice()
                        self.bool_LastResultSearch = false
                        self.tblview_AllSearchResult.reloadData()
                        self.customCollectionView.reloadData()
                        
                    }
                    
                default:
                    break
                }
                
                
            }, errorBlock: {(err) in
                DispatchQueue.main.async {
                    
                    self.clearAllNotice()
                    self.bool_LastResultSearch = false
                  //  self.showAlert(Message:(err?.localizedDescription)!, vc: self)
                    
                }
            })
        }
            
        else
        {
            self.showAlert(Message: Global.macros.kInternetConnection, vc: self)
            
        }
        
    }
    
    func suffixNumber(number:NSNumber) -> NSString {
        
        var num:Double = number.doubleValue;
        let sign = ((num < 0) ? "-" : "" );
        
        num = fabs(num);
        
        if (num < 1000.0){
            return "\(sign)\(num)" as NSString;
        }
        
        let exp:Int = Int(log10(num) / 3.0 ); //log10(1000));
        
        let units:[String] = ["K","M","G","T","P","E"];
        
        let roundedNum:Double = round(10 * num / pow(1000.0,Double(exp))) / 10;
        
        return "\(sign)\(roundedNum)\(units[exp-1])" as NSString;
    }
    
    
    
    //MARK: Action of Buttons
    
    
    
    @IBAction func Action_HorizontalView(_ sender: Any) {
        bool_Occupation = false
        
        if arr_SearchData.count > 0 {
            
            
            if (btn_HorizontalView.currentImage?.isEqual(UIImage(named: "three-dots")))! {
                
                //do something here
                btn_HorizontalView.setImage(UIImage(named: "grayHorizontalLines"), for: .normal)
                self.scrollViewDidEndDecelerating(customCollectionView)
                tblview_AllSearchResult.isHidden = true
                view_CollectionView.isHidden = false
                searchBar.resignFirstResponder()
                
            }
                
            else {
                
                btn_HorizontalView.setImage(UIImage(named: "three-dots"), for: .normal)
                tblview_AllSearchResult.isHidden = false
                view_CollectionView.isHidden = true
                searchBar.isHidden = false
                
                if bool_LocationFilter == true {
                    
                    btn_FilterLocation.isHidden = false
                    img_DropDrown.isHidden = false
                    
                }
                else {
                    
                    btn_FilterLocation.isHidden = true
                    img_DropDrown.isHidden = true
                    
                }
            }
        }
        else {
            self.showAlert(Message: "No data found.", vc: self)
        }
        
    }
    
    
    
    //MARK: - Button Actions
    
    
    @IBAction func Action_Shadow(_ sender: UIButton) {
        
        //  self.showAlert(Message: "Coming Soon", vc: self)
        
        let visibleRect = CGRect(origin: self.customCollectionView.contentOffset, size: self.customCollectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        let indexPath = self.customCollectionView.indexPathForItem(at: visiblePoint)
        
        if indexPath != nil {
            self.navigationItem.setHidesBackButton(false, animated:true)
            self.navigationController?.setNavigationBarHidden(false, animated: false)
            
            if ((self.arr_SearchData[(indexPath?.row)!] as! NSDictionary)["userId"] as? NSNumber) != nil {
                
                let user_IdMyProfile = ((self.arr_SearchData[(indexPath?.row)!] as! NSDictionary)["userId"] as? NSNumber)
                
                
                if user_IdMyProfile == SavedPreferences.value(forKey: Global.macros.kUserId) as? NSNumber   {
                    
                    let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "MyRequests") as! RequestsListViewController
                    vc.user_Name =  ((self.arr_SearchData[(indexPath?.row)!] as! NSDictionary)["name"] as? String)?.capitalized
                    
                    _ = self.navigationController?.pushViewController(vc, animated: true)
                }
                    
                    
                else{
                    
                    let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "send_request") as! SendRequestViewController
                    vc.user_Name =   ((self.arr_SearchData[(indexPath?.row)!] as! NSDictionary)["name"] as? String)?.capitalized
                    vc.userIdFromSendRequest = user_IdMyProfile
                    //userIdFromSearch
                    _ = self.navigationController?.pushViewController(vc, animated: true)
                    
                }
            }
        }
    }
    
    @IBAction func Action_OpenCompany(_ sender: UIButton) {
        
        
        bool_UserIdComingFromSearch = true
        
        let visibleRect = CGRect(origin: self.customCollectionView.contentOffset, size: self.customCollectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        let indexPath = self.customCollectionView.indexPathForItem(at: visiblePoint)
        
        
        
        if indexPath != nil {
            let dict_Temp = (self.arr_SearchData[(indexPath?.row)!] as! NSDictionary)["userDTO"] as? NSDictionary
            let dic = dict_Temp?["companyDTO"] as? NSDictionary
            
            idFromProfileVC = dic?.value(forKey: "companyUserId") as? NSNumber
            
            if idFromProfileVC != nil {
                
                DispatchQueue.main.async {
                    
                    self.navigationController?.setNavigationBarHidden(false, animated: false)
                    self.navigationItem.setHidesBackButton(false, animated:true)
                    let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "company") as! ComapanySchoolViewController//UINavigationController
                    vc.user_IdMyProfile = idFromProfileVC
                    
                    _ = self.navigationController?.pushViewController(vc, animated: true)
                }
            }
                
            else {
                self.showAlert(Message: "Company is not registered yet.", vc: self)
            }
        }
    }
    
    
    @IBAction func Action_BackButtonOnCollectionView(_ sender: Any) {
        
        btn_HorizontalView.setImage(UIImage(named: "three-dots"), for: .normal)
        tblview_AllSearchResult.isHidden = false
        view_CollectionView.isHidden = true
        searchBar.isHidden = false
        
        if bool_LocationFilter == true {
            
            btn_FilterLocation.isHidden = false
            img_DropDrown.isHidden = false
            
        }
        else {
            
            btn_FilterLocation.isHidden = true
            img_DropDrown.isHidden = true
            
        }
    }
    
    
    @IBAction func Action_Video(_ sender: UIButton) {
        
        DispatchQueue.main.async {
            
            let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "Upload_Video") as! UploadViewController
            
            if self.video_url != nil {
                
                bool_PlayFromProfile = true
                vc.video_urlProfile  = self.video_url
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
    
    @IBAction func Action_OpenSocialSite1(_ sender: UIButton) {
        linkForOpenWebsite = ""
        SetWebViewUrl (index: 0)
        
        
    }
    
    @IBAction func Action_OpenSocialSite2(_ sender: UIButton) {
        linkForOpenWebsite = ""
        SetWebViewUrl (index: 1)
        
        
    }
    
    @IBAction func Action_OpenSocialSite3(_ sender: UIButton) {
        linkForOpenWebsite = ""
        SetWebViewUrl (index: 2)
        
    }
    
    
    
    @IBAction func Action_ViewFullProfile(_ sender: UIButton) {
        
        bool_UserIdComingFromSearch = true
        let dict_Temp = (arr_SearchData[sender.tag] as! NSDictionary)["userDTO"] as? NSDictionary
        
        let str_role = dict_Temp?.value(forKey: "role") as? String
        dic_DataOfProfileForOtherUser = NSMutableDictionary()
        dic_DataOfProfileForOtherUser = (arr_SearchData[sender.tag] as! NSDictionary).mutableCopy() as! NSMutableDictionary
        
        let vc_com = Global.macros.Storyboard.instantiateViewController(withIdentifier: "company") as! ComapanySchoolViewController
        let vc_user = Global.macros.Storyboard.instantiateViewController(withIdentifier: "user") as! ProfileVC
        
        
        if str_role == "USER" {
            
            vc_user.userIdFromSearch = dict_Temp?.value(forKey: "userId") as? NSNumber
            self.navigationController?.setNavigationBarHidden(false, animated: false)
            self.navigationItem.setHidesBackButton(false, animated:true)
            
            _ = self.navigationController?.pushViewController(vc_user, animated: true)
            
        }
            
        else {
            
            vc_com.userIdFromSearch = dict_Temp?.value(forKey: "userId") as? NSNumber
            self.navigationController?.setNavigationBarHidden(false, animated: false)
            self.navigationItem.setHidesBackButton(false, animated:true)
            _ = self.navigationController?.pushViewController(vc_com, animated: true)
            
        }
    }
    
    
    
    @IBAction func ActionSelectLocationFilter(_ sender: UIButton) {
        
        self.view.endEditing(true)
        view_Black.isHidden = false
        view_PopUp.isHidden = false
        
    }
    
    
    
    @IBAction func Action_Slider(_ sender: UISlider) {
        
        let currentValue = Int(sender.value)
        str_radiusInMiles = "\(currentValue)"
        
    }
    
    
    
    @IBAction func Action_FilterLocationApply(_ sender: Any) {
        pageIndex = 0
        
        btn_FilterLocation.setTitle(str_radiusInMiles! + " " + "MILES", for: .normal)
        view_Black.isHidden = true
        view_PopUp.isHidden = true
        self.view.endEditing(true)
        self.arr_SearchData.removeAllObjects()
        GetSearchDataAccordingToLocation()
        
    }
    
    
    @IBAction func Action_Cancel(_ sender: Any) {
        
        self.view.endEditing(true)
        view_Black.isHidden = true
        view_PopUp.isHidden = true
        
    }
    
    
    
    @IBAction func Action_DidSelectRow(_ sender: UIButton) {
        
         if self.str_comingfromDialogue.contains("true") {
            
            let dict_Temp = (arr_ToChatWithoutOcc[sender.tag] as! NSDictionary)["userDTO"] as? NSDictionary
            let str_role = dict_Temp?.value(forKey: "role") as? String
            
            
            if dict_Temp?.value(forKey: "qbId")as? String != nil {
                
                self.qb_id =  dict_Temp?.value(forKey: "qbId") as? String
                
            } else {
                
                self.qb_id = ""
            }
            
            if str_comingfromDialogue.contains("true") {
                
                DispatchQueue.main.async {
                    self.pleaseWait()
                    
                }
                
                
                if str_role == "USER" {
                    
                    self.user_IdMyProfile = (self.arr_ToChatWithoutOcc[sender.tag] as! NSDictionary)["userId"] as? NSNumber
                    
                    self.str_roleSchoolCompany = str_role
                }
                    
                    
                else if str_role == "COMPANY" || str_role == "SCHOOL" {
                    
                    self.user_IdMyProfile = (self.arr_ToChatWithoutOcc[sender.tag] as! NSDictionary)["userId"] as? NSNumber
                    
                    self.str_roleSchoolCompany = str_role
                    
                }
                else{
                    
                    self.user_IdMyProfile = (self.arr_ToChatWithoutOcc[sender.tag] as! NSDictionary)["id"] as? NSNumber
                    self.str_roleSchoolCompany = str_role
                }
                
                
                //  DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                
                if SavedPreferences.value(forKey: "qb_UserId") != nil {
                    
                    
                    if self.user_IdMyProfile != SavedPreferences.value(forKey: Global.macros.kUserId) as? NSNumber {
                        
                        
                        if self.qb_id != nil  && self.qb_id != ""  {
                            
                            DispatchQueue.main.async {
                                
                                self.navigationController?.setNavigationBarHidden(false, animated: false)
                                self.navigationItem.setHidesBackButton(false, animated:true)
                            }
                            
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
                                            let str_name = ((self.arr_ToChatWithoutOcc[sender.tag] as! NSDictionary)["name"] as? String)?.capitalized
                                            
                                            let dict_Temp = (self.arr_ToChatWithoutOcc[sender.tag] as! NSDictionary)["userDTO"] as? NSDictionary
                                            let str_role = dict_Temp?.value(forKey: "role") as? String
                                            
                                            if str_name != nil && str_name != "" {
                                                
                                                vc.str_ReceiverName = "\(str_name!)"
                                                vc.local_roleOtherUser = str_role
                                                vc.local_otherUserId = self.user_IdMyProfile
                                                
                                                
                                            }
                                            
                                            
                                            vc.str_OtherUserId = self.qb_id
                                            
                                            if vc.str_ReceiverName == nil {
                                                vc.str_ReceiverName = self.title
                                            }
                                            
                                            _ = self.navigationController?.pushViewController(vc, animated: true)
                                            
                                        }
                                    }
                                    
                                case 400:
                                    
                                    DispatchQueue.main.async {
                                        
                                        
                                        let chatDialog: QBChatDialog = QBChatDialog(dialogID: nil, type: QBChatDialogType.group)
                                        
                                        
                                        let str_name = ((self.arr_ToChatWithoutOcc[sender.tag] as! NSDictionary)["name"] as? String)?.capitalized
                                        
                                        
                                        if self.qb_id != nil && str_name != "" && str_name != nil {
                                            
                                            
                                            if (SavedPreferences.value(forKey: "role") as? String) == "SCHOOL" {
                                                
                                                
                                                chatDialog.name  = "\(str_name!)" + "/" + "\(self.user_IdMyProfile!)" + "-" + "\(self.str_roleSchoolCompany!)" + "_" + "\(SavedPreferences.value(forKey: Global.macros.kschoolName)!)" + "/" + "\(SavedPreferences.value(forKey: Global.macros.kUserId)!)" + "-" + "\(SavedPreferences.value(forKey: Global.macros.krole)!)"
                                                
                                                print(chatDialog.name!)
                                            }
                                            else if (SavedPreferences.value(forKey: "role") as? String) == "COMPANY"  {
                                                
                                                chatDialog.name  = "\(str_name!)" + "/" + "\(self.user_IdMyProfile!)" + "-" + "\(self.str_roleSchoolCompany!)" + "_" + "\(SavedPreferences.value(forKey: Global.macros.kcompanyName)!)" + "/" + "\(SavedPreferences.value(forKey: Global.macros.kUserId)!)" + "-" + "\(SavedPreferences.value(forKey: Global.macros.krole)!)"
                                                
                                            }
                                                
                                            else if (SavedPreferences.value(forKey: "role") as? String) == "USER"  {
                                                
                                                chatDialog.name  = "\(str_name!)" + "/" + "\(self.user_IdMyProfile!)" + "-" + "\(self.str_roleSchoolCompany!)"  + "_" + "\(SavedPreferences.value(forKey: Global.macros.kUserName)!)" + "/" + "\(SavedPreferences.value(forKey: Global.macros.kUserId)!)" + "-" + "\(SavedPreferences.value(forKey: Global.macros.krole)!)"
                                                
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
                                            
                                        else{
                                            
                                            self.showAlert(Message: "Please try again.", vc: self)
                                        }}
                                    
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
                        self.clearAllNotice()
                    }
                }
                else {
                    self.clearAllNotice()
                    self.showAlert(Message: "Please try again.", vc: self)
                }
            }
            else{
                
                if bool_Occupation == false {
                    
                    if self.checkInternetConnection()
                    {
                        bool_UserIdComingFromSearch = true
                        
                        dic_DataOfProfileForOtherUser = (arr_ToChatWithoutOcc[sender.tag] as! NSDictionary).mutableCopy() as! NSMutableDictionary
                        
                        if str_role == "USER" {
                            
                            DispatchQueue.main.async {
                                
                                let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "user") as! ProfileVC
                                vc.userIdFromSearch = (self.arr_ToChatWithoutOcc[sender.tag] as! NSDictionary)["userId"] as? NSNumber
                                
                                self.navigationController?.setNavigationBarHidden(false, animated: false)
                                self.navigationItem.setHidesBackButton(false, animated:true)
                                
                                _ = self.navigationController?.pushViewController(vc, animated: true)
                                
                            }
                        }
                        else if str_role == "COMPANY" || str_role == "SCHOOL" {
                            
                            DispatchQueue.main.async {
                                
                                let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "company") as! ComapanySchoolViewController
                                vc.userIdFromSearch = (self.arr_ToChatWithoutOcc[sender.tag] as! NSDictionary)["userId"] as? NSNumber
                                self.navigationController?.setNavigationBarHidden(false, animated: false)
                                self.navigationItem.setHidesBackButton(false, animated:true)
                                _ = self.navigationController?.pushViewController(vc, animated: true)
                            }
                            
                            
                        }
                            
                        else {
                            DispatchQueue.main.async {
                                
                                let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "OccupationDetail") as! OccupationDetailViewController
                                vc.occupationId = (self.arr_ToChatWithoutOcc[sender.tag] as! NSDictionary)["id"]! as? NSNumber
                                self.navigationController?.setNavigationBarHidden(false, animated: false)
                                self.navigationItem.setHidesBackButton(false, animated:true)
                                _ = self.navigationController?.pushViewController(vc, animated: true)
                            }
                        }
                    }
                        
                    else{
                        self.showAlert(Message: Global.macros.kInternetConnection, vc: self)
                    }
                    
                }
                else {
                    // self.showAlert(Message: "Coming Soon.", vc: self)
                    DispatchQueue.main.async {
                        
                        if (self.arr_SearchData[sender.tag] as! NSDictionary)["id"] != nil {
                            let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "OccupationDetail") as! OccupationDetailViewController
                            vc.occupationId = (self.arr_ToChatWithoutOcc[sender.tag] as! NSDictionary)["id"]! as? NSNumber
                            self.navigationController?.setNavigationBarHidden(false, animated: false)
                            self.navigationItem.setHidesBackButton(false, animated:true)
                            _ = self.navigationController?.pushViewController(vc, animated: true)
                            
                        }}}}
        }
        
         else {
        let dict_Temp = (arr_SearchData[sender.tag] as! NSDictionary)["userDTO"] as? NSDictionary
        let str_role = dict_Temp?.value(forKey: "role") as? String
        
        
        if dict_Temp?.value(forKey: "qbId")as? String != nil {
            
            self.qb_id =  dict_Temp?.value(forKey: "qbId") as? String
            
        } else {
            
            self.qb_id = ""
        }
        
        if str_comingfromDialogue.contains("true") {
            
            DispatchQueue.main.async {
                self.pleaseWait()
                
            }
            
            
            if str_role == "USER" {

                self.user_IdMyProfile = (self.arr_SearchData[sender.tag] as! NSDictionary)["userId"] as? NSNumber
                
                  self.str_roleSchoolCompany = str_role
            }
                
                
            else if str_role == "COMPANY" || str_role == "SCHOOL" {
                
                self.user_IdMyProfile = (self.arr_SearchData[sender.tag] as! NSDictionary)["userId"] as? NSNumber

                self.str_roleSchoolCompany = str_role
                
            }
            else{
                
                self.user_IdMyProfile = (self.arr_SearchData[sender.tag] as! NSDictionary)["id"] as? NSNumber
                self.str_roleSchoolCompany = str_role
            }
            
            
            //  DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
            
            if SavedPreferences.value(forKey: "qb_UserId") != nil {
                
                
                if self.user_IdMyProfile != SavedPreferences.value(forKey: Global.macros.kUserId) as? NSNumber {
                    
                    
                    if self.qb_id != nil  && self.qb_id != ""  {
                        
                        DispatchQueue.main.async {
                            
                            self.navigationController?.setNavigationBarHidden(false, animated: false)
                            self.navigationItem.setHidesBackButton(false, animated:true)
                        }
                        
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
                                        let str_name = ((self.arr_SearchData[sender.tag] as! NSDictionary)["name"] as? String)?.capitalized
                                        
                                        let dict_Temp = (self.arr_SearchData[sender.tag] as! NSDictionary)["userDTO"] as? NSDictionary
                                        let str_role = dict_Temp?.value(forKey: "role") as? String
                                        
                                        if str_name != nil && str_name != "" {
                                            
                                            vc.str_ReceiverName = "\(str_name!)"
                                            vc.local_roleOtherUser = str_role
                                                vc.local_otherUserId = self.user_IdMyProfile
                                            
                                            
                                        }
                                        
                                        
                                        vc.str_OtherUserId = self.qb_id
                                        
                                        if vc.str_ReceiverName == nil {
                                            vc.str_ReceiverName = self.title
                                        }
                                        
                                        _ = self.navigationController?.pushViewController(vc, animated: true)
                                        
                                    }
                                }
                                
                            case 400:
                                
                                DispatchQueue.main.async {
                                    
                                    
                                    let chatDialog: QBChatDialog = QBChatDialog(dialogID: nil, type: QBChatDialogType.group)
                                    
                                    
                                    let str_name = ((self.arr_SearchData[sender.tag] as! NSDictionary)["name"] as? String)?.capitalized
                                    
                                    
                                    if self.qb_id != nil && str_name != "" && str_name != nil {
                                        
                                        
                                        if (SavedPreferences.value(forKey: "role") as? String) == "SCHOOL" {
                                            
                                            
                                            chatDialog.name  = "\(str_name!)" + "/" + "\(self.user_IdMyProfile!)" + "-" + "\(self.str_roleSchoolCompany!)" + "_" + "\(SavedPreferences.value(forKey: Global.macros.kschoolName)!)" + "/" + "\(SavedPreferences.value(forKey: Global.macros.kUserId)!)" + "-" + "\(SavedPreferences.value(forKey: Global.macros.krole)!)"
                                            
                                            print(chatDialog.name!)
                                        }
                                        else if (SavedPreferences.value(forKey: "role") as? String) == "COMPANY"  {
                                            
                                            chatDialog.name  = "\(str_name!)" + "/" + "\(self.user_IdMyProfile!)" + "-" + "\(self.str_roleSchoolCompany!)" + "_" + "\(SavedPreferences.value(forKey: Global.macros.kcompanyName)!)" + "/" + "\(SavedPreferences.value(forKey: Global.macros.kUserId)!)" + "-" + "\(SavedPreferences.value(forKey: Global.macros.krole)!)"
                                            
                                        }
                                            
                                        else if (SavedPreferences.value(forKey: "role") as? String) == "USER"  {
                                            
                                            chatDialog.name  = "\(str_name!)" + "/" + "\(self.user_IdMyProfile!)" + "-" + "\(self.str_roleSchoolCompany!)"  + "_" + "\(SavedPreferences.value(forKey: Global.macros.kUserName)!)" + "/" + "\(SavedPreferences.value(forKey: Global.macros.kUserId)!)" + "-" + "\(SavedPreferences.value(forKey: Global.macros.krole)!)"
                                            
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
                                        
                                    else{
                                        
                                        self.showAlert(Message: "Please try again.", vc: self)
                                    }}
                                
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
                    self.clearAllNotice()
                }
            }
            else {
                self.clearAllNotice()
                self.showAlert(Message: "Please try again.", vc: self)
            }
        }
        else{
            
            if bool_Occupation == false {
                
                if self.checkInternetConnection()
                {
                    bool_UserIdComingFromSearch = true
                    print(arr_SearchData[sender.tag] as! NSDictionary)
                    
                    dic_DataOfProfileForOtherUser = (arr_SearchData[sender.tag] as! NSDictionary).mutableCopy() as! NSMutableDictionary
                    
                    if str_role == "USER" {
                        
                        DispatchQueue.main.async {
                            
                            let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "user") as! ProfileVC
                            vc.userIdFromSearch = (self.arr_SearchData[sender.tag] as! NSDictionary)["userId"] as? NSNumber
                            
                            self.navigationController?.setNavigationBarHidden(false, animated: false)
                            self.navigationItem.setHidesBackButton(false, animated:true)
                            
                            _ = self.navigationController?.pushViewController(vc, animated: true)
                            
                        }
                    }
                    else if str_role == "COMPANY" || str_role == "SCHOOL" {
                        
                        DispatchQueue.main.async {
                            
                            let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "company") as! ComapanySchoolViewController
                            vc.userIdFromSearch = (self.arr_SearchData[sender.tag] as! NSDictionary)["userId"] as? NSNumber
                            self.navigationController?.setNavigationBarHidden(false, animated: false)
                            self.navigationItem.setHidesBackButton(false, animated:true)
                            _ = self.navigationController?.pushViewController(vc, animated: true)
                        }
                        
                        
                    }
                        
                    else {
                        DispatchQueue.main.async {
                            
                            let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "OccupationDetail") as! OccupationDetailViewController
                            vc.occupationId = (self.arr_SearchData[sender.tag] as! NSDictionary)["id"]! as? NSNumber
                            self.navigationController?.setNavigationBarHidden(false, animated: false)
                            self.navigationItem.setHidesBackButton(false, animated:true)
                            _ = self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                }
                    
                else{
                    self.showAlert(Message: Global.macros.kInternetConnection, vc: self)
                }
                
            }
            else {
                // self.showAlert(Message: "Coming Soon.", vc: self)
                DispatchQueue.main.async {
                    
                    if (self.arr_SearchData[sender.tag] as! NSDictionary)["id"] != nil {
                        let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "OccupationDetail") as! OccupationDetailViewController
                        vc.occupationId = (self.arr_SearchData[sender.tag] as! NSDictionary)["id"]! as? NSNumber
                        self.navigationController?.setNavigationBarHidden(false, animated: false)
                        self.navigationItem.setHidesBackButton(false, animated:true)
                        _ = self.navigationController?.pushViewController(vc, animated: true)
                        
                    }}}}
            
        }
        }
    
    
    @IBAction func Action_OpenUrl(_ sender: UIButton) {
        
        
        //Custom indexpath and cell formation
        let visibleRect = CGRect(origin: self.customCollectionView.contentOffset, size: self.customCollectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        let indexPath = self.customCollectionView.indexPathForItem(at: visiblePoint)
        
        
        
        if indexPath != nil {
            var url:String?
            var trimmedString:String?
            
            let str_role = ((self.arr_SearchData[(indexPath?.row)!] as! NSDictionary)["userDTO"] as? NSDictionary)?.value(forKey: "role") as? String
            
            if str_role == "COMPANY"{
                url = ((self.arr_SearchData[(indexPath?.row)!] as! NSDictionary)["userDTO"] as? NSDictionary)?.value(forKey: "companyUrl") as? String
                trimmedString = url?.trimmingCharacters(in: .whitespacesAndNewlines)
                
                
                
                DispatchQueue.main.async {
                    
                    if trimmedString != nil && trimmedString != "" {
                        if let checkURL = NSURL(string: trimmedString!) {
                            
                            if  UIApplication.shared.openURL(checkURL as URL){
                                print("URL Successfully Opened")
                            }
                            else {
                                self.showAlert(Message: "Invalid URL. Unable to open in browser.", vc: self)
                            }
                        }
                        else {
                            
                            self.showAlert(Message:"Invalid URL. Unable to open in browser.", vc: self)
                        }
                    }
                    else {
                        self.showAlert(Message: "Invalid URL. Unable to open in browser.", vc: self)
                    }
                }
                
            } else  if str_role == "SCHOOL"{
                url = ((self.arr_SearchData[(indexPath?.row)!] as! NSDictionary)["userDTO"] as? NSDictionary)?.value(forKey: "schoolUrl") as? String
                trimmedString = url?.trimmingCharacters(in: .whitespacesAndNewlines)
                
                DispatchQueue.main.async {
                    
                    if trimmedString != nil && trimmedString != "" {
                        if let checkURL = NSURL(string: trimmedString!) {
                            
                            if  UIApplication.shared.openURL(checkURL as URL){
                                print("URL Successfully Opened")
                            }
                            else {
                                self.showAlert(Message: "Invalid URL. Unable to open in browser.", vc: self)
                            }
                        }
                        else {
                            
                            self.showAlert(Message:"Invalid URL. Unable to open in browser.", vc: self)
                        }
                    }
                    else {
                        self.showAlert(Message: "Invalid URL. Unable to open in browser.", vc: self)
                    }
                }}
                
            else {
                
                let dict_Temp = (self.arr_SearchData[(indexPath?.row)!] as! NSDictionary)["userDTO"] as? NSDictionary
                let dic = dict_Temp?["schoolDTO"] as? NSDictionary
                bool_UserIdComingFromSearch = true
                
                idFromProfileVC = dic?.value(forKey: "schoolUserId") as? NSNumber
                
                if idFromProfileVC != nil {
                    let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "company") as! ComapanySchoolViewController//UINavigationController
                    vc.user_IdMyProfile = idFromProfileVC
                    _ = self.navigationController?.pushViewController(vc, animated: true)
                }
                    
                else {
                    self.showAlert(Message: "School is not registered yet.", vc: self)
                }}}}
    
    
    @IBAction func Action_OpenRatingView(_ sender: Any) {

    }
    
    
    @IBAction func Action_ViewProfileOccupation(_ sender: UIButton) {
        
        //Custom indexpath and cell formation
        let visibleRect = CGRect(origin: self.customCollectionView.contentOffset, size: self.customCollectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        let indexPath = self.customCollectionView.indexPathForItem(at: visiblePoint)
        let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "OccupationDetail") as! OccupationDetailViewController
        
        if indexPath != nil {
            vc.occupationId = (arr_SearchData[(indexPath?.row)!] as! NSDictionary)["id"]! as? NSNumber
        }
        else {
            vc.occupationId = 1
        }
        
        _ = self.navigationController?.pushViewController(vc, animated: true)
        vc.extendedLayoutIncludesOpaqueBars = true
        self.tabBarController?.tabBar.isTranslucent = false
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    
    //Action of ocupation view
    
    @IBAction func UserWithOccupationOnOccupationView(_ sender: Any) {
        
    }
    
    
    @IBAction func ActionRatingOnOccupation(_ sender: Any) {
        
        //Custom indexpath and cell formation
        let visibleRect = CGRect(origin: self.customCollectionView.contentOffset, size: self.customCollectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        let indexPath = self.customCollectionView.indexPathForItem(at: visiblePoint)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationItem.setHidesBackButton(true, animated:true)
        self.tabBarController?.tabBar.isHidden = true
        
        if indexPath != nil {
            
            
            let dict_Temp = (arr_SearchData[(indexPath?.row)!] as! NSDictionary)["occupationDTO"] as? NSDictionary
            bool_FromOccupation = true
            let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "ratingView") as! RatingViewController
            vc.occ_id = dict_Temp?.value(forKey: "id") as? NSNumber
            _ = self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    @IBAction func UserThatShadowedOnOccupationView(_ sender: Any) {
        
    }
    
    //Actions on school, company and user slider view
    
    @IBAction func OpenList(_ sender: UIButton) {
        
        bool_UserIdComingFromSearch = true
        
        //Custom indexpath and cell formation
        let visibleRect = CGRect(origin: self.customCollectionView.contentOffset, size: self.customCollectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        let indexPath = self.customCollectionView.indexPathForItem(at: visiblePoint)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationItem.setHidesBackButton(true, animated:true)
        self.tabBarController?.tabBar.isHidden = true
        var type:String?
        var navigation_title:String?
        
        
        if sender.tag == 1{//shadowers
            
            type = Global.macros.kShadow
            navigation_title =  "Shadowers"
            
        }else if sender.tag == 2{//shadowed
            
           let dict_Temp = (arr_SearchData[(indexPath?.row)!] as! NSDictionary)["userDTO"] as? NSDictionary
            
             if dict_Temp?.value(forKey: "role") as! String == "USER" {
           
                type = Global.macros.kShadowed
                navigation_title = "Shadowed Users"
            }
             else{
                type = Global.macros.kVerifyUsers
                navigation_title = "Verified Users"
            }
          
            
            
        }else if sender.tag == 3{//occupations
            
            type = Global.macros.k_Occupation
            navigation_title = "Users with these Occupations"
            
            
        }
        else { //users
            
            type = Global.macros.k_User
            navigation_title = "Users List"
            
            
        }
        
        
        let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "listing") as! ListingViewController
        vc.type = type
        if indexPath != nil {
            let dict_Temp = (arr_SearchData[(indexPath?.row)!] as! NSDictionary)["userDTO"] as? NSDictionary
            
            if dict_Temp?.value(forKey: "role") as! String == "COMPANY" {
                
                if (dict_Temp?["companyDTO"] as? NSDictionary) != nil {
                    
                    let dict  = dict_Temp?["companyDTO"] as! NSDictionary
                    vc.ListuserId =  dict.value(forKey: "companyUserId") as? NSNumber
                }
            }
            else if dict_Temp?.value(forKey: "role") as! String == "SCHOOL" {
                
                if (dict_Temp?["schoolDTO"] as? NSDictionary) != nil {
                    
                    let dict  = dict_Temp?["schoolDTO"] as! NSDictionary
                    vc.ListuserId =  dict.value(forKey: "schoolUserId") as? NSNumber //userId
                }
            }
            else if dict_Temp?.value(forKey: "role") as! String == "USER" {
                
                
                vc.ListuserId =  dict_Temp?.value(forKey: "userId") as? NSNumber //userId
                
            }
            
            vc.navigation_title = navigation_title
            _ = self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    @IBAction func OpenRattingListOnOccupation(_ sender: UIButton) {
        
        
        bool_UserIdComingFromSearch = true
        
        //Custom indexpath and cell formation
        let visibleRect = CGRect(origin: self.customCollectionView.contentOffset, size: self.customCollectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        let indexPath = self.customCollectionView.indexPathForItem(at: visiblePoint)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationItem.setHidesBackButton(true, animated:true)
        self.tabBarController?.tabBar.isHidden = true
        
        
        let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "ratingView") as! RatingViewController
        
        if indexPath != nil {
            
            let dict_Temp = (arr_SearchData[(indexPath?.row)!] as! NSDictionary)["userDTO"] as? NSDictionary
            
            if dict_Temp?.value(forKey: "role") as! String == "COMPANY" {
                if (dict_Temp?["companyDTO"] as? NSDictionary) != nil {
                    
                    let dict  = dict_Temp?["companyDTO"] as! NSDictionary
                    vc.userIdForRating =  dict.value(forKey: "companyUserId") as? NSNumber
                    ratingview_name = dict.value(forKey: "name")as? String
                    
                }
            }
            else if dict_Temp?.value(forKey: "role") as! String == "SCHOOL" {
                
                if (dict_Temp?["schoolDTO"] as? NSDictionary) != nil {
                    
                    let dict  = dict_Temp?["schoolDTO"] as! NSDictionary
                    vc.userIdForRating =  dict.value(forKey: "schoolUserId") as? NSNumber //userId
                    ratingview_name = dict.value(forKey: "name")as? String
                    
                }
            }
            else if dict_Temp?.value(forKey: "role") as! String == "USER" {
                
                vc.userIdForRating =  dict_Temp?.value(forKey: "userId") as? NSNumber //userId
                ratingview_name = dict_Temp?.value(forKey: "userName")as? String
                
            }
            var profileurl = dict_Temp?.value(forKey: "profileImageUrl")as? String
            profileurl = profileurl?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            ratingview_imgurl = profileurl?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            
            
            _ = self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    
    
    
    
    //MARK:Scroll View Delegate Methods and Pagination
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.video_url = nil
        pointNow = scrollView.contentOffset
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        bool_FromOccupation = false
        //Custom indexpath and cell formation
        let visibleRect = CGRect(origin: self.customCollectionView.contentOffset, size: self.customCollectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        let indexPath = self.customCollectionView.indexPathForItem(at: visiblePoint)
        if indexPath != nil {
            let cell = self.customCollectionView.cellForItem(at: indexPath!) as? CustomCollectionViewCell
            
            if cell != nil {
                
                if scrollView == self.tblview_AllSearchResult {       //Pagination for tableview
                    
                    print(scrollView.contentOffset.y)
                    if (scrollView.contentOffset.y<(pointNow?.y)!) {
                        print("down")
                    } else if (scrollView.contentOffset.y>(pointNow?.y)!) {
                        
                        if isFetching {
                            self.pageIndex = self.pageIndex + 1
                            isFetching = true
                            //   DispatchQueue.global(qos: .background).async {
                            
                            self.bool_Search = true
                            if bool_AllTypeOfSearches == true {
                                self.getSearchData()
                                
                            }
                            else if bool_LocationFilter == true {
                                self.GetSearchDataAccordingToLocation()
                            }
                                
                            else if bool_CompanySchoolTrends == true {
                                self.GetOnlyCompanyData()
                            }
                            //  }
                        }
                    }
                    
                }
                else {
                    
                    if (indexPath?.row)!  == self.arr_SearchData.count - 1 {   //Pagination for scrollView
                        
                        print(scrollView.contentOffset.x)
                        print(arr_SearchData.count)
                        
                        if pointNow != nil {
                            if (scrollView.contentOffset.x<(pointNow?.x)!) {
                                print("down")
                            } else if (scrollView.contentOffset.x>(pointNow?.x)!) {
                                if isFetching {
                                    self.pageIndex = self.pageIndex + 1
                                    isFetching = true
                                    //  DispatchQueue.global(qos: .background).async {
                                    self.bool_Search = true
                                    if bool_AllTypeOfSearches == true {
                                        self.getSearchData()
                                        
                                    }
                                    else if bool_LocationFilter == true {
                                        self.GetSearchDataAccordingToLocation()
                                        
                                    }
                                    else if bool_CompanySchoolTrends == true {
                                        self.GetOnlyCompanyData()
                                        
                                    }
                                    //   }
                                }
                            }
                                
                            else {
                                self.bool_Search = true
                                self.tblview_AllSearchResult.reloadData()
                                self.customCollectionView.reloadData()
                            }
                        }
                        else {
                            self.bool_Search = true
                            self.tblview_AllSearchResult.reloadData()
                            self.customCollectionView.reloadData()
                            
                        }
                        
                    }
                    else {        //Set data for UICollectionView when end declarating calls
                        DispatchQueue.main.async {
                            
//                            cell?.k_Constraint_Top_labelUrl.constant = 0.0
//                            cell?.k_Constraint_Top_btnUrl.constant = 0.0
//                            cell?.k_Constraint_Top_imageViewUrl.constant = 0.0
//                            cell?.k_Constraint_Top_tblViewSocialSite.constant = 0.0
//                            cell?.k_Constraint_ViewDescriptionHeight.constant = 0.0
//                            cell?.kheightdescription.constant = 0
//                            cell?.k_Constraint_Height_TableviewSocialSite.constant = 0.0
                            
                             cell?.lbl_Description.textColor = UIColor.init(red: 36.0/255.0, green: 36.0/255.0, blue: 36.0/255.0, alpha: 1.0)
                            
                            if  (self.arr_SearchData[(indexPath?.row)!] as! NSDictionary)["occupationDTO"] == nil {
                                
                                cell?.view_MainOccupation.isHidden = true
                                cell?.btn_ViewFullProfile.tag = (indexPath?.row)!
                                cell?.btn_PlayVideo.tag = (indexPath?.row)!
                                cell?.btn_SocialSite1.tag = (indexPath?.row)!
                                cell?.btn_SocialSite2.tag = (indexPath?.row)!
                                cell?.btn_SocialSite3.tag = (indexPath?.row)!
                                cell?.btn_OpenUrl.tag = (indexPath?.row)!
                                
                                if self.arr_SearchData.count > 0 {
                                    self.dicUrl.removeAllObjects()
                                    if (self.arr_SearchData[(indexPath?.row)!] as! NSDictionary)["name"] != nil || (self.arr_SearchData[(indexPath?.row)!] as! NSDictionary)["name"] as? String != "" {
                                        cell?.lbl_CompanySchoolUserName.text = ((self.arr_SearchData[(indexPath?.row)!] as! NSDictionary)["name"] as? String)?.capitalized
                                    }
                                    else {
                                        cell?.lbl_CompanySchoolUserName.text = "NA"
                                    }
                                    
                                    let rating_number = "\((self.arr_SearchData[(indexPath?.row)!] as! NSDictionary)["avgRating"]!)"  //Set the star images acc. to rating
                                    
                                    let dbl = 2.0
                                    
                                    if  dbl.truncatingRemainder(dividingBy: 1) == 0
                                    {
                                        cell?.lbl_RatingFloat.text = rating_number + ".0"
                                        
                                    }
                                    else {
                                        
                                        cell?.lbl_RatingFloat.text = rating_number
                                    }
                                    
                                    
                                    cell?.lbl_totalRatingCount.text = "\((self.arr_SearchData[(indexPath?.row)!] as! NSDictionary)["ratingCount"]!)"
                                    
                                    
                                    
                                    let dict_Temp = (self.arr_SearchData[(indexPath?.row)!] as! NSDictionary)["userDTO"] as? NSDictionary
                                    let str_role = dict_Temp?.value(forKey: "role") as? String //Getting the role
                                    
                                    let str_video =  dict_Temp?.value(forKey: "videoUrl") as? String  //Video url to play video
                                    
                                    if str_video != nil {
                                        self.video_url = NSURL(string: str_video!) as URL?
                                    }
                                    else{
                                        self.video_url = nil
                                    }
                                    
                                    
                                    array_public_UserSocialSites.removeAll()
                                    
                                    //fetching urls
                                    for v in self.array_ActualSocialSites
                                    {
                                        let value = v["name_url"] as? String
                                        if  (dict_Temp?[value!] != nil && dict_Temp?.value(forKey: value!) as? String != "" )
                                        {
                                            
                                            var dic = v
                                            dic["url"] = (dict_Temp?.value(forKey: value!)!)
                                            array_public_UserSocialSites.append(dic)
                                            }
                                    }
                                    
                                    print(array_public_UserSocialSites)
                                    DispatchQueue.main.async {
                                        cell?.lbl_Description.frame.size.height = (cell?.lbl_Description.intrinsicContentSize.height)!
                                        
                                    }
                                    
                                    if str_role == "USER" {
                                        
                                        cell?.lbl_ShadowOthers.text = "Shadow Others"
                                        cell?.lbl_Count_CompanySchoolWithOccupations.isHidden = true
                                        cell?.lbl_Count_NumberOfUsers.isHidden = true
                                        cell?.lbl_occupation.isHidden = true
                                        cell?.lbl_attend.isHidden = true
                                        cell?.view_line.isHidden = true
                                        cell?.kHeight_BehindDetailView.constant = 58
                                        
                                        cell?.lbl_Location.isHidden = true
                                        cell?.imgView_Location.isHidden = true
                                        cell?.lbl_Url.isHidden = true
                                        cell?.imgView_Url.isHidden = true
                                        cell?.btn_OpenUrl.isHidden = true
                                        cell?.btn_Company.isHidden =  true
                                        
                                        cell?.lbl_Description.textAlignment = .left
                                        let str_bio = dict_Temp?.value(forKey: "bio") as? String
                                        
                                        
                                        
                                        
                                        if dict_Temp?.value(forKey: "userId") as? NSNumber == SavedPreferences.value(forKey: Global.macros.kUserId) as? NSNumber {
                                            cell?.btn_Shadow.isHidden = true
                                        }
                                        else{
                                            
                                            cell?.btn_Shadow.isHidden = false
                                        }
                                        
                                        if dict_Temp?.value(forKey: "companyName") != nil && dict_Temp?.value(forKey: "companyName") as? String != "" && dict_Temp?.value(forKey: "companyName") as? String != " " {//company not nil
                                            
                                            cell?.lbl_Location.isHidden = false
                                            cell?.imgView_Location.isHidden = false
                                            cell?.btn_Company.isHidden =  false
                                            
                                            cell?.lbl_Location.text = (dict_Temp?.value(forKey: "companyName") as? String)?.capitalized
                                            cell?.imgView_Location.image = UIImage.init(named: "company-icon")
                                            
                                            
                                            if dict_Temp?.value(forKey: "schoolName") != nil &&  dict_Temp?.value(forKey: "schoolName") as? String != "" && dict_Temp?.value(forKey: "schoolName") as? String != " " {
                                                
                                                cell?.lbl_Url.isHidden = false
                                                cell?.imgView_Url.isHidden = false
                                                cell?.btn_OpenUrl.isHidden = false
                                                
                                                cell?.lbl_Url.text = (dict_Temp?.value(forKey: "schoolName") as? String)?.capitalized
                                                cell?.imgView_Url.image = UIImage.init(named: "school-icon")
                                                // cell.btn_OpenUrl.isUserInteractionEnabled = false
                                                
                                                cell?.k_Constraint_Top_labelUrl.constant = 8.0
                                                cell?.k_Constraint_Top_btnUrl.constant = 8.0
                                                cell?.k_Constraint_Top_imageViewUrl.constant = 8.0
                                                cell?.k_Constraint_Top_tblViewSocialSite.constant = 5.0
                                                
                                                if array_public_UserSocialSites.count > 0 {
                                                    
                                                    cell?.tbl_View_SocialSite.isHidden = false
                                                    if array_public_UserSocialSites.count == 1 {//social site count 1
                                                        
                                                        cell?.k_Constraint_Height_TableviewSocialSite.constant = 50.0
                                                        
                                                        

                                                        DispatchQueue.main.async {
                                                            cell?.k_Constraint_ViewDescriptionHeight.constant = (cell?.lbl_Description.intrinsicContentSize.height)! + 130
                                                            
                                                        }

                                                        
                                                        
                                                    }
                                                    else  if array_public_UserSocialSites.count == 2{//social site count 2
                                                        
                                                        cell?.k_Constraint_Height_TableviewSocialSite.constant = 100.0

                                                        
                                                        DispatchQueue.main.async {
                                                            cell?.k_Constraint_ViewDescriptionHeight.constant = (cell?.lbl_Description.intrinsicContentSize.height)! + 155
                                                            
                                                        }
                                                        
                                                        
                                                    }
                                                    else{//social site count 3
                                                        
                                                        cell?.k_Constraint_Height_TableviewSocialSite.constant = 150.0
                                                        

                                                        
                                                        
                                                        DispatchQueue.main.async {
                                                            cell?.k_Constraint_ViewDescriptionHeight.constant = (cell?.lbl_Description.intrinsicContentSize.height)! + 185
                                                            
                                                        }
                                                    }
                                                    cell?.tbl_View_SocialSite.reloadData()
                                                    
                                                }else{
                                                    
                                                    cell?.tbl_View_SocialSite.isHidden = true
                                                    
                                             
                                                        
                                                        DispatchQueue.main.async {
                                                            cell?.k_Constraint_ViewDescriptionHeight.constant = (cell?.lbl_Description.intrinsicContentSize.height)! + 98
                                                            
                                                            
                                                        }
                                                
                                                    
                                                }
                                            }
                                            else{
                                                
                                                cell?.lbl_Url.isHidden = true
                                                cell?.imgView_Url.isHidden = true
                                                cell?.btn_OpenUrl.isHidden = true
                                                cell?.k_Constraint_Top_tblViewSocialSite.constant = -21.0

                                                if array_public_UserSocialSites.count > 0 {//social site nil
                                                    
                                                    cell?.tbl_View_SocialSite.isHidden = false
                                                    
                                                    if array_public_UserSocialSites.count == 1 {//social site count 1
                                                        
                                                        cell?.k_Constraint_Height_TableviewSocialSite.constant = 50.0
                                                        //  cell.k_Constraint_ViewDescriptionHeight.constant = 145.0
                                                        

                                                        
                                                        DispatchQueue.main.async {
                                                            cell?.k_Constraint_ViewDescriptionHeight.constant = (cell?.lbl_Description.intrinsicContentSize.height)! + 98
                                                            
                                                        }
                                                        
                                                    }
                                                    else  if array_public_UserSocialSites.count == 2{//social site count 2
                                                        
                                                        cell?.k_Constraint_Height_TableviewSocialSite.constant = 100.0
                                                       
                                                        
                                                        DispatchQueue.main.async {
                                                            cell?.k_Constraint_ViewDescriptionHeight.constant = (cell?.lbl_Description.intrinsicContentSize.height)! + 135
                                                            
                                                        }
                                                        
                                                    }
                                                    else{//social site count 3
                                                        
                                                        cell?.k_Constraint_Height_TableviewSocialSite.constant = 150.0

                                                        DispatchQueue.main.async {
                                                            cell?.k_Constraint_ViewDescriptionHeight.constant = (cell?.lbl_Description.intrinsicContentSize.height)! + 160
                                                            
                                                        }
                                                        
                                                        
                                                        
                                                        
                                                    }
                                                    cell?.tbl_View_SocialSite.reloadData()
                                                    
                                                }
                                                else{//social site not nil
                                                    
                                                    cell?.tbl_View_SocialSite.isHidden = true
                                                    
                                                    

                                                    DispatchQueue.main.async {
                                                        cell?.k_Constraint_ViewDescriptionHeight.constant = (cell?.lbl_Description.intrinsicContentSize.height)! + 75
                                                        
                                                    }
                                                    
                                                }
                                            }
                                            
                                            
                                        }
                                        else {//company is nil
                                            
                                            cell?.lbl_Location.isHidden = true
                                            cell?.imgView_Location.isHidden = true
                                            cell?.btn_Company.isHidden =  true
                                            
                                            
                                            if dict_Temp?.value(forKey: "schoolName") != nil &&  dict_Temp?.value(forKey: "schoolName") as? String != ""   &&  dict_Temp?.value(forKey: "schoolName") as? String != " "{
                                                
                                                cell?.btn_OpenUrl.isHidden = false
                                                cell?.lbl_Url.isHidden = false
                                                cell?.imgView_Url.isHidden = false
                                                
                                                cell?.lbl_Url.text = (dict_Temp?.value(forKey: "schoolName") as? String)?.capitalized
                                                cell?.imgView_Url.image = UIImage.init(named: "school-icon")
                                                
                                                
                                                cell?.k_Constraint_Top_labelUrl.constant = -20.0
                                                cell?.k_Constraint_Top_btnUrl.constant = -20.0
                                                cell?.k_Constraint_Top_imageViewUrl.constant = -15.0
                                                
                                                cell?.k_Constraint_Top_tblViewSocialSite.constant = 3.0

                                                
                                                if array_public_UserSocialSites.count > 0 {//social site not nil
                                                    
                                                    cell?.tbl_View_SocialSite.isHidden = false
                                                    if array_public_UserSocialSites.count == 1 {//social site count 1
                                                        
                                                        cell?.k_Constraint_Height_TableviewSocialSite.constant = 50.0
 
                                                        DispatchQueue.main.async {
                                                            cell?.k_Constraint_ViewDescriptionHeight.constant = (cell?.lbl_Description.intrinsicContentSize.height)! + 100
                                                            
                                                        }
                                                        
                                                        
                                                    }
                                                    else  if array_public_UserSocialSites.count == 2 { //social site count 2
                                                        
                                                        cell?.k_Constraint_Height_TableviewSocialSite.constant = 100.0
 
                                                        
                                                        DispatchQueue.main.async {
                                                            cell?.k_Constraint_ViewDescriptionHeight.constant = (cell?.lbl_Description.intrinsicContentSize.height)! + 136
                                                            
                                                        }
                                                        
                                                    }
                                                    else{//social site count 3
                                                        
                                                        cell?.k_Constraint_Height_TableviewSocialSite.constant = 150.0
      
                                                        
                                                        DispatchQueue.main.async {
                                                            cell?.k_Constraint_ViewDescriptionHeight.constant = (cell?.lbl_Description.intrinsicContentSize.height)! + 160
                                                            
                                                        }
                                                        
                                                    }
                                                    cell?.tbl_View_SocialSite.reloadData()
                                                    
                                                }else{//special site nil
                                                    
                                                    cell?.tbl_View_SocialSite.isHidden = true
                                             
                                                    
                                                    DispatchQueue.main.async {
                                                        cell?.k_Constraint_ViewDescriptionHeight.constant = (cell?.lbl_Description.intrinsicContentSize.height)! + 80
                                                        
                                                    }
                                                    
                                                    
                                                }
                                            }
                                            else{
                                                
                                                cell?.lbl_Url.isHidden = true
                                                cell?.imgView_Url.isHidden = true
                                                cell?.btn_OpenUrl.isHidden = true
                                                
                                                if array_public_UserSocialSites.count > 0 {//social sites not nil
                                                    
//                                                    print(cell?.k_Constraint_Top_tblViewSocialSite.constant ?? "" )
//                                                   // print(cell?.kheightdescription.constant ?? "" )
//                                                    print(cell?.k_Constraint_Top_labelUrl.constant ?? "" )
//                                                    print(cell?.k_Constraint_Top_btnUrl.constant ?? "" )
//                                                    print(cell?.k_Constraint_Top_imageViewUrl.constant ?? "" )
//                                                    print(cell?.k_Constraint_ViewDescriptionHeight.constant ?? "" )
//                                                    print(cell?.k_Constraint_Height_TableviewSocialSite.constant ?? "" )
//
//                                                    print(cell?.lbl_Url.frame ?? "")
//                                                     print(cell?.imgView_Url.frame ?? "")
//                                                    print(cell?.btn_OpenUrl.frame ?? "" )
//
//                                                    print(cell?.lbl_Location.frame ?? "")
//                                                    print(cell?.imgView_Location.frame ?? "")
//                                                    print(cell?.btn_Company.frame ?? "") //lbl_Description
//                                                     print(cell?.lbl_Description.frame  ?? "")
                                                 
                                                    
                                                    
                                                      cell?.tbl_View_SocialSite.isHidden = false

                                                    cell?.k_Constraint_Top_tblViewSocialSite.constant = -45.0
                                                    
                                                    if array_public_UserSocialSites.count == 1 {//social site count 1
                                                        
                                                        cell?.k_Constraint_Height_TableviewSocialSite.constant = 60.0
                                                 
                                                        
                                                        
                                                        DispatchQueue.main.async {
                                                            cell?.k_Constraint_ViewDescriptionHeight.constant = (cell?.lbl_Description.intrinsicContentSize.height)! + 85
                                                            
                                                        }
                                                        
                                                        
                                                    }
                                                    else  if array_public_UserSocialSites.count == 2{//social site count 2
                                                        
                                                        cell?.k_Constraint_Height_TableviewSocialSite.constant = 100.0
                                                      
                                                        
                                                        DispatchQueue.main.async {
                                                            cell?.k_Constraint_ViewDescriptionHeight.constant = (cell?.lbl_Description.intrinsicContentSize.height)! + 110
                                                            
                                                        }
                                                        
                                                    }
                                                    else{//social site count 3
                                                        
                                                        cell?.k_Constraint_Height_TableviewSocialSite.constant = 150.0
                                                        
                                                        DispatchQueue.main.async {
                                                            cell?.k_Constraint_ViewDescriptionHeight.constant = (cell?.lbl_Description.intrinsicContentSize.height)! + 135
                                                            
                                                        }
                                                        
                                                    }
                                                    cell?.tbl_View_SocialSite.reloadData()
                                                    
                                                }
                                                else{//everything nil
                                                    
                                                    cell?.tbl_View_SocialSite.isHidden = true
                                                  
                                                    
                                                    DispatchQueue.main.async {
                                                        cell?.k_Constraint_ViewDescriptionHeight.constant = (cell?.lbl_Description.intrinsicContentSize.height)! + 50
                                                        
                                                    }
                                                    
                                                }}}
                                        
                                         DispatchQueue.main.async {
                                        let rawString: String = (dict_Temp?.value(forKey: "companyName") as? String)!
                                        let whitespace = CharacterSet.whitespacesAndNewlines
                                        var trimmed = rawString.trimmingCharacters(in: whitespace)
                                        
                                        let rawString1: String = (dict_Temp?.value(forKey: "schoolName") as? String)!
                                        let whitespace1 = CharacterSet.whitespacesAndNewlines
                                        var trimmed1 = rawString1.trimmingCharacters(in: whitespace1)
                                        
                                        
                                        if str_bio != nil {
                                        if str_bio == "" && (trimmed.characters.count) == 0 &&  (trimmed1.characters.count) == 0 && array_public_UserSocialSites.count == 0 {
                                            DispatchQueue.main.async {

                                                //cell?.kheightdescription.constant = 20
                                                cell?.lbl_Description.frame.size.height = (cell?.lbl_Description.intrinsicContentSize.height)!
                                               cell?.lbl_Description.textColor = UIColor.darkGray

                                                cell?.lbl_Description.text = "No About Me yet."
                                                cell?.lbl_Description.font = UIFont(name: "Arial", size: 14)
                                                cell?.lbl_Description.textAlignment = .center
                                                cell?.k_Constraint_ViewDescriptionHeight.constant = (cell?.lbl_Description.intrinsicContentSize.height)! + 60
                                            }
                                            
                                        }
                                    }
                                        else {
                                            
                                            if str_bio == nil && (trimmed.characters.count) == 0 &&  (trimmed1.characters.count) == 0 && array_public_UserSocialSites.count == 0 {
                                                DispatchQueue.main.async {

                                                    //cell?.kheightdescription.constant = 20
                                                    cell?.lbl_Description.frame.size.height = (cell?.lbl_Description.intrinsicContentSize.height)!
                                                    
                                                    cell?.lbl_Description.text = "No About Me yet."
                                                    cell?.lbl_Description.font = UIFont(name: "Arial", size: 14)
                                                    cell?.lbl_Description.textAlignment = .center
                                                    cell?.lbl_Description.textColor = UIColor.darkGray
                                                    cell?.k_Constraint_ViewDescriptionHeight.constant = (cell?.lbl_Description.intrinsicContentSize.height)! + 60
                                                }
                                                
                                            }
                                            
                                        }
                                    }
                                    }
                                    else{   //For Company and school UI and data Checks
                                        cell?.lbl_ShadowOthers.text = "Verified Users"
                                        cell?.lbl_Count_NumberOfUsers.isHidden = false
                                        cell?.lbl_Count_CompanySchoolWithOccupations.isHidden = false
                                        cell?.lbl_occupation.isHidden = false
                                        cell?.lbl_attend.isHidden = false
                                        cell?.view_line.isHidden = false
                                        
                                        
                                        cell?.kHeight_BehindDetailView.constant = 118
                                        
                                        
                                        
                                        if dict_Temp?.value(forKey: "userId") as? NSNumber == SavedPreferences.value(forKey: Global.macros.kUserId) as? NSNumber {
                                            cell?.btn_Shadow.isHidden = true
                                        }
                                        else{
                                            cell?.btn_Shadow.isHidden = false
                                        }
                                        
                                        if dict_Temp?.value(forKey: "schoolOrCompanyWithTheseUsers") != nil {
                                            cell?.lbl_Count_NumberOfUsers.text = "\((dict_Temp?.value(forKey: "schoolOrCompanyWithTheseUsers") as! NSDictionary)["count"]!)"
                                            
                                            if str_role == "COMPANY"{
                                                cell?.lbl_attend.text = "Users Employed"
                                                
                                            }
                                            else{
                                                cell?.lbl_attend.text = "Users attended this school"
                                            }
                                        }
                                        else {
                                            
                                            cell?.lbl_Count_NumberOfUsers.text = "0"
                                            
                                            if str_role == "COMPANY"{
                                                cell?.lbl_attend.text = "Users Employed"
                                                
                                            }
                                            else{
                                                cell?.lbl_attend.text = "Users attended this school"
                                            }
                                        }
                                        
                                        if dict_Temp?.value(forKey: "schoolOrCompanyWithTheseOccupations")  != nil {
                                            
                                            cell?.lbl_Count_CompanySchoolWithOccupations.text = "\((dict_Temp?.value(forKey: "schoolOrCompanyWithTheseOccupations") as! NSDictionary)["count"]!)"
                                            
                                            if str_role == "COMPANY"{
                                                cell?.lbl_occupation.text = "School with these occupations"
                                                
                                            }
                                            else{
                                                cell?.lbl_occupation.text = "Company with these occupations"
                                            }
                                        }
                                            
                                        else {
                                            cell?.lbl_Count_CompanySchoolWithOccupations.text = "0"
                                            
                                            if str_role == "COMPANY"{
                                                cell?.lbl_occupation.text = "School with these occupations"
                                                
                                            }
                                            else{
                                                cell?.lbl_occupation.text = "Company with these occupations"
                                            }
                                        }
                                        
                                        cell?.imgView_Location.image = UIImage.init(named: "location-pin")
                                        cell?.lbl_Location.isHidden = false
                                        cell?.imgView_Location.isHidden = false
                                        
                                        
                                        if dict_Temp?.value(forKey: "location") != nil && dict_Temp?.value(forKey: "location") as? String != "" {
                                            // cell?.lbl_Location.text = dict_Temp?.value(forKey: "location") as? String
                                            cell?.lbl_Location.isHidden = false
                                            
                                            
                                            if ((dict_Temp?.value(forKey: Global.macros.klocation) as? String)!.contains("United States")) || ((dict_Temp?.value(forKey: Global.macros.klocation) as? String)!.contains("USA"))
                                            {
                                                let str = dict_Temp?.value(forKey: Global.macros.klocation) as? String
                                                let formattedString = str?.replacingOccurrences(of: "   ", with: "")

                                                var strArry = formattedString?.components(separatedBy: ",")
                                                strArry?.removeLast()
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
                                                    cell?.lbl_Location.text = tempStr
                                                    
                                                }
                                                
                                                
                                            }
                                                
                                            else {
                                                let str = dict_Temp?.value(forKey: Global.macros.klocation) as? String
                                                let formattedString = str?.replacingOccurrences(of: "   ", with: "")

                                                cell?.lbl_Location.text = formattedString
                                                
                                            }
                                        }
                                            
                                        else {
                                            cell?.lbl_Location.text = "NA"
                                        }
                                        
                                        
                                        if str_role == "COMPANY"{
                                            
                                            cell?.lbl_Description.textAlignment = .left
                                            
                                            //Set Company or school url to view
                                              let str_bio = dict_Temp?.value(forKey: "bio") as? String
                                            if dict_Temp?.value(forKey: "companyUrl") as? String != nil && dict_Temp?.value(forKey: "companyUrl") as? String != " "{
                                                
                                                cell?.lbl_Url.text = dict_Temp?.value(forKey: "companyUrl") as? String
                                                cell?.imgView_Url.image = UIImage.init(named: "url_icon")
                                                cell?.btn_OpenUrl.isUserInteractionEnabled = true
                                                cell?.lbl_Url.isHidden = false
                                                cell?.imgView_Url.isHidden = false
                                                
                                                cell?.k_Constraint_Top_labelUrl.constant = 8.0
                                                cell?.k_Constraint_Top_btnUrl.constant = 8.0
                                                cell?.k_Constraint_Top_imageViewUrl.constant = 8.0
                                                cell?.k_Constraint_Top_tblViewSocialSite.constant = 4.0
                                                
                                                
                                                
                                                if array_public_UserSocialSites.count > 0{//social sites not nil
                                                    cell?.tbl_View_SocialSite.isHidden = false
                                                    
                                                    if array_public_UserSocialSites.count == 1 {//social site count 1
                                                        
                                                        cell?.k_Constraint_Height_TableviewSocialSite.constant = 50.0

                                                        
                                                        DispatchQueue.main.async {
                                                            cell?.k_Constraint_ViewDescriptionHeight.constant = (cell?.lbl_Description.intrinsicContentSize.height)! + 130
                                                            
                                                        }
                                                        
                                                        
                                                    }
                                                    else  if array_public_UserSocialSites.count == 2{//social site count 2
                                                        
                                                        cell?.k_Constraint_Height_TableviewSocialSite.constant = 100.0
                                                        

                                                        
                                                        DispatchQueue.main.async {
                                                            cell?.k_Constraint_ViewDescriptionHeight.constant = (cell?.lbl_Description.intrinsicContentSize.height)! + 160
                                                            
                                                        }
                                                        
                                                    }
                                                    else{//social site count 3
                                                        
                                                        cell?.k_Constraint_Height_TableviewSocialSite.constant = 130.0
                                                        

                                                        
                                                        
                                                        DispatchQueue.main.async {
                                                            cell?.k_Constraint_ViewDescriptionHeight.constant = (cell?.lbl_Description.intrinsicContentSize.height)! + 190
                                                            
                                                        }
                                                    }
                                                    
                                                    
                                                    cell?.tbl_View_SocialSite.reloadData()
                                                }
                                                else{
                                                    
                                                    cell?.tbl_View_SocialSite.isHidden = true

                                                    
                                                    DispatchQueue.main.async {
                                                        cell?.k_Constraint_ViewDescriptionHeight.constant = (cell?.lbl_Description.intrinsicContentSize.height)! + 100
                                                        
                                                    }
                                                }
                                            }
                                            else{//IF COMPANY URL IS NIL
                                                
                                            
                                                
                                                cell?.lbl_Url.isHidden = true
                                                cell?.imgView_Url.isHidden = true
                                                cell?.btn_OpenUrl.isUserInteractionEnabled = false
                                                cell?.k_Constraint_Top_tblViewSocialSite.constant = -22 //pp

                                                if array_public_UserSocialSites.count > 0{//social sites not nil
                                                    cell?.tbl_View_SocialSite.isHidden = false
                                                    
                                                    if array_public_UserSocialSites.count == 1 {//social site count 1
                                                        
                                                        cell?.k_Constraint_Height_TableviewSocialSite.constant = 50.0

                                                        
                                                        DispatchQueue.main.async {
                                                            cell?.k_Constraint_ViewDescriptionHeight.constant = (cell?.lbl_Description.intrinsicContentSize.height)! + 100
                                                            
                                                        }
                                                        
                                                    }
                                                    else  if array_public_UserSocialSites.count == 2{//social site count 2
                                                        
                                                        cell?.k_Constraint_Height_TableviewSocialSite.constant = 100.0

                                                        
                                                        DispatchQueue.main.async {
                                                            cell?.k_Constraint_ViewDescriptionHeight.constant = (cell?.lbl_Description.intrinsicContentSize.height)! + 130
                                                            
                                                        }
                                                        
                                                    }
                                                    else{//social site count 3
                                                        
                                                        cell?.k_Constraint_Height_TableviewSocialSite.constant = 130.0

                                                        
                                                        DispatchQueue.main.async {
                                                            cell?.k_Constraint_ViewDescriptionHeight.constant = (cell?.lbl_Description.intrinsicContentSize.height)! + 160
                                                            
                                                        }
                                                    }
                                                    
                                                    
                                                    cell?.tbl_View_SocialSite.reloadData()
                                                }
                                                else{//IF SOCIAL SITES ARE NIL IN CASE OF COMPANY
                                                    
                                                    cell?.tbl_View_SocialSite.isHidden = true
                                                    

                                                    
                                                    DispatchQueue.main.async {
                                                        cell?.k_Constraint_ViewDescriptionHeight.constant = (cell?.lbl_Description.intrinsicContentSize.height)! + 75
                                                        
                                                    }
                                                }
                                                
                                                
                                            }
                                            
                                        }else{
                                            
                                            cell?.lbl_Description.textAlignment = .left

                                              let str_bio = dict_Temp?.value(forKey: "bio") as? String
                                            if dict_Temp?.value(forKey: "schoolUrl") as? String != nil && dict_Temp?.value(forKey: "schoolUrl") as? String != " " && dict_Temp?.value(forKey: "schoolUrl") as? String != ""{
                                                
                                                
                                                cell?.lbl_Url.text = dict_Temp?.value(forKey: "schoolUrl") as? String
                                                
                                                
                                                DispatchQueue.main.async {
                                                    
                                                    cell?.k_Constraint_Top_labelUrl.constant = 8.0
                                                    cell?.k_Constraint_Top_btnUrl.constant = 8.0
                                                    cell?.k_Constraint_Top_imageViewUrl.constant = 8.0
                                                    
                                                    
                                                    cell?.btn_OpenUrl.isUserInteractionEnabled = true
                                                    cell?.lbl_Url.isHidden = false
                                                    cell?.imgView_Url.isHidden = false
                                                    cell?.imgView_Url.image = UIImage.init(named: "url_icon")
                                                    cell?.k_Constraint_Top_tblViewSocialSite.constant = 2.0
                                             
                                                }
                                                
                                                
                                                if array_public_UserSocialSites.count > 0{//social sites not nil
                                                    cell?.tbl_View_SocialSite.isHidden = false
                                                    
                                                    if array_public_UserSocialSites.count == 1 {//social site count 1
                                                        
                                                        cell?.k_Constraint_Height_TableviewSocialSite.constant = 50.0

                                                        
                                                        DispatchQueue.main.async {
                                                            cell?.k_Constraint_ViewDescriptionHeight.constant = (cell?.lbl_Description.intrinsicContentSize.height)! + 130
                                                            
                                                        }
                                                        
                                                    }
                                                    else  if array_public_UserSocialSites.count == 2{//social site count 2
                                                        
                                                        cell?.k_Constraint_Height_TableviewSocialSite.constant = 100.0
                                                        DispatchQueue.main.async {
                                                            cell?.k_Constraint_ViewDescriptionHeight.constant = (cell?.lbl_Description.intrinsicContentSize.height)! + 160
                                                            
                                                        }
                                                        
                                                    }
                                                    else{//social site count 3
                                                        
                                                        cell?.k_Constraint_Height_TableviewSocialSite.constant = 130.0
                                                        DispatchQueue.main.async {
                                                            cell?.k_Constraint_ViewDescriptionHeight.constant = (cell?.lbl_Description.intrinsicContentSize.height)! + 190
                                                            
                                                        }
                                                    }
                                                    
                                                    
                                                    cell?.tbl_View_SocialSite.reloadData()
                                                }
                                                else{
                                                    
                                                    cell?.tbl_View_SocialSite.isHidden = true
                                                    
                                                    DispatchQueue.main.async {
                                                        cell?.k_Constraint_ViewDescriptionHeight.constant = (cell?.lbl_Description.intrinsicContentSize.height)! + 100
                                                        
                                                    }
                                                }
                                                
                                                
                                            }
                                            else{
                                                
                                                
                                                    cell?.lbl_Url.isHidden = true
                                                    cell?.imgView_Url.isHidden = true
                                                    cell?.btn_OpenUrl.isUserInteractionEnabled = false
                                                
                                                cell?.k_Constraint_Top_tblViewSocialSite.constant = -22.0
                                                print("atinder in")

                                                if array_public_UserSocialSites.count > 0{//social sites not nil
                                                    cell?.tbl_View_SocialSite.isHidden = false
                                                    
                                                    if array_public_UserSocialSites.count == 1 {//social site count 1
                                                        
                                                        cell?.k_Constraint_Height_TableviewSocialSite.constant = 50.0
                                                        DispatchQueue.main.async {
                                                            cell?.k_Constraint_ViewDescriptionHeight.constant = (cell?.lbl_Description.intrinsicContentSize.height)! + 100
                                                           print("atinder in in")
                                                        }
                                                        
                                                        
                                                    }
                                                    else  if array_public_UserSocialSites.count == 2{//social site count 2
                                                        
                                                        cell?.k_Constraint_Height_TableviewSocialSite.constant = 100.0
                                                        DispatchQueue.main.async {
                                                            cell?.k_Constraint_ViewDescriptionHeight.constant = (cell?.lbl_Description.intrinsicContentSize.height)! + 130
                                                            
                                                        }
                                                        
                                                    }
                                                    else{//social site count 3
                                                        
                                                        cell?.k_Constraint_Height_TableviewSocialSite.constant = 130.0
                                                        DispatchQueue.main.async {
                                                            cell?.k_Constraint_ViewDescriptionHeight.constant = (cell?.lbl_Description.intrinsicContentSize.height)! + 160
                                                            
                                                        }
                                                    }
                                                    
                                                    
                                                    cell?.tbl_View_SocialSite.reloadData()
                                                }
                                                else{//IF SOCIAL SITES ARE NIL IN CASE OF school
                                                    
                                                    cell?.tbl_View_SocialSite.isHidden = true
                                                    
                                                    DispatchQueue.main.async {
                                                        cell?.k_Constraint_ViewDescriptionHeight.constant = (cell?.lbl_Description.intrinsicContentSize.height)! + 75
                                                        
                                                    }
                                                }
                                                }}}
                                    
                                    
                                    //                        self.lbl_CountshadowedYou.text = "\((response.1).value(forKey: "totalUserCountForCompanyAndSchool")!)"
                                    
                                    
                                    
                                    
                                     if str_role == "COMPANY" || str_role == "SCHOOL" {

                                    if dict_Temp?.value(forKey: "totalUserCountForCompanyAndSchool") != nil {
                                        //Mutual data set on user, school and company
                                        let str =  dict_Temp?.value(forKey: "totalUserCountForCompanyAndSchool") as? String
                                        cell?.lbl_Count_ShadowedByShadowUser.text  = "\(str!)"
                                    }
                                        
                                    else {
                                        cell?.lbl_Count_ShadowedByShadowUser.text = "0"
                                    }
                                    
                                    }
                                    else {
                                        if dict_Temp?.value(forKey: "shadowedByShadowUser") != nil {   //Mutual data set on user, school and company
                                            let str =  "\((dict_Temp?.value(forKey: "shadowedByShadowUser") as! NSDictionary)["count"]!)"
                                            cell?.lbl_Count_ShadowedByShadowUser.text  = str
                                        }
                                            
                                        else {
                                            cell?.lbl_Count_ShadowedByShadowUser.text = "0"
                                        }
                                        
                                        
                                    }
                                    
                                    
                                    if dict_Temp?.value(forKey: "shadowersVerified")  != nil { //lbl_Count_ShadowersVerified
                                        cell?.lbl_Count_ShadowersVerified.text = "\((dict_Temp?.value(forKey: "shadowersVerified") as! NSDictionary)["count"]!)"
                                    }
                                    else {
                                        
                                        cell?.lbl_Count_ShadowersVerified.text = "0"
                                    }
                                    
                                    
                                    let str_bio = dict_Temp?.value(forKey: "bio") as? String
                                    
                               
                                    
                                    if str_bio != "" && str_bio != nil {
                                      
                                        cell?.lbl_Description.text = str_bio
                                         // cell?.kheightdescription.constant = 20
                                    }
                                    else{
                                         cell?.lbl_Description.text = ""
                                       //  cell?.kheightdescription.constant = 0
                                    }
                                    
//                                    if cell?.lbl_Url.text  == "" &&  cell?.lbl_Description.text == ""  &&  cell?.lbl_Location.text == "" {
//
//                                        DispatchQueue.main.async {
//                                            cell?.lbl_Description.isHidden = false
//                                              cell?.kheightdescription.constant = 20
//                                            cell?.lbl_Description.text = "No About Me Yet."
//                                            cell?.lbl_Description.font = UIFont(name: "Arial", size: 13)
//                                            cell?.lbl_Description.textAlignment = .center
//                                            cell?.lbl_Description.textColor = UIColor.darkGray
//                                        }
//                                    }
                                    
                                    
                                    if (dict_Temp?.value(forKey: "profileImageUrl")as? String) != nil {      // Set Profile ImageUrl
                                        var profileurl = dict_Temp?.value(forKey: "profileImageUrl") as? String
                                        profileurl = profileurl?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                                        
                                        if profileurl != nil {
                                            cell?.imgView_ProfilePic.sd_setImage(with: URL(string:profileurl!), placeholderImage: UIImage(named: "profile-icon-1"))//image
                                        }
                                    }else{
                                        cell?.imgView_ProfilePic.image = UIImage.init(named: "dummy")
                                    }
                                    self.bool_LastResultSearch = false
                                }
                                
                             //    let dict_Temp = (self.arr_SearchData[(indexPath?.row)!] as! NSDictionary)["userDTO"] as? NSDictionary
                           //      let str_bio = dict_Temp?.value(forKey: "bio") as? String
                                
                                
//                                if str_bio == "" || str_bio == nil && cell?.lbl_Url.text == "" && cell?.lbl_Location.text == "" {
//                                    DispatchQueue.main.async {
//                                    cell?.txtView_Description.isHidden = false
//                                    cell?.txtView_Description.text = "No About Me Yet."
//                                    cell?.txtView_Description.font = UIFont(name: "Arial", size: 13)
//                                    cell?.txtView_Description.textAlignment = .center
//                                    cell?.txtView_Description.textColor = UIColor.darkGray
//                                    }
//                                }
                                
                                
                                
                            } //a
                                
                            else {
                                DispatchQueue.main.async {
                                    
                                    cell?.view_MainOccupation.isHidden = false
                                    cell?.setChart()
                                    
                                    if self.arr_SearchData.count > 0 {
                                        
                                        self.dicUrl.removeAllObjects()
                                        
                                        if (self.arr_SearchData[(indexPath?.row)!] as! NSDictionary)["name"] != nil || (self.arr_SearchData[(indexPath?.row)!] as! NSDictionary)["name"] as? String != "" {
                                            cell?.lbl_CompanySchoolUserName.text = ((self.arr_SearchData[(indexPath?.row)!] as! NSDictionary)["name"] as? String)?.capitalized
                                            cell?.lbl_Abt.text = "About" + " " + "\((self.arr_SearchData[(indexPath?.row)!] as! NSDictionary)["name"]!)"
                                            
                                        }
                                        else {
                                            
                                            cell?.lbl_CompanySchoolUserName.text = "NA"
                                            cell?.lbl_Abt.text = "About"
                                        }
                                        
                                        let rating_number = "\((self.arr_SearchData[(indexPath?.row)!] as! NSDictionary)["avgRating"]!)"
                                        
                                        let dbl = 2.0
                                        
                                        if  dbl.truncatingRemainder(dividingBy: 1) == 0
                                        {
                                            cell?.lbl_Rating.text = rating_number + ".0"
                                            
                                        }
                                        else {
                                            cell?.lbl_Rating.text = rating_number
                                        }
                                        
                                        if (self.arr_SearchData[(indexPath?.row)!] as! NSDictionary)["occupationDTO"] as? NSDictionary != nil {
                                            
                                            
                                            let dict_Temp = (self.arr_SearchData[(indexPath?.row)!] as! NSDictionary)["occupationDTO"] as! NSDictionary
                                            
                                            let str_bio = dict_Temp.value(forKey: "description") as? String
                                            
                                            if str_bio != "" && str_bio != nil {
                                                
                                                 cell?.txtView_Description.text = str_bio
                                            }
                                            else {
                                                
                                                cell?.txtView_Description.text = ""

                                            }
                                            
                                            
                                            let growth = dict_Temp.value(forKey: "growth") as? String
                                            
                                            if growth != "" && growth != nil {
                                                cell?.lbl_Growth.text = growth! + "%"
                                            }
                                            else {
                                                cell?.lbl_Growth.text = "0%"
                                                
                                            }
                                            if dict_Temp.value(forKey: "salary") != nil {

                                            let morePrecisePI = Double((dict_Temp.value(forKey: "salary") as? String)!)
                                            let myInteger = Int(morePrecisePI!)
                                            let myNumber = NSNumber(value:myInteger)
                                            print(myNumber)
                                            cell?.lbl_avgSalary.text = self.suffixNumber(number: myNumber) as String
                                            }
                                            else{
                                                cell?.lbl_avgSalary.text = "0.0"
                                            }
                                            
                                        }
                                        
                                        cell?.lbl_RatingCount.text = "\((self.arr_SearchData[(indexPath?.row)!] as! NSDictionary)["ratingCount"]!)"
                                        cell?.lbl_UserWithOccupation.text = "0"
                                        cell?.lbl_UserShadowed.text = "0"
                                        
                                        
                                     
                                        
                                        
                                                                     }}}}}}}}}
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
        let visibleRect = CGRect(origin: self.customCollectionView.contentOffset, size: self.customCollectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        let indexPath = self.customCollectionView.indexPathForItem(at: visiblePoint)
        if indexPath != nil {
            let cell = self.customCollectionView.cellForItem(at: indexPath!) as? CustomCollectionViewCell
            
            if bool_Occupation == false {
                cell?.customScrollView.contentSize = CGSize.init(width: self.view.frame.size.width, height:  950)
                cell?.customScrollView.isScrollEnabled = true
                
            }
                
            else{
                
                cell?.customScrollView.contentSize = CGSize.init(width: self.view.frame.size.width, height:  750)
                
                cell?.customScrollView.isScrollEnabled = false
            }
            
            if scrollView == self.customCollectionView {
                
                if scrollView == cell?.customScrollView {
                    
                    if cell != nil {
                        
                        cell?.customScrollView.contentSize = CGSize.init(width: self.view.frame.size.width, height:  950)
                        cell?.customScrollView.contentOffset = CGPoint.zero
                        cell?.customScrollView.contentInset = UIEdgeInsets.zero
                        cell?.customScrollView.isScrollEnabled = true
                        
                    }
                }
                    
                else {
                    
                    DispatchQueue.main.async {
                        
                        let visibleRect = CGRect(origin: self.customCollectionView.contentOffset, size: self.customCollectionView.bounds.size)
                        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
                        let indexPath = self.customCollectionView.indexPathForItem(at: visiblePoint)
                        
                        if indexPath != nil {
                            let cell  = self.customCollectionView.cellForItem(at: indexPath!) as? CustomCollectionViewCell
                            
                            cell?.imgView_ProfilePic.image = UIImage.init(named: "dummy")
                            cell?.btn_SocialSite1.isHidden = true
                            cell?.btn_SocialSite2.isHidden = true
                            cell?.btn_SocialSite3.isHidden = true
                            cell?.lbl_Url.isHidden = true
                            cell?.imgView_Url.isHidden = true
                           
                            
                            cell?.lbl_CompanySchoolUserName.text = ""
                            cell?.lbl_Location.text = ""
                            cell?.lbl_Url.text = ""
                            cell?.lbl_Count_ShadowersVerified.text = "0"
                            cell?.lbl_Count_ShadowedByShadowUser.text = "0"
                            cell?.lbl_Count_CompanySchoolWithOccupations.text = "0"
                            cell?.lbl_Count_NumberOfUsers.text = "0"
                            cell?.lbl_Description.text = ""
                            cell?.txtView_Description.text = ""
                        
//                            cell?.k_Constraint_Top_labelUrl.constant = 0.0
//                            cell?.k_Constraint_Top_btnUrl.constant = 0.0
//                            cell?.k_Constraint_Top_imageViewUrl.constant = 0.0
//                            cell?.k_Constraint_Top_tblViewSocialSite.constant = 0.0
//                            cell?.k_Constraint_ViewDescriptionHeight.constant = 0.0
//                            cell?.kheightdescription.constant = 0
//                            cell?.k_Constraint_Height_TableviewSocialSite.constant = 0.0
                            
                            cell?.txtView_Description.font = UIFont(name: "Arial", size: 13)
                            cell?.txtView_Description.textAlignment = .left
                            cell?.txtView_Description.textColor = UIColor.darkGray
                            cell?.imgView_Url.isHidden = false
                            
                        }}}}}
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

//MARK: SEARCHBAR METHODS

extension CustomSearchViewController:UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            self.searchBar.resignFirstResponder()
            return false
        }
          else {
            return true
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        
        self.searchBar.showsCancelButton = false
        str_searchText = searchText
        
        if ((self.str_searchText.characters.count) > 2 ) {
            
            if bool_AllTypeOfSearches == true {
                if bool_LastResultSearch == false {
                    
                    pageIndex = 0
                      if self.str_comingfromDialogue.contains("true") {
                        self.arr_ToChatWithoutOcc.removeAllObjects()

                    }
                      else{
                        self.arr_SearchData.removeAllObjects()

                    }
                    
                    self.bool_Search = true
                    self.getSearchData()
                   
                }
            }
                
            else if bool_LocationFilter == true {
                
                if bool_LastResultSearch == false {
                    pageIndex = 0
                    self.arr_SearchData.removeAllObjects()
                    
                    self.bool_Search = true
                    self.GetSearchDataAccordingToLocation()
                   
                }
            }
                
            else if bool_CompanySchoolTrends == true{
                
                if bool_LastResultSearch == false {
                    pageIndex = 0
                    self.arr_SearchData.removeAllObjects()
                    
                    self.bool_Search = true
                    self.GetOnlyCompanyData()
                   
                }
            }
         
        }
        else  if ((self.str_searchText.characters.count) == 0 ) {
            
            
            if bool_AllTypeOfSearches == true {
                pageIndex = 0
                if self.str_comingfromDialogue.contains("true") {
                    self.arr_ToChatWithoutOcc.removeAllObjects()
                    
                }
                else{
                    self.arr_SearchData.removeAllObjects()
                    
                }
                
                self.bool_Search = true
                self.getSearchData()
                
            }
                
            else  if bool_LocationFilter == true {
                pageIndex = 0
                
                self.arr_SearchData.removeAllObjects()
                self.bool_Search = true
                self.GetSearchDataAccordingToLocation()
                
            }
                
            else if bool_CompanySchoolTrends == true{
                pageIndex = 0
                self.arr_SearchData.removeAllObjects()
                self.bool_Search = true
                self.GetOnlyCompanyData()
              
            }
                
            else {
                self.arr_SearchData.removeAllObjects()
                self.tblview_AllSearchResult.reloadData()
                self.customCollectionView.reloadData()
              
            }
        }
        else{
            self.arr_SearchData.removeAllObjects()
            self.tblview_AllSearchResult.reloadData()
            self.customCollectionView.reloadData()
           }
        
//        if searchBar.text == "" {
//            
//            self.str_searchText = ""
//            searchBar.resignFirstResponder()
//            
//            if bool_AllTypeOfSearches == true {
//                pageIndex = 0
//                self.arr_SearchData.removeAllObjects()
//                self.bool_Search = true
//                self.getSearchData()
//                self.tblview_AllSearchResult.reloadData()
//                self.customCollectionView.reloadData()
//            }
//                
//            else  if bool_LocationFilter == true {
//                pageIndex = 0
//                self.arr_SearchData.removeAllObjects()
//                self.bool_Search = true
//                self.GetSearchDataAccordingToLocation()
//                self.tblview_AllSearchResult.reloadData()
//                self.customCollectionView.reloadData()
//           
//            }
//                
//            else if bool_CompanySchoolTrends == true {
//                pageIndex = 0
//                self.arr_SearchData.removeAllObjects()
//                self.bool_Search = true
//                self.GetOnlyCompanyData()
//                self.tblview_AllSearchResult.reloadData()
//                self.customCollectionView.reloadData()
//            }
//                
//            else {
//                self.arr_SearchData.removeAllObjects()
//                self.tblview_AllSearchResult.reloadData()
//                self.customCollectionView.reloadData()
//             }
//        }
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.alpha = 1
        self.searchBar.showsCancelButton = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {}
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {}
    
}

//MARK: - CLASS EXTENSIONS
extension CustomSearchViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count:Int?
        //Custom indexpath and cell formation
        let visibleRect = CGRect(origin: self.customCollectionView.contentOffset, size: self.customCollectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        let indexPath = self.customCollectionView.indexPathForItem(at: visiblePoint)
        
        if indexPath != nil {
            let cell = self.customCollectionView.cellForItem(at: indexPath!) as? CustomCollectionViewCell
            if tableView == cell?.tbl_View_SocialSite{
                
                count = array_public_UserSocialSites.count
                
            }else{
                
                count = array_public_UserSocialSites.count
            }
            
        }
          if self.str_comingfromDialogue.contains("true") {
         
            if tableView == tblview_AllSearchResult {
                count = arr_ToChatWithoutOcc.count
            }
        }
          else{
          
            if tableView == tblview_AllSearchResult {
                count = arr_SearchData.count
            }
            
        }
        
        return count!
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var main_cell = UITableViewCell()
        
        bool_FromOccupation = false
        
        if tableView == tblview_AllSearchResult {
             if !self.str_comingfromDialogue.contains("true") {
            if self.arr_SearchData.count > 0 {
                
                if self.arr_SearchData[(indexPath.row)] as? NSDictionary != nil {
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: "cell_Simple", for: indexPath) as! AllSearchesTableViewCell
                    cell.btn_DidSelectRow.tag = indexPath.row
                    
                    DispatchQueue.main.async {
                        
                        let dict_Temp = (self.arr_SearchData[(indexPath.row)] as! NSDictionary)["userDTO"] as? NSDictionary
                        let str_role = dict_Temp?.value(forKey: "role") as? String
                        
                        if str_role == "USER" {

                            if dict_Temp?.value(forKey: "companyName") != nil  && dict_Temp?.value(forKey: "companyName") as? String != ""  && dict_Temp?.value(forKey: "companyName") as? String != " " {
                                
                                if (self.arr_SearchData[(indexPath.row)] as! NSDictionary)["occupationDTO"] == nil {
                                    
                                    cell.lbl_LocNcom.isHidden = false
                                    cell.img_LocNcom.isHidden = false
                                    
                                    let companyName =  dict_Temp?.value(forKey: "companyName") as! String
                                    
                                    if companyName != "" && dict_Temp?.value(forKey: "companyName") != nil && companyName != " " {
                                        cell.lbl_LocNcom.text = companyName.capitalized
                                        cell.img_LocNcom.image = UIImage.init(named: "company-icon")
                                    }
                                    else {
                                        
                                        cell.lbl_LocNcom.text  = ""
                                        cell.img_LocNcom.isHidden = true
                                    }
                                }
                                else {
                                    cell.lbl_LocNcom.isHidden = true
                                    cell.img_LocNcom.isHidden = true
                                }
                            }
                                
                            else {
                                
                                if dict_Temp?.value(forKey: "schoolName") != nil && dict_Temp?.value(forKey: "schoolName") as? String != "" && dict_Temp?.value(forKey: "schoolName") as? String != " " {
                                    
                                    if (self.arr_SearchData[(indexPath.row)] as! NSDictionary)["occupationDTO"] == nil {
                                        
                                        cell.lbl_LocNcom.isHidden = false
                                        cell.img_LocNcom.isHidden = false
                                        
                                        let schoolName = dict_Temp?.value(forKey: "schoolName") as! String
                                        if schoolName != "" && dict_Temp?.value(forKey: "schoolName") != nil && schoolName != " "
                                        {
                                            cell.lbl_LocNcom.text = schoolName.capitalized
                                            cell.img_LocNcom.image = UIImage.init(named: "company-icon")
                                        }
                                        else {
                                            cell.lbl_LocNcom.text = ""
                                            cell.img_LocNcom.isHidden = true
                                            
                                        }
                                    }
                                        
                                        
                                    else {
                                        cell.lbl_LocNcom.isHidden = true
                                        cell.img_LocNcom.isHidden = true
                                    }
                                }
                                    
                                else {
                                    cell.lbl_LocNcom.isHidden = true
                                    cell.img_LocNcom.isHidden = true
                                }}
                            
                        }
                            
                        else {
                            
                            if (self.arr_SearchData[(indexPath.row)] as! NSDictionary)["occupationDTO"] == nil   {
                                
                                if dict_Temp?.value(forKey: "location") != nil && dict_Temp?.value(forKey: "location") as? String != "" && dict_Temp?.value(forKey: "location") as? String != " " {
                                    
                                    
                                    cell.lbl_LocNcom.isHidden = false
                                    cell.img_LocNcom.isHidden = false
                                    
                                    let str = dict_Temp?.value(forKey: Global.macros.klocation) as? String
                                    let formattedString = str?.replacingOccurrences(of: "   ", with: "")
                                    var strArry = formattedString?.components(separatedBy: ",")
                                    
                                    
                                    if strArry?.count == 1 {
                                        var tempStr:String = ""
                                        
                                        tempStr = (strArry?.first)!
                                        
                                        let stringWithoutDigit = (tempStr.components(separatedBy: NSCharacterSet.decimalDigits) as NSArray).componentsJoined(by: "")
                                        cell.lbl_LocNcom.text = stringWithoutDigit.capitalized
                                        
                                    }
                                        
                                    else if strArry?.count == 2 {
                                        strArry?.removeLast()
                                        var tempStr:String = ""
                                        
                                        tempStr = (strArry?.first)!
                                        
                                        let stringWithoutDigit = (tempStr.components(separatedBy: NSCharacterSet.decimalDigits) as NSArray).componentsJoined(by: "")
                                        cell.lbl_LocNcom.text = stringWithoutDigit.capitalized
                                        
                                        
                                    }
                                        
                                    else if strArry?.count == 3 {
                                        
                                        strArry?.removeLast()
                                        
                                        var tempStr:String = ""
                                        if strArry != nil {
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
                                                let stringWithoutDigit = (tempStr.components(separatedBy: NSCharacterSet.decimalDigits) as NSArray).componentsJoined(by: "")
                                                cell.lbl_LocNcom.text = stringWithoutDigit.capitalized
                                                
                                                
                                            }
                                            
                                        }
                                    }
                                    else if (strArry?.count)! > 3 {
                                        
                                        print(strArry!)
                                        strArry?.removeLast()
                                        strArry?.removeFirst()
                                        
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
                                            
                                            let stringWithoutDigit = (tempStr.components(separatedBy: NSCharacterSet.decimalDigits) as NSArray).componentsJoined(by: "")
                                            cell.lbl_LocNcom.text = stringWithoutDigit.capitalized
                                            
                                        }
                                    }
                                    cell.img_LocNcom.image = UIImage.init(named: "location-pin")
                                    
                                }
                                else {
                                    
                                    cell.lbl_LocNcom.text = ""
                                    cell.img_LocNcom.image = UIImage.init(named: "")
                                    cell.img_LocNcom.isHidden = true
                                  }
                            }
                            else {
                                cell.lbl_LocNcom.isHidden = true
                                cell.img_LocNcom.isHidden = true
                            }
                        }
                        
                        if bool_LocationFilter == true {
                            
                            cell.lbl_Time.isHidden = false
                            
                            if self.arr_SearchData.count > 0 {
                                let str_distance = (self.arr_SearchData[indexPath.row] as! NSDictionary)["distance"] as? NSString
                                
                                if str_distance == "" || str_distance == nil {
                                    cell.lbl_Time.text = "10000M"
                                }
                                else {
                                    cell.lbl_Time.text = String(format: "%.0f", str_distance!.floatValue) + " " + "MILES"
                                }
                            }
                        }
                            
                        else {
                            cell.lbl_Time.isHidden = true
                        }
                    }
                    if self.arr_SearchData.count > 0 {
                        
                        cell.lbl_Name.text = ((arr_SearchData[indexPath.row] as! NSDictionary)["name"] as? String)?.capitalized
                        let rating_number = "\((arr_SearchData[indexPath.row] as! NSDictionary)["avgRating"]!)"
                        let dbl = 2.0
                        if  dbl.truncatingRemainder(dividingBy: 1) == 0
                        {
                            cell.lbl_RatingFloat.text = rating_number + ".0"
                        }
                        else {
                            cell.lbl_RatingFloat.text = rating_number
                        }
                        
                        cell.lbl_totalRatingCount.text = "\((arr_SearchData[indexPath.row] as! NSDictionary)["ratingCount"]!)"
                        
                        let dict_Temp : NSDictionary?
                       
                        if  bool_Occupation == true {
                            
                        
                            dict_Temp = (arr_SearchData[indexPath.row] as! NSDictionary)["occupationDTO"] as? NSDictionary
                            
                            if dict_Temp?.value(forKey: "profileImageUrl")as? String != nil {
                                var profileurl = dict_Temp?.value(forKey: "profileImageUrl")as? String
                                profileurl = profileurl?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                                
                                if profileurl != nil {
                                    
                                    cell.imgView_Profile.sd_setImage(with: URL(string:profileurl!), placeholderImage: UIImage(named: "occupation_filter"))//image
                                }
                            }else{
                                cell.imgView_Profile.image = UIImage.init(named: "occupation_filter")
                            }
                            
                        }
                        else {
                            
                            if (arr_SearchData[indexPath.row] as! NSDictionary)["occupationDTO"] as? NSDictionary != nil {
                                
                                dict_Temp = (arr_SearchData[indexPath.row] as! NSDictionary)["occupationDTO"] as? NSDictionary
                                
                                if dict_Temp?.value(forKey: "profileImageUrl")as? String != nil{
                                    var profileurl = dict_Temp?.value(forKey: "profileImageUrl")as? String
                                    profileurl = profileurl?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                                    
                                    if profileurl != nil {
                                        
                                        cell.imgView_Profile.sd_setImage(with: URL(string:profileurl!), placeholderImage: UIImage(named: "occupation_filter"))//image
                                    }
                                }else{
                                    cell.imgView_Profile.image = UIImage.init(named: "occupation_filter")
                                }
                            }
                            else {
                                dict_Temp = (arr_SearchData[indexPath.row] as! NSDictionary)["userDTO"] as? NSDictionary
                                
                                if dict_Temp?.value(forKey: "profileImageUrl")as? String != nil{
                                    var profileurl = dict_Temp?.value(forKey: "profileImageUrl")as? String
                                    profileurl = profileurl?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                                    
                                    if profileurl != nil {
                                        
                                        cell.imgView_Profile.sd_setImage(with: URL(string:profileurl!), placeholderImage: UIImage(named: "profile-icon-1"))//image
                                    }
                                }else{
                                    cell.imgView_Profile.image = UIImage.init(named: "profile-icon-1")
                                }
                                
                                if dict_Temp?.value(forKey: "qbId")as? String != nil {
                                    
                                    self.qb_id =  dict_Temp?.value(forKey: "qbId") as? String
                                    
                                }else{
                                    self.qb_id = ""
                                } }
                            
                            
                            
                            
                        }
                        bool_LastResultSearch = false
                    }
                    
                
                    
                    
                    
                    
                    
                    
                    main_cell = cell
                }
                
                
                }
            
        }
             else{
                
                   if self.arr_ToChatWithoutOcc.count > 0 {
                    
                    if self.arr_ToChatWithoutOcc[(indexPath.row)] as? NSDictionary != nil {
                        
                        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_Simple", for: indexPath) as! AllSearchesTableViewCell
                        cell.btn_DidSelectRow.tag = indexPath.row
                        
                        DispatchQueue.main.async {
                            
                            let dict_Temp = (self.arr_ToChatWithoutOcc[(indexPath.row)] as! NSDictionary)["userDTO"] as? NSDictionary
                            let str_role = dict_Temp?.value(forKey: "role") as? String
                            
                            if str_role == "USER" {
                                
                                if dict_Temp?.value(forKey: "companyName") != nil  && dict_Temp?.value(forKey: "companyName") as? String != ""  && dict_Temp?.value(forKey: "companyName") as? String != " " {
                                    
                                    if (self.arr_ToChatWithoutOcc[(indexPath.row)] as! NSDictionary)["occupationDTO"] == nil {
                                        
                                        cell.lbl_LocNcom.isHidden = false
                                        cell.img_LocNcom.isHidden = false
                                        
                                        let companyName =  dict_Temp?.value(forKey: "companyName") as! String
                                        
                                        if companyName != "" && dict_Temp?.value(forKey: "companyName") != nil && companyName != " " {
                                            cell.lbl_LocNcom.text = companyName.capitalized
                                            cell.img_LocNcom.image = UIImage.init(named: "company-icon")
                                        }
                                        else {
                                            
                                            cell.lbl_LocNcom.text  = ""
                                            cell.img_LocNcom.isHidden = true
                                        }
                                    }
                                    else {
                                        cell.lbl_LocNcom.isHidden = true
                                        cell.img_LocNcom.isHidden = true
                                    }
                                }
                                    
                                else {
                                    
                                    if dict_Temp?.value(forKey: "schoolName") != nil && dict_Temp?.value(forKey: "schoolName") as? String != "" && dict_Temp?.value(forKey: "schoolName") as? String != " " {
                                        
                                        if (self.arr_ToChatWithoutOcc[(indexPath.row)] as! NSDictionary)["occupationDTO"] == nil {
                                            
                                            cell.lbl_LocNcom.isHidden = false
                                            cell.img_LocNcom.isHidden = false
                                            
                                            let schoolName = dict_Temp?.value(forKey: "schoolName") as! String
                                            if schoolName != "" && dict_Temp?.value(forKey: "schoolName") != nil && schoolName != " "
                                            {
                                                cell.lbl_LocNcom.text = schoolName.capitalized
                                                cell.img_LocNcom.image = UIImage.init(named: "company-icon")
                                            }
                                            else {
                                                cell.lbl_LocNcom.text = ""
                                                cell.img_LocNcom.isHidden = true
                                                
                                            }
                                        }
                                            
                                            
                                        else {
                                            cell.lbl_LocNcom.isHidden = true
                                            cell.img_LocNcom.isHidden = true
                                        }
                                    }
                                        
                                    else {
                                        cell.lbl_LocNcom.isHidden = true
                                        cell.img_LocNcom.isHidden = true
                                    }}
                                
                            }
                                
                            else {
                                
                                
                                    if dict_Temp?.value(forKey: "location") != nil && dict_Temp?.value(forKey: "location") as? String != "" && dict_Temp?.value(forKey: "location") as? String != " " {
                                        
                                        
                                        cell.lbl_LocNcom.isHidden = false
                                        cell.img_LocNcom.isHidden = false
                                        
                                        let str = dict_Temp?.value(forKey: Global.macros.klocation) as? String
                                     
                                        let formattedString = str?.replacingOccurrences(of: "   ", with: "")
                                        var strArry = formattedString?.components(separatedBy: ",")
                                        
                                        
                                        if strArry?.count == 1 {
                                            var tempStr:String = ""
                                            
                                            tempStr = (strArry?.first)!
                                            
                                            let stringWithoutDigit = (tempStr.components(separatedBy: NSCharacterSet.decimalDigits) as NSArray).componentsJoined(by: "")
                                            cell.lbl_LocNcom.text = stringWithoutDigit.capitalized
                                            
                                        }
                                            
                                        else if strArry?.count == 2 {
                                            strArry?.removeLast()
                                            var tempStr:String = ""
                                            
                                            tempStr = (strArry?.first)!
                                            
                                            let stringWithoutDigit = (tempStr.components(separatedBy: NSCharacterSet.decimalDigits) as NSArray).componentsJoined(by: "")
                                            cell.lbl_LocNcom.text = stringWithoutDigit.capitalized
                                            
                                            
                                        }
                                            
                                        else if strArry?.count == 3 {
                                            
                                            strArry?.removeLast()
                                            
                                            var tempStr:String = ""
                                            if strArry != nil {
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
                                                    let stringWithoutDigit = (tempStr.components(separatedBy: NSCharacterSet.decimalDigits) as NSArray).componentsJoined(by: "")
                                                    cell.lbl_LocNcom.text = stringWithoutDigit.capitalized
                                                    
                                                    
                                                }
                                                
                                            }
                                        }
                                        else if (strArry?.count)! > 3 {
                                            
                                            print(strArry!)
                                            strArry?.removeLast()
                                            strArry?.removeFirst()
                                            
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
                                                
                                                let stringWithoutDigit = (tempStr.components(separatedBy: NSCharacterSet.decimalDigits) as NSArray).componentsJoined(by: "")
                                                cell.lbl_LocNcom.text = stringWithoutDigit.capitalized
                                                
                                            }
                                        }
                                        cell.img_LocNcom.image = UIImage.init(named: "location-pin")
                                        
                                    }
                                    else {
                                        
                                        cell.lbl_LocNcom.text = ""
                                        cell.img_LocNcom.image = UIImage.init(named: "")
                                        cell.img_LocNcom.isHidden = true
                                    }
                                
                            }
                            
                        }
                        if self.arr_ToChatWithoutOcc.count > 0 {
                             cell.lbl_Time.isHidden = true
                            cell.lbl_Name.text = ((arr_ToChatWithoutOcc[indexPath.row] as! NSDictionary)["name"] as? String)?.capitalized
                            let rating_number = "\((arr_ToChatWithoutOcc[indexPath.row] as! NSDictionary)["avgRating"]!)"
                            let dbl = 2.0
                            if  dbl.truncatingRemainder(dividingBy: 1) == 0
                            {
                                cell.lbl_RatingFloat.text = rating_number + ".0"
                            }
                            else {
                                cell.lbl_RatingFloat.text = rating_number
                            }
                            
                            cell.lbl_totalRatingCount.text = "\((arr_ToChatWithoutOcc[indexPath.row] as! NSDictionary)["ratingCount"]!)"
                            
                            let dict_Temp : NSDictionary?
                            
                               
                                    dict_Temp = (arr_ToChatWithoutOcc[indexPath.row] as! NSDictionary)["userDTO"] as? NSDictionary
                                    
                                    if dict_Temp?.value(forKey: "profileImageUrl")as? String != nil{
                                        var profileurl = dict_Temp?.value(forKey: "profileImageUrl")as? String
                                        profileurl = profileurl?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                                        
                                        if profileurl != nil {
                                            
                                            cell.imgView_Profile.sd_setImage(with: URL(string:profileurl!), placeholderImage: UIImage(named: "profile-icon-1"))//image
                                        }
                                    }else{
                                        cell.imgView_Profile.image = UIImage.init(named: "profile-icon-1")
                                    }
                                    
                                    if dict_Temp?.value(forKey: "qbId")as? String != nil {
                                        
                                        self.qb_id =  dict_Temp?.value(forKey: "qbId") as? String
                                        
                                    }else{
                                        self.qb_id = ""
                                    }
                                
                                
                                
                                
                            
                            bool_LastResultSearch = false
                        }
                        
                        
                        
                        
                        
                        
                        
                        
                        main_cell = cell
                    }

                    
                   }
                
            }
            
        }
        else {//for social site table view
            
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
            
            main_cell = cell
        }
        return main_cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView != tblview_AllSearchResult {
            
            let site_url = (array_public_UserSocialSites[indexPath.row] as NSDictionary).value(forKey: "url") as? String
            let trimmedString = site_url?.trimmingCharacters(in: .whitespacesAndNewlines)
            
            print(trimmedString!)
            DispatchQueue.main.async {
                
                if let checkURL = NSURL(string: trimmedString!) {
                    
                    if  UIApplication.shared.openURL(checkURL as URL) {
                        
                        print("URL Successfully Opened")
                    }
                    else {
                        self.showAlert(Message: "Invalid URL", vc: self)
                        print("Invalid URL")
                    }
                } else {
                    self.showAlert(Message: "Invalid URL", vc: self)
                    print("Invalid URL")
                }}}}}

//MARK : - COLLECTIONVIEW StarFull
extension CustomSearchViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath)as! CustomCollectionViewCell
        bool_FromOccupation = false
        
        let desiredOffset = CGPoint(x: 0, y: -CGFloat((cell.customScrollView.contentInset.top )))
        cell.customScrollView.setContentOffset(desiredOffset, animated: true)
        
            DispatchQueue.main.async {
            if self.bool_Search == true {
                  cell.lbl_Description.textColor = UIColor.init(red: 36.0/255.0, green: 36.0/255.0, blue: 36.0/255.0, alpha: 1.0)
                if (self.arr_SearchData[(indexPath.row)] as! NSDictionary)["occupationDTO"] == nil {
                    cell.view_MainOccupation.isHidden = true
                    self.bool_Search = false
                    cell.btn_ViewFullProfile.tag = indexPath.row
                    cell.btn_PlayVideo.tag =   indexPath.row
                    cell.btn_SocialSite1.tag = indexPath.row
                    cell.btn_SocialSite2.tag = indexPath.row
                    cell.btn_SocialSite3.tag = indexPath.row
                    
                    print(indexPath.row)
                    print("indexPath \(indexPath.row)")
                    if self.arr_SearchData.count > 0 {
                        
                        self.dicUrl.removeAllObjects()
                        
                        if (self.arr_SearchData[indexPath.row] as! NSDictionary)["name"] != nil || (self.arr_SearchData[indexPath.row] as! NSDictionary)["name"] as? String != "" {
                            cell.lbl_CompanySchoolUserName.text = ((self.arr_SearchData[indexPath.row] as! NSDictionary)["name"] as? String)?.capitalized
                            
                        }
                        else {
                            cell.lbl_CompanySchoolUserName.text = "NA"
                        }
                        
                        let rating_number = "\((self.arr_SearchData[indexPath.row] as! NSDictionary)["avgRating"]!)"
                        
                        let dbl = 2.0
                        
                        if  dbl.truncatingRemainder(dividingBy: 1) == 0
                        {
                            cell.lbl_RatingFloat.text = rating_number + ".0"
                        }
                        else {
                            cell.lbl_RatingFloat.text = rating_number
                        }
                        
                        cell.lbl_totalRatingCount.text = "\((self.arr_SearchData[(indexPath.row)] as! NSDictionary)["ratingCount"]!)"
                        
                        let dict_Temp = (self.arr_SearchData[(indexPath.row)] as! NSDictionary)["userDTO"] as? NSDictionary
                        let str_role = dict_Temp?.value(forKey: "role") as? String
                        let str_video =  dict_Temp?.value(forKey: "videoUrl") as? String
                        
                        if str_video != nil {
                            self.video_url = NSURL(string: str_video!) as URL?
                        }
                        else {
                            self.video_url = nil
                        }
                        array_public_UserSocialSites.removeAll()
                        
                        //fetching urls
                        for v in self.array_ActualSocialSites
                        {
                            let value = v["name_url"] as? String
                            if  (dict_Temp?[value!] != nil && dict_Temp?.value(forKey: value!) as? String != "" )
                            {
                                var dic = v
                                dic["url"] = (dict_Temp?.value(forKey: value!)!)
                                array_public_UserSocialSites.append(dic)
                            }
                        }
                        
                        print(array_public_UserSocialSites)
                        
                        if str_role == "USER" {
                            
                            cell.lbl_ShadowOthers.text = "Shadow Others"
                            cell.lbl_Count_CompanySchoolWithOccupations.isHidden = true
                            cell.lbl_Count_NumberOfUsers.isHidden = true
                            cell.lbl_occupation.isHidden = true
                            cell.lbl_attend.isHidden = true
                            cell.view_line.isHidden = true
                            cell.kHeight_BehindDetailView.constant = 58
                            
                            cell.lbl_Location.isHidden = true
                            cell.imgView_Location.isHidden = true
                            cell.lbl_Url.isHidden = true
                            cell.imgView_Url.isHidden = true
                            cell.btn_OpenUrl.isHidden = true
                            cell.btn_Company.isHidden =  true
                            
                            cell.lbl_Description.textAlignment = .left
                            let str_bio = dict_Temp?.value(forKey: "bio") as? String
                            
                            
                            
                            
                            if dict_Temp?.value(forKey: "userId") as? NSNumber == SavedPreferences.value(forKey: Global.macros.kUserId) as? NSNumber {
                                cell.btn_Shadow.isHidden = true
                            }
                            else{
                                
                                cell.btn_Shadow.isHidden = false
                            }
                            
                            if dict_Temp?.value(forKey: "companyName") != nil && dict_Temp?.value(forKey: "companyName") as? String != "" && dict_Temp?.value(forKey: "companyName") as? String != " " {//company not nil
                                
                                cell.lbl_Location.isHidden = false
                                cell.imgView_Location.isHidden = false
                                cell.btn_Company.isHidden =  false
                                
                                cell.lbl_Location.text = (dict_Temp?.value(forKey: "companyName") as? String)?.capitalized
                                cell.imgView_Location.image = UIImage.init(named: "company-icon")
                                
                                
                                if dict_Temp?.value(forKey: "schoolName") != nil &&  dict_Temp?.value(forKey: "schoolName") as? String != "" && dict_Temp?.value(forKey: "schoolName") as? String != " " {
                                    
                                    cell.lbl_Url.isHidden = false
                                    cell.imgView_Url.isHidden = false
                                    cell.btn_OpenUrl.isHidden = false
                                    
                                    cell.lbl_Url.text = (dict_Temp?.value(forKey: "schoolName") as? String)?.capitalized
                                    cell.imgView_Url.image = UIImage.init(named: "school-icon")
                                    // cell.btn_OpenUrl.isUserInteractionEnabled = false
                                    
                                    cell.k_Constraint_Top_labelUrl.constant = 8.0
                                    cell.k_Constraint_Top_btnUrl.constant = 8.0
                                    cell.k_Constraint_Top_imageViewUrl.constant = 8.0
                                    cell.k_Constraint_Top_tblViewSocialSite.constant = 5.0
                                    
                                    if array_public_UserSocialSites.count > 0 {
                                        
                                        cell.tbl_View_SocialSite.isHidden = false
                                        if array_public_UserSocialSites.count == 1 {//social site count 1
                                            
                                            cell.k_Constraint_Height_TableviewSocialSite.constant = 50.0
                                            
                                            
                                            
                                            DispatchQueue.main.async {
                                                cell.k_Constraint_ViewDescriptionHeight.constant = cell.lbl_Description.intrinsicContentSize.height + 130
                                                
                                            }
                                            
                                            
                                            
                                        }
                                        else  if array_public_UserSocialSites.count == 2{//social site count 2
                                            
                                            cell.k_Constraint_Height_TableviewSocialSite.constant = 100.0
                                            
                                            
                                            DispatchQueue.main.async {
                                                cell.k_Constraint_ViewDescriptionHeight.constant = cell.lbl_Description.intrinsicContentSize.height + 155
                                                
                                            }
                                            
                                            
                                        }
                                        else{//social site count 3
                                            
                                            cell.k_Constraint_Height_TableviewSocialSite.constant = 150.0
                                            
                                            
                                            
                                            
                                            DispatchQueue.main.async {
                                                cell.k_Constraint_ViewDescriptionHeight.constant = cell.lbl_Description.intrinsicContentSize.height + 185
                                                
                                            }
                                        }
                                        cell.tbl_View_SocialSite.reloadData()
                                        
                                    }else{
                                        
                                        cell.tbl_View_SocialSite.isHidden = true
                                        
                                        
                                        
                                        DispatchQueue.main.async {
                                            cell.k_Constraint_ViewDescriptionHeight.constant = cell.lbl_Description.intrinsicContentSize.height + 98
                                            
                                            
                                        }
                                        
                                        
                                    }
                                }
                                else{
                                    
                                    cell.lbl_Url.isHidden = true
                                    cell.imgView_Url.isHidden = true
                                    cell.btn_OpenUrl.isHidden = true
                                    cell.k_Constraint_Top_tblViewSocialSite.constant = -21.0
                                    
                                    if array_public_UserSocialSites.count > 0 {//social site nil
                                        
                                        cell.tbl_View_SocialSite.isHidden = false
                                        
                                        if array_public_UserSocialSites.count == 1 {//social site count 1
                                            
                                            cell.k_Constraint_Height_TableviewSocialSite.constant = 50.0
                                            //  cell.k_Constraint_ViewDescriptionHeight.constant = 145.0
                                            
                                            
                                            
                                            DispatchQueue.main.async {
                                                cell.k_Constraint_ViewDescriptionHeight.constant = cell.lbl_Description.intrinsicContentSize.height + 98
                                                
                                            }
                                            
                                        }
                                        else  if array_public_UserSocialSites.count == 2{//social site count 2
                                            
                                            cell.k_Constraint_Height_TableviewSocialSite.constant = 100.0
                                            
                                            
                                            DispatchQueue.main.async {
                                                cell.k_Constraint_ViewDescriptionHeight.constant = cell.lbl_Description.intrinsicContentSize.height + 135
                                                
                                            }
                                            
                                        }
                                        else{//social site count 3
                                            
                                            cell.k_Constraint_Height_TableviewSocialSite.constant = 150.0
                                            
                                            DispatchQueue.main.async {
                                                cell.k_Constraint_ViewDescriptionHeight.constant = cell.lbl_Description.intrinsicContentSize.height + 160
                                                
                                            }
                                            
                                            
                                            
                                            
                                        }
                                        cell.tbl_View_SocialSite.reloadData()
                                        
                                    }
                                    else{//social site not nil
                                        
                                        cell.tbl_View_SocialSite.isHidden = true
                                        
                                        
                                        
                                        DispatchQueue.main.async {
                                            cell.k_Constraint_ViewDescriptionHeight.constant = cell.lbl_Description.intrinsicContentSize.height + 75
                                            
                                        }
                                        
                                    }
                                }
                                
                                
                            }
                            else {//company is nil
                                
                                cell.lbl_Location.isHidden = true
                                cell.imgView_Location.isHidden = true
                                cell.btn_Company.isHidden =  true
                                
                                
                                if dict_Temp?.value(forKey: "schoolName") != nil &&  dict_Temp?.value(forKey: "schoolName") as? String != ""   &&  dict_Temp?.value(forKey: "schoolName") as? String != " "{
                                    
                                    cell.btn_OpenUrl.isHidden = false
                                    cell.lbl_Url.isHidden = false
                                    cell.imgView_Url.isHidden = false
                                    
                                    cell.lbl_Url.text = (dict_Temp?.value(forKey: "schoolName") as? String)?.capitalized
                                    cell.imgView_Url.image = UIImage.init(named: "school-icon")
                                    
                                    
                                    cell.k_Constraint_Top_labelUrl.constant = -20.0
                                    cell.k_Constraint_Top_btnUrl.constant = -20.0
                                    cell.k_Constraint_Top_imageViewUrl.constant = -15.0
                                    
                                    cell.k_Constraint_Top_tblViewSocialSite.constant = 3.0
                                    
                                    
                                    if array_public_UserSocialSites.count > 0 {//social site not nil
                                        
                                        cell.tbl_View_SocialSite.isHidden = false
                                        if array_public_UserSocialSites.count == 1 {//social site count 1
                                            
                                            cell.k_Constraint_Height_TableviewSocialSite.constant = 50.0
                                            
                                            DispatchQueue.main.async {
                                                cell.k_Constraint_ViewDescriptionHeight.constant = cell.lbl_Description.intrinsicContentSize.height + 100
                                                
                                            }
                                            
                                            
                                        }
                                        else  if array_public_UserSocialSites.count == 2 { //social site count 2
                                            
                                            cell.k_Constraint_Height_TableviewSocialSite.constant = 100.0
                                            
                                            
                                            DispatchQueue.main.async {
                                                cell.k_Constraint_ViewDescriptionHeight.constant = cell.lbl_Description.intrinsicContentSize.height + 136
                                                
                                            }
                                            
                                        }
                                        else{//social site count 3
                                            
                                            cell.k_Constraint_Height_TableviewSocialSite.constant = 150.0
                                            
                                            
                                            DispatchQueue.main.async {
                                                cell.k_Constraint_ViewDescriptionHeight.constant = cell.lbl_Description.intrinsicContentSize.height + 160
                                                
                                            }
                                            
                                        }
                                        cell.tbl_View_SocialSite.reloadData()
                                        
                                    }else{//special site nil
                                        
                                        cell.tbl_View_SocialSite.isHidden = true
                                        
                                        
                                        DispatchQueue.main.async {
                                            cell.k_Constraint_ViewDescriptionHeight.constant = cell.lbl_Description.intrinsicContentSize.height + 80
                                            
                                        }
                                        
                                        
                                    }
                                }
                                else{
                                    
                                    cell.lbl_Url.isHidden = true
                                    cell.imgView_Url.isHidden = true
                                    cell.btn_OpenUrl.isHidden = true
                                    
                                    if array_public_UserSocialSites.count > 0 {//social sites not nil
                                        
                                        //                                                    print(cell?.k_Constraint_Top_tblViewSocialSite.constant ?? "" )
                                        //                                                   // print(cell?.kheightdescription.constant ?? "" )
                                        //                                                    print(cell?.k_Constraint_Top_labelUrl.constant ?? "" )
                                        //                                                    print(cell?.k_Constraint_Top_btnUrl.constant ?? "" )
                                        //                                                    print(cell?.k_Constraint_Top_imageViewUrl.constant ?? "" )
                                        //                                                    print(cell?.k_Constraint_ViewDescriptionHeight.constant ?? "" )
                                        //                                                    print(cell?.k_Constraint_Height_TableviewSocialSite.constant ?? "" )
                                        //
                                        //                                                    print(cell?.lbl_Url.frame ?? "")
                                        //                                                     print(cell?.imgView_Url.frame ?? "")
                                        //                                                    print(cell?.btn_OpenUrl.frame ?? "" )
                                        //
                                        //                                                    print(cell?.lbl_Location.frame ?? "")
                                        //                                                    print(cell?.imgView_Location.frame ?? "")
                                        //                                                    print(cell?.btn_Company.frame ?? "") //lbl_Description
                                        //                                                     print(cell?.lbl_Description.frame  ?? "")
                                        
                                        
                                        
                                        cell.tbl_View_SocialSite.isHidden = false
                                        
                                        cell.k_Constraint_Top_tblViewSocialSite.constant = -45.0
                                        
                                        if array_public_UserSocialSites.count == 1 {//social site count 1
                                            
                                            cell.k_Constraint_Height_TableviewSocialSite.constant = 60.0
                                            
                                            
                                            
                                            DispatchQueue.main.async {
                                                cell.k_Constraint_ViewDescriptionHeight.constant = cell.lbl_Description.intrinsicContentSize.height + 85
                                                
                                            }
                                            
                                            
                                        }
                                        else  if array_public_UserSocialSites.count == 2{//social site count 2
                                            
                                            cell.k_Constraint_Height_TableviewSocialSite.constant = 100.0
                                            
                                            
                                            DispatchQueue.main.async {
                                                cell.k_Constraint_ViewDescriptionHeight.constant = cell.lbl_Description.intrinsicContentSize.height + 110
                                                
                                            }
                                            
                                        }
                                        else{//social site count 3
                                            
                                            cell.k_Constraint_Height_TableviewSocialSite.constant = 150.0
                                            
                                            DispatchQueue.main.async {
                                                cell.k_Constraint_ViewDescriptionHeight.constant = cell.lbl_Description.intrinsicContentSize.height + 135
                                                
                                            }
                                            
                                        }
                                        cell.tbl_View_SocialSite.reloadData()
                                        
                                    }
                                    else{//everything nil
                                        
                                        cell.tbl_View_SocialSite.isHidden = true
                                        
                                        
                                        DispatchQueue.main.async {
                                            cell.k_Constraint_ViewDescriptionHeight.constant = cell.lbl_Description.intrinsicContentSize.height + 50
                                            
                                        }
                                        
                                    }}}
                            
                              DispatchQueue.main.async {
                            let rawString: String = (dict_Temp?.value(forKey: "companyName") as? String)!
                            let whitespace = CharacterSet.whitespacesAndNewlines
                            var trimmed = rawString.trimmingCharacters(in: whitespace)
                            
                            let rawString1: String = (dict_Temp?.value(forKey: "schoolName") as? String)!
                            let whitespace1 = CharacterSet.whitespacesAndNewlines
                            var trimmed1 = rawString1.trimmingCharacters(in: whitespace1)
                            
                            
                            if str_bio != nil {
                                if str_bio == "" && (trimmed.characters.count) == 0 &&  (trimmed1.characters.count) == 0 && array_public_UserSocialSites.count == 0 {
                                    
                                        
                                        //cell?.kheightdescription.constant = 20
                                        cell.lbl_Description.frame.size.height = cell.lbl_Description.intrinsicContentSize.height
                                        
                                        cell.lbl_Description.text = "No About Me yet."
                                        cell.lbl_Description.font = UIFont(name: "Arial", size: 14)
                                        cell.lbl_Description.textAlignment = .center
                                        cell.lbl_Description.textColor = UIColor.darkGray
                                        cell.k_Constraint_ViewDescriptionHeight.constant = cell.lbl_Description.intrinsicContentSize.height + 60
                                    }
                                    
                                
                            }
                            else {
                                
                                if str_bio == nil && (trimmed.characters.count) == 0 &&  (trimmed1.characters.count) == 0 && array_public_UserSocialSites.count == 0 {
                                    
                                        //cell?.kheightdescription.constant = 20
                                        cell.lbl_Description.frame.size.height = cell.lbl_Description.intrinsicContentSize.height
                                        
                                        cell.lbl_Description.text = "No About Me yet."
                                        cell.lbl_Description.font = UIFont(name: "Arial", size: 14)
                                        cell.lbl_Description.textAlignment = .center
                                        cell.lbl_Description.textColor = UIColor.darkGray
                                        cell.k_Constraint_ViewDescriptionHeight.constant = cell.lbl_Description.intrinsicContentSize.height + 60
                                    }
                                    
                            
                                
                            }
                        }
                            
                        }
                        else{   //For Company and school UI and data Checks
                            cell.lbl_ShadowOthers.text = "Verified Users"
                            cell.lbl_Count_NumberOfUsers.isHidden = false
                            cell.lbl_Count_CompanySchoolWithOccupations.isHidden = false
                            cell.lbl_occupation.isHidden = false
                            cell.lbl_attend.isHidden = false
                            cell.view_line.isHidden = false
                            
                            
                            cell.kHeight_BehindDetailView.constant = 118
                            
                            
                            
                            if dict_Temp?.value(forKey: "userId") as? NSNumber == SavedPreferences.value(forKey: Global.macros.kUserId) as? NSNumber {
                                cell.btn_Shadow.isHidden = true
                            }
                            else{
                                cell.btn_Shadow.isHidden = false
                            }
                            
                            if dict_Temp?.value(forKey: "schoolOrCompanyWithTheseUsers") != nil {
                                cell.lbl_Count_NumberOfUsers.text = "\((dict_Temp?.value(forKey: "schoolOrCompanyWithTheseUsers") as! NSDictionary)["count"]!)"
                                
                                if str_role == "COMPANY"{
                                    cell.lbl_attend.text = "Users Employed"
                                    
                                }
                                else{
                                    cell.lbl_attend.text = "Users attended this school"
                                }
                            }
                            else {
                                
                                cell.lbl_Count_NumberOfUsers.text = "0"
                                
                                if str_role == "COMPANY"{
                                    cell.lbl_attend.text = "Users Employed"
                                    
                                }
                                else{
                                    cell.lbl_attend.text = "Users attended this school"
                                }
                            }
                            
                            if dict_Temp?.value(forKey: "schoolOrCompanyWithTheseOccupations")  != nil {
                                
                                cell.lbl_Count_CompanySchoolWithOccupations.text = "\((dict_Temp?.value(forKey: "schoolOrCompanyWithTheseOccupations") as! NSDictionary)["count"]!)"
                                
                                if str_role == "COMPANY"{
                                    cell.lbl_occupation.text = "School with these occupations"
                                    
                                }
                                else{
                                    cell.lbl_occupation.text = "Company with these occupations"
                                }
                            }
                                
                            else {
                                cell.lbl_Count_CompanySchoolWithOccupations.text = "0"
                                
                                if str_role == "COMPANY"{
                                    cell.lbl_occupation.text = "School with these occupations"
                                    
                                }
                                else{
                                    cell.lbl_occupation.text = "Company with these occupations"
                                }
                            }
                            
                            cell.imgView_Location.image = UIImage.init(named: "location-pin")
                            cell.lbl_Location.isHidden = false
                            cell.imgView_Location.isHidden = false
                            
                            
                            if dict_Temp?.value(forKey: "location") != nil && dict_Temp?.value(forKey: "location") as? String != "" {
                                // cell?.lbl_Location.text = dict_Temp?.value(forKey: "location") as? String
                                cell.lbl_Location.isHidden = false
                                
                                
                                if ((dict_Temp?.value(forKey: Global.macros.klocation) as? String)!.contains("United States")) || ((dict_Temp?.value(forKey: Global.macros.klocation) as? String)!.contains("USA"))
                                {
                                    let str = dict_Temp?.value(forKey: Global.macros.klocation) as? String
                                     let formattedString = str?.replacingOccurrences(of: "   ", with: "")
                                    
                                    var strArry = formattedString?.components(separatedBy: ",")
                                    strArry?.removeLast()
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
                                        cell.lbl_Location.text = tempStr
                                        
                                    }
                                    
                                    
                                }
                                    
                                else {
                                    let str = dict_Temp?.value(forKey: Global.macros.klocation) as? String
                                    let formattedString = str?.replacingOccurrences(of: "   ", with: "")

                                    cell.lbl_Location.text = formattedString
                                    
                                }
                            }
                                
                            else {
                                cell.lbl_Location.text = "NA"
                            }
                            
                            
                            if str_role == "COMPANY"{
                                
                                cell.lbl_Description.textAlignment = .left
                                
                                //Set Company or school url to view
                                let str_bio = dict_Temp?.value(forKey: "bio") as? String
                                if dict_Temp?.value(forKey: "companyUrl") as? String != nil && dict_Temp?.value(forKey: "companyUrl") as? String != " "{
                                    
                                    cell.lbl_Url.text = dict_Temp?.value(forKey: "companyUrl") as? String
                                    cell.imgView_Url.image = UIImage.init(named: "url_icon")
                                    cell.btn_OpenUrl.isUserInteractionEnabled = true
                                    cell.lbl_Url.isHidden = false
                                    cell.imgView_Url.isHidden = false
                                    
                                    cell.k_Constraint_Top_labelUrl.constant = 8.0
                                    cell.k_Constraint_Top_btnUrl.constant = 8.0
                                    cell.k_Constraint_Top_imageViewUrl.constant = 8.0
                                    cell.k_Constraint_Top_tblViewSocialSite.constant = 4.0
                                    
                                    
                                    
                                    if array_public_UserSocialSites.count > 0{//social sites not nil
                                        cell.tbl_View_SocialSite.isHidden = false
                                        
                                        if array_public_UserSocialSites.count == 1 {//social site count 1
                                            
                                            cell.k_Constraint_Height_TableviewSocialSite.constant = 50.0
                                            
                                            
                                            DispatchQueue.main.async {
                                                cell.k_Constraint_ViewDescriptionHeight.constant = cell.lbl_Description.intrinsicContentSize.height + 130
                                                
                                            }
                                            
                                            
                                        }
                                        else  if array_public_UserSocialSites.count == 2{//social site count 2
                                            
                                            cell.k_Constraint_Height_TableviewSocialSite.constant = 100.0
                                            
                                            
                                            
                                            DispatchQueue.main.async {
                                                cell.k_Constraint_ViewDescriptionHeight.constant = cell.lbl_Description.intrinsicContentSize.height + 160
                                                
                                            }
                                            
                                        }
                                        else{//social site count 3
                                            
                                            cell.k_Constraint_Height_TableviewSocialSite.constant = 130.0
                                            
                                            
                                            
                                            
                                            DispatchQueue.main.async {
                                                cell.k_Constraint_ViewDescriptionHeight.constant = cell.lbl_Description.intrinsicContentSize.height + 190
                                                
                                            }
                                        }
                                        
                                        
                                        cell.tbl_View_SocialSite.reloadData()
                                    }
                                    else{
                                        
                                        cell.tbl_View_SocialSite.isHidden = true
                                        
                                        
                                        DispatchQueue.main.async {
                                            cell.k_Constraint_ViewDescriptionHeight.constant = cell.lbl_Description.intrinsicContentSize.height + 100
                                            
                                        }
                                    }
                                }
                                else{//IF COMPANY URL IS NIL
                                    
                                    
                                    
                                    cell.lbl_Url.isHidden = true
                                    cell.imgView_Url.isHidden = true
                                    cell.btn_OpenUrl.isUserInteractionEnabled = false
                                    cell.k_Constraint_Top_tblViewSocialSite.constant = -22 //pp
                                    
                                    if array_public_UserSocialSites.count > 0{//social sites not nil
                                        cell.tbl_View_SocialSite.isHidden = false
                                        
                                        if array_public_UserSocialSites.count == 1 {//social site count 1
                                            
                                            cell.k_Constraint_Height_TableviewSocialSite.constant = 50.0
                                            
                                            
                                            DispatchQueue.main.async {
                                                cell.k_Constraint_ViewDescriptionHeight.constant = cell.lbl_Description.intrinsicContentSize.height + 100
                                                
                                            }
                                            
                                        }
                                        else  if array_public_UserSocialSites.count == 2{//social site count 2
                                            
                                            cell.k_Constraint_Height_TableviewSocialSite.constant = 100.0
                                            
                                            
                                            DispatchQueue.main.async {
                                                cell.k_Constraint_ViewDescriptionHeight.constant = cell.lbl_Description.intrinsicContentSize.height + 130
                                                
                                            }
                                            
                                        }
                                        else{//social site count 3
                                            
                                            cell.k_Constraint_Height_TableviewSocialSite.constant = 130.0
                                            
                                            
                                            DispatchQueue.main.async {
                                                cell.k_Constraint_ViewDescriptionHeight.constant = cell.lbl_Description.intrinsicContentSize.height + 160
                                                
                                            }
                                        }
                                        
                                        
                                        cell.tbl_View_SocialSite.reloadData()
                                    }
                                    else{//IF SOCIAL SITES ARE NIL IN CASE OF COMPANY
                                        
                                        cell.tbl_View_SocialSite.isHidden = true
                                        
                                        
                                        
                                        DispatchQueue.main.async {
                                            cell.k_Constraint_ViewDescriptionHeight.constant = cell.lbl_Description.intrinsicContentSize.height + 75
                                            
                                        }
                                    }
                                    
                                    
                                }
                                
                            }else{
                                
                                cell.lbl_Description.textAlignment = .left
                                
                                let str_bio = dict_Temp?.value(forKey: "bio") as? String
                                if dict_Temp?.value(forKey: "schoolUrl") as? String != nil && dict_Temp?.value(forKey: "schoolUrl") as? String != " " && dict_Temp?.value(forKey: "schoolUrl") as? String != ""{
                                    
                                    
                                    cell.lbl_Url.text = dict_Temp?.value(forKey: "schoolUrl") as? String
                                    
                                    
                                    DispatchQueue.main.async {
                                        
                                        cell.k_Constraint_Top_labelUrl.constant = 8.0
                                        cell.k_Constraint_Top_btnUrl.constant = 8.0
                                        cell.k_Constraint_Top_imageViewUrl.constant = 8.0
                                        
                                        
                                        cell.btn_OpenUrl.isUserInteractionEnabled = true
                                        cell.lbl_Url.isHidden = false
                                        cell.imgView_Url.isHidden = false
                                        cell.imgView_Url.image = UIImage.init(named: "url_icon")
                                        cell.k_Constraint_Top_tblViewSocialSite.constant = 2.0
                                        
                                    }
                                    
                                    
                                    if array_public_UserSocialSites.count > 0{//social sites not nil
                                        cell.tbl_View_SocialSite.isHidden = false
                                        
                                        if array_public_UserSocialSites.count == 1 {//social site count 1
                                            
                                            cell.k_Constraint_Height_TableviewSocialSite.constant = 50.0
                                            
                                            
                                            DispatchQueue.main.async {
                                                cell.k_Constraint_ViewDescriptionHeight.constant = cell.lbl_Description.intrinsicContentSize.height + 130
                                                
                                            }
                                            
                                        }
                                        else  if array_public_UserSocialSites.count == 2{//social site count 2
                                            
                                            cell.k_Constraint_Height_TableviewSocialSite.constant = 100.0
                                            DispatchQueue.main.async {
                                                cell.k_Constraint_ViewDescriptionHeight.constant = cell.lbl_Description.intrinsicContentSize.height + 160
                                                
                                            }
                                            
                                        }
                                        else{//social site count 3
                                            
                                            cell.k_Constraint_Height_TableviewSocialSite.constant = 130.0
                                            DispatchQueue.main.async {
                                                cell.k_Constraint_ViewDescriptionHeight.constant = cell.lbl_Description.intrinsicContentSize.height + 190
                                                
                                            }
                                        }
                                        
                                        
                                        cell.tbl_View_SocialSite.reloadData()
                                    }
                                    else{
                                        
                                        cell.tbl_View_SocialSite.isHidden = true
                                        
                                        DispatchQueue.main.async {
                                            cell.k_Constraint_ViewDescriptionHeight.constant = cell.lbl_Description.intrinsicContentSize.height + 100
                                            
                                        }
                                    }
                                    
                                    
                                }
                                else{
                                    
                                    
                                    cell.lbl_Url.isHidden = true
                                    cell.imgView_Url.isHidden = true
                                    cell.btn_OpenUrl.isUserInteractionEnabled = false
                                    
                                    cell.k_Constraint_Top_tblViewSocialSite.constant = -22.0
                                    print("atinder in")
                                    
                                    if array_public_UserSocialSites.count > 0{//social sites not nil
                                        cell.tbl_View_SocialSite.isHidden = false
                                        
                                        if array_public_UserSocialSites.count == 1 {//social site count 1
                                            
                                            cell.k_Constraint_Height_TableviewSocialSite.constant = 50.0
                                            DispatchQueue.main.async {
                                                cell.k_Constraint_ViewDescriptionHeight.constant = cell.lbl_Description.intrinsicContentSize.height + 100
                                                print("atinder in in")
                                            }
                                            
                                            
                                        }
                                        else  if array_public_UserSocialSites.count == 2{//social site count 2
                                            
                                            cell.k_Constraint_Height_TableviewSocialSite.constant = 100.0
                                            DispatchQueue.main.async {
                                                cell.k_Constraint_ViewDescriptionHeight.constant = cell.lbl_Description.intrinsicContentSize.height + 130
                                                
                                            }
                                            
                                        }
                                        else{//social site count 3
                                            
                                            cell.k_Constraint_Height_TableviewSocialSite.constant = 130.0
                                            DispatchQueue.main.async {
                                                cell.k_Constraint_ViewDescriptionHeight.constant = cell.lbl_Description.intrinsicContentSize.height + 160
                                                
                                            }
                                        }
                                        
                                        
                                        cell.tbl_View_SocialSite.reloadData()
                                    }
                                    else{//IF SOCIAL SITES ARE NIL IN CASE OF school
                                        
                                        cell.tbl_View_SocialSite.isHidden = true
                                        
                                        DispatchQueue.main.async {
                                            cell.k_Constraint_ViewDescriptionHeight.constant = cell.lbl_Description.intrinsicContentSize.height + 75
                                            
                                        }
                                    }
                                }}}
                        
                        if str_role == "COMPANY" || str_role == "SCHOOL" {
                            
                            if dict_Temp?.value(forKey: "totalUserCountForCompanyAndSchool") != nil {   //Mutual data set on user, school and company
                                let str =  dict_Temp?.value(forKey: "totalUserCountForCompanyAndSchool") as? String
                                cell.lbl_Count_ShadowedByShadowUser.text  = "\(str!)"
                            }
                                
                            else {
                                cell.lbl_Count_ShadowedByShadowUser.text = "0"
                            }
                            
                        }
                        else {
                            if dict_Temp?.value(forKey: "shadowedByShadowUser") != nil {   //Mutual data set on user, school and company
                                let str =  "\((dict_Temp?.value(forKey: "shadowedByShadowUser") as! NSDictionary)["count"]!)"
                                cell.lbl_Count_ShadowedByShadowUser.text  = str
                            }
                                
                            else {
                                cell.lbl_Count_ShadowedByShadowUser.text = "0"
                            }
                            
                            
                        }
                        
                        if dict_Temp?.value(forKey: "shadowersVerified") != nil {
                            cell.lbl_Count_ShadowedByShadowUser.text = "\((dict_Temp?.value(forKey: "shadowersVerified") as! NSDictionary)["count"]!)"
                        }
                        else {
                            
                            cell.lbl_Count_ShadowedByShadowUser.text = "0"
                        }
                        
                        let str_bio = dict_Temp?.value(forKey: "bio") as? String
                        
                        if str_bio != "" && str_bio != nil {
                           
                             cell.lbl_Description.text = str_bio
                            //cell.kheightdescription.constant = 20

                        }
                        else{
                            cell.lbl_Description.text = ""
                            cell.lbl_Description.frame.size.height = cell.lbl_Description.intrinsicContentSize.height


                        }
                       
                        
                        //  profileImageUrl
                        if (dict_Temp?.value(forKey: "profileImageUrl")as? String) != nil {
                            var profileurl = dict_Temp?.value(forKey: "profileImageUrl") as? String
                            profileurl = profileurl?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                            
                            if profileurl != nil {
                                cell.imgView_ProfilePic.sd_setImage(with: URL(string:profileurl!), placeholderImage: UIImage(named: "profile-icon-1"))//image
                            }
                            
                        }else{
                            
                            cell.imgView_ProfilePic.image = UIImage.init(named: "dummy")
                            
                        }
                        self.bool_LastResultSearch = false
                        
                  
                        
                        
                 
                        
//                        if cell.lbl_Description.text == "" && cell.lbl_Url.text == "" && cell.lbl_Location.text == "" {
//                            DispatchQueue.main.async {
//                                
//                                cell.kheightdescription.constant = 20
//                                cell.lbl_Description.text = "No About Me Yet."
//                                cell.lbl_Description.font = UIFont(name: "Arial", size: 13)
//                                cell.lbl_Description.textAlignment = .center
//                                cell.lbl_Description.textColor = UIColor.darkGray
//                            }
//                            
//                        }
                        
                    }
                    
             
                    
                    
                }   //at
                else {
                    
                    DispatchQueue.main.async {
                        
                        cell.view_MainOccupation.isHidden = false
                        cell.setChart()
                        
                        if self.arr_SearchData.count > 0 {
                            
                            self.dicUrl.removeAllObjects()
                            if (self.arr_SearchData[indexPath.row] as! NSDictionary)["name"] != nil || (self.arr_SearchData[indexPath.row] as! NSDictionary)["name"] as? String != "" {
                                cell.lbl_CompanySchoolUserName.text = ((self.arr_SearchData[indexPath.row] as! NSDictionary)["name"] as? String)?.capitalized
                                cell.lbl_Abt.text = "About" + " " + "\((self.arr_SearchData[indexPath.row] as! NSDictionary)["name"]!)"
                                
                            }
                            else {
                                
                                cell.lbl_CompanySchoolUserName.text = "NA"
                                cell.lbl_Abt.text = "About"
                            }
                            
                            let rating_number = "\((self.arr_SearchData[indexPath.row] as! NSDictionary)["avgRating"]!)"
                            
                            let dbl = 2.0
                            
                            if  dbl.truncatingRemainder(dividingBy: 1) == 0
                            {
                                cell.lbl_Rating.text = rating_number + ".0"
                                
                            }
                            else {
                                cell.lbl_Rating.text = rating_number
                            }
                            if (self.arr_SearchData[(indexPath.row)] as! NSDictionary)["occupationDTO"] as? NSDictionary != nil {
                                
                                
                                let dict_Temp = (self.arr_SearchData[(indexPath.row)] as! NSDictionary)["occupationDTO"] as! NSDictionary
                                
                                let str_bio = dict_Temp.value(forKey: "description") as? String
                                
                                let growth = dict_Temp.value(forKey: "growth") as? String
                                
                                  if growth != "" && growth != nil {
                                     cell.lbl_Growth.text = growth! + "%"
                                }
                                else {
                                    cell.lbl_Growth.text = "0%"
                                }
                                
                                if str_bio != "" && str_bio != nil {
                                    
                                      cell.txtView_Description.text = str_bio

                                }
                                else {
                                    
                                       cell.txtView_Description.text = ""

                                }
                              
                                if dict_Temp.value(forKey: "salary") != nil {

                                if dict_Temp.value(forKey: "salary") as? String != "" && dict_Temp.value(forKey: "salary") != nil {
                                let morePrecisePI = Double((dict_Temp.value(forKey: "salary") as? String)!)
                                let myInteger = Int(morePrecisePI!)
                                let myNumber = NSNumber(value:myInteger)
                                print(myNumber)
                                cell.lbl_avgSalary.text = self.suffixNumber(number: myNumber) as String
                                    
                                    }
                                    
                                else {
                                    
                                    cell.lbl_avgSalary.text = "0.0"
                                    }
                                    
                                }
                            }
                            
                            
                            cell.lbl_RatingCount.text = "\((self.arr_SearchData[(indexPath.row)] as! NSDictionary)["ratingCount"]!)"
                          
                            cell.lbl_UserWithOccupation.text = "0"
                            cell.lbl_UserShadowed.text = "0"
                              }}}}}
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.size.width , height: self.view.frame.size.height + 180)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arr_SearchData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
    
}


