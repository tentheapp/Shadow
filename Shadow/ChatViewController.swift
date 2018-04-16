//
//  ChatViewController.swift
//  Shadow
//
//  Created by Atinderjit Kaur on 01/11/17.
//  Copyright © 2017 Atinderjit Kaur. All rights reserved.


import UIKit
import RSKImageCropper

import MobileCoreServices
import AVKit
import AVFoundation
import  MediaPlayer

var timer  : Timer?

var bool_comingFromChat : Bool = false
var Globaldialog_Chat : QBChatDialog!
var str_DialogId_NotificationScreen :   String? 

class ChatViewController: UIViewController {
    
    var str_DialogId :        String?
    var str_OtherUserId :     String?
    var str_ReceiverName :    String?
    var local_otherUserId :   NSNumber?
    var local_roleOtherUser : String?
    var video_url :           URL?
    var movieController =     AVPlayerViewController()
    public var videoData :    Data?
    
    @IBOutlet weak var img_Send:          UIImageView! 
    @IBOutlet weak var lbl_Typing:        UILabel!
    @IBOutlet weak var kBehindViewBottom: NSLayoutConstraint!
    @IBOutlet weak var kTablebtm:         NSLayoutConstraint!
    @IBOutlet weak var lbl_PlaceHolder:   UILabel!
    @IBOutlet weak var view_BehindTxtView:UIView!
    @IBOutlet weak var tblView:           UITableView!
    @IBOutlet weak var txtView_Msg:       UITextView!
    @IBOutlet weak var btn_Send:          UIButton!
    var dialog_Chat :                     QBChatDialog!
    var keyboardHeight =                  CGFloat()
    var messages =                        NSMutableArray()
    var arr_Dates =                       NSMutableArray()
    var arr_messages =                    NSMutableArray()
    var dict_Sections =                   NSMutableDictionary()
    var int_LeftRight :                   Int = 0
    var bool_SendMsg :                    Bool = false
    let myBackButton:                     UIButton = UIButton()
    let button:UIButton =                 UIButton()
    
    @IBOutlet weak var kHeightBehindTxtView: NSLayoutConstraint!
    @IBOutlet weak var KtxtViewHeight:       NSLayoutConstraint!
    var currentUser :                        QBUUser!
    var timer =                              Timer()
    var date_today :                         Date?
    var str_date :                           String = ""
    var counter = 0
    var videoDataCustom =                    Data()
    var local_msg =                         [QBChatMessage]()
    var bool_chat : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if str_DialogId_NotificationScreen != nil && str_DialogId_NotificationScreen != "" {
            
            str_DialogId = str_DialogId_NotificationScreen
            
        }
        
        
        QBChat.instance().addDelegate(self)
       self.txtView_Msg.resignFirstResponder()
        self.tabBarController?.tabBar.isHidden = true
        
        self.txtView_Msg.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        self.txtView_Msg.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10)
        
        self.txtView_Msg.layer.cornerRadius = 20.0
        self.tblView.separatorColor = UIColor.clear
        
        if self.dialog_Chat != nil {
            
            Globaldialog_Chat = self.dialog_Chat
            SavedPreferences.set(str_DialogId, forKey: "DialogId")
            
            self.dialog_Chat.join(completionBlock: { (error) in
                print(error)
            })
            self.ChatConnectandWrite()
            
            
                self.navigationItem.title = self.str_ReceiverName?.capitalized
                self.button.frame = CGRect(x:25, y: 0, width: 100, height: 60)
                self.button.setTitle(self.str_ReceiverName?.capitalized, for: .normal)
                self.button.titleLabel?.font =  UIFont(name: "Arial Rounded MT Bold", size: 16)
                self.button.setTitleColor(.black, for: .normal)
                
                self.button.addTarget(self, action: #selector(self.clickOnButton), for: .touchUpInside)
                self.navigationItem.titleView = self.button
                
            
        }
            
        else{
            
            
            
            SavedPreferences.set(str_DialogId!, forKey: "DialogId")
            
            let extendedRequest = [str_DialogId! : "_id"]
            
            let page = QBResponsePage(limit: 1000, skip: 0)
            
            QBRequest.dialogs(for: page, extendedRequest: extendedRequest, successBlock: { (response: QBResponse, dialogs: [QBChatDialog]?, dialogsUsersIDs: Set<NSNumber>?, page: QBResponsePage?) -> Void in
                
                DispatchQueue.main.async {
                    self.pleaseWait()
                }
                for (_, value) in (dialogs?.enumerated())! {
                    
                    let dialog : QBChatDialog! = value
                    
                    
                    if dialog.id! == self.str_DialogId! {
                        
                        self.dialog_Chat = dialog!
                        Globaldialog_Chat = self.dialog_Chat
                      
                        self.dialog_Chat.join(completionBlock: { (error) in
                            print(error)
                        })
                        
                        let str =  self.dialog_Chat.name
                        
                        
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
                        
                        if self.str_ReceiverName == nil || self.str_ReceiverName == "" {
                            
//                            if str_name != "\(SavedPreferences.value(forKey: Global.macros.kUserName)!)" {
//
//                                self.str_ReceiverName = str_name
//                                if let myInteger = Int(str_Id) {
//                                    let myNumber = NSNumber(value:myInteger)
//                                    self.local_otherUserId = myNumber
//                                    self.local_roleOtherUser = str_role
//
//                                }
//
//                            }
//
//                            else if str_name2 != "\(SavedPreferences.value(forKey: Global.macros.kUserName)!)" {
//                                self.str_ReceiverName = str_name2
//                                if let myInteger = Int(str_Id2) {
//                                    let myNumber = NSNumber(value:myInteger)
//                                    self.local_otherUserId = myNumber
//                                    self.local_roleOtherUser = str_role2
//
//
//
//
//                                }
//                            }
                            
                            
                            if (SavedPreferences.value(forKey: "role") as? String) == "USER" {
                                
                                if  (str_name.caseInsensitiveCompare("\(SavedPreferences.value(forKey: Global.macros.kUserName)!)".capitalized ) != ComparisonResult.orderedSame) {
                               
                               // if str_name != "\(SavedPreferences.value(forKey: Global.macros.kUserName)!)".capitalized {
                                    
                                    self.str_ReceiverName = str_name
                                    
                                    if let myInteger = Int(str_Id) {
                                        let myNumber = NSNumber(value:myInteger)
                                        self.local_otherUserId = myNumber
                                        self.local_roleOtherUser = str_role
                                    }
                                }
                                    
                                    
                                else  if  (str_name2.caseInsensitiveCompare("\(SavedPreferences.value(forKey: Global.macros.kUserName)!)".capitalized ) != ComparisonResult.orderedSame){
                                    self.str_ReceiverName = str_name2
                                    
                                    if let myInteger = Int(str_Id2) {
                                        let myNumber = NSNumber(value:myInteger)
                                        self.local_otherUserId = myNumber
                                        self.local_roleOtherUser = str_role2
                                    }
                                    
                                    
                                    
                                    
                                }
                                
                                
                            }
                                
                            else if (SavedPreferences.value(forKey: "role") as? String) == "SCHOOL" {
                                
                                
                              if  (str_name.caseInsensitiveCompare("\(SavedPreferences.value(forKey: Global.macros.kschoolName)!)".capitalized ) != ComparisonResult.orderedSame) {
                                
                              //  if str_name != "\(SavedPreferences.value(forKey: Global.macros.kschoolName)!)".capitalized {
                                    
                                    self.str_ReceiverName = str_name
                                    
                                    if let myInteger = Int(str_Id) {
                                        let myNumber = NSNumber(value:myInteger)
                                        self.local_otherUserId = myNumber
                                    self.local_roleOtherUser = str_role
                                    }
                                    
                                    
                                    //    self.userIdToShowProfile = (token1.last)!
                                    //   print( self.userIdToShowProfile!)
                                    
                                    
                                }
                                else  if (str_name2.caseInsensitiveCompare("\(SavedPreferences.value(forKey: Global.macros.kschoolName)!)".capitalized ) != ComparisonResult.orderedSame) {
                             //   else if str_name2 != "\(SavedPreferences.value(forKey: Global.macros.kschoolName)!)".capitalized {
                                    self.str_ReceiverName = str_name2
                                    
                                    if let myInteger = Int(str_Id2) {
                                        let myNumber = NSNumber(value:myInteger)
                                        self.local_otherUserId = myNumber
                                        self.local_roleOtherUser = str_role2
                                    }
                                    
                                    //  self.userIdToShowProfile = (token2.last)!
                                    //   print( self.userIdToShowProfile!)
                                    
                                    
                                    
                                }
                                
                            }
                                
                            else {
                                if  (str_name.caseInsensitiveCompare("\(SavedPreferences.value(forKey: Global.macros.kcompanyName)!)".capitalized ) != ComparisonResult.orderedSame) {
                                //if str_name != "\(SavedPreferences.value(forKey: Global.macros.kcompanyName)!)".capitalized {
                                    
                                    self.str_ReceiverName = str_name
                                    
                                    if let myInteger = Int(str_Id) {
                                        let myNumber = NSNumber(value:myInteger)
                                        self.local_otherUserId = myNumber
                                        self.local_roleOtherUser = str_role
                                    }
                                    
                                    
                                    //  self.userIdToShowProfile = (token1.last)!
                                    //  print( self.userIdToShowProfile!)
                                    
                                    
                                }
                                    
                                 else  if  (str_name2.caseInsensitiveCompare("\(SavedPreferences.value(forKey: Global.macros.kcompanyName)!)".capitalized ) != ComparisonResult.orderedSame) {
                                    
                               // else  if str_name2 != "\(SavedPreferences.value(forKey: Global.macros.kcompanyName)!)".capitalized {
                                    self.str_ReceiverName = str_name2
                                    
                                    if let myInteger = Int(str_Id2) {
                                        let myNumber = NSNumber(value:myInteger)
                                        self.local_otherUserId = myNumber
                                        self.local_roleOtherUser = str_role2
                                    }
                                    
                                    //  self.userIdToShowProfile = (token2.last)!
                                    //  print( self.userIdToShowProfile!)
                                    
                                    
                                }
                                
                                
                                
                            }
                            
                        }
                        
                        if self.str_OtherUserId == nil || self.str_OtherUserId == "" {
                            
                            print("other user id")
                            
                            let Array_selectedId =  self.dialog_Chat.value(forKey: "occupantIDs") as! NSArray
                            let selectedId = "\(Array_selectedId[0])"
                            print(selectedId)
                            
                            
                            for (index, element) in Array_selectedId.enumerated() {
                                
                                print(index)
                                print(element)
                                
                                if element as! UInt != SavedPreferences.value(forKey:"qb_UserId") as! UInt {
                                    self.str_OtherUserId = "\(element)"
                                }
                            }
                        }
                         self.ChatConnectandWrite()
                    }
                    else {
                        
                        
                        
                        DispatchQueue.main.async {
                            self.clearAllNotice()
                            
                        }
                        
                    }
                    
                }
                
                
                
                
                    self.navigationItem.title = self.str_ReceiverName?.capitalized
                    
                    self.button.frame = CGRect(x:25, y: 0, width: 100, height: 60)
                    self.button.setTitle(self.str_ReceiverName, for: .normal)
                    self.button.titleLabel?.font =  UIFont(name: "Arial Rounded MT Bold", size: 16)
                    self.button.setTitleColor(.black, for: .normal)
                    
                    self.button.addTarget(self, action: #selector(self.clickOnButton), for: .touchUpInside)
                    self.navigationItem.titleView = self.button
              
                
                
                
                
            }) { (response: QBResponse) -> Void in
                
                DispatchQueue.main.async {
                    self.clearAllNotice()
                    print(response.error?.description)
                }
            }
            
            
        }
        
        DispatchQueue.main.async {
            
            self.tblView.estimatedRowHeight = 90.0
            self.tblView.rowHeight = UITableViewAutomaticDimension
            NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
            
            let myBackButton:UIButton = UIButton()
            myBackButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
            myBackButton.setImage(UIImage(named:"back-new"), for: UIControlState())
            myBackButton.addTarget(self, action: #selector(self.PopToRootViewController), for: UIControlEvents.touchUpInside)
            let leftBackBarButton:UIBarButtonItem = UIBarButtonItem(customView: myBackButton)
            self.navigationItem.leftBarButtonItem = leftBackBarButton
            
            
            Global.macros.statusBar.backgroundColor = UIColor.white
            UIApplication.shared.statusBarStyle = .default
            Global.macros.statusBar.isHidden = false
            UINavigationBar.appearance().isTranslucent = false
            self.tblView.tableHeaderView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: self.tblView.bounds.size.width, height: 10))
            
            
        }
        
        
        //        let swiperight = UISwipeGestureRecognizer(target: self, action: #selector(self.swiperight))
        //        swiperight.direction = .right
        //        self.tblView.addGestureRecognizer(swiperight)
        //        self.view.addGestureRecognizer(swiperight)
        //
        
        //        let swipeleft = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeleft))
        //        swipeleft.direction = .left
        //        self.tblView.addGestureRecognizer(swipeleft)
        //        self.view.addGestureRecognizer(swipeleft)
        //
        
        
        
        if  bool_PushComingFromAppDelegate == true {
            bool_PushComingFromAppDelegate = false
            myBackButton.addTarget(self, action: #selector(self.PopToRootVC), for: UIControlEvents.touchUpInside)
        }
        
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            Global.macros.statusBar.isHidden = false
             bool_notificationFromChat = true
             self.txtView_Msg.resignFirstResponder()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        bool_notificationFromChat = false
          self.txtView_Msg.resignFirstResponder()
        str_DialogId_NotificationScreen = ""
    }
    
    // called every time interval from the timer
    func timerAction() {
        
        counter += 1
        
        if counter == 2 {
            
            counter = 0
              if self.dialog_Chat != nil {
              self.dialog_Chat.sendUserStoppedTyping()
            }
            timer.invalidate()
            print("stop")
            
        }
    }
    
    
    func CompareDate() {
        
        
        
        //
        //            if duration > 4 && duration < 6 {
        //
        //            self.dialog_Chat.sendUserStoppedTyping()
        //
        //                if timer != nil {
        //
        //                timer?.invalidate()
        //                timer = nil
        //                    print("timer nil")
        //
        //            }
        //        }
        //
        //
        //        }
        
        
    }
    
    func clickOnButton(button: UIButton) {
        
        if local_roleOtherUser != nil &&  local_roleOtherUser != "" {
            
            if local_roleOtherUser == "USER" {
                
                let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "user") as! ProfileVC
                vc.user_IdMyProfile =  local_otherUserId
                _ = self.navigationController?.pushViewController(vc, animated: true)
                
            }
                
            else{
                
                let vc_com = Global.macros.Storyboard.instantiateViewController(withIdentifier: "company") as! ComapanySchoolViewController
                vc_com.user_IdMyProfile =  local_otherUserId
                _ = self.navigationController?.pushViewController(vc_com, animated: true)
                
            }
        }
         
            
        else{
            PopToRootViewController()
            
        }
    }
    
    func PopToRootVC() {
        DispatchQueue.main.async {
            bool_PlayFromProfile = false
            self.tabBarController?.tabBar.isHidden = false
            let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "SWRevealViewController") as!  SWRevealViewController
            Global.macros.kAppDelegate.window?.rootViewController = vc
        }
    }
    
    
    func ChatConnectandWrite() {
        
        if self.dialog_Chat != nil {
            self.dialog_Chat.onUserIsTyping = { user_id in
                print("user started typing")
                
                if user_id != SavedPreferences.value(forKey:"qb_UserId") as! UInt {
                    DispatchQueue.main.async {
                        
                        self.lbl_Typing.isHidden = false
                        
                    }
                }
            }
            
            self.dialog_Chat.onUserStoppedTyping = { user_id in
                
                DispatchQueue.main.async {
                    
                    print("user end typing")
                    self.lbl_Typing.isHidden = true
                    
                    if self.txtView_Msg.text.characters.count <= 1 {
                        
                        self.img_Send.image = UIImage(named:"send-grey")
                        
                    }
                }
            }
            
        }
        
        currentUser = QBUUser()
        
        currentUser.id = SavedPreferences.value(forKey:"qb_UserId") as! UInt
        currentUser.password = "mind@123"
        
        
        if bool_chat == false {
       
        
        QBChat.instance().connect(with: currentUser!, completion: { (error) in
            print("Successful connected")
            QBChat.instance().addDelegate(self)
            
            self.dialog_Chat.join(completionBlock: { (error) in
                self.retrieveMessages()
                print(error)
            })
            
        })
        }
        else{
            bool_chat = false
            self.retrieveMessages()
            
        }
    }
    
    
    //MARK: Swipe Actions
    
    func swipeleft(_ gestureRecognizer: UISwipeGestureRecognizer) { //NEXT
        
        
        UIView.performWithoutAnimation {
            self.int_LeftRight = 1
            
            self.tblView.reloadData()
            self.tblView.beginUpdates()
            self.tblView.endUpdates()
            
        }
        
    }
    
    func swiperight(_ gestureRecognizer: UISwipeGestureRecognizer) { //PREVIOUS
        
        UIView.performWithoutAnimation {
            self.int_LeftRight = 0
            
            self.tblView.reloadData()
            self.tblView.beginUpdates()
            self.tblView.endUpdates()
            
        }
        
        
    }
    
    
    //MARK: Keyboard show
    func keyboardWillShow(_ notification:Notification){
        let userInfo:NSDictionary = (notification as NSNotification).userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        keyboardHeight = keyboardRectangle.height
    }
    
    
    //MARK: Refresh Data and retrieve Messages
    func RefreshData() {
        
        DispatchQueue.main.async {
            self.pleaseWait()
        }
        self.retrieveMessages()
    }
    
    func retrieveMessages() {
        
               if checkInternetConnection() {
        
        bool_comingFromChat = false
        
        let resPage = QBResponsePage(limit:1000, skip: 0)
        
        QBRequest.messages(withDialogID: str_DialogId!, extendedRequest: nil, for: resPage, successBlock: {(response: QBResponse, messages: [QBChatMessage]?, responcePage: QBResponsePage?) in
            
            if (messages?.count)! > 0 {
                
                print("messages")
                
                self.local_msg = []
                self.local_msg = messages!
                print(self.local_msg)
                
                var tempArray = NSMutableArray()
                if self.messages.contains(messages!) {
                    
                }
                else{
                    
                    self.messages.add(messages!)
        
                    for (_, value) in (messages?.enumerated())! {
                        
                        let dateFormat = DateFormatter()
                        dateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                        let date: Date? = dateFormat.date(from: "\(value.dateSent!)")
                        
                        let formatter = DateFormatter()
                        formatter.locale = NSLocale(localeIdentifier: "GMT") as Locale
                        formatter.dateFormat = "yyyy-MM-dd"
                        let dateAsString: String = formatter.string(from: date!)
                        
                        if !self.arr_Dates.contains(dateAsString) {
                            self.arr_Dates.add(dateAsString) //enamurating array to collect all dates in common array to show dates through sections
                        }
                        
                    }
                    
                    for (_,obj) in (messages?.enumerated())!
                    {
                        
                        
                        let dateFormat = DateFormatter()
                        dateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                        let date: Date? = dateFormat.date(from: "\((obj ).dateSent!)")
                        let formatter = DateFormatter()
                        formatter.locale = NSLocale(localeIdentifier: "GMT") as Locale
                        formatter.dateFormat = "yyyy-MM-dd"
                        let dateAsString: String = formatter.string(from: date!)
                        
                        
                        let newtemp = tempArray.lastObject as? QBChatMessage   // check whether last msg's date in temparray is not equal to new message's date then remove them from new array and that msg comes under new date
                        
                        if newtemp != nil {
                            
                            let dateAsString1: String = formatter.string(from: (newtemp?.dateSent)!)
                            
                            if dateAsString1 != dateAsString {
                                
                                tempArray = NSMutableArray()
                            } }
                        
                        for (_,element) in self.arr_Dates.enumerated()    // check whether date of coming Message date is matching from array of collection dates
                            
                        {
                            if (element as! String) == dateAsString
                            {
                                tempArray.add(obj)
                            }
                        }
                        
                        self.dict_Sections.setValue(tempArray, forKey: dateAsString)  // add them in dic
                    }
                    
                    
                    
                    DispatchQueue.main.async {
                        self.clearAllNotice()
                        
                    }
                    
                    
                    if (self.messages.count) > 0 {
                        
                        // DispatchQueue.main.async {
                        
                        UIView.performWithoutAnimation {
                            self.tblView.reloadData()
                            self.tblView.beginUpdates()
                            self.tblView.endUpdates()
                            let topIndexPath = IndexPath(row: (tempArray.count) - 1, section: (self.arr_Dates.count) - 1)
                            self.tblView.scrollToRow(at: topIndexPath, at: .middle, animated: true)
                        }
                        
                        print("reload tbl")
                        // }
                    }
                }
                
                
            }
            else {
                print("err1")
                DispatchQueue.main.async {
                    
                    self.clearAllNotice()
                    
                }
            }
            
        }, errorBlock: {(response: QBResponse!) in
            
            print("err2")
            DispatchQueue.main.async {
                self.clearAllNotice()
                self.showAlert(Message: "Please try again", vc: self)
                
            }
        })
        
        
        
    }
    
    else {
    
    self.showAlert(Message: Global.macros.kInternetConnection, vc: self)
    
    }
        
    }
    
    func localChatMessage(messages: QBChatMessage) {
        
            print(messages)
        
            var tempArray = NSMutableArray()
        
        print(local_msg)
        
         local_msg.insert(messages, at: local_msg.endIndex)
        
          print(local_msg)
        
        for (_, value) in (self.local_msg.enumerated()) {
            
            print(value)
            
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
            let date: Date? = dateFormat.date(from: "\(value.dateSent!)")
            
            let formatter = DateFormatter()
            formatter.locale = NSLocale(localeIdentifier: "GMT") as Locale
            formatter.dateFormat = "yyyy-MM-dd"
            let dateAsString: String = formatter.string(from: date!)
            
            if !self.arr_Dates.contains(dateAsString) {
                self.arr_Dates.add(dateAsString) //enamurating array to collect all dates in common array to show dates through sections
            }
            
        }
        
        for (_,obj) in (self.local_msg.enumerated())
        {
            
            
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
            let date: Date? = dateFormat.date(from: "\(obj.dateSent!)")
            let formatter = DateFormatter()
            formatter.locale = NSLocale(localeIdentifier: "GMT") as Locale
            formatter.dateFormat = "yyyy-MM-dd"
            let dateAsString: String = formatter.string(from: date!)
            
            
            let newtemp = tempArray.lastObject as? QBChatMessage   // check whether last msg's date in temparray is not equal to new message's date then remove them from new array and that msg comes under new date
            
            if newtemp != nil {
                
                let dateAsString1: String = formatter.string(from: (newtemp?.dateSent)!)
                
                if dateAsString1 != dateAsString {
                    
                    tempArray = NSMutableArray()
                } }
            
            for (_,element) in self.arr_Dates.enumerated()    // check whether date of coming Message date is matching from array of collection dates
                
            {
                if (element as! String) == dateAsString
                {
                    tempArray.add(obj)
                }
            }
            
            self.dict_Sections.setValue(tempArray, forKey: dateAsString)  // add them in dic
        }
        
        
        
        DispatchQueue.main.async {
            self.clearAllNotice()
            
        }
        
        
        if (self.local_msg.count) > 0 {
            
            // DispatchQueue.main.async {
            
            UIView.performWithoutAnimation {
                self.tblView.reloadData()
                self.tblView.beginUpdates()
                self.tblView.endUpdates()
                let topIndexPath = IndexPath(row: (tempArray.count) - 1, section: (self.arr_Dates.count) - 1)
                self.tblView.scrollToRow(at: topIndexPath, at: .middle, animated: true)
            }
            
            print("reload tbl")
            // }
        }

            
        
        
    }
    
    //MARK: Actions
    
    
    @IBAction func Action_BtnPlay(_ sender: UIButton) {
       
          if checkInternetConnection() {
        //    textViewDidEndEditing)
        txtView_Msg.resignFirstResponder()
        self.kBehindViewBottom.constant = 0
        self.kTablebtm.constant = 0
        
        
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tblView)
        let indexPath = self.tblView.indexPathForRow(at: buttonPosition)
        
        //      let cell = self.tblView.cellForRow(at: indexPath!)
        
        let key =  arr_Dates[(indexPath?.section)!] as? String
        let tempArray = dict_Sections.value(forKey: key!) as? NSArray
        
        let dic_Message = tempArray?[(indexPath?.row)!] as! QBChatMessage
        
        
        
        dic_Message.attachments?.forEach({ (attachment) in
            
            let privateUrl : String =  attachment.url!         // QBCBlob.privateUrl(forFileUID: attachment.id!)!
            
            DispatchQueue.main.async {
                
                let movieURL = NSURL(string: privateUrl)
                print(movieURL!)
                let videoURL = URL(string: privateUrl)
                
                var player = AVPlayer()
                
                player = AVPlayer(url: videoURL!)
                let playerViewController = AVPlayerViewController()
                playerViewController.player = player
                self.present(playerViewController, animated: true) {
                    playerViewController.player!.play()
                }
                //                   let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "Upload_Video") as! UploadViewController
                //
                //                    if  movieURL != nil {
                //                        bool_VideoFromGallary = false
                //                        bool_PlayFromProfile = true
                //
                //                        vc.video_urlProfile = movieURL as URL?
                //                        _ = self.navigationController?.present(vc, animated: true, completion: nil)
                //                        //_ = self.navigationController?.pushViewController(vc, animated: true)
                //
                //
                //                    }
                //                    else {
                //
                //                        self.showAlert(Message: "No video to play yet.", vc: self)
                //
                //                    }
                
                
            }
            
        })
             }
                else {
                    
                    self.showAlert(Message: Global.macros.kInternetConnection, vc: self)
                    
                }
        
    }
    
    
    
    @IBAction func SendMsg(_ sender: UIButton) {
        
        
        if checkInternetConnection() {
            
            let rawString: String = txtView_Msg.text
            txtView_Msg.text = ""
            let whitespace = CharacterSet.whitespacesAndNewlines
            var trimmed = rawString.trimmingCharacters(in: whitespace)
            if (trimmed.characters.count) == 0 {
                return
                // Text was empty or only whitespace.
            }
            

            
            //if QBChat.instance().isConnected{
            let privateChatDialog: QBChatDialog? = self.dialog_Chat
            //privateChatDialog?.sendUserIsTyping()
            
            
            privateChatDialog?.join(completionBlock: { (error) in
                let message = QBChatMessage()
                message.text = trimmed
                //
                let params = NSMutableDictionary()
                params["save_to_history"] = true
                message.customParameters = params
                privateChatDialog?.send(message, completionBlock: {(_ error: Error?) -> Void in
                    //  self.sendPushNotification(rawString, userID: dialog_Chat["occupantIDs"][1])
                    print("send message")
                //   self.localChatMessage(messages: message)
                    self.kHeightBehindTxtView.constant = 56
                    self.KtxtViewHeight.constant = 42
                    self.img_Send.image = UIImage(named:"send-grey")
                    
                    //self.retrieveMessages()
                    self.createChatNotificationForGroupChatUpdate(dialog: privateChatDialog!,message:message)
                    
                })
                
            })
            
            
        }
        else {
            self.showAlert(Message: Global.macros.kInternetConnection, vc: self)
        }
    }
    
    
    func takeNewPhotoFromCamera()
    {
        if UIImagePickerController.isSourceTypeAvailable(.camera)
        {
            let controller = UIImagePickerController()
            controller.sourceType = .camera
            controller.allowsEditing = false
            controller.delegate = self
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
    
    
    
    @IBAction func Action_OpenCamera(_ sender: UIButton) {
        
        
        takeNewPhotoFromCamera()
    }
    
    
    @IBAction func ActionAttachmentr(_ sender: UIButton) {
        
        txtView_Msg.resignFirstResponder()
        UIView.animate(withDuration: 0.0, animations: {
            
            self.kBehindViewBottom.constant = 0
            self.kTablebtm.constant = 0
            
        }, completion: nil)
        
        let actionSheet1 = UIAlertController(title: "Choose Option", message: nil, preferredStyle: .actionSheet)
        
        
        actionSheet1.addAction(UIAlertAction(title: "Photo", style: .default, handler: {(action: UIAlertAction) -> Void in
            // choose photo button tapped.
            
            let actionSheet = UIAlertController(title: "Choose Option", message: nil, preferredStyle: .actionSheet)
            
            
            actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction) -> Void in
                // choose photo button tapped.
                
                
                self.takeNewPhotoFromCamera()
                
                
                
            }))
            
            
            
            actionSheet.addAction(UIAlertAction(title: "Gallery", style: .default, handler: {(action: UIAlertAction) -> Void in
                // Destructive button tapped.
                self.choosePhotoFromExistingImages()
                
            }))
            
            
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: {(action: UIAlertAction) -> Void in
                // Destructive button tapped.
                
            }))
            
            
            DispatchQueue.main.async {
                self.present(actionSheet, animated: true, completion: { _ in })
            }
            
        }))
        
        
        
        actionSheet1.addAction(UIAlertAction(title: "Video", style: .default, handler: {(action: UIAlertAction) -> Void in
            // Destructive button tapped.
            
            let actionSheet = UIAlertController(title: "Choose Option", message: nil, preferredStyle: .actionSheet)
            
            
            actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction) -> Void in
                // choose photo button tapped.
                
                bool_PlayFromProfile = false
                bool_comingFromChat = true
                
                let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "CameraView") as! CameraViewController
                self.present(vc, animated: true, completion: nil)
                
                
                
            }))
            
            
            
            actionSheet.addAction(UIAlertAction(title: "Gallery", style: .default, handler: {(action: UIAlertAction) -> Void in
                // Destructive button tapped.
                
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
                    bool_SelectVideoFromGallary = true //willcheck
                    
                }
                
                
            }))
            
            
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: {(action: UIAlertAction) -> Void in
                // Destructive button tapped.
                
            }))
            
            DispatchQueue.main.async {
                self.present(actionSheet, animated: true, completion: { _ in })
            }
            
            
        }))
        
        
        actionSheet1.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: {(action: UIAlertAction) -> Void in
            // Destructive button tapped.
            
        }))
        
        
        
        
        
        
        DispatchQueue.main.async {
            self.present(actionSheet1, animated: true, completion: { _ in })
        }
        
    }
    
    
    
    public func UploadVideoFromCamera() {
        
        if checkInternetConnection() {
        
        do {
            //                    let asset = AVURLAsset(url: videoURL_forthumbnail as! URL , options: nil)
            //                    let imgGenerator = AVAssetImageGenerator(asset: asset)
            //                    imgGenerator.appliesPreferredTrackTransform = true
            //                    let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(0, 1), actualTime: nil)
            //                    let thumbnail = UIImage(cgImage: cgImage)
            //  imgView.image = thumbnail
            
            currentUser = QBUUser()
            currentUser.id = SavedPreferences.value(forKey:"qb_UserId") as! UInt
            currentUser.password = "mind@123"
            
            QBChat.instance().connect(with: currentUser, completion: {(_ error: Error?) -> Void in
                let privateChatDialog: QBChatDialog? = self.dialog_Chat
                privateChatDialog?.sendUserIsTyping()
                privateChatDialog?.join(completionBlock: { (error) in
                    
                    QBRequest.tUploadFile( self.videoData! , fileName: "video", contentType: "video/mp4", isPublic: true,
                                           successBlock: {(response: QBResponse!, uploadedBlob: QBCBlob!) in
                                            // Create and configure message
                                            let message: QBChatMessage = QBChatMessage()
                                            
                                            let uploadedFileID = uploadedBlob.uid
                                            let attachment: QBChatAttachment = QBChatAttachment()
                                            attachment.type = "video"
                                            attachment.id = uploadedFileID! as String
                                            attachment.url = uploadedBlob.privateUrl()
                                            
                                            message.attachments = [attachment]
                                            message.text = "Attachment video"
                                            // Send message
                                            
                                            let params = NSMutableDictionary()
                                            params["save_to_history"] = true
                                            message.customParameters = params
                                            //
                                            privateChatDialog?.send(message, completionBlock: {(_ error: Error?) -> Void in
                                                self.createChatNotificationForGroupChatUpdate(dialog: privateChatDialog!,message:message)
   
                                                //self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
                                                //                                                print("success")
                                                //                                                privateChatDialog?.sendUserStoppedTyping()
                                                //
                                                //                                                DispatchQueue.main.async {
                                                //                                                    self.clearAllNotice()
                                                //                                                }
                                                //                                                self.retrieveMessages()
                                                
                                            })
                                            
                                            
                                            
                                            
                    }, statusBlock: {(request: QBRequest?, status: QBRequestStatus?) in
                        
                    }, errorBlock: {(response: QBResponse!) in
                        DispatchQueue.main.async {
                            self.clearAllNotice()
                        }
                        
                        self.showAlert(Message: "Please try again", vc: self)
                        // print(response.error!.reasons!)
                    })
                })
            })
            
            
            
        } catch let error {
            print("*** Error generating thumbnail: \(error.localizedDescription)")
        }
        
        
        }
        
                else {
                    
                    self.showAlert(Message: Global.macros.kInternetConnection, vc: self)
                    
        }
        
        
    }
    
    // Actions of buttons
    
    @IBAction func Action_OpenMessage(_ sender: UIButton) {
        
        //    textViewDidEndEditing)
        txtView_Msg.resignFirstResponder()
        self.kBehindViewBottom.constant = 0
        self.kTablebtm.constant = 0
        
        
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tblView)
        let indexPath = self.tblView.indexPathForRow(at: buttonPosition)
        
        let cell = self.tblView.cellForRow(at: indexPath!) as? ChatImageTableViewCell
        
        DispatchQueue.main.async {
            
            
            Global.macros.statusBar.isHidden = true
            
            if (cell?.imageView_Attachment.image!) != nil {
                let imgdata = UIImageJPEGRepresentation((cell?.imageView_Attachment.image!)! , 0.5)
                if imgdata != nil {
                    
                    let photos = self.ArrayOfPhotos(data: imgdata!)
                    let vc: NYTPhotosViewController = NYTPhotosViewController(photos: photos as? [NYTPhoto])
                    vc.rightBarButtonItem = nil
                    
                    
                    self.present(vc, animated: true, completion: nil)
                }
                
                
            }
            
        }
        //   }
        
    }
    
    
    func ArrayOfPhotos(data:Data)->(NSArray)
    {
        self.tblView.contentInset = UIEdgeInsets.init(top: 10, left: 0, bottom: 0, right: 0)
        let photos:NSMutableArray = NSMutableArray()
        let photo:NYTExamplePhoto = NYTExamplePhoto()
        photo.imageData = data
        photos.add(photo)
        return photos
        
    }
    
    
    
    func heightForView_txtView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        
        
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
        
    }
    
    
    
    
    func documentsPathForFileName(name: String) -> String {
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        return documentsPath.appending(name)
    }
    
    
    
    //MARK: Push notifications
    
    func createChatNotificationForGroupChatUpdate(dialog: QBChatDialog, message: QBChatMessage)  {
      
        
        var otheruserid : String!
        let dic = dialog
        
        let Array_selectedId = dic.value(forKey: "occupantIDs") as! NSArray
        let selectedId = "\(Array_selectedId[0])"
        print(selectedId)
        
        for (index, element) in Array_selectedId.enumerated() {
            
            print(index)
            print(element)
            
            if element as! UInt != SavedPreferences.value(forKey:"qb_UserId") as! UInt {
                otheruserid = "\(element)"
                
                let event = QBMEvent.init()
                event.notificationType = .push
                event.usersIDs = otheruserid
                print(event)
                var str : String = ""

                var dictPush = [String : String]()
                
                if (SavedPreferences.value(forKey: "role") as? String) == "USER" {
                    
                    dictPush["message"] = (SavedPreferences.value(forKey: "firstname") as? String)! + " " + (SavedPreferences.value(forKey: "lastname") as? String)! + ":" + " " + message.text!
                     str = (SavedPreferences.value(forKey: "firstname") as? String)! + " " + (SavedPreferences.value(forKey: "lastname") as? String)!
                }
                    
                    
                else if  (SavedPreferences.value(forKey: "role") as? String) == "SCHOOL" {
                    
                    dictPush["message"] = (SavedPreferences.value(forKey: Global.macros.kschoolName) as? String)! + ":" + " " + message.text!
                    str = (SavedPreferences.value(forKey: Global.macros.kschoolName) as? String)!

                }
                    
                else if (SavedPreferences.value(forKey: "role") as? String) == "COMPANY" {
                    
                     dictPush["message"] = (SavedPreferences.value(forKey: Global.macros.kcompanyName) as? String)! + ":" + " " + message.text!
                    str = (SavedPreferences.value(forKey: Global.macros.kcompanyName) as? String)!

                }
                
//                dictPush["chatDialogId"] = dialog.id
//                dictPush["otherUserId"] = "\(local_otherUserId)"
//                dictPush["titleName"] = self.navigationItem.title
//                dictPush["otherUserRole"] = ""
                
                dictPush["chatDialogId"] = dialog.id
                dictPush["otherUserId"] = "\(String(describing: SavedPreferences.value(forKey: "Global.macros.kUserId"))))"
                dictPush["titleName"] = str
                dictPush["otherUserRole"] = "\(String(describing: SavedPreferences.value(forKey: "role")))"

                print(dictPush)
                
                let jsonData = try? JSONSerialization.data(withJSONObject: dictPush, options: .prettyPrinted)
                let jsonString = String(bytes: jsonData!, encoding: String.Encoding.utf8)
                
                event.message = jsonString
                event.notificationType = QBMNotificationType.push
                event.type = QBMEventType.oneShot
                //QBMNotificationTypePush
                
                
                QBRequest.createEvent(event, successBlock: {(response: QBResponse,events: [QBMEvent]?) -> Void in
                    // Successful response with event
                    print("success")
                    
                }, errorBlock: {(response: QBResponse) -> Void in
                    // Handle error
                    print(response.error)
                })

            }
        }
        
        
    }
    
    //MARK : Video compress
    
    func compressVideo(_ inputURL: URL,outputURL:URL ,handler completion: @escaping (AVAssetExportSession) -> Void) {
        
        let vc = UploadViewController()
        vc.str_comingFromChat = "true"
        vc.uploadVideo_rightOrientation(inputURL)
        
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   

}


extension ChatViewController : QBChatDelegate{
    
    
    func chatRoomDidReceive(_ message: QBChatMessage, fromDialogID dialogID: String) {
        
        print("aa gea chat delegate ch")
        DispatchQueue.main.async {
            Global.macros.statusBar.isHidden = false
        }
        
        self.retrieveMessages()
        
    }
}


extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "cellDate") as! DateTableViewCell
        
        let str = arr_Dates[section] as? String
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat  = "yyyy-MM-dd"
        let date = dateFormatter1.date(from:str!)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat  = "EEEE, MMM d, yyyy"//"EE" to get short style
        let dayInWeek = dateFormatter.string(from: date!)//"Sunday"
        headerCell.lbl_Date.text = dayInWeek
        
        return headerCell.contentView
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        
        return arr_Dates.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        
        let key =  arr_Dates[section] as? String
        
        let tempArray = dict_Sections.value(forKey: key!) as? NSArray
        
        
        
        return (tempArray?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var main_cell = UITableViewCell()
        
        let key =  arr_Dates[indexPath.section] as? String
        let tempArray = dict_Sections.value(forKey: key!) as? NSArray
        
        
        
        if (tempArray?.count)! > 0 {
            
            
            if ((tempArray?[indexPath.row] as! QBChatMessage).attachments?.count)! > 0 {
                
                let dic_Message = tempArray?[indexPath.row] as! QBChatMessage
                let sender = "\(dic_Message.senderID)"
                
                let CellIdentifier = "cellimage"
                var cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier) as? ChatImageTableViewCell
                
                cell?.lbl_Time.isHidden = true
                
                if cell == nil {
                    cell = ChatImageTableViewCell(style: .default, reuseIdentifier: CellIdentifier)
                }
               // cell?.imageView_Attachment.image = UIImage()

           //     cell?.imageView_Attachment.image = UIImage(named: "profile-icon-1")

                cell?.btn_Image.tag = indexPath.row
                cell?.btn_Play.tag = indexPath.row
                
                dic_Message.attachments?.forEach({ (attachment) in
                    
                    if   attachment.type == "video" {
                        
                        cell?.btn_Play.isHidden = false
                        cell?.btn_Image.isHidden = true  //video-player
                        DispatchQueue.main.async {
                            
                            cell?.imageView_Attachment.sd_setImage(with: nil, placeholderImage: UIImage(named: "video-player"), options: .refreshCached , completed: nil)
                        }
                        
                        let str_OtherUserQB_id = self.str_OtherUserId
                        let dateFormat = DateFormatter()
                        dateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                        let date: Date? = dateFormat.date(from: "\(dic_Message.dateSent!)")
                        let formatter = DateFormatter()
                        formatter.locale = NSLocale(localeIdentifier: "GMT") as Locale
                        formatter.dateFormat = "hh:mm a"
                        let dateAsString: String = formatter.string(from: date!)
                        
                        if (sender == str_OtherUserQB_id) {
                            // left aligned
                            DispatchQueue.main.async {
                                
                                
                                cell?.lbl_Name.textAlignment = .left
                                cell?.lbl_Time.textAlignment = .right
                                cell?.lbl_Name.text = self.str_ReceiverName?.capitalized
                                cell?.imageView_Attachment.layer.borderColor =  UIColor.init(red: 115.0/255.0, green: 213.0/255.0, blue: 255.0/255.0, alpha: 1.0).cgColor
                                cell?.imageView_Attachment.layer.cornerRadius = 8.0
                                // cell?.imageView_Attachment.layer.borderWidth = 1.0
                                cell?.imageView_Attachment.clipsToBounds = true
                                
                                cell?.lbl_Time.text = dateAsString
                                cell?.imageView_Attachment.frame = CGRect(x: 24, y: 12, width: 120, height: 135)
                                cell?.btn_Image.frame = CGRect(x: 24, y: 24, width: 115, height: 108)
                                cell?.btn_Play.frame =  CGRect(x: 24, y: 24, width: 115, height: 108)
                                
                                
                            }
                            
                        }
                            
                        else {
                            DispatchQueue.main.async {
                                
                                
                                cell?.lbl_Time.text = dateAsString
                                
                                cell?.lbl_Name.textAlignment = .right
                                cell?.lbl_Time.textAlignment = .right
                                
                                cell?.imageView_Attachment.layer.borderColor =  UIColor.init(red: 241.0/255.0, green: 241.0/255.0, blue: 241.0/255.0, alpha: 1.0).cgColor
                                cell?.imageView_Attachment.layer.cornerRadius = 8.0
                                //  cell?.imageView_Attachment.layer.borderWidth = 1.0
                                cell?.imageView_Attachment.frame = CGRect(x: (cell?.contentView.frame.size.width)! - 140, y: 12, width: 120, height: 135)
                                cell?.btn_Image.frame = CGRect(x: (cell?.contentView.frame.size.width)! - 140, y: 24, width: 115, height: 108)
                                cell?.imageView_Attachment.clipsToBounds = true
                                cell?.btn_Play.frame =  CGRect(x: (cell?.contentView.frame.size.width)! - 140, y: 24, width: 115, height: 108)
                                
                                
                                if (SavedPreferences.value(forKey: "role") as? String) == "USER" {
                                    
                                    cell?.lbl_Name.text = ((SavedPreferences.value(forKey: "firstname") as? String)! + " " + (SavedPreferences.value(forKey: "lastname") as? String)!).capitalized
                                }
                                    
                                    
                                else if  (SavedPreferences.value(forKey: "role") as? String) == "SCHOOL" {
                                    
                                    cell?.lbl_Name.text = ((SavedPreferences.value(forKey: Global.macros.kschoolName) as? String)!).capitalized
                                }
                                    
                                else if (SavedPreferences.value(forKey: "role") as? String) == "COMPANY" {
                                    
                                    cell?.lbl_Name.text = ((SavedPreferences.value(forKey: Global.macros.kcompanyName) as? String)!).capitalized
                                }
                            }
                        }
                        
                        
                    }
                        
                    else {
                        
                        
                        cell?.btn_Play.isHidden = true
                        cell?.btn_Image.isHidden = false
                        
                        
                        dic_Message.attachments?.forEach({ (attachment) in
                            
                            let privateUrl : String = QBCBlob.privateUrl(forFileUID: attachment.id!)!
                            
                            
                            
                            
                            if privateUrl != "" {
                                
//                                DispatchQueue.main.async {
//
//                                cell?.imageView_Attachment.sd_setImage(with: URL(string:privateUrl), placeholderImage: UIImage(named: "profile-icon-1"), options: .refreshCached, progress: { (a, b, str) in
//
//
//                                }, completed: { (image, error, cacheType, urlStr) in
//                                    DispatchQueue.main.async {
//                                        cell?.imageView_Attachment.image = image
//                                    }
//
//                                })
//
//
//
//
//                                     }
                                
                                
//                                UIImage * imageCache = [[UIImage alloc]init];
//
//                                imageCache = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:[NSString stringWithFormat:@"%@post/%@/image",KbaseURL,[[arrayForPosts valueForKey:@"idPost"] objectAtIndex:indexPath.row]]];
//
//                                if (imageCache == nil)
//                                {
//                                    imageCache = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[NSString stringWithFormat:@"%@post/%@/image",KbaseURL,[[arrayForPosts valueForKey:@"idPost"] objectAtIndex:indexPath.row]]];
//                                }

                                var imageCache = SDImageCache.shared().imageFromCache(forKey: privateUrl)
                                
                                if imageCache != nil {
                                    
                                       cell?.imageView_Attachment.image = imageCache
                                }
                                
                                else{
                                    
                                     imageCache = SDImageCache.shared().imageFromDiskCache(forKey: privateUrl)
                                    if imageCache != nil {
                                        
                                        cell?.imageView_Attachment.image = imageCache
                                    }
                                    
                                    else{
                                        
                                      
                                        SDWebImageManager.shared().loadImage(with: URL(string:privateUrl), options: .highPriority , progress: { (receivedSize :Int, ExpectedSize :Int, url : URL?) in
                                            
                                            
                                            
                                        }, completed: { (image : UIImage?, data : Data?, error : Error?, cacheType : SDImageCacheType, finished : Bool, url : URL?) in
                                            
                                            DispatchQueue.main.async {
                                                cell?.imageView_Attachment.sd_setImage(with: url, placeholderImage: UIImage(named: "profile-icon-1"), options: .refreshCached , completed: nil)
                                            }
                                            
                                            
                                        })
                                        
                                    }
                                }
                                
                        
                               
//                                else {
//
////                                DispatchQueue.main.async {
////                                    cell?.imageView_Attachment.sd_setImage(with: URL(string:privateUrl), placeholderImage: UIImage(named: "profile-icon-1"), options: .refreshCached , completed: nil)
////                                }
//
//                                }
                                

                            }
                                
                            else{
                                
                                cell?.imageView_Attachment.image = UIImage(named: "profile-icon-1")
                                
                            }
                        })
                        
                        
                        
                        
                        let str_OtherUserQB_id = self.str_OtherUserId
                        let dateFormat = DateFormatter()
                        dateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                        let date: Date? = dateFormat.date(from: "\(dic_Message.dateSent!)")
                        let formatter = DateFormatter()
                        formatter.locale = NSLocale(localeIdentifier: "GMT") as Locale
                        formatter.dateFormat = "hh:mm a"
                        let dateAsString: String = formatter.string(from: date!)
                        
                        if (sender == str_OtherUserQB_id) {
                            // left aligned
                            DispatchQueue.main.async {
                                
                                
                                cell?.lbl_Name.textAlignment = .left
                                cell?.lbl_Time.textAlignment = .right
                                cell?.lbl_Name.text = self.str_ReceiverName?.capitalized
                                cell?.imageView_Attachment.layer.borderColor =  UIColor.init(red: 115.0/255.0, green: 213.0/255.0, blue: 255.0/255.0, alpha: 1.0).cgColor
                                cell?.imageView_Attachment.layer.cornerRadius = 8.0
                                // cell?.imageView_Attachment.layer.borderWidth = 1.0
                                cell?.imageView_Attachment.clipsToBounds = true
                                
                                cell?.lbl_Time.text = dateAsString
                                cell?.imageView_Attachment.frame = CGRect(x: 24, y: 24, width: 115, height: 108)
                                cell?.btn_Image.frame = CGRect(x: 24, y: 24, width: 115, height: 108)
                                cell?.btn_Play.frame = CGRect(x: 24, y: 24, width: 115, height: 108)
                                
                                
                            }
                            
                        }
                            
                        else {
                            DispatchQueue.main.async {
                                
                                
                                cell?.lbl_Time.text = dateAsString
                                
                                cell?.lbl_Name.textAlignment = .right
                                cell?.lbl_Time.textAlignment = .right
                                
                                cell?.imageView_Attachment.layer.borderColor =  UIColor.init(red: 241.0/255.0, green: 241.0/255.0, blue: 241.0/255.0, alpha: 1.0).cgColor
                                cell?.imageView_Attachment.layer.cornerRadius = 8.0
                                //  cell?.imageView_Attachment.layer.borderWidth = 1.0
                                cell?.imageView_Attachment.frame = CGRect(x: (cell?.contentView.frame.size.width)! - 140, y: 24, width: 115, height: 108)
                                cell?.btn_Image.frame = CGRect(x: (cell?.contentView.frame.size.width)! - 140, y: 24, width: 115, height: 108)
                                cell?.imageView_Attachment.clipsToBounds = true
                                cell?.btn_Play.frame = CGRect(x: (cell?.contentView.frame.size.width)! - 140, y: 24, width: 115, height: 108)
                                
                                
                                if (SavedPreferences.value(forKey: "role") as? String) == "USER" {
                                    
                                    cell?.lbl_Name.text = ((SavedPreferences.value(forKey: "firstname") as? String)! + " " + (SavedPreferences.value(forKey: "lastname") as? String)!).capitalized
                                }
                                    
                                    
                                else if  (SavedPreferences.value(forKey: "role") as? String) == "SCHOOL" {
                                    
                                    cell?.lbl_Name.text = ((SavedPreferences.value(forKey: Global.macros.kschoolName) as? String)!).capitalized
                                }
                                    
                                else if (SavedPreferences.value(forKey: "role") as? String) == "COMPANY" {
                                    
                                    cell?.lbl_Name.text = ((SavedPreferences.value(forKey: Global.macros.kcompanyName) as? String)!).capitalized
                                }
                            }
                        }
                        
                        
                    }
                    
                })
                
                main_cell = cell!
            }
                
            else {
                
                let dic_Message = tempArray?[indexPath.row] as! QBChatMessage
                let sender = "\(dic_Message.senderID)"
                
                let CellIdentifier = "cell"
                var cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier) as? ChatTableViewCell
                if cell == nil {
                    cell = ChatTableViewCell(style: .default, reuseIdentifier: CellIdentifier)
                }
                
                cell?.lbl_Time.isHidden = true
                let message: String? = dic_Message.text
                let time = "\(dic_Message.createdAt)"
                let dateFormat = DateFormatter()
                dateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                let date: Date? = dateFormat.date(from: "\(dic_Message.dateSent!)")
                let formatter = DateFormatter()
                formatter.locale = NSLocale(localeIdentifier: "GMT") as Locale
                formatter.dateFormat = "hh:mm a"
                let dateAsString: String = formatter.string(from: date!)
                
                cell?.accessoryType = .none
                //  cell?.isUserInteractionEnabled = false
                let str_OtherUserQB_id = str_OtherUserId
                
                cell?.lbl_Message.layer.cornerRadius = 8.0
                cell?.lbl_Message.clipsToBounds = true
                
                
                
                let textSize = CGSize(width: 260.0, height: 10000.0)
                
                
                var size: CGSize = message!.boundingRect(with: textSize, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: (cell?.lbl_Message.font)!], context: nil).size
                
                size.width += 30.0/2 + 10
                cell?.lbl_Message.numberOfLines = 2000
                
                
                if (sender == str_OtherUserQB_id) {
                    // left aligned
                    
                    DispatchQueue.main.async {
                        
                        cell?.lbl_Message.frame = CGRect(x: 22, y: 12 * 2, width: size.width , height:  size.height + 18)
                        cell?.lbl_Name.textAlignment =    .left
                        cell?.lbl_Message.textAlignment = .left
                        cell?.lbl_Time.textAlignment =    .right
                        
                        cell?.lbl_Name.text = self.str_ReceiverName?.capitalized
                        cell?.lbl_Message.layer.borderColor =  UIColor.init(red: 115.0/255.0, green: 213.0/255.0, blue: 255.0/255.0, alpha: 1.0).cgColor
                        cell?.lbl_Message.layer.borderWidth = 1.0
                        
                        cell?.lbl_Message.text = message
                        cell?.lbl_Time.text = dateAsString
                        cell?.lbl_Message.textColor = UIColor.white
                        
                        cell?.lbl_Message.backgroundColor = UIColor.init(red: 115.0/255.0, green: 213.0/255.0, blue: 255.0/255.0, alpha: 1.0)
                        
                        
                        
                        
                    }
                }
                    
                else {
                    
                    //     DispatchQueue.main.async {
                    
                    cell?.lbl_Message.frame = CGRect(x: self.view.frame.size.width - size.width - 26, y: 12 * 2, width: size.width, height:  size.height + 18)
                    
                    cell?.lbl_Name.textAlignment = .right
                    cell?.lbl_Message.textAlignment = .left
                    cell?.lbl_Time.textAlignment = .right
                    cell?.lbl_Time.text = dateAsString
                    
                    
                    if (SavedPreferences.value(forKey: "role") as? String) == "USER" {
                        
                        cell?.lbl_Name.text = ((SavedPreferences.value(forKey: "firstname") as? String)! + " " + (SavedPreferences.value(forKey: "lastname") as? String)!).capitalized
                    }
                        
                        
                    else if  (SavedPreferences.value(forKey: "role") as? String) == "SCHOOL" {
                        
                        cell?.lbl_Name.text = ((SavedPreferences.value(forKey: Global.macros.kschoolName) as? String)!).capitalized
                    }
                        
                    else if (SavedPreferences.value(forKey: "role") as? String) == "COMPANY" {
                        
                        cell?.lbl_Name.text = ((SavedPreferences.value(forKey: Global.macros.kcompanyName) as? String)!).capitalized
                    }
                    
                    
                    
                    cell?.lbl_Message.layer.borderColor = UIColor.init(red: 241.0/255.0, green: 241.0/255.0, blue: 241.0/255.0, alpha: 1.0).cgColor
                    cell?.lbl_Message.layer.borderWidth = 1.0
                    cell?.lbl_Message.text = message
                    cell?.lbl_Message.backgroundColor = UIColor.init(red: 241.0/255.0, green: 241.0/255.0, blue: 241.0/255.0, alpha: 1.0)
                    cell?.lbl_Message.textColor = UIColor.init(red: 131.0/255.0, green: 138.0/255.0, blue: 141.0/255.0, alpha: 1.0)
                    
                    
                }
                
                
                
                main_cell = cell!
                
            }
            
        }
        //    main_cell.transform = CGAffineTransform(scaleX: 1, y: -1);
        
        return main_cell
        
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        let key =  arr_Dates[indexPath.section] as? String
        let tempArray = dict_Sections.value(forKey: key!)as? NSArray
        
        if (tempArray?.count)! > 0 {
            
            let dic_Message = tempArray?[indexPath.row] as! QBChatMessage
            
            
            if ((tempArray?[indexPath.row] as! QBChatMessage).attachments?.count)! > 0 {
                
                
                return 140
            }
                
            else {
                
                let dic_Message = tempArray?[indexPath.row] as! QBChatMessage
                let message: String? = dic_Message.text
                
                let textSize = CGSize(width: 260.0, height: 10000.0)
                
                
                var size: CGSize = message!.boundingRect(with: textSize, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont(name: "Helvetica", size: 16.0)!], context: nil).size
                
                size.width += 30.0/2
                
                let height : CGFloat = size.height + 50
                
                //let height:CGFloat = self.calculateHeight(inString: message!)
                return height
                
            }
            
        }
        else {
            
            return 0
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        DispatchQueue.main.async {
            Global.macros.statusBar.isHidden = false
            
        }
        
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let key =  arr_Dates[indexPath.section] as? String
        let tempArray = dict_Sections.value(forKey: key!) as? NSMutableArray
        
        
        let dic_Message = tempArray?[indexPath.row] as! QBChatMessage
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        let date: Date? = dateFormat.date(from: "\(dic_Message.dateSent!)")
        let formatter = DateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "GMT") as Locale
        formatter.dateFormat = "hh:mm a"
        let dateAsString: String = formatter.string(from: date!)
        let sender = "\(dic_Message.senderID)"
        
        if (sender != self.str_OtherUserId) {
            
            
            let editAction = UITableViewRowAction(style: .normal, title: dateAsString) { (rowAction, indexPath) in
                //TODO: edit the row at indexPath here
            }
            editAction.backgroundColor = UIColor.init(red: 131.0/255.0, green: 138.0/255.0, blue: 141.0/255.0, alpha: 1.0)
            let deleteAction = UITableViewRowAction(style: .normal, title: "Delete") { (rowAction, indexPath) in
                if dic_Message.id != nil {
                    
                    QBRequest.deleteMessages(withIDs: Set(arrayLiteral: dic_Message.id!), forAllUsers: true, successBlock: { (response: QBResponse!) -> Void in
                        
                        DispatchQueue.main.async {
                            
                            //  let replaceDict = (array_GlobalDiscussions[sender.tag]as! NSDictionary).mutableCopy() as! NSMutableDictionary
                            //                    let object: QBChatMessage = (tempArray![indexPath.row] as! QBChatMessage).mutableCopy() as! QBChatMessage
                            //                    tempArray?.removeObject(at: indexPath.row)
                            
                            
                            let key =  self.arr_Dates[indexPath.section] as? String


                         let arr = self.dict_Sections.value(forKey: key!) as? NSMutableArray
                            
                           
                           
                            
                            if arr?[indexPath.row] != nil   {
                                
                                (self.dict_Sections.value(forKey: key!) as! NSMutableArray).removeObject(at: indexPath.row)
  
                                UIView.performWithoutAnimation {
                                    
                                    self.tblView.reloadData()
                                    self.tblView.beginUpdates()
                                    self.tblView.endUpdates()
                                    
                                }
                            }
                                
                         
                        }
                        
                        
                        
                    }) { (response: QBResponse!) -> Void in
                        
                        DispatchQueue.main.async {
                            
                           // let temp = self.dict_Sections[indexPath.row] as? NSMutableArray
                            //  let replaceDict = (array_GlobalDiscussions[sender.tag]as! NSDictionary).mutableCopy() as! NSMutableDictionary
                            //                    let object: QBChatMessage = (tempArray![indexPath.row] as! QBChatMessage).mutableCopy() as! QBChatMessage
                            //                    tempArray?.removeObject(at: indexPath.row)
                            
                            let arr = self.dict_Sections.value(forKey: key!) as? NSMutableArray
                            
                            
                            if arr?[indexPath.row] != nil   {
                                
                                (self.dict_Sections.value(forKey: key!) as! NSMutableArray).removeObject(at: indexPath.row)
                                
                                UIView.performWithoutAnimation {
                                    
                                    self.tblView.reloadData()
                                    self.tblView.beginUpdates()
                                    self.tblView.endUpdates()
                                    
                                }
                            }

                        }
                        
                        
                        print(response.error!)
                    }
                }
                
            }
            deleteAction.backgroundColor = .red
            
            return [editAction,deleteAction]
            
            
        }
        else{
            
            
            let editAction = UITableViewRowAction(style: .normal, title: dateAsString) { (rowAction, indexPath) in
                //TODO: edit the row at indexPath here
            }
            editAction.backgroundColor = UIColor.init(red: 131.0/255.0, green: 138.0/255.0, blue: 141.0/255.0, alpha: 1.0)
            //            let deleteAction = UITableViewRowAction(style: .normal, title: "Delete") { (rowAction, indexPath) in
            //
            //                if dic_Message.id != nil {
            //
            //                    QBRequest.deleteMessages(withIDs: Set(arrayLiteral: dic_Message.id!), forAllUsers: false, successBlock: { (response: QBResponse!) -> Void in
            //
            //                        DispatchQueue.main.async {
            //
            //                            //  let replaceDict = (array_GlobalDiscussions[sender.tag]as! NSDictionary).mutableCopy() as! NSMutableDictionary
            //                            //                    let object: QBChatMessage = (tempArray![indexPath.row] as! QBChatMessage).mutableCopy() as! QBChatMessage
            //                            //                    tempArray?.removeObject(at: indexPath.row)
            //
            //
            //                            let key =  self.arr_Dates[indexPath.section] as? String
            //                            (self.dict_Sections.value(forKey: key!) as! NSMutableArray).removeObject(at: indexPath.row)
            //                            UIView.performWithoutAnimation {
            //
            //                                self.tblView.reloadData()
            //                                self.tblView.beginUpdates()
            //                                self.tblView.endUpdates()
            //
            //                            }
            //
            //
            //
            //
            //                            print("ok")
            //                        }
            //
            //
            //
            //                    }) { (response: QBResponse!) -> Void in
            //
            //
            //
            //
            //                        print(response.error!)
            //                    }
            //                }
            //
            //
            //            }
            //            deleteAction.backgroundColor = .red
            
            return [editAction]
            
            
            
        }
        
        
        
    }
    
    /* func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
     
     
     if let maincell = cell as? ChatImageTableViewCell {
     
     DispatchQueue.main.async {
     
     
     if self.int_LeftRight == 1 {
     
     DispatchQueue.main.async {
     
     maincell.view_Behind.frame = CGRect(x:  -100 , y: (maincell.view_Behind.frame.origin.y), width: (maincell.view_Behind.bounds.size.width), height: (maincell.view_Behind.bounds.size.height))
     
     
     maincell.lbl_Time.isHidden = false
     
     }
     
     
     }
     
     
     
     else {
     DispatchQueue.main.async {
     
     maincell.view_Behind.frame = CGRect(x:  0, y: (maincell.view_Behind.frame.origin.y), width: (maincell.view_Behind.bounds.size.width), height: (maincell.view_Behind.bounds.size.height))
     maincell.lbl_Time.isHidden = false
     }
     }
     
     }
     
     }
     
     
     if  ((cell as? ChatImageTableViewCell) != nil) {
     
     
     }
     else {
     
     DispatchQueue.main.async {
     
     
     if let maincell2 = cell as? ChatTableViewCell {
     
     if self.int_LeftRight == 1 {
     
     DispatchQueue.main.async {
     
     maincell2.view_Behind.frame = CGRect(x:  -100 , y: (maincell2.view_Behind.frame.origin.y), width: (maincell2.view_Behind.bounds.size.width), height: (maincell2.view_Behind.bounds.size.height))
     
     
     maincell2.lbl_Time.isHidden = false
     }
     
     }
     
     else {
     
     DispatchQueue.main.async {
     
     maincell2.view_Behind.frame = CGRect(x:  0, y: (maincell2.view_Behind.frame.origin.y), width: (maincell2.view_Behind.bounds.size.width), height: (maincell2.view_Behind.bounds.size.height))
     
     
     
     maincell2.lbl_Time.isHidden = false
     }
     
     }
     
     }
     
     
     }
     
     }
     
     
     
     } */
    
    
    
    
    
    
}

extension ChatViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        
        self.lbl_PlaceHolder.isHidden = true
        
        //a self.img_Send.image = UIImage(named:"send_white")
        
        UIView.animate(withDuration: 1.0, animations: {
            self.kBehindViewBottom.constant = self.keyboardHeight
            self.kTablebtm.constant = 0
        }, completion: nil)
        
        
        
        self.tblView.setContentOffset(CGPoint(x: 0, y: CGFloat.greatestFiniteMagnitude), animated: false)
        
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
         if self.dialog_Chat != nil {
        self.dialog_Chat.sendUserStoppedTyping()
        }
        
        var txtAfterUpdate = textView.text.trimmingCharacters(in: .whitespaces)
        
        if txtAfterUpdate.characters.count == 0
        {
            UIView.animate(withDuration: 0.0, animations: {
                
                self.img_Send.image = UIImage(named:"send-grey")
                
                
            }, completion: nil)
            
            textView.resignFirstResponder()
        }
        
        self.kBehindViewBottom.constant = 0
        self.kTablebtm.constant = 0
        
    }
    
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        
        if text == "\n"
        {
             if self.dialog_Chat != nil {
            self.dialog_Chat.sendUserStoppedTyping()
                
            }
            
            UIView.animate(withDuration: 0.0, animations: {
                
                self.kBehindViewBottom.constant = 0
                self.kTablebtm.constant = 0
                
            }, completion: nil)
            
            textView.resignFirstResponder()
        }
        else{
            
            
            
            var txtAfterUpdate = textView.text.trimmingCharacters(in: .whitespaces)
            
            
            if txtAfterUpdate.characters.count <= 1
            {
                  if self.dialog_Chat != nil {
                self.dialog_Chat.sendUserStoppedTyping()
                    
                }
                self.img_Send.image = UIImage(named:"send-grey")
            }
            else{
                  if self.dialog_Chat != nil {
                self.dialog_Chat.sendUserIsTyping()
                }
            }
            
        }
        
        return true
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        
        
        self.lbl_PlaceHolder.isHidden = !textView.text.isEmpty
        
        timer.invalidate()
        counter = 0
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        
        
        if self.lbl_PlaceHolder.isHidden == false {
              if self.dialog_Chat != nil {
                self.dialog_Chat.sendUserStoppedTyping() }
            self.img_Send.image = UIImage(named:"send-grey")
            
            
        }
        else {
            
            
            self.img_Send.image = UIImage(named:"send_white")
            //  self.dialog_Chat.sendUserIsTyping()
            
        }
        
        guard let textView =  self.txtView_Msg.text else {
            
            return
            
        }
        
        let height =  self.heightForView(text: textView, font: self.txtView_Msg.font!, width: self.txtView_Msg.frame.size.width)
        
        if height >= 20 && height < 117  {
            
            self.kHeightBehindTxtView.constant = height + 25
            self.KtxtViewHeight.constant = height + 5
            
        }
        
        
        
    }
    
}

//MARK: - CLASS EXTENSIONS

extension ChatViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate,RSKImageCropViewControllerDelegate {
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        Global.macros.statusBar.backgroundColor = UIColor.white
        UIApplication.shared.statusBarStyle = .default
        DispatchQueue.main.async {
            Global.macros.statusBar.isHidden = false
            
        }
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
         if checkInternetConnection() {
        
        if image != nil {
            
            
            //                var imageCropVC : RSKImageCropViewController!
            //
            //                imageCropVC = RSKImageCropViewController(image: image!, cropMode: RSKImageCropMode.circle)
            //                imageCropVC.delegate = self
            //
            //                self.navigationController?.pushViewController(imageCropVC, animated: true)
            
            
            DispatchQueue.main.async {
                self.pleaseWait()
            }
            
            let imageData = UIImageJPEGRepresentation(image!, 0.1)
            // let imageData = croppedImage.jpeg(.lowest)
            
            QBChat.instance().connect(with: self.currentUser, completion: {(_ error: Error?) -> Void in
                let privateChatDialog: QBChatDialog? = self.dialog_Chat
                privateChatDialog?.sendUserIsTyping()
                
                privateChatDialog?.join(completionBlock: { (error) in
                    
                    QBRequest.tUploadFile(imageData!, fileName: "7date.jpeg", contentType: "image/jpeg", isPublic: true,
                                          successBlock: {(response: QBResponse!, uploadedBlob: QBCBlob!) in
                                            // Create and configure message
                                            let message: QBChatMessage = QBChatMessage()
                                            
                                            let uploadedFileID = uploadedBlob.uid
                                            let attachment: QBChatAttachment = QBChatAttachment()
                                            attachment.type = "image"
                                            attachment.id = uploadedFileID! as String
                                            attachment.url = uploadedBlob.privateUrl()
                                            
                                            message.attachments = [attachment]
                                            message.text = "Attachment image"
                                            
                                            let params = NSMutableDictionary()
                                            params["save_to_history"] = true
                                            message.customParameters = params
                                            //
                                            privateChatDialog?.send(message, completionBlock: {(_ error: Error?) -> Void in
                                                privateChatDialog?.sendUserStoppedTyping()
                                                
                                                
                                                
                                                DispatchQueue.main.async {
                                                    
                                                    self.clearAllNotice()
                                                }
                                                // self.retrieveMessages()
                                                self.createChatNotificationForGroupChatUpdate(dialog: privateChatDialog!,message:message )
                                                
                                            })
                                            
                                            
                                            
                                            
                    }, statusBlock: {(request: QBRequest?, status: QBRequestStatus?) in
                        
                    }, errorBlock: {(response: QBResponse!) in
                        
                        self.showAlert(Message: "Please try again", vc: self)
                    })
                })
            })
            
            self.navigationController?.dismiss(animated: true, completion: nil)
            
            
        }
            
        else{
            
            /*    let videoURL_forthumbnail = info[UIImagePickerControllerMediaURL] as? NSURL
             
             
             if let fileURL = info[UIImagePickerControllerMediaURL] as? NSURL {
             if let videoData = NSData(contentsOf: fileURL as URL) {
             print(videoData.length)
             videoDataCustom = videoData as Data
             
             }
             }
             
             DispatchQueue.main.async {
             self.pleaseWait()
             }
             
             
             do {
             //                                    let asset = AVURLAsset(url: videoURL_forthumbnail as! URL , options: nil)
             //                                    let imgGenerator = AVAssetImageGenerator(asset: asset)
             //                                    imgGenerator.appliesPreferredTrackTransform = true
             //                                    let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(0, 1), actualTime: nil)
             //                                    let thumbnail = UIImage(cgImage: cgImage)
             //  imgView.image = thumbnail
             
             QBChat.instance().connect(with: self.currentUser, completion: {(_ error: Error?) -> Void in
             let privateChatDialog: QBChatDialog? = self.dialog_Chat
             privateChatDialog?.sendUserIsTyping()
             
             privateChatDialog?.join(completionBlock: { (error) in
             
             QBRequest.tUploadFile( self.videoDataCustom as Data, fileName: "video", contentType: "video/mp4", isPublic: true,
             successBlock: {(response: QBResponse!, uploadedBlob: QBCBlob!) in
             // Create and configure message
             
             
             let message: QBChatMessage = QBChatMessage()
             let uploadedFileID = uploadedBlob.uid
             let attachment: QBChatAttachment = QBChatAttachment()
             attachment.type = "video"
             attachment.id = uploadedFileID! as String
             attachment.url = uploadedBlob.privateUrl()
             
             message.attachments = [attachment]
             message.text = "Attachment video"
             // Send message
             
             let params = NSMutableDictionary()
             params["save_to_history"] = true
             message.customParameters = params
             //
             privateChatDialog?.send(message, completionBlock: {(_ error: Error?) -> Void in
             
             picker.dismiss(animated: true, completion: nil)
             
             privateChatDialog?.sendUserStoppedTyping()
             
             DispatchQueue.main.async {
             self.clearAllNotice()
             }
             //  self.retrieveMessages()
             self.createChatNotificationForGroupChatUpdate(dialog: privateChatDialog!,message:message )
             
             })
             
             
             
             
             }, statusBlock: {(request: QBRequest?, status: QBRequestStatus?) in
             
             }, errorBlock: {(response: QBResponse!) in
             
             self.showAlert(Message: "Please try again", vc: self)
             // print(response.error!.reasons!)
             })
             
             
             })
             })
             
             
             
             } catch let error {
             print("*** Error generating thumbnail: \(error.localizedDescription)")
             }
             */
            
            
            
            let tempImage = info[UIImagePickerControllerMediaURL] as! URL!
            let pathString = tempImage?.relativePath
            
            
            if (pathString != "")
            {
                DispatchQueue.main.async {
                    
                    //   let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "Upload_Video") as! UploadViewController
                    
                    bool_VideoFromGallary = true
                    bool_PlayFromProfile = false
                    let url_video=URL(fileURLWithPath: pathString! as String)
                    
                    var path_String = pathString! as NSString
                    let asset: AVAsset = AVAsset(url: url_video)
                    
                    var durationInSeconds: TimeInterval = 0.0
                    durationInSeconds = CMTimeGetSeconds(asset.duration)
                    
//                    if durationInSeconds <= 10.0 {
//                        DispatchQueue.main.async {
//                            // bool_VideoIsOfShortLength = true
//                            picker.dismiss(animated: true, completion: nil)
//                            self.showAlert(Message: "Please select video of minimum 10 seconds.", vc: self)
//
//                        }
//                        
//                    }
//                    else {
                    
                        let imageGenerator = AVAssetImageGenerator(asset: asset);
                        imageGenerator.appliesPreferredTrackTransform = true
                        let time = CMTimeMakeWithSeconds(0.0, 600)
                        
                        var actualTime : CMTime = CMTimeMake(0, 1)
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
                            //print("Myvideo\(url1)")
                            
                            
                            // let geturl = URL(fileURLWithPath: path_String as String)
                            
                            //   let weatherData:Data?=try! Data(contentsOf: url1)
                            
                            //print("The data is : \(weatherData!)")
                            
                            
                            DispatchQueue.main.async {
                                
                                let videodata:Data?=try! Data(contentsOf: url1)
                                let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "Upload_Video") as! UploadViewController
                                vc.videoPath = path_String as String
                                vc.video_urlProfile = url_video
                                bool_comingFromChat = true
                                _  =    picker.present(vc, animated: true, completion: nil)
                                
                                
                            }
                            
                        })
                 //   }
                    
                }
                
            }
            
            
        }
        
    }
    else{
    
            self.showAlert(Message: Global.macros.kInternetConnection, vc: self)
            

    }
        
        
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
        bool_SelectVideoFromGallary = false
    }
    
    func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
        _ =  self.navigationController?.popViewController(animated: true)
        
    }
    func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect) {
        
        //      let imageData = UIImagePNGRepresentation(croppedImage)
        //  let resultiamgedata = imageData!.base64EncodedData(options: NSData.Base64EncodingOptions.lineLength64Characters)
        //        self.str_profileImage = (NSString(data: resultiamgedata, encoding: String.Encoding.utf8.rawValue) as String?)!
        //        self.img_PlusIconProfile.isHidden = true
        //        self.imgView_Profile.image = croppedImage
        
        DispatchQueue.main.async {
            self.pleaseWait()
        }
        
        let imageData = UIImageJPEGRepresentation(croppedImage , 0.0)
        // let imageData = croppedImage.jpeg(.lowest)
        
        QBChat.instance().connect(with: currentUser, completion: {(_ error: Error?) -> Void in
            let privateChatDialog: QBChatDialog? = self.dialog_Chat
            privateChatDialog?.sendUserIsTyping()
            
            privateChatDialog?.join(completionBlock: { (error) in
                
                QBRequest.tUploadFile(imageData!, fileName: "7date.jpeg", contentType: "image/jpeg", isPublic: false,
                                      successBlock: {(response: QBResponse!, uploadedBlob: QBCBlob!) in
                                        // Create and configure message
                                        let message: QBChatMessage = QBChatMessage()
                                        
                                        let uploadedFileID = uploadedBlob.uid
                                        let attachment: QBChatAttachment = QBChatAttachment()
                                        attachment.type = "image"
                                        attachment.id = uploadedFileID! as String
                                        attachment.url = uploadedBlob.privateUrl()
                                        
                                        message.attachments = [attachment]
                                        message.text = "Attachment image"
                                        // Send message
                                        
                                        //
                                        let params = NSMutableDictionary()
                                        params["save_to_history"] = true
                                        message.customParameters = params
                                        //
                                        privateChatDialog?.send(message, completionBlock: {(_ error: Error?) -> Void in
                                            //  self.sendPushNotification(rawString, userID: dialog_Chat["occupantIDs"][1])
                                            privateChatDialog?.sendUserStoppedTyping()
                                            
                                            DispatchQueue.main.async {
                                                self.clearAllNotice()
                                            }
                                         //   self.retrieveMessages()
                                            
                                        })
                                        
                                        
                                        
                                        
                }, statusBlock: {(request: QBRequest?, status: QBRequestStatus?) in
                    
                }, errorBlock: {(response: QBResponse!) in
                    
                    self.showAlert(Message: "Please try again", vc: self)
                    // print(response.error!.reasons!)
                })
            })
        })
        _ = self.navigationController?.popViewController(animated: true)
        
        
    }
    
    
}
extension ChatViewController : AVPlayerViewControllerDelegate {
    
    
    
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        
        
        DispatchQueue.main.async {
            Global.macros.statusBar.isHidden = false
            
        }
        
        
    }
    override func motionCancelled(_ motion: UIEventSubtype, with event: UIEvent?) {
        
        DispatchQueue.main.async {
            Global.macros.statusBar.isHidden = false
            
        }
        
    }
    
    
    
}
extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpeg(_ quality: JPEGQuality) -> Data? {
        return UIImageJPEGRepresentation(self, quality.rawValue)
    }
}



