//
//  FirstAndLastNameViewController.swift
//  Shadow
//
//  Created by Atinderjit Kaur on 31/05/17.
//  Copyright © 2017 Atinderjit Kaur. All rights reserved.
//

import UIKit



class FirstAndLastNameViewController: UIViewController {
    
    @IBOutlet weak var btn_Next:            UIButton!
    @IBOutlet weak var textfield_Lastname:  UITextField!
    @IBOutlet weak var textfield_Firstname: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myBackButton:UIButton = UIButton()
        myBackButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        myBackButton.setImage(UIImage(named:"back-new"), for: UIControlState())
        myBackButton.addTarget(self, action: #selector(self.PopToRootViewController), for: UIControlEvents.touchUpInside)
        let leftBackBarButton:UIBarButtonItem = UIBarButtonItem(customView: myBackButton)
        self.navigationItem.leftBarButtonItem = leftBackBarButton
        
        self.SetButtonCustomAttributes(btn_Next)
        textfield_Firstname.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControlEvents.editingChanged)
        textfield_Lastname.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControlEvents.editingChanged)
        
    }
    
    
    func textFieldDidChange(textField:UITextField)
    {
        
        let str_firstname = textfield_Firstname.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let str_lastname = textfield_Lastname.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if str_firstname != "" && (str_firstname?.characters.count)! >= 2 && str_lastname != "" && (str_lastname?.characters.count)! >= 2
        {
            SetButtonCustomAttributesPurple(btn_Next)
            
              }
        else {
            SetButtonCustomAttributes(btn_Next)
            
        }
        
    }

    
   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        Validations()
    }
    
    //Validations
    fileprivate func Validations()
    {
        if textfield_Lastname.text != ""  && textfield_Firstname.text != ""
        {
            btn_Next.isUserInteractionEnabled = true
        }
        else
        {
            btn_Next.isUserInteractionEnabled = false
            
        }
    }
    
    //MARK:-Button Actions
    
    
    @IBAction func Action_Next(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        let str_firstname = textfield_Firstname.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let str_lastname = textfield_Lastname.text?.trimmingCharacters(in: .whitespacesAndNewlines)

        
        if str_firstname != ""
        {
            
        
        if (str_firstname?.characters.count)! >= 2
        {
            
            if str_lastname != ""
            {
            
            if (str_lastname?.characters.count)! >= 2
            {
                
            if self.checkInternetConnection()
            {
                lastName = str_lastname!
                firstName = str_firstname!
                
                self.performSegue(withIdentifier: "FirstameToShadow", sender: self)
            }
            else
            {
                self.showAlert(Message: Global.macros.kInternetConnection, vc: self)
                
            }
            }
            else {
                self.showAlert(Message: "Lastname must contain 2 characters.", vc: self)

            }
        }
        else {
            self.showAlert(Message: "Please enter your lastname.", vc: self)
 
            
        }
            }
            else {
                
                self.showAlert(Message: "Firstname must contain 2 characters.", vc: self)
            }
            
        }
        
        else {
            
            self.showAlert(Message: "Please enter your firstname.", vc: self)
        }
    }
    
}
extension FirstAndLastNameViewController:UITextFieldDelegate
{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        textField.text?.capitalizeFirstLetter()
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
            return string.length <= 15
        }
        else{
            btn_Next.isUserInteractionEnabled = false
            
            return string.length <= 15

        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == textfield_Firstname{
            textfield_Lastname.becomeFirstResponder()
        }
        else{
            textfield_Lastname.resignFirstResponder()
        }
        return true
    }
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


