//
//  EnterOtpVC.swift
//  Shadow
//
//  Created by Sahil Arora on 5/31/17.
//  Copyright © 2017 Atinderjit Kaur. All rights reserved.
//

import UIKit
import AVFoundation
import GooglePlaces
import GooglePlacePicker


class EnterOtpVC: UIViewController ,CLLocationManagerDelegate {

    @IBOutlet var btn_ResendOtp:   UIButton!
    @IBOutlet var lbl_OtpSource:   UILabel!
    @IBOutlet var btn_Next:        UIButton!
    @IBOutlet var textfield_Otp:   UITextField!
    
    //Variables from segue from previous class
    public var otpRecievedOn:      String?
    public var emailId:            String?
    public var country_Code:       String?
    public var Phonenumber:        String?

    public var myCurrentLat :     Double?
    public var myCurrentLong :    Double?
    
    var locManager = CLLocationManager()
    var currentLocation = CLLocation()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.async {
            
           self.navigationController?.navigationBar.isHidden = false
            let myBackButton:UIButton = UIButton()
            myBackButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
            myBackButton.setImage(UIImage(named:"back-new"), for: UIControlState())
            myBackButton.addTarget(self, action: #selector(self.popVC), for: UIControlEvents.touchUpInside)
            let leftBackBarButton:UIBarButtonItem = UIBarButtonItem(customView: myBackButton)
            self.navigationItem.leftBarButtonItem = leftBackBarButton
            self.SetButtonCustomAttributes(self.btn_Next)
            self.SetButtonCustomAttributes(self.self.btn_ResendOtp)
            self.textfield_Otp.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControlEvents.editingChanged)
            
        }
        //  self.navigationItem.hidesBackButton = true //Hide default back button
       
    }
    
    func popVC() {
        
       // self.navigationController?.navigationBar.isHidden = true
        let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "Login")
        Global.macros.kAppDelegate.window?.rootViewController = vc
    }
    
   
  
    func textFieldDidChange(textField:UITextField)
    {
        if  textfield_Otp.text != ""  && (textfield_Otp.text?.characters.count)! >= 6 {
            SetButtonCustomAttributesPurple(btn_Next)
        }
        else {
            SetButtonCustomAttributes(btn_Next)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if otpRecievedOn == "email"
        {
          lbl_OtpSource.text = "Enter the code sent to your registered email."
        }
        else
        {
         lbl_OtpSource.text = "Enter the code sent to you via email."
        }
     Validation()
        
    }
    
    
    fileprivate func Validation()
    {
        
        if textfield_Otp.text != ""
        {
            btn_Next.isUserInteractionEnabled = true
            Action_Next(btn_Next)
        }
        else
        {
            btn_Next.isUserInteractionEnabled = false
        }
    }
    
    @IBAction func Action_ResendOtp(_ sender: UIButton) {
        
             
     //   if bool_fromMobile == true {

        
        let dict = NSMutableDictionary()
        dict.setValue(str_email, forKey: Global.macros.kEmail)
        
        if self.checkInternetConnection()
        {
            DispatchQueue.main.async {
            self.pleaseWait()
            }
            AuthenticationAPI.sharedInstance.ResendOtp(dict: dict, completion: {(response) in
                
                switch response.0 {
                    
                case 200:
                    
                    DispatchQueue.main.async {
                        self.showAlert(Message: Global.macros.kResentOtp, vc: self)

                    }
                    
                default:break
                    
                }
                self.clearAllNotice()
                
            }, errorBlock: {(err) in
                
                DispatchQueue.main.async {
                    
                    self.clearAllNotice()
                    self.showAlert(Message: Global.macros.kError, vc: self)

                    
                }
                
            })
            
        }

   
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func Action_Next(_ sender: UIButton) {
        
        if textfield_Otp.text != ""
        {
            if (textfield_Otp.text?.characters.count)! >= 6 {
     
     // if bool_fromMobile == true {
      if self.checkInternetConnection()
      {
        
        //API Response 
        let dict = NSMutableDictionary()
        dict.setValue(SavedPreferences.value(forKey: Global.macros.kUserId)as! NSNumber, forKey:Global.macros.kUserId )
        dict.setValue(textfield_Otp.text, forKey: "emailVerificationOtp")
        
        
        DispatchQueue.main.async {
            self.pleaseWait()
        }
        
        AuthenticationAPI.sharedInstance.VerifyOTP(dict: dict, completion: {(response) in
           
            switch response {
                
            case 200:
               
                DispatchQueue.main.async {
                   // self.showAlert(Message: "User registered successfully.", vc: self)
                   self.textfield_Otp.resignFirstResponder()
                    
                    if str_OtpComingFromSignUp == "true" { // Login service
                      
                        str_OtpComingFromSignUp = ""
                        SavedPreferences.set("yes", forKey: "user_verified")
                      
                        
                        DispatchQueue.main.async
                            {
                                
                                let TitleString = NSAttributedString(string: "Shadow", attributes: [
                                    NSFontAttributeName : UIFont.systemFont(ofSize: 18),
                                    NSForegroundColorAttributeName : Global.macros.themeColor_pink
                                    ])
                                let MessageString = NSAttributedString(string: "Your account is now verified, please login to the application.", attributes: [
                                    NSFontAttributeName : UIFont.systemFont(ofSize: 15),
                                    NSForegroundColorAttributeName : Global.macros.themeColor_pink
                                    ])
        
                                DispatchQueue.main.async {
                                    self.clearAllNotice()
                                    
                                    let alert = UIAlertController(title: "Shadow", message: "", preferredStyle: .alert)
                                    alert.addAction(UIAlertAction.init(title: "Ok", style: .default, handler: { (alert) in
                                        
                                        self.navigationController?.navigationBar.isHidden = true
                                        let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "Login")
                                        Global.macros.kAppDelegate.window?.rootViewController = vc
                                        
                                    }))
                                    
                                 //   alert.addAction(UIAlertAction.init(title: "Cancel", style: .default, handler:nil))
                                    alert.view.layer.cornerRadius = 10.0
                                    alert.view.clipsToBounds = true
                                    alert.view.backgroundColor = UIColor.white
                                    alert.view.tintColor = Global.macros.themeColor_pink
                                    
                                    alert.setValue(TitleString, forKey: "attributedTitle")
                                    alert.setValue(MessageString, forKey: "attributedMessage")
                                    self.present(alert, animated: true, completion: nil)
                                    
                                }
                                
                        }
                        
                        
                    }
                    else{
                        
                        SavedPreferences.set("yes", forKey: "user_verified")
                        self.navigationController?.navigationBar.isHidden = true
                        self.performSegue(withIdentifier: "email_present_reveal", sender: self)

                        
                    }
                    
                }
                
                
            case 400:
                DispatchQueue.main.async {
                    self.showAlert(Message: "Incorrect verification code.", vc: self)
                }
            case 401:
                DispatchQueue.main.async {
                    self.setRootView("Login")
                }

                
                break
                
            default:break
                
            }
            
            DispatchQueue.main.async {
                self.clearAllNotice()
            }
        }, errorBlock: {(err) in
            
            DispatchQueue.main.async {
                self.clearAllNotice()
                self.showAlert(Message: (err?.localizedDescription)!, vc: self)

                
            }
            
        }) }
        
        else
      {
        self.showAlert(Message: Global.macros.kInternetConnection, vc: self)

        } }
            else {
                self.showAlert(Message: "Otp must contain 6 characters.", vc: self)
            } }
        
        else
        {
            self.showAlert(Message: "Please enter otp.", vc: self)
            
        }
        
    }

}
extension EnterOtpVC:UITextFieldDelegate
{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textfield_Otp.text == "\n"
        {
            textfield_Otp.resignFirstResponder()
      //  Validation()
        
        }
        
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
    //    textField.text?.capitalizeFirstLetter()
        
        
        
        let string: NSString = (textField.text! as NSString).replacingCharacters(in: range, with: string) as NSString
        
        if (string.length > 0) {
            
            if string.hasPrefix(" ") {
                return false
            }
            else if string.hasSuffix(" ") {
                return false
            }
                
            else if string.contains(" ") {
                return false
            }
            btn_Next.isUserInteractionEnabled = true
            return string.length <= 6
        }
        else{
            btn_Next.isUserInteractionEnabled = false
            return string.length <= 6
            
        }
        
        
        
        return true
    }
 
    
}
