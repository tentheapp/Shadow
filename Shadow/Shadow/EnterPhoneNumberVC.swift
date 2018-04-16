//
//  EnterPhoneNumberVC.swift
//  Shadow
//
//  Created by Sahil Arora on 5/31/17.
//  Copyright © 2017 Atinderjit Kaur. All rights reserved.


import UIKit
import CoreLocation

class EnterPhoneNumberVC: UIViewController {
    
    @IBOutlet var view_PickerVIew:       UIView!
    @IBOutlet var textfield_CountryCode: UITextField!
    @IBOutlet var pickerView:            UIPickerView!
    @IBOutlet var btn_CountryCode:       UIButton!
    @IBOutlet var textfield_Phone:       UITextField!
    @IBOutlet var btn_Next:              UIButton!
    
    fileprivate var countryarr:         NSArray = NSArray()
    fileprivate var Code:               String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setting country code of current country
        let countryLocale : NSLocale =  NSLocale.current as NSLocale
        let country_Code  = countryLocale.object(forKey: NSLocale.Key.countryCode)
        let country = countryLocale.displayName(forKey: NSLocale.Key.countryCode, value: country_Code!)
        
        countryarr = Global.sharedInstance.countryCode()
        let predicate = NSPredicate(format:"name = %@", country!)
        let mArr = countryarr.filtered(using: predicate)
      
        if(mArr.count > 0) {
            
            let dictionary = mArr[0] as! NSDictionary
            let code = "+" + (dictionary["code"]as? String)!
            btn_CountryCode.setTitle(code, for: .normal)
            countryCode = code
            
        }
        
        textfield_Phone.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControlEvents.editingChanged)
    }
    
    
    func textFieldDidChange(textField:UITextField)
    {
        print(textField.text!)
        if  textfield_Phone.text != ""  && self.isPhoneNumberLength(textfield_Phone.text!)
       {
            SetButtonCustomAttributesPurple(btn_Next)
        }
        else {
            
            SetButtonCustomAttributes(btn_Next)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
        if str_Confirmation == "true" {
            self.navigationItem.hidesBackButton = true
           
            
        }
        else {
            
            let myBackButton:UIButton = UIButton()
            myBackButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
            myBackButton.setImage(UIImage(named:"back-new"), for: UIControlState())
            myBackButton.addTarget(self, action: #selector(self.root_ViewController), for: UIControlEvents.touchUpInside)
            let leftBackBarButton:UIBarButtonItem = UIBarButtonItem(customView: myBackButton)
            self.navigationItem.leftBarButtonItem = leftBackBarButton
            
            
        }

        self.SetButtonCustomAttributes(btn_Next)
        
        Validations()
    }
    
    func root_ViewController() {
        DispatchQueue.main.async {
            self.setRootView("Login")
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        pickerView.isHidden = true
    }
    //Validations
    fileprivate func Validations()
    {
        if textfield_Phone.text != "" && textfield_CountryCode.text != ""
        {
            btn_Next.isUserInteractionEnabled = true
        }
        else
        {
            btn_Next.isUserInteractionEnabled = false
        }
    }
    
    func Api_SignUp() {
        
        if textfield_Phone.text != ""
        {
        bool_fromMobile = false
        bool_fromVerificationMobile = false
        if bool_NotVerified == false && str_Confirmation == "" {
            
            
            let dict = NSMutableDictionary()
            
            dict.setValue(textfield_Phone.text, forKey: "mobileNumber")
            dict.setValue(registeringAs, forKey: "role")
            dict.setValue(password, forKey: Global.macros.kPassword)
            dict.setValue(true, forKey: "phoneOtp")
            dict.setValue(username, forKey: Global.macros.kUserName)
            dict.setValue(firstName, forKey: Global.macros.kFirstName)
            dict.setValue(lastName, forKey: Global.macros.kLastName)
            dict.setValue(countryCode, forKey: "countryCode")
            dict.setValue(schoolName, forKey: "schoolName")
            dict.setValue(Location, forKey: "location")
            dict.setValue(companyName, forKey: "companyName")
            dict.setValue(allowShadow, forKey: "otherUsersShadowYou")
            dict.setValue(false, forKey: "emailOtp")
            dict.setValue("1.1", forKey: Global.macros.kAppVersion)
            dict.setValue("1.1.1", forKey: Global.macros.kAppBuildNumber)
            dict.setValue(latitude, forKey: Global.macros.klatitude)
            dict.setValue(longitude, forKey: Global.macros.klongitude)
            
            print(dict)
            if self.checkInternetConnection()
            {
                
                if self.isPhoneNumberLength(textfield_Phone.text!)
                {
                    
                    DispatchQueue.main.async {
                        self.pleaseWait()
                    }
                    
                    AuthenticationAPI.sharedInstance.Register(dict: dict, completion: {(response) in
                        print(response)
                        
                        switch response {
                            
                        case 200:
                            DispatchQueue.main.async {
                                
                                self.performSegue(withIdentifier: "PhoneToOTP", sender: self)
                                
                            }
                            
                        case 226:
                            DispatchQueue.main.async {
                                self.showAlert(Message: "Phone Number already exist.", vc: self)
                                
                                
                            }
                            
                        case 500:
                            DispatchQueue.main.async {
                                self.showAlert(Message: Global.macros.kError, vc: self)
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
                else
                {
                    self.showAlert(Message: Global.macros.KInvalidPhoneNumber, vc: self)
                    
                }
         
            }
            else
            {
                self.showAlert(Message: Global.macros.kInternetConnection, vc: self)
                
            }
            
        }
          
        else if str_Confirmation == "true" {//editProfile
            let dict = NSMutableDictionary()
             dict.setValue(SavedPreferences.value(forKey: Global.macros.kUserId), forKey: Global.macros.kUserId)
            dict.setValue(textfield_Phone.text, forKey: "mobileNumber")
            dict.setValue(countryCode, forKey: "countryCode")
            dict.setValue("1.1", forKey: Global.macros.kAppVersion)
            dict.setValue("1.1.1", forKey: Global.macros.kAppBuildNumber)
            
            print(dict)
            if self.checkInternetConnection(){
                if self.isPhoneNumberLength(textfield_Phone.text!){
                    DispatchQueue.main.async{
                        self.pleaseWait()
                    }
                    
                    AuthenticationAPI.sharedInstance.editProfile(dict: dict, completion: {(response) in
                        print(response)
                        switch response {
                        case 200:
                            DispatchQueue.main.async {
                                SavedPreferences.set("yes", forKey: "user_verified")

                      //      email_to_reveal
                                self.navigationController?.navigationBar.isHidden = true
                                self.performSegue(withIdentifier: "phone_present_reveal", sender: self)

                            }
                            
                        case 226:
                            DispatchQueue.main.async {
                                self.showAlert(Message: "Phone Number already exist.", vc: self)
                            }
                            
                        case 500:
                            DispatchQueue.main.async {
                                self.showAlert(Message: Global.macros.kError, vc: self)
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
                    self.showAlert(Message: Global.macros.KInvalidEmail, vc: self)
                }
            }
            else{
                self.showAlert(Message: Global.macros.kInternetConnection, vc: self)
            }
            
            
        }
            
            
        else {
            
            
            let dict = NSMutableDictionary()
            dict.setValue(textfield_Phone.text, forKey: Global.macros.kMobileNumber)
            dict.setValue(countryCode, forKey: Global.macros.kCountryCode)
            
            
            if self.checkInternetConnection()
            {
                if self.isPhoneNumberLength(textfield_Phone.text!)
                {

                DispatchQueue.main.async {
                    self.pleaseWait()
                }
                AuthenticationAPI.sharedInstance.ResendOtpPhone(dict: dict, completion: {(response) in
                    
                    switch response.0{
                        
                    case 200:
                        
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "PhoneToOTP", sender: self)
                            
                            
                        }
                        
                    case 500:
                        DispatchQueue.main.async {
                            self.showAlert(Message: Global.macros.kError, vc: self)
                        }
                        
                    case 226:
                        DispatchQueue.main.async {
                            self.showAlert(Message: Global.macros.kError, vc: self)
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
            else
            {
                self.showAlert(Message: Global.macros.KInvalidPhoneNumber, vc: self)
                
            }
            }
            else{
                self.showAlert(Message: Global.macros.kInternetConnection, vc: self)
 
            }
            
        }
        }
        else {
            
            self.showAlert(Message: "Please enter your phonenumber.", vc: self)

        }
        
    }
    
    
    @IBAction func Action_SelectCountryCode(_ sender: UIButton) {
        
        textfield_Phone.resignFirstResponder()
        view_PickerVIew.isHidden = false
        Code = "+" +  (((countryarr[0] as! NSDictionary).value(forKey: "code")as? String)!).replacingOccurrences(of: "-", with: "")
        btn_CountryCode.setTitle("", for: .normal)

        btn_CountryCode.setTitle(Code, for: .normal)

        
    }
    @IBAction func Action_Next(_ sender: UIButton) {
        
        if self.checkInternetConnection()
        {
            
            if self.isPhoneNumberLength(textfield_Phone.text!)
            {
                Api_SignUp()
                // self.performSegue(withIdentifier: "PhoneToOTP", sender: self)
            }
            else
            {
                self.showAlert(Message: Global.macros.KInvalidPhoneNumber, vc: self)
                
            }
            
        }
        else
        {
            self.showAlert(Message: Global.macros.kInternetConnection, vc: self)
            
        }
        
        
    }
    @IBAction func Action_CancelPickerView(_ sender: UIButton) {
        
        view_PickerVIew.isHidden = true
        
    }
    @IBAction func Action_DonePickerView(_ sender: UIButton) {
        
        view_PickerVIew.isHidden = true
        textfield_Phone.resignFirstResponder()
        btn_CountryCode.setTitle(Code, for: .normal)
        countryCode = Code! as String
        
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "PhoneToOTP"
        {
            let vc =  segue.destination as! EnterOtpVC
            vc.otpRecievedOn = "phone"
            vc.country_Code = countryCode
            vc.Phonenumber = textfield_Phone.text
            
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension EnterPhoneNumberVC:UIPickerViewDelegate,UIPickerViewDataSource{
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        
        return countryarr.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let str = (countryarr[row] as! NSDictionary).value(forKey: "name")as! String
        let codeStr = "+" +  (((countryarr[row] as! NSDictionary).value(forKey: "code")as? String)!).replacingOccurrences(of: "-", with: "")
        
        return codeStr + ", " + str
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
        Code = "+" +  (((countryarr[row] as! NSDictionary).value(forKey: "code")as? String)!).replacingOccurrences(of: "-", with: "")
        btn_CountryCode.setTitle(Code, for: .normal)

        
    }
}
extension EnterPhoneNumberVC:UITextFieldDelegate
{
  
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textfield_Phone.resignFirstResponder()
        // Validation()
        return true
    }
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
      //  textField.text?.capitalizeFirstLetter()
        
        
        
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

            return string.length <= 12
        }
        else{
            btn_Next.isUserInteractionEnabled = false
            return string.length <= 12
            
        }
      }
 
}

