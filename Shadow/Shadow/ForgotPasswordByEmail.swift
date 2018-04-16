//
//  ForgotPasswordByEmail.swift
//  Shadow
//
//  Created by Sahil Arora on 6/5/17.
//  Copyright © 2017 Atinderjit Kaur. All rights reserved.
//

import UIKit

class ForgotPasswordByEmail: UIViewController {

    @IBOutlet var btn_TryPhone:  UIButton!
    @IBOutlet var btn_Send:      UIButton!
    @IBOutlet var textfield_Email: UITextField!
    
    fileprivate var userId:      String?
    fileprivate var emailOtp:    String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myBackButton:UIButton = UIButton()
        myBackButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        myBackButton.setImage(UIImage(named:"back-new"), for: UIControlState())
        myBackButton.addTarget(self, action: #selector(self.PopToRootViewController), for: UIControlEvents.touchUpInside)
        let leftBackBarButton:UIBarButtonItem = UIBarButtonItem(customView: myBackButton)
        self.navigationItem.leftBarButtonItem = leftBackBarButton
        self.SetButtonCustomAttributes(self.btn_Send)
        textfield_Email.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControlEvents.editingChanged)
        
        
    }
    
    func PopToRootViewController()
    {
        
        
              
        
        
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        add_padding(textfield: textfield_Email)
        
        Validation()
    }
    
    //MARK: UITextfield delegate methods
    
    func textFieldDidChange(textField:UITextField)
    {
        print(textField.text!)
        if  textfield_Email.text != ""  &&  self.isValidEmail(textfield_Email.text!) {
            
            SetButtonCustomAttributesPurple(btn_Send)
        }
        else {
            
            SetButtonCustomAttributes(btn_Send)
        }
    }

  
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
            self.view.endEditing(true)
       
    }
    
   
    
    //Validation
    fileprivate func Validation()
    {
        if textfield_Email.text != ""
        {
            btn_Send.isUserInteractionEnabled = true
            
        }
        else
        {
            btn_Send.isUserInteractionEnabled = false
        }
    }
    //MARK:- Button Actions
    
    @IBAction func Action_Send(_ sender: UIButton) {
        if textfield_Email.text != ""
        {
        
        let dict = NSMutableDictionary()
        dict.setValue(textfield_Email.text, forKey: Global.macros.kEmail)
        
        if self.checkInternetConnection()
        {
            if self.isValidEmail(textfield_Email.text!)
            {
            DispatchQueue.main.async {
                self.pleaseWait()
            }
            
            AuthenticationAPI.sharedInstance.ResendOtp(dict: dict, completion: {(response) in
                switch response.0{
                    
                case 200:
       
               self.userId = "\((response.1).value(forKey: "userId")!)"
               self.emailOtp = "\((response.1).value(forKey: "emailOtp")!)"
               SavedPreferences.set((response.1).value(forKey: "userId") , forKey: Global.macros.kUserId)
               
               DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "EmailToOTP", sender: self)
                }

                case 404:
                    
                    DispatchQueue.main.async {
                        self.showAlert(Message: Global.macros.kUserNotExist, vc: self)
                    }

                default:break
                    
                }
                self.clearAllNotice()

            }, errorBlock: {(err) in
                
                DispatchQueue.main.async{
                    self.clearAllNotice()
                    self.showAlert(Message: Global.macros.kError, vc: self)
                }
                
            })
        }
            else
            {
                self.showAlert(Message: Global.macros.KInvalidEmail, vc: self)

                
            }
            
        }
        else
        {
            self.showAlert(Message: Global.macros.kInternetConnection, vc: self)

        }
        
        }
        else{
            self.showAlert(Message: "Please enter your email.", vc: self)

            
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "EmailToOTP"{
            
            let vc =  segue.destination as! ResetPasswordVC
            vc.user_id = self.userId
            vc.otp = self.emailOtp
        }
    }
    
    @IBAction func Action_TryPhoneNumber(_ sender: UIButton) {
        let array = self.navigationController?.viewControllers
        
        print(array!)
        
        if (array?.count)! > 2
        {
            _ = self.navigationController?.popViewController(animated: true)
            
        }
        else
        {
            let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "ForgotPhone")as! ForgotPasswordByPhone
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
       
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
extension ForgotPasswordByEmail:UITextFieldDelegate
{

    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
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
        btn_Send.isUserInteractionEnabled = true
            
            return string.length <= 40
        }
            
        else{
            btn_Send.isUserInteractionEnabled = false
             return string.length <= 40
        }
        
    }

    
}
