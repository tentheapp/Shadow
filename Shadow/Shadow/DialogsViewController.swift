//
//  DialogsViewController.swift
//  Shadow
//
//  Created by Atinderjit Kaur on 31/10/17.
//  Copyright © 2017 Atinderjit Kaur. All rights reserved.
//

import UIKit



class DialogsViewController: UIViewController {
    
    
    @IBOutlet weak var tblView_Dialogs: UITableView!
    var arr_Dialogs = NSMutableArray()
    var dialog_Chat : QBChatDialog!
    
    
    var searchBar : UISearchBar!
    var btn2:UIButton = UIButton()
    var barBtn_Search: UIBarButtonItem?
    var lbl_Search = UILabel()
    
    
    fileprivate var str_searchText: String = ""
    fileprivate var temp_arr : NSMutableArray = NSMutableArray()
    fileprivate var arr_Search : NSMutableArray = NSMutableArray()
    fileprivate var arr_FinalDialogs : NSMutableArray = NSMutableArray()
    private let refreshControl = UIRefreshControl()
    
    
    var userIdToShowProfile : String? = ""
    var arr_DeletedDialogId = NSMutableArray()
  //  var str_deletedDialogId : String = ""
  //  var str_deletedLastMessage : String = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblView_Dialogs.tableFooterView = UIView()
        let myBackButton:UIButton = UIButton()
        myBackButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        myBackButton.setImage(UIImage(named:"back-new"), for: UIControlState())
        myBackButton.addTarget(self, action: #selector(self.popvc), for: UIControlEvents.touchUpInside)
        let leftBackBarButton:UIBarButtonItem = UIBarButtonItem(customView: myBackButton)
        self.navigationItem.leftBarButtonItem = leftBackBarButton
        
        // To add new chat contacts
        let myPlusButton:UIButton = UIButton()
        myPlusButton.frame = CGRect(x: 0, y: 0, width: 18, height: 18)
        myPlusButton.setImage(UIImage(named:"add_purple"), for: UIControlState())
        myPlusButton.addTarget(self, action: #selector(self.OpenProfileOfOther), for: UIControlEvents.touchUpInside)
        let RightBackBarButton:UIBarButtonItem = UIBarButtonItem(customView: myPlusButton)
        self.navigationItem.rightBarButtonItem = RightBackBarButton
        
        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            self.tblView_Dialogs.refreshControl = self.refreshControl
        } else {
            self.tblView_Dialogs.addSubview(self.refreshControl)
        }
        
        self.refreshControl.addTarget(self, action: #selector(self.refreshWeatherData(_:)), for: .valueChanged)
        
        // Do any additional setup after loading the view.
    }
    
   
    func popvc()
    {
        
        
        bool_PlayFromProfile = false
        
        if   bool_PushComingFromAppDelegate == true {
            
            bool_PushComingFromAppDelegate = false
            
            let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "SWRevealViewController") as!  SWRevealViewController
            Global.macros.kAppDelegate.window?.rootViewController = vc
            
        }
        else{
            let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "SWRevealViewController") as!  SWRevealViewController
            Global.macros.kAppDelegate.window?.rootViewController = vc

        }
        
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        DispatchQueue.main.async {
            
            DispatchQueue.main.async {
                self.pleaseWait()
            }
            
            self.searchBar = UISearchBar()
            self.searchBar.delegate = self
            self.arr_FinalDialogs.removeAllObjects()
            bool_AllTypeOfSearches = false
            
            self.navigationController?.setNavigationBarHidden(false, animated: false)
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.navigationController?.navigationBar.shadowImage = UIImage();
            UINavigationBar.appearance().isTranslucent = false
            self.navigationItem.setHidesBackButton(false, animated:true)
            Global.macros.statusBar.backgroundColor = UIColor.white
            UIApplication.shared.statusBarStyle = .default
            Global.macros.statusBar.isHidden = false
            self.showSearchBar()
            
            self.tblView_Dialogs.separatorColor = UIColor.lightGray
            
        }
        
        QBRequest.logIn(withUserLogin: SavedPreferences.value(forKey: "email") as! String, password: "mind@123", successBlock: { (response, user) in
            
            print("Successful login")
            
            SavedPreferences.setValue(user?.id, forKey: "qb_UserId")
            
            
            QBChat.instance().connect(with: user!, completion: { (error) in
                self.FetchDialogs()
               
                
            })
            
            
        }, errorBlock: { (response) in
            print("login")
            print("error: \(response.error)")
            DispatchQueue.main.async
                {
                    self.clearAllNotice()
                    self.showAlert(Message: "Something went wrong! Please try again." ,vc: self)
            }
            
        })
        
        
        
        
        
        self.tabBarController?.tabBar.isHidden = true
        self.tabBarController?.tabBar.isTranslucent = true
    }
    
    
    @objc private func refreshWeatherData(_ sender: Any) {
        // Fetch Weather Data
        FetchDialogs()
        self.refreshControl.endRefreshing()
        
    }
    
    
    // To open list for chat with new user
    func OpenProfileOfOther() {
        
        self.next_View()
        
    }
    
    
    func next_View(){
        
        if self.checkInternetConnection()
        {
            DispatchQueue.main.async {
                
                self.searchBar.endEditing(true)
                self.view.endEditing(true)
                self.searchBar.resignFirstResponder()
                self.searchBar.text = ""
                
            }
            
            bool_AllTypeOfSearches = true
            self.PushToCustomSearchVC()
            
        }
        else
        {
            self.showAlert(Message: Global.macros.kInternetConnection, vc: self)
        }
        
        
    }
    
    func PushToCustomSearchVC() {
        
        let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "customSearch") as! CustomSearchViewController
        vc.str_comingfromDialogue = "true"
        
        _ = self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    
    
    //MARK: Fuctions
    
    
    @IBAction func OpenProfile(_ sender: UIButton) {
        
        
        let dic = arr_Dialogs[sender.tag] as! QBChatDialog
        
        let str = dic.name
        
        let str_obb :NSString = NSString(string:str!)
        
        let delimiter = "_"
        let token = str_obb.components(separatedBy: delimiter)
        
        let str1: String = (token.first)!
        let str2: String = (token.last)!
        
//        let str1: String = (token.first)!
//        let str2: String = (token.last)!
//
//        // str1
//        let delimiter1 = "/"
//        let token1 = str1.components(separatedBy: delimiter1)
//
//        let delimiter_role = "-"
//        let token_role = str1.components(separatedBy: delimiter_role)
//        let str_role: String = (token_role.last)!
//
//        let str_name: String = (token1.first)!
//
//        let token_userId = (token_role.first)!.components(separatedBy: delimiter1)
//        let str_Id: String = (token_userId.last)!
//
//
//        let token2 = str2.components(separatedBy: "/")
//        print(token2)
//        let token_id = (token2.last)!.components(separatedBy: "-")
//
//        let str_name2: String = (token2.first)!
//
//        let str_role2: String = (token_id.last)!
//
//        let str_Id2: String = (token_id.first)!
        
        // str1
        let delimiter1 = "/"
        let token1 = str1.components(separatedBy: delimiter1)
        let str_name: String = (token1.first)! //name
        let sub_data : String = (token1.last)!
    
        
        let subDataArray = sub_data.components(separatedBy: "-")
        let str_Id: String = (subDataArray.first)!
        let str_role: String = (subDataArray.last)!
        
        
        // str 2
        let token2 = str2.components(separatedBy: "/")
        print(token2)
        let str_name2: String = (token2.first)!
        let sub_data2 : String = (token2.last)!
        
        let subDataArray2 = sub_data2.components(separatedBy: "-")
        let str_Id2: String = (subDataArray2.first)!
        let str_role2: String = (subDataArray2.last)!
        
        
        if (SavedPreferences.value(forKey: "role") as? String) == "USER" {
            
            
            if (str_name.caseInsensitiveCompare("\(SavedPreferences.value(forKey: Global.macros.kUserName)!)".capitalized ) != ComparisonResult.orderedSame) {
                
                
                if str_role == "USER" {
                    
                    let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "user") as! ProfileVC
                    
                    self.userIdToShowProfile = str_Id
                    
                    if let myInteger = Int(self.userIdToShowProfile!) {
                        let myNumber = NSNumber(value:myInteger)
                        vc.user_IdMyProfile =  myNumber
                        
                    }
                    
                    _ = self.navigationController?.pushViewController(vc, animated: true)
                    
                }
                    
                else{
                    
                    let vc_com = Global.macros.Storyboard.instantiateViewController(withIdentifier: "company") as! ComapanySchoolViewController
                    self.userIdToShowProfile = str_Id
                    
                    
                    if let myInteger = Int(self.userIdToShowProfile!) {
                        let myNumber = NSNumber(value:myInteger)
                        vc_com.user_IdMyProfile =  myNumber
                        
                    }
                    
                    _ = self.navigationController?.pushViewController(vc_com, animated: true)
                    
                    
                }
                
            }
                
            else if (str_name2.caseInsensitiveCompare("\(SavedPreferences.value(forKey: Global.macros.kUserName)!)".capitalized ) != ComparisonResult.orderedSame) {
                
                if str_role2 == "USER" {
                    
                    let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "user") as! ProfileVC
                    
                    
                    self.userIdToShowProfile = str_Id2
                    
                    
                    if let myInteger = Int(self.userIdToShowProfile!) {
                        let myNumber = NSNumber(value:myInteger)
                        vc.user_IdMyProfile =  myNumber
                        
                    }
                    
                    _ = self.navigationController?.pushViewController(vc, animated: true)
                    
                }
                    
                else{
                    
                    let vc_com = Global.macros.Storyboard.instantiateViewController(withIdentifier: "company") as! ComapanySchoolViewController
                    self.userIdToShowProfile = str_Id2
                    
                    
                    if let myInteger = Int(self.userIdToShowProfile!) {
                        let myNumber = NSNumber(value:myInteger)
                        vc_com.user_IdMyProfile =  myNumber
                        
                    }
                    
                    _ = self.navigationController?.pushViewController(vc_com, animated: true)
                    
                    
                }
                
            }
            
            
        }
            
            
        else  if (SavedPreferences.value(forKey: "role") as? String) == "SCHOOL" {
            
            
            if (str_name.caseInsensitiveCompare("\(SavedPreferences.value(forKey: Global.macros.kschoolName)!)".capitalized ) != ComparisonResult.orderedSame) {
                
                
                if str_role == "USER" {
                    
                    let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "user") as! ProfileVC
                    
                    self.userIdToShowProfile = str_Id
                    
                    if let myInteger = Int(self.userIdToShowProfile!) {
                        
                        let myNumber = NSNumber(value:myInteger)
                        vc.user_IdMyProfile =  myNumber
                        
                    }
                    
                    _ = self.navigationController?.pushViewController(vc, animated: true)
                    
                }
                    
                else{
                    
                    let vc_com = Global.macros.Storyboard.instantiateViewController(withIdentifier: "company") as! ComapanySchoolViewController
                    self.userIdToShowProfile = str_Id
                    
                    
                    if let myInteger = Int(self.userIdToShowProfile!) {
                        let myNumber = NSNumber(value:myInteger)
                        vc_com.user_IdMyProfile =  myNumber
                        
                    }
                    
                    _ = self.navigationController?.pushViewController(vc_com, animated: true)
                    
                    
                }
                
            }
                
            else if (str_name2.caseInsensitiveCompare("\(SavedPreferences.value(forKey: Global.macros.kschoolName)!)".capitalized ) != ComparisonResult.orderedSame){
                
                if str_role2 == "USER" {
                    
                    let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "user") as! ProfileVC
                    
                    
                    self.userIdToShowProfile = str_Id2
                    
                    
                    if let myInteger = Int(self.userIdToShowProfile!) {
                        let myNumber = NSNumber(value:myInteger)
                        vc.user_IdMyProfile =  myNumber
                        
                    }
                    
                    _ = self.navigationController?.pushViewController(vc, animated: true)
                    
                }
                    
                else{
                    
                    let vc_com = Global.macros.Storyboard.instantiateViewController(withIdentifier: "company") as! ComapanySchoolViewController
                    self.userIdToShowProfile = str_Id2
                    
                    
                    if let myInteger = Int(self.userIdToShowProfile!) {
                        let myNumber = NSNumber(value:myInteger)
                        vc_com.user_IdMyProfile =  myNumber
                        
                    }
                    
                    _ = self.navigationController?.pushViewController(vc_com, animated: true)
                    
                    
                }
                
            }
            
            
        }
            
        else  if (SavedPreferences.value(forKey: "role") as? String) == "COMPANY" {
            
            
            if (str_name.caseInsensitiveCompare("\(SavedPreferences.value(forKey: Global.macros.kcompanyName)!)".capitalized ) != ComparisonResult.orderedSame) {
                
                
                if str_role == "USER" {
                    
                    let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "user") as! ProfileVC
                    
                    self.userIdToShowProfile = str_Id
                    
                    if let myInteger = Int(self.userIdToShowProfile!) {
                        let myNumber = NSNumber(value:myInteger)
                        vc.user_IdMyProfile =  myNumber
                        
                    }
                    
                    _ = self.navigationController?.pushViewController(vc, animated: true)
                    
                }
                    
                else{
                    
                    let vc_com = Global.macros.Storyboard.instantiateViewController(withIdentifier: "company") as! ComapanySchoolViewController
                    self.userIdToShowProfile = str_Id
                    
                    
                    if let myInteger = Int(self.userIdToShowProfile!) {
                        let myNumber = NSNumber(value:myInteger)
                        vc_com.user_IdMyProfile =  myNumber
                        
                    }
                    
                    _ = self.navigationController?.pushViewController(vc_com, animated: true)
                    
                    
                }
                
            }
                
            else if (str_name2.caseInsensitiveCompare("\(SavedPreferences.value(forKey: Global.macros.kcompanyName)!)".capitalized ) != ComparisonResult.orderedSame){
                
                if str_role2 == "USER" {
                    
                    let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "user") as! ProfileVC
                    
                    
                    self.userIdToShowProfile = str_Id2
                    
                    
                    if let myInteger = Int(self.userIdToShowProfile!) {
                        let myNumber = NSNumber(value:myInteger)
                        vc.user_IdMyProfile =  myNumber
                        
                    }
                    
                    _ = self.navigationController?.pushViewController(vc, animated: true)
                    
                }
                    
                else{
                    
                    let vc_com = Global.macros.Storyboard.instantiateViewController(withIdentifier: "company") as! ComapanySchoolViewController
                    self.userIdToShowProfile = str_Id2
                    
                    
                    if let myInteger = Int(self.userIdToShowProfile!) {
                        let myNumber = NSNumber(value:myInteger)
                        vc_com.user_IdMyProfile =  myNumber
                        
                    }
                    
                    _ = self.navigationController?.pushViewController(vc_com, animated: true)
                    
                    
                }
                
            }
            
            
        }
        
        
    }
    
    
    
    func showSearchBar() {
        
        if let textFieldInsideSearchBar = self.searchBar.value(forKey: "searchField") as? UITextField,let glassIconView = textFieldInsideSearchBar.leftView as? UIImageView {
            
            //Magnifying glass
            glassIconView.frame = CGRect(x: 40, y: glassIconView.frame.origin.y , width: 14, height: 14)
            glassIconView.image = glassIconView.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            glassIconView.tintColor = UIColor.init(red: 143.0/255.0, green: 143.0/255.0, blue: 148.0/255.0, alpha: 1.0)
            textFieldInsideSearchBar.layer.borderColor = UIColor.clear.cgColor
            textFieldInsideSearchBar.layer.cornerRadius = 16.0
            textFieldInsideSearchBar.layer.borderWidth = 1.0
            textFieldInsideSearchBar.clipsToBounds = true
            textFieldInsideSearchBar.backgroundColor = UIColor.init(red: 247.0/255.0, green: 249.0/255.0, blue: 251.0/255.0, alpha: 1.0)
            textFieldInsideSearchBar.attributedPlaceholder = NSAttributedString(string: "Search",
                                                                                attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
            textFieldInsideSearchBar.isUserInteractionEnabled = true
            
        }
        navigationItem.titleView = searchBar
        
    }
    
    
    
    
    func FetchDialogs() {
        
        if checkInternetConnection() {
        
        self.DeleteChat(str_deletedId: "")
        self.arr_Dialogs.removeAllObjects()
         self.arr_DeletedDialogId.removeAllObjects()
        let extendedRequest = ["sort_desc" : "last_message_date_sent"]
        
        let page = QBResponsePage(limit: 1000, skip: 0)
        
        QBRequest.dialogs(for: page, extendedRequest: extendedRequest, successBlock: { (response: QBResponse, dialogs: [QBChatDialog]?, dialogsUsersIDs: Set<NSNumber>?, page: QBResponsePage?) -> Void in
            
            for (_, value) in (dialogs?.enumerated())! {
                let dialog : QBChatDialog! = value
                
                self.dialog_Chat = dialog!
                print(self.dialog_Chat)
                
                
                if self.dialog_Chat.lastMessageDate != nil {
                    
                    var str_checkfordel : String = ""
                    
                    let dateFormat = DateFormatter()
                    dateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                    let date: Date? = dateFormat.date(from: "\(self.dialog_Chat.updatedAt!)")
                    let formatter = DateFormatter()
                    formatter.locale = NSLocale(localeIdentifier: "GMT") as Locale
                    formatter.dateFormat = "hh:mm a"
                    let dateAsString: String = formatter.string(from: date!)
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat  = "EE"                    //"EE" to get short style
                    let dayInWeek = dateFormatter.string(from: date!)  //"Sunday"
                    let datefinal = dayInWeek + " " + dateAsString
                    
                    
                    if self.dialog_Chat.lastMessageText != nil {
                        
                
                    str_checkfordel = self.dialog_Chat.id! + "_" + self.dialog_Chat.lastMessageText! + "_" + datefinal
                    }
                    
                    else {
                        
                          str_checkfordel = self.dialog_Chat.id! + "_" + "null" + "_" + datefinal
                        
                    }
                    print(self.arr_DeletedDialogId)
                    
                    if self.arr_DeletedDialogId.count > 0 {
                        
                    //    for (_, value) in (self.arr_DeletedDialogId.enumerated()) {
                            
                       //     let str = value as! String
                            
                            if !(self.arr_DeletedDialogId.contains(str_checkfordel))  {
                            
                            self.arr_Dialogs.add(self.dialog_Chat)
                            self.arr_Search = self.arr_Dialogs.mutableCopy() as! NSMutableArray
                            self.arr_FinalDialogs  = self.arr_Dialogs.mutableCopy() as! NSMutableArray
                            self.tblView_Dialogs.reloadData()
                            
                            }
                            
                       // }
                    }
                    
                    else{
                        
                        self.arr_Dialogs.add(self.dialog_Chat)
                        self.arr_Search = self.arr_Dialogs.mutableCopy() as! NSMutableArray
                        self.arr_FinalDialogs  = self.arr_Dialogs.mutableCopy() as! NSMutableArray
                        self.tblView_Dialogs.reloadData()
                        
                    }
                    
                    
               
                   
                }
            }
            
            DispatchQueue.main.async {
                self.clearAllNotice()
                //  self.showAlert(Message: "Please try again", vc: self)
                
            }
            
        }) { (response: QBResponse) -> Void in
            DispatchQueue.main.async {
                self.clearAllNotice()
                self.showAlert(Message: "Please try again", vc: self)
                
            }
        }
        
        }
        
            else{
            DispatchQueue.main.async {

                 self.clearAllNotice()
                self.showAlert(Message: Global.macros.kInternetConnection, vc: self)
            }
        }
        
    }
    

        func DeleteChat(str_deletedId : String) {
            
            let dict = NSMutableDictionary()
            let user_Id = SavedPreferences.value(forKey: Global.macros.kUserId) as? NSNumber
            dict.setValue(user_Id, forKey: Global.macros.kUserId)
            dict.setValue(str_deletedId, forKey: "arrayName")
            print(dict)
            
            
            if self.checkInternetConnection(){
                
                DispatchQueue.main.async {
                    self.pleaseWait()
                }
                
                Requests_API.sharedInstance.saveChatArray(completionBlock: { (status, dict_Info) in
                    DispatchQueue.main.async {
                        self.clearAllNotice()
                    }
                    switch status{
                        
                    case 200:
                        
                        DispatchQueue.main.async {
                            
                            
                            let arr = (dict_Info.value(forKey: "data") as! NSArray).mutableCopy() as! NSMutableArray
                            
                            if arr.count > 0 {
                             
                                print(arr)
                            for (_, value) in (arr.enumerated()) {
                                
                                let val = (value as! NSDictionary).mutableCopy() as! NSMutableDictionary
                                let str = val["arrayName"] as! String
                                self.arr_DeletedDialogId.add(str)
              
                                
                            }
                                print(self.arr_DeletedDialogId)
                               }
                            
                       
                       

                         //  arr_DeletedDialogId.add(dic)
                            UIView.performWithoutAnimation {
                                
                                self.tblView_Dialogs.reloadData()
                                self.tblView_Dialogs.beginUpdates()
                                self.tblView_Dialogs.endUpdates()
                                
                            }
                            
                        }
                        
               
                        
                        break
                        
                    case 404:
                        
                        DispatchQueue.main.async {
                            self.clearAllNotice()
                           // self.showAlert(Message: Global.macros.kError, vc: self)
                          //  self.tblView_Dialogs.isHidden = true
                           // self.arr_verified = NSMutableArray()
                           //   self.tblView_Dialogs.reloadData()
                        }
                        
                    default:
                        DispatchQueue.main.async {
                            self.clearAllNotice()
                         //   self.showAlert(Message: Global.macros.kError, vc: self)
                          //  self.tblView_Dialogs.isHidden = true
                          //  self.arr_verified = NSMutableArray()
                         //   self.tblView_Dialogs.reloadData()
                            
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
            else{
                
                self.showAlert(Message: Global.macros.kInternetConnection, vc: self)
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


extension DialogsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.arr_Dialogs.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellDialog", for: indexPath) as! CellDialogTableViewCell
        
        cell.selectionStyle = .none
        cell.btn_ImageClick.tag = indexPath.row
        
        cell.imgView.image = UIImage(named: "dummySearch")
        cell.lbl_countUnreadMessages.text = ""
      
        if arr_Dialogs.count > 0 {
            
            let dic = arr_Dialogs[indexPath.row] as! QBChatDialog
            print(dic)
            let Array_selectedId = dic.value(forKey: "occupantIDs") as! NSArray
            var selectedId : String = ""
            var selectedIdTwo : String = ""
            
            if Array_selectedId.count == 2 {
                
                selectedId = "\(Array_selectedId[0])"
                print(selectedId)
                selectedIdTwo = "\(Array_selectedId[1])"
                print(selectedIdTwo)
                
            }
            
            if selectedId != "\(SavedPreferences.value(forKey: "qb_UserId")!)" {
                
                QBRequest.user(withID: Array_selectedId[0] as! UInt , successBlock: { (response, user) in
                    
                    DispatchQueue.main.async {
                        let url = user?.customData
                        if url != nil {
                            print(url)
                            cell.imgView.sd_setImage(with: URL.init(string: url!), placeholderImage: UIImage.init(named: "dummySearch"))
                            
                        }
                    }
                
                    
                }, errorBlock: { (response) in
                    
                })
                
            }
                
            else if selectedIdTwo != "\(SavedPreferences.value(forKey: "qb_UserId")!)" {
                
                QBRequest.user(withID: Array_selectedId[1] as! UInt , successBlock: { (response, user) in
                    
                    DispatchQueue.main.async {
                    print(Array_selectedId[1])
                        
                    let url = user?.customData
                    if url != nil {
                        cell.imgView.sd_setImage(with: URL.init(string: url!), placeholderImage: UIImage.init(named: "dummySearch"))
                        
                       }
                    }
                    
                }, errorBlock: { (response) in
                    
                    print(response.error?.description)
                    
                })
                
            }
            
            DispatchQueue.main.async {
                cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 14.0)
                let str = dic.value(forKey: "name") as! String
                let str_obb :NSString = NSString(string:str)
                
                let delimiter = "_"
                let token = str_obb.components(separatedBy: delimiter)
                
                let str1: String = (token.first)!
                let str2: String = (token.last)!
                
                // str1
                let delimiter1 = "/"
                let token1 = str1.components(separatedBy: delimiter1)
                
                let str_name: String = (token1.first)!
                
                let token2 = str2.components(separatedBy: "/")
                print(token2)
                
                let str_name2: String = (token2.first)!
                
                
                if (SavedPreferences.value(forKey: "role") as? String) == "USER" {
                    
                   if(str_name.caseInsensitiveCompare("\(SavedPreferences.value(forKey: Global.macros.kUserName)!)".capitalized ) != ComparisonResult.orderedSame)  {
                        
                        cell.lbl_Name.text = str_name.capitalized
                        
                        
                    }
                        
                    else if (str_name2.caseInsensitiveCompare("\(SavedPreferences.value(forKey: Global.macros.kUserName)!)".capitalized ) != ComparisonResult.orderedSame) {
                        
                        cell.lbl_Name.text = str_name2.capitalized
                        
                    }
                    
                }
                    
                else if (SavedPreferences.value(forKey: "role") as? String) == "SCHOOL" {
                    
                    
                    if (str_name.caseInsensitiveCompare("\(SavedPreferences.value(forKey: Global.macros.kschoolName)!)".capitalized ) != ComparisonResult.orderedSame) {
                        
                        cell.lbl_Name.text = str_name.capitalized
                        
                    }
                        
                    else if (str_name2.caseInsensitiveCompare("\(SavedPreferences.value(forKey: Global.macros.kschoolName)!)".capitalized ) != ComparisonResult.orderedSame) {
                        
                        cell.lbl_Name.text = str_name2.capitalized
                        
                    }
                    
                }
                    
                else if (SavedPreferences.value(forKey: "role") as? String) == "COMPANY" {
                    
                    
                    if (str_name.caseInsensitiveCompare("\(SavedPreferences.value(forKey: Global.macros.kcompanyName)!)".capitalized ) != ComparisonResult.orderedSame){
                        
                        cell.lbl_Name.text = str_name.capitalized
                        
                    }
                        
                    else if (str_name2.caseInsensitiveCompare("\(SavedPreferences.value(forKey: Global.macros.kcompanyName)!)".capitalized ) != ComparisonResult.orderedSame) {
                        
                        cell.lbl_Name.text = str_name2.capitalized
                        
                        
                    }
                    
                }
                
                
            }
            
            let time = dic.updatedAt
            if time != nil  {
                
                let dateFormat = DateFormatter()
                dateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                let date: Date? = dateFormat.date(from: "\(dic.updatedAt!)")
                let formatter = DateFormatter()
                formatter.locale = NSLocale(localeIdentifier: "GMT") as Locale
                formatter.dateFormat = "hh:mm a"
                let dateAsString: String = formatter.string(from: date!)
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat  = "EE"                    //"EE" to get short style
                let dayInWeek = dateFormatter.string(from: date!)  //"Sunday"
                
                let unreadMessagesCount = dic.value(forKey: "unreadMessagesCount") as! UInt
                let lastmsgid = dic.value(forKey: "lastMessageUserID") as! UInt
                
                if unreadMessagesCount >= 1 && lastmsgid == SavedPreferences.value(forKey: "qb_UserId") as! UInt {
                    
                    cell.lbl_Date.text = "Delivered" + " " + dayInWeek + " " + dateAsString
                    
                }
                    
                else if unreadMessagesCount >= 1 && lastmsgid != SavedPreferences.value(forKey: "qb_UserId") as! UInt {
                    
                    cell.lbl_Date.text = "Received" + " " + dayInWeek + " " + dateAsString
                    cell.lbl_countUnreadMessages.text = "\(dic.unreadMessagesCount)"
                    
                }
                    
                    
                else {
                    
                    cell.lbl_Date.text = "Opened" + " " + dayInWeek + " " + dateAsString
                    
                }
                
                
                if dic.photo != nil && dic.photo != ""{
                    
                    
                    //QBCBlob.privateUrl(forFileUID: dic.photo.!)!
                    
                    
                    let privateUrl : String = QBCBlob.privateUrl(forFileUID: "\(dic.photo!)")!
                    
                    print(privateUrl)
                    
                    DispatchQueue.main.async {
                        if privateUrl != "" {
                            cell.imgView.sd_setImage(with: URL(string:privateUrl), placeholderImage: UIImage(named: "dummySearch"))//image
                        }                    }
                    
                }
                // lastMessage:Attachment image
                print(dic)
                print("\(dic.lastMessageText))")
                
                
                if dic.lastMessageText != nil {
                    
                    if dic.lastMessageText == "Attachment video" {
                        
                        cell.lbl_LastMSG.text = "Video Attachment"
                    }
                    else if dic.lastMessageText == "Attachment image" {
                        
                        cell.lbl_LastMSG.text = "Image Attachment"
                    }
                    else{
                        
                        cell.lbl_LastMSG.text = "\(dic.lastMessageText!)" }
                    
                }
                    
                else{
                    
                    cell.lbl_LastMSG.text = "Attachment"
                    
                }
            }
            
                
          
            
        }
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        DispatchQueue.main.async {
            self.pleaseWait()
        }
        
        let dic = arr_Dialogs[indexPath.row] as! QBChatDialog
        let Array_selectedId = dic.value(forKey: "occupantIDs") as! NSArray
        let selectedId = "\(Array_selectedId[0])"
        print(selectedId)
        
        let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        vc.str_DialogId = dic.id
        
        
        for (index, element) in Array_selectedId.enumerated() {
            
            print(index)
            print(element)
            
            if element as! UInt != SavedPreferences.value(forKey:"qb_UserId") as! UInt {
                vc.str_OtherUserId = "\(element)"
            }
        }
        
        let str = dic.name
        
        let str_obb :NSString = NSString(string:str!)
        
        
        let delimiter = "_"
        let token = str_obb.components(separatedBy: delimiter)
        
        let str1: String = (token.first)!
        let str2: String = (token.last)!
        
        // str1
        let delimiter1 = "/"
        let token1 = str1.components(separatedBy: delimiter1)
        let str_name: String = (token1.first)! //name
        let sub_data : String = (token1.last)!
        
        
        
        
//        let delimiter_role = "-"
//        let token_role = str1.components(separatedBy: delimiter_role)
//        let str_role: String = (token_role.last)!
//
//
//        let token_userId = (token_role.first)!.components(separatedBy: delimiter1)
//        let str_Id: String = (token_userId.last)!
        
           let subDataArray = sub_data.components(separatedBy: "-")
            let str_Id: String = (subDataArray.first)!
            let str_role: String = (subDataArray.last)!

       // str 2
        let token2 = str2.components(separatedBy: "/")
        print(token2)
        let str_name2: String = (token2.first)!
         let sub_data2 : String = (token2.last)!
        
        let subDataArray2 = sub_data2.components(separatedBy: "-")
        let str_Id2: String = (subDataArray2.first)!
        let str_role2: String = (subDataArray2.last)!
        
        
//        let token_id = (token2.last)!.components(separatedBy: "-")
//
//        let str_name2: String = (token2.first)!
//
//        let str_role2: String = (token_id.last)!
//
//        let str_Id2: String = (token_id.first)!
        
        
        
        
        if (SavedPreferences.value(forKey: "role") as? String) == "USER" {
            
            if (str_name.caseInsensitiveCompare("\(SavedPreferences.value(forKey: Global.macros.kUserName)!)".capitalized ) != ComparisonResult.orderedSame) {
                
                vc.str_ReceiverName = str_name
                
                if let myInteger = Int(str_Id) {
                    let myNumber = NSNumber(value:myInteger)
                    vc.local_otherUserId = myNumber
                    vc.local_roleOtherUser = str_role
                }
                
                self.userIdToShowProfile = (token1.last)!
                print( self.userIdToShowProfile!)
                
                
            }
            
                
            else if (str_name2.caseInsensitiveCompare("\(SavedPreferences.value(forKey: Global.macros.kUserName)!)".capitalized ) != ComparisonResult.orderedSame) {
                vc.str_ReceiverName = str_name2
                
                if let myInteger = Int(str_Id2) {
                    let myNumber = NSNumber(value:myInteger)
                    vc.local_otherUserId = myNumber
                    vc.local_roleOtherUser = str_role2
                }
                
                
                self.userIdToShowProfile = (token2.last)!
                print( self.userIdToShowProfile!)
                
                
            }
            
            
        }
        
        else if (SavedPreferences.value(forKey: "role") as? String) == "SCHOOL" {
            
            
            if (str_name.caseInsensitiveCompare("\(SavedPreferences.value(forKey: Global.macros.kschoolName)!)".capitalized ) != ComparisonResult.orderedSame) {
                
                vc.str_ReceiverName = str_name
                
                if let myInteger = Int(str_Id) {
                    let myNumber = NSNumber(value:myInteger)
                    vc.local_otherUserId = myNumber
                    vc.local_roleOtherUser = str_role
                }
                
                
                self.userIdToShowProfile = (token1.last)!
                print( self.userIdToShowProfile!)
                
                
            }
            
            else if (str_name2.caseInsensitiveCompare("\(SavedPreferences.value(forKey: Global.macros.kschoolName)!)".capitalized ) != ComparisonResult.orderedSame) {
                vc.str_ReceiverName = str_name2
                
                if let myInteger = Int(str_Id2) {
                    let myNumber = NSNumber(value:myInteger)
                    vc.local_otherUserId = myNumber
                    vc.local_roleOtherUser = str_role2
                }
                
                self.userIdToShowProfile = (token2.last)!
                print( self.userIdToShowProfile!)
                
                
                
            }
            
        }
        
        else {
           
            if (str_name.caseInsensitiveCompare("\(SavedPreferences.value(forKey: Global.macros.kcompanyName)!)".capitalized ) != ComparisonResult.orderedSame) {
                
                vc.str_ReceiverName = str_name
                
                if let myInteger = Int(str_Id) {
                    let myNumber = NSNumber(value:myInteger)
                    vc.local_otherUserId = myNumber
                    vc.local_roleOtherUser = str_role
                }
                
                
                self.userIdToShowProfile = (token1.last)!
                print( self.userIdToShowProfile!)
                
                
            }
            
            
            else  if (str_name2.caseInsensitiveCompare("\(SavedPreferences.value(forKey: Global.macros.kcompanyName)!)".capitalized ) != ComparisonResult.orderedSame) {
                vc.str_ReceiverName = str_name2
                
                if let myInteger = Int(str_Id2) {
                    let myNumber = NSNumber(value:myInteger)
                    vc.local_otherUserId = myNumber
                    vc.local_roleOtherUser = str_role2
                }
                
                self.userIdToShowProfile = (token2.last)!
                print( self.userIdToShowProfile!)
                
                
            }
            
            
            
        }
        
        
        
        
        
        
//        if str_name != "\(SavedPreferences.value(forKey: Global.macros.kUserName)!)" {
//
//            vc.str_ReceiverName = str_name
//
//            if let myInteger = Int(str_Id) {
//                let myNumber = NSNumber(value:myInteger)
//                vc.local_otherUserId = myNumber
//                vc.local_roleOtherUser = str_role
//            }
//
//            self.userIdToShowProfile = (token1.last)!
//            print( self.userIdToShowProfile!)
//
//
//        }
//
//        else if str_name != "\(SavedPreferences.value(forKey: Global.macros.kcompanyName)!)" {
//
//            vc.str_ReceiverName = str_name
//
//            if let myInteger = Int(str_Id) {
//                let myNumber = NSNumber(value:myInteger)
//                vc.local_otherUserId = myNumber
//                vc.local_roleOtherUser = str_role
//            }
//
//
//            self.userIdToShowProfile = (token1.last)!
//            print( self.userIdToShowProfile!)
//
//
//        }
//
//
//
//
//
//
//          else if str_name != "\(SavedPreferences.value(forKey: Global.macros.kschoolName)!)" {
//
//            vc.str_ReceiverName = str_name
//
//            if let myInteger = Int(str_Id) {
//                let myNumber = NSNumber(value:myInteger)
//                vc.local_otherUserId = myNumber
//                vc.local_roleOtherUser = str_role
//            }
//
//
//            self.userIdToShowProfile = (token1.last)!
//            print( self.userIdToShowProfile!)
//
//
//        }
//
//
//       else if str_name2 != "\(SavedPreferences.value(forKey: Global.macros.kUserName)!)" {
//            vc.str_ReceiverName = str_name2
//
//            if let myInteger = Int(str_Id2) {
//                let myNumber = NSNumber(value:myInteger)
//                vc.local_otherUserId = myNumber
//                vc.local_roleOtherUser = str_role2
//            }
//
//
//            self.userIdToShowProfile = (token2.last)!
//            print( self.userIdToShowProfile!)
//
//
//        }
//
//        else if str_name2 != "\(SavedPreferences.value(forKey: Global.macros.kschoolName)!)" {
//            vc.str_ReceiverName = str_name2
//
//            if let myInteger = Int(str_Id2) {
//                let myNumber = NSNumber(value:myInteger)
//                vc.local_otherUserId = myNumber
//                vc.local_roleOtherUser = str_role2
//            }
//
//            self.userIdToShowProfile = (token2.last)!
//            print( self.userIdToShowProfile!)
//
//
//
//        }
//
//
//
//        else  if str_name2 != "\(SavedPreferences.value(forKey: Global.macros.kcompanyName)!)" {
//            vc.str_ReceiverName = str_name2
//
//            if let myInteger = Int(str_Id2) {
//                let myNumber = NSNumber(value:myInteger)
//                vc.local_otherUserId = myNumber
//                vc.local_roleOtherUser = str_role2
//            }
//
//            self.userIdToShowProfile = (token2.last)!
//            print( self.userIdToShowProfile!)
//
//
//        }
//
        
         vc.dialog_Chat  = dic
         vc.bool_chat = true
         var currentUser : QBUUser!
        currentUser = QBUUser()
        
        currentUser.id = SavedPreferences.value(forKey:"qb_UserId") as! UInt
        currentUser.password = "mind@123"
        
        QBChat.instance().connect(with: currentUser!, completion: { (error) in
            print("Successful connected")
            QBChat.instance().addDelegate(vc)
            
            vc.dialog_Chat.join(completionBlock: { (error) in
                _ = self.navigationController?.pushViewController(vc, animated: true)

                print(error)
            })
            
        })
        
        
        
    }
    
    //
    //        func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    //            cell.separatorInset = UIEdgeInsets.zero
    //            cell.layoutMargins =  UIEdgeInsets.zero
    //        }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 76
        
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
       
        
        let dic = arr_Dialogs[indexPath.row] as! QBChatDialog
        
        let deleteAction = UITableViewRowAction(style: .normal, title: "Delete") { (rowAction, indexPath) in
            if dic.id != nil {

                DispatchQueue.main.async {
                    
                    self.pleaseWait()
                    
                }
                var local_msg = [QBChatMessage]()
                var local_msgIds = Set<String>()
                
                let resPage = QBResponsePage(limit:1000, skip: 0)
                
                QBRequest.messages(withDialogID: dic.id!, extendedRequest: nil, for: resPage, successBlock: {(response: QBResponse, messages: [QBChatMessage]?, responcePage: QBResponsePage?) in
                    
                   
                    local_msg = []
                    local_msg = messages!
                    print(local_msg)
                    
                    
                    for (_, value) in (local_msg.enumerated()) {
                        
                             print(value)
                             local_msgIds.insert("\(value.id!)")
           
                    }
                    
                if local_msgIds.count > 0 {
          QBRequest.deleteMessages(withIDs: local_msgIds, forAllUsers: false, successBlock: { (response: QBResponse!) in

           
            self.arr_Dialogs.removeObject(at: indexPath.row)
            self.arr_Search.removeObject(at: indexPath.row)
            self.arr_FinalDialogs.removeObject(at: indexPath.row)
            
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
            let date: Date? = dateFormat.date(from: "\(dic.updatedAt!)")
            let formatter = DateFormatter()
            formatter.locale = NSLocale(localeIdentifier: "GMT") as Locale
            formatter.dateFormat = "hh:mm a"
            let dateAsString: String = formatter.string(from: date!)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat  = "EE"                    //"EE" to get short style
            let dayInWeek = dateFormatter.string(from: date!)  //"Sunday"
            let datefinal = dayInWeek + " " + dateAsString
            
            
            if dic.lastMessageText != nil {
                
                
              let str_checkfordel = dic.id! + "_" + dic.lastMessageText! + "_" + datefinal
                  if !(self.arr_DeletedDialogId.contains(str_checkfordel))  {
                    self.DeleteChat(str_deletedId: str_checkfordel)
                }
                
            }
                
            else {
                
             let str_checkfordel = dic.id! + "_" + "null" + "_" + datefinal
                if !(self.arr_DeletedDialogId.contains(str_checkfordel))  {
                    self.DeleteChat(str_deletedId: str_checkfordel)
                }

            }
            
            
            
            
            
            

        }, errorBlock: { (response: QBResponse!) -> Void in
            DispatchQueue.main.async {
                self.clearAllNotice()
            }

            
            
            
            
            
        })
                }
                    
                else{
                    
                    
                    self.arr_Dialogs.removeObject(at: indexPath.row)
                    self.arr_Search.removeObject(at: indexPath.row)
                    self.arr_FinalDialogs.removeObject(at: indexPath.row)

                    let dateFormat = DateFormatter()
                    dateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                    let date: Date? = dateFormat.date(from: "\(dic.updatedAt!)")
                    let formatter = DateFormatter()
                    formatter.locale = NSLocale(localeIdentifier: "GMT") as Locale
                    formatter.dateFormat = "hh:mm a"
                    let dateAsString: String = formatter.string(from: date!)
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat  = "EE"                    //"EE" to get short style
                    let dayInWeek = dateFormatter.string(from: date!)  //"Sunday"
                    let datefinal = dayInWeek + " " + dateAsString
                    
                    
                    if dic.lastMessageText != nil {
                        
                        
                        let str_checkfordel = dic.id! + "_" + dic.lastMessageText! + "_" + datefinal
                        if !(self.arr_DeletedDialogId.contains(str_checkfordel))  {
                            self.DeleteChat(str_deletedId: str_checkfordel)
                        }
                        
                        
                    }
                        
                    else {
                        
                        let str_checkfordel = dic.id! + "_" + "null" + "_" + datefinal
                        if !(self.arr_DeletedDialogId.contains(str_checkfordel))  {
                            self.DeleteChat(str_deletedId: str_checkfordel)
                        }
                        
                    }
                    
                    
                    
                    }

                    
                    
                }, errorBlock: {(response: QBResponse!) in
                    
                    print("err2")
                    DispatchQueue.main.async {
                        self.clearAllNotice()
                    //    self.showAlert(Message: "Please try again", vc: self)
                        
                    }
                })
                
                
                
         
                

                
                
                
//                    QBRequest.deleteDialogs(withIDs: Set(arrayLiteral: dic.id!), forAllUsers: false,
//                 successBlock: { (response: QBResponse!, deletedObjectsIDs: [String]?, notFoundObjectsIDs: [String]?, wrongPermissionsObjectsIDs: [String]?) -> Void in
//
//                 DispatchQueue.main.async {
//
//                 self.arr_Dialogs.removeObject(at: indexPath.row)
//
//                 UIView.performWithoutAnimation {
//
//                 self.tblView_Dialogs.reloadData()
//                 self.tblView_Dialogs.beginUpdates()
//                 self.tblView_Dialogs.endUpdates()
//
//                 }
//
//                 print("yess")
//                 }
//
//
//                 }) { (response: QBResponse!) -> Void in
//
//                 DispatchQueue.main.async {
//
//                 self.arr_Dialogs.removeObject(at: indexPath.row)
//
//
//
//                 UIView.performWithoutAnimation {
//
//                 self.tblView_Dialogs.reloadData()
//                 self.tblView_Dialogs.beginUpdates()
//                 self.tblView_Dialogs.endUpdates()
//
//                 }
//
//                 print("yess")
//                 }
//
//                 }
         
                
            }
            
        }
        
        deleteAction.backgroundColor = .red
        
        return [deleteAction]
        
        
        
        
        
        
    }
    
    
    
}
//MARK: SEARCHBAR METHODS

extension DialogsViewController:UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            self.searchBar.resignFirstResponder()
            return false
            
        }
            
            
        else {
            
              if checkInternetConnection() {
            
            
            var txtAfterUpdate = NSString(string: searchBar.text!)
            txtAfterUpdate = txtAfterUpdate.replacingCharacters(in: range, with: text) as NSString
            
            
            if txtAfterUpdate.length > 2 {
                
                let predicate = NSPredicate(format: "(name contains[cd] %@)", txtAfterUpdate)
                self.temp_arr.removeAllObjects()
                self.temp_arr.addObjects(from: self.arr_Search.filtered(using: predicate))
                self.arr_Dialogs.removeAllObjects()
                self.arr_Dialogs = self.temp_arr.mutableCopy() as! NSMutableArray
                self.tblView_Dialogs.reloadData()
            }
            else {
                
                self.temp_arr = NSMutableArray()
                self.arr_Dialogs.removeAllObjects()
                self.arr_Dialogs = self.arr_FinalDialogs.mutableCopy() as! NSMutableArray
                self.tblView_Dialogs.reloadData()
                
            }
                
            }
            
            
              else{
                
                self.showAlert(Message: Global.macros.kInternetConnection, vc: self)

            }
        }
        return true
        
        
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        
        self.searchBar.showsCancelButton = false
        
        
        
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        self.searchBar.alpha = 1
        self.searchBar.showsCancelButton = false
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
    }
    
}
