//
//  ShadowOptionVC.swift
//  Shadow
//  Created by Sahil Arora on 5/31/17.
//  Copyright © 2017 Atinderjit Kaur. All rights reserved.
//

import UIKit

class ShadowOptionVC: UIViewController {

    @IBOutlet var btn_Next:     UIButton!
    @IBOutlet var imageView_No: UIImageView!
    @IBOutlet var imageView_Yes:UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.async{
            
            let user : QBUUser = QBUUser()
            user.login = str_email
            user.password = "mind@123"
            user.fullName = username
            
            QBRequest.signUp(user, successBlock: {(response, user) in
                SavedPreferences.setValue(user?.id, forKey: "qb_UserId")
                
                print("Successful signup")
                
                QBRequest.logIn(withUserLogin: str_email, password: "mind@123", successBlock: { (response, user) in
                    SavedPreferences.setValue(user?.id, forKey: "qb_UserId")
                    print(user?.id ?? "")
                    print("Successful login")
                    QBChat.instance().connect(with: user!, completion: { (error) in
                        print("Successful connected")
                        SavedPreferences.setValue(user?.id, forKey: "qb_UserId")

                        let deviceIdentifier: String = UIDevice.current.identifierForVendor!.uuidString
                        let subscription: QBMSubscription! = QBMSubscription()
                        
                        subscription.notificationChannel = QBMNotificationChannel.APNS
                        subscription.deviceUDID = deviceIdentifier
                        subscription.deviceToken = data_deviceToken
                        QBRequest.createSubscription(subscription, successBlock: { (response: QBResponse!, objects: [QBMSubscription]?) -> Void in
                            
                            print("success note")
                            
                        }) { (response: QBResponse!) -> Void in
                            
                            print(response.error?.description)
                            
                            
                        }
                    })
                    
                    
                }, errorBlock: { (response) in
                    print("login")
                    print("error: \(response.error)")
                })
                
            }, errorBlock: {(response) in
                print("signup")
                print("error: \(response.error)")
            })
            
           
            
        }
        
     // self.navigationItem.hidesBackButton = true //Hide default back button
        let myBackButton:UIButton = UIButton()
        myBackButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        myBackButton.setImage(UIImage(named:"back-new"), for: UIControlState())
        myBackButton.addTarget(self, action: #selector(self.PopToRootViewController), for: UIControlEvents.touchUpInside)
        let leftBackBarButton:UIBarButtonItem = UIBarButtonItem(customView: myBackButton)
        self.navigationItem.leftBarButtonItem = leftBackBarButton

        
        self.SetButtonCustomAttributesPurple(btn_Next)
        allowShadow = true
        
        
        imageView_Yes.image = UIImage(named:"purple")
        imageView_No.image = UIImage(named:"blank")
        
        
        


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//MARK:- Button Actions
    
    @IBAction func Action_SelectShadowOptions(_ sender: UIButton) {
        
        if sender.tag == 0
        {
           imageView_Yes.image = UIImage(named:"purple")
            imageView_No.image = UIImage(named:"blank")
            allowShadow = true


        }
        else {
            imageView_Yes.image = UIImage(named:"blank")
            imageView_No.image = UIImage(named:"purple")
            allowShadow = false
        }
        
    }
    
    @IBAction func Action_Next(_ sender: UIButton) {
        
        DispatchQueue.main.async{
            self.pleaseWait()
        }

        username = firstName + " " + lastName
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {

        if self.checkInternetConnection()
        {
            
            let dict = NSMutableDictionary()
            dict.setValue(str_email, forKey: Global.macros.kEmail)
            dict.setValue(registeringAs, forKey: "role")
            dict.setValue(password, forKey: Global.macros.kPassword)
            dict.setValue(false, forKey: "phoneOtp")
            dict.setValue(username, forKey: Global.macros.kUserName)
            dict.setValue(firstName, forKey: Global.macros.kFirstName)
            dict.setValue(lastName, forKey: Global.macros.kLastName)
            dict.setValue(countryCode, forKey: "countryCode")
            dict.setValue(schoolName, forKey: "schoolName")
            dict.setValue(Location, forKey: "location")
            dict.setValue(companyName, forKey: "companyName")
            dict.setValue(allowShadow, forKey: "otherUsersShadowYou")
            dict.setValue(true, forKey: "emailOtp")
            dict.setValue("1.1", forKey: Global.macros.kAppVersion)
            dict.setValue("1.1.1", forKey: Global.macros.kAppBuildNumber)
            dict.setValue(latitude, forKey: Global.macros.klatitude)
            dict.setValue(longitude, forKey: Global.macros.klongitude) //qbId
            dict.setValue(SavedPreferences.value(forKey: "qb_UserId"), forKey: "qbId")
            print(dict)
            
            if self.checkInternetConnection() {
                
                    AuthenticationAPI.sharedInstance.Register(dict: dict, completion: {(response) in
                        print(response)
                        switch response {
                        case 200:
                            
                            DispatchQueue.main.async {
                                self.performSegue(withIdentifier: "EmailToOTP", sender: self)
                            }
                            
                        case 226:
                            DispatchQueue.main.async {
                                self.showAlert(Message: "Email already exist.", vc: self)
                            }
                        default:
                            break
                        }
                        self.clearAllNotice()
                        
                    }, errorBlock: {(err) in
                        
                        DispatchQueue.main.async {
                            
                            self.clearAllNotice()
                            self.showAlert(Message: Global.macros.kError, vc: self)
                            
                        }
                    })
                
            }
            else{
                self.showAlert(Message: Global.macros.kInternetConnection, vc: self)
            }
            
         //  self.CreateAlert()
        }
        else
        {
            self.showAlert(Message: Global.macros.kInternetConnection, vc: self)

        }
            
            
            })
    }
    

}
