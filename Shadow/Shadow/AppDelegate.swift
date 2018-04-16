//  AppDelegate.swift
//  Shadow
//  Created by Atinderjit Kaur on 29/05/17.
//  Copyright © 2017 Atinderjit Kaur. All rights reserved.

import UIKit
import GooglePlaces
import GooglePlacePicker
import AVFoundation
import UserNotifications
import Quickblox

// Global Objects
var deviceTokenString =                     String()       // Device token string used in login and sign ups
public var DeviceType:                      String = "0"
public var bool_Backntn :                   Bool = false
public var bool_PushComingFromAppDelegate : Bool = false
public var bool_FirstTimeLogin :            Bool = false
public var data_deviceToken :               Data?
public var str_Confirmation:                String = ""   
public var myCurrentLat :                   Double?
public var myCurrentLong :                  Double?
public var bool_notificationFromChat :      Bool = false
public var bool_OpenProfile :               Bool = false
var dict_notificationData =                 NSDictionary()

let kQBApplicationID:                       UInt = 64034
let kQBAuthKey =    "suAFvNejYVn22LE"
let kQBAuthSecret = "68vq9CMWcbXqt5X"
let kQBAccountKey = "GkY8DE3BhuqE8kKVyhLF"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,CLLocationManagerDelegate {
    
    var window: UIWindow?
    var locManager = CLLocationManager()
    var currentLocation = CLLocation()
    var dialog_Chat : QBChatDialog!

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Set QuickBlox credentials (You must create application in admin.quickblox.com).
        
        bool_FirstTimeLogin = true
        QBSettings.setApplicationID(kQBApplicationID)
        QBSettings.setAuthKey(kQBAuthKey)
        QBSettings.setAuthSecret(kQBAuthSecret)
        QBSettings.setAccountKey(kQBAccountKey)
        
        // enabling carbons for chat
        QBSettings.setCarbonsEnabled(true)
        
        // Enables Quickblox REST API calls debug console output.
        QBSettings.setLogLevel(QBLogLevel.nothing)
        
        // Enables detailed XMPP logging in console output.
        QBSettings.enableXMPPLogging()
        
        //Code for push notifications
        application.applicationIconBadgeNumber = 1

        let settings = UIUserNotificationSettings(types: [.alert,.badge,.sound], categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()

        Global.macros.statusBar.backgroundColor = UIColor.white
        UIApplication.shared.statusBarStyle = .default

        
        //Sleep for splash
        TestFairy.begin("2813e5e8d4b5b274cbdebb5dfc2f013909665937")
        Thread.sleep(forTimeInterval: 3.0)
        
      //  sleep(UInt32(2.0))
        
        GMSServices.provideAPIKey("AIzaSyCywl2nqZ6x_NOMRNSGufIF7RKVe-pgj2w")
        GMSPlacesClient.provideAPIKey("AIzaSyCywl2nqZ6x_NOMRNSGufIF7RKVe-pgj2w")
        
       //My current Location
        locManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locManager.delegate = self
            locManager.desiredAccuracy = kCLLocationAccuracyBest
            locManager.startUpdatingLocation()
        }
        
      
        
        if SavedPreferences.value(forKey: "userId")as? NSNumber != nil
        {

           // DispatchQueue.main.async {
            let remoteNotif = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? NSDictionary
                
            if remoteNotif != nil {
                
                
                let dict = remoteNotif! as NSDictionary
                if let str = (dict.value(forKey: "jsonResponse") as? String) {
                let diccct = self.convertToDictionary(text: str)
                dict_notificationData = diccct?["notificationResponse"] as! NSDictionary

                 self.pushTONext()
                    
                }
                
                else {
                    
                    if  dict.value(forKey: "dialog_id") != nil && "\(String(describing: dict.value(forKey: "dialog_id")))" != "" {
   
                    dict_notificationData = dict
                    self.pushTONext()
                    }
                    
                    else if dict.value(forKey: "chatDialogId") != nil && "\(String(describing: dict.value(forKey: "chatDialogId")))" != "" {
                        
                        dict_notificationData = dict
                        self.pushTONext()
                    }

                }
               
            }
            else{
                
               
             // DispatchQueue.main.async {
                let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "SWRevealViewController") as!  SWRevealViewController
                Global.macros.kAppDelegate.window?.rootViewController = vc
             // }
            }
                
           // }
            
        }
        else
        {
            // DispatchQueue.main.async {
            let alert = UIAlertController(title: "Shadow", message: "fdfdfdsfsd", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            
            alert.view.backgroundColor = UIColor.white
            alert.view.tintColor = UIColor.black
                
              //  self.window?.rootViewController?.present(alert, animated: true, completion: nil)
                let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "Login")
                Global.macros.kAppDelegate.window?.rootViewController = vc
            //}
        }
        
   
        if application.applicationState == .active{
            
            let audio_Session = AVAudioSession.sharedInstance()
                    if audio_Session.isOtherAudioPlaying{
            
                        _ = try? audio_Session.setCategory(AVAudioSessionCategoryAmbient, with: AVAudioSessionCategoryOptions.mixWithOthers)
                        
                    }
            
        }
        
        
        return true
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        
        let audio_Session = AVAudioSession.sharedInstance()
        if audio_Session.isOtherAudioPlaying{
            
            _ = try? audio_Session.setCategory(AVAudioSessionCategoryAmbient, with: AVAudioSessionCategoryOptions.mixWithOthers)
            
        }
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
        let audio_Session = AVAudioSession.sharedInstance()
        if audio_Session.isOtherAudioPlaying{
            
            _ = try? audio_Session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: AVAudioSessionCategoryOptions.mixWithOthers)
            
        }
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
                let audio_Session = AVAudioSession.sharedInstance()
                if audio_Session.isOtherAudioPlaying{
        
                    _ = try? audio_Session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: AVAudioSessionCategoryOptions.mixWithOthers)
                    
                }

        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
        application.applicationIconBadgeNumber = 0
        
        if SavedPreferences.value(forKey: "email") as? String != nil {
            
        QBRequest.logIn(withUserLogin: (SavedPreferences.value(forKey: "email") as? String)!, password: "mind@123", successBlock: { (response, user) in
            
            print("Successful login app")
            
            SavedPreferences.setValue(user?.id, forKey: "qb_UserId")
            
            
            QBChat.instance().connect(with: user!, completion: { (error) in
                print("Successful connected app")
            })
            
            
        }, errorBlock: { (response) in
            print("login")
            print("error: \(String(describing: response.error))")
        })
            
        }
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
        let audio_Session = AVAudioSession.sharedInstance()
        if audio_Session.isOtherAudioPlaying{
            
            _ = try? audio_Session.setCategory(AVAudioSessionCategoryAmbient, with: AVAudioSessionCategoryOptions.mixWithOthers)
            
        }
        
        
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        // print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        myCurrentLat = locValue.latitude
        myCurrentLong = locValue.longitude
        
    }
    
    //MARK: Push notifications delegates
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data){
     
        deviceTokenString = ""
        
        for i in 0..<deviceToken.count{
            
            deviceTokenString = deviceTokenString + String(format: "%02.2hhx", arguments: [deviceToken[i]])
        }
        
        print("Device Token is \(deviceTokenString)")
     ///   UIPasteboard.general.string = deviceTokenString
        
        data_deviceToken = deviceToken
        let deviceIdentifier: String = UIDevice.current.identifierForVendor!.uuidString
        let subscription: QBMSubscription! = QBMSubscription()
        
        subscription.notificationChannel = QBMNotificationChannel.APNS
        subscription.deviceUDID = deviceIdentifier
        subscription.deviceToken = deviceToken
        QBRequest.createSubscription(subscription, successBlock: { (response: QBResponse!, objects: [QBMSubscription]?) -> Void in
           
            print("success note")
            
        }) { (response: QBResponse!) -> Void in
           
            print(response.error?.description)
            

        }
   
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        
        Global.macros.statusBar.isHidden = false
        let dict = userInfo as NSDictionary
        
        if let str = (dict.value(forKey: "jsonResponse") as? String) {
            let diccct = self.convertToDictionary(text: str)
            dict_notificationData = diccct?["notificationResponse"] as! NSDictionary
            
            if application.applicationState == .active {
        
                
                let details = dict.value(forKey: "aps") as! NSDictionary
                
                let strdata = details.value(forKey: "alert") as? String
                if  !(strdata?.contains("Verification"))!   {  // To avoid double notification on update the profile.
            Notificationview.sharedInstance.createNotificationview(win: self.window!)
              Notificationview.sharedInstance.showNotificationView(userInfo as NSDictionary)
             
                }
            }
            else{
               self.pushTONext()
            }

        } else {
            
            
            if application.applicationState != .active {
               
                
                if dict.value(forKey: "aps") != nil {

                    let  localdic = dict.value(forKey: "aps") as! NSDictionary
                    
                    if localdic.value(forKey: "alert") != nil && "\(String(describing: localdic.value(forKey: "alert")))" != "" {
                        
                let str = "\(String(describing: localdic.value(forKey: "alert")!))"
                        
                 if !str.contains("new message") {
                
                if dict.value(forKey: "dialog_id") != nil && "\(String(describing: dict.value(forKey: "dialog_id")))" != "" {
                  
                dict_notificationData = dict
                self.pushTONext()
                    
                } //chatDialogId
                
                else  if dict.value(forKey: "chatDialogId") != nil && "\(String(describing: dict.value(forKey: "chatDialogId")))" != "" {
                    
                    dict_notificationData = dict
                    self.pushTONext()
                    
                }
                        
                    }
                        
               
                        
                
                }
            }
                
                
            }
            else{
               // UIPasteboard.general.string = "\(bool_notificationFromChat)"
                
                if bool_OpenProfile == true {
                    
                    
                 if (SavedPreferences.value(forKey: "role") as? String) == "USER" {
                    let nc = NotificationCenter.default
                    nc.post(name: Notification.Name("ProfileVCOpened"), object: nil)
                    
                    }
                    
                 else{
                    
                    let nc = NotificationCenter.default
                    nc.post(name: Notification.Name("ProfileVCOpened"), object: nil)
                    
                    }
                
                }
                
                
                
                
               if bool_notificationFromChat == false {
                
               if dict.value(forKey: "aps") != nil {
                    
                 let  localdic = dict.value(forKey: "aps") as! NSDictionary
                
                if localdic.value(forKey: "alert") != nil && "\(String(describing: localdic.value(forKey: "alert")))" != "" {
                    
                    let str = "\(String(describing: localdic.value(forKey: "alert")!))"
                    
                    if !str.contains("new message") {
                        
                     //   UIPasteboard.general.string = str
                        dict_notificationData = dict
                        Notificationview.sharedInstance.createNotificationview(win: self.window!)
                        Notificationview.sharedInstance.showNotificationView(userInfo as NSDictionary)
                    }
                    
                }
                
              }
            }
            
            }
          
        }
    }
    
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        deviceTokenString = "b43c88327277116c7eb398395a96907e744d04ebb288efc970658b63498014ec"
        
    }
    
    func pushTONext() { //requestId
        
        UINavigationBar.appearance().barTintColor = UIColor.white
        UINavigationBar.appearance().tintColor = UIColor.black
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.black]
        UINavigationBar.appearance().isTranslucent = false

        
        bool_PushComingFromAppDelegate = true
       // let navigationController: SWRevealViewController? = (window?.rootViewController as? SWRevealViewController)
        
        
            let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "SWRevealViewController") as!  SWRevealViewController
            Global.macros.kAppDelegate.window?.rootViewController = vc
        
            
        
        
    }
    
}

