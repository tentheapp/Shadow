//
//  CompanyNameAndLocationVC.swift
//  Shadow
//
//  Created by Sahil Arora on 5/31/17.
//  Copyright © 2017 Atinderjit Kaur. All rights reserved.
//

import UIKit
import CoreLocation
import GooglePlaces
import GooglePlacePicker


class CompanyNameAndLocationVC: UIViewController,GMSAutocompleteViewControllerDelegate {
    
    @IBOutlet var textfield_Location: UITextField!
    @IBOutlet var textfield_Name:     UITextField!
    @IBOutlet var btn_Next:           UIButton!
    
    var geocoder:CLGeocoder?

    
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
        self.SetButtonCustomAttributes(btn_Next)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
       

        add_padding(textfield: textfield_Name)
        add_padding(textfield: textfield_Location)
        
        Validation()
        
        textfield_Name.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControlEvents.editingChanged)
        
        textfield_Location.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControlEvents.editingChanged)
        
    }
    
    //MARK:- Functions
    func textFieldDidChange(textField:UITextField)
    {
        
        
        if textfield_Name.text != "" && (textfield_Name.text?.characters.count)! >= 6 && textfield_Location.text != "" && (textfield_Location.text?.characters.count)! >= 4 {
            
            SetButtonCustomAttributesPurple(btn_Next)
            
        }
        else {
            
            SetButtonCustomAttributes(btn_Next)
            
        }
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    fileprivate func Validation()
    {
        if textfield_Name.text != "" && textfield_Location.text != ""{
            
            btn_Next.isUserInteractionEnabled = true
            SetButtonCustomAttributesPurple(btn_Next)
        }
        else{
            btn_Next.isUserInteractionEnabled = false
        }
    }
    
    /**
     latlong function is used to get list of countries.
     :params: string-string that has the required text.
     :params: dispatchGroup- dispatch group that works until the user write .leave.
     */
    func latlong(string:String) {
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(string, completionHandler: {
            
            (placemark,error) -> Void in
            
            if (error != nil) {
                DispatchQueue.main.async {
                    self.textfield_Location.text = ""

                    print("Error" + (error?.localizedDescription)!)
                    self.showAlert(Message: "Invalid address.Can't find your location.", vc: self)
                }
               
               
            }
                
            else if (placemark?.count)! > 0 {
                let pl = (placemark?.last)! as CLPlacemark
                let numLat = NSNumber(value: (pl.location?.coordinate.latitude)! as Double)
                latitude = numLat.stringValue
                let numLong = NSNumber(value: (pl.location?.coordinate.longitude)! as Double)
                longitude = numLong.stringValue
                print("latitude:\(latitude) longitude:\(longitude)")
            }
                
            else{
                DispatchQueue.main.async {
                    self.textfield_Location.text = ""

                self.showAlert(Message: "Can't find your location.Try again later.", vc: self)
                }

            }
        })
        
    }
    
    func RegisterWithCompany() {
        
        username = firstName + " " + lastName
        
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
            dict.setValue(longitude, forKey: Global.macros.klongitude)
            dict.setValue(SavedPreferences.value(forKey: "qb_UserId"), forKey: "qbId")

            
            print(dict)
            if self.checkInternetConnection(){
//
//                DispatchQueue.main.async{
//                    self.pleaseWait()
//                }
                
                AuthenticationAPI.sharedInstance.Register(dict: dict, completion: {(response) in
                    print(response)
                    switch response {
                    case 200:
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "CompanyEmailToOTP", sender: self)
                        }
                        
                    case 226:
                        DispatchQueue.main.async {
                            self.showAlert(Message: "Email already exist.", vc: self)
                        }
                    default:
                        break
                    }
                      DispatchQueue.main.async{
                        self.clearAllNotice()}
                    
                }, errorBlock: {(err) in
                    
                    DispatchQueue.main.async {
                        self.clearAllNotice()
                        self.showAlert(Message: Global.macros.kError, vc: self)
                    }
                })
                
            }
            else{
                DispatchQueue.main.async {
                    self.clearAllNotice()
                }
                self.showAlert(Message: Global.macros.kInternetConnection, vc: self)
            }
            
            //  self.CreateAlert()
        }
        else
        {
            
            DispatchQueue.main.async {
                self.clearAllNotice()
            }
            self.showAlert(Message: Global.macros.kInternetConnection, vc: self)
            
        }
    }
    
    func CheckCompanyNameExist() {
        
         let trimmedString = textfield_Name.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let dict = NSMutableDictionary()
        dict.setValue(trimmedString, forKey: Global.macros.kcompanyName)
        
        //Loader
      
        AuthenticationAPI.sharedInstance.CheckAvailabilityOfCampanyname(dict: dict, completion: {(response) in
            
            
            switch response {
                
            case 226:
                DispatchQueue.main.async {
                    self.clearAllNotice()
                }
                self.showAlert(Message: "Company name already exist.", vc: self)
                
            case 404:
                
                        self.RegisterWithCompany()
                        
            default:
                break
                DispatchQueue.main.async {
                    self.clearAllNotice()
                }
            }
           
            
        }, errorBlock: {(err) in
            
            self.clearAllNotice()
            self.showAlert(Message: Global.macros.kError, vc: self)
            
            
        })
        
        
        
    }
    
   // MARK: - Delegate GMSAutocompleteViewController
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        print("Place name: \(place.name)")
        print("Place address: \(String(describing: place.formattedAddress))")
        print("Place attributions: \(String(describing: place.attributions))")
        if place.formattedAddress != nil && "\(String(describing: place.formattedAddress))" != "" {
            
            textfield_Location.text =  "\(String(describing: place.formattedAddress!))"
            
        }
        else{
            textfield_Location.text =  "\(place.name)"
            
            
        }
        
        latlong(string: "\(place.name)")
        dismiss(animated: true, completion: nil)
        
       
    }
    
    
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        //  handle the error.
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

    
    
    //MARK: - Button Actions
    @IBAction func Action_Next(_ sender: UIButton) {
        
        if self.checkInternetConnection()
        {
            if textfield_Name.text != ""  {
                
                  if (textfield_Name.text?.characters.count)! >= 6 {
                
                           if textfield_Location.text != "" {
                                
                        if (textfield_Location.text?.characters.count)! >= 4 {
                            
                            //Check address is valid or not
                            let trimmedString = textfield_Name.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                            companyName = trimmedString
                            Location = textfield_Location.text!
                            var string_address:String = String()
                            string_address =  "\(textfield_Location.text!)"
                            if string_address  == ""
                            {
                                self.showAlert(Message: "Please enter your location.", vc: self)
                            }
                            else{
                                
                                DispatchQueue.main.async {
                                    self.pleaseWait()
                                }
                                CheckCompanyNameExist()
                                     }

 
                            
                            
                        }
                        else {
                            self.showAlert(Message: "Please enter valid location.", vc: self)
                            
                        }
                    }
                        
                    else {
                        self.showAlert(Message: "Please enter your location.", vc: self)
                        
                    }
                }
                else {
                    self.showAlert(Message: "Please enter valid company name.", vc: self)
                    
                }
            }
            else {
                self.showAlert(Message: "Please enter company name.", vc: self)
            }
        }
        else{
            self.showAlert(Message: Global.macros.kInternetConnection, vc: self)
            
        }
    }
}



extension CompanyNameAndLocationVC:UITextFieldDelegate
{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == textfield_Name
        {
            textfield_Location.becomeFirstResponder()
        }
        else
        {
            textfield_Location.resignFirstResponder()
        }
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == textfield_Location {
            textfield_Location.resignFirstResponder()

            let autocompleteController = GMSAutocompleteViewController()
            autocompleteController.delegate = self
            present(autocompleteController, animated: true, completion: nil)
            
            
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
       // textField.text?.capitalizeFirstLetter()
        
        if textField == textfield_Name{
            
            let string: NSString = (textField.text! as NSString).replacingCharacters(in: range, with: string) as NSString
            
            if (string.length > 0) {
                if string.hasPrefix(" ") {
                    return false
                }
               
                btn_Next.isUserInteractionEnabled = true
                return string.length <= 30
            }
            else{
                btn_Next.isUserInteractionEnabled = false
                return string.length <= 30
                
            }
            
        }
        
        else {
            let string: NSString = (textField.text! as NSString).replacingCharacters(in: range, with: string) as NSString
            
            if (string.length > 0) {
                if string.hasPrefix(" ") {
                    return false
                }
                
                btn_Next.isUserInteractionEnabled = true
                return string.length <= 60
            }
            else{
                btn_Next.isUserInteractionEnabled = false
                return string.length <= 60
                
            }
            
        }
    }
      
}
