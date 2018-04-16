//
//  SendRequestViewController.swift
//  Shadow
//
//  Created by Aditi on 18/08/17.
//  Copyright © 2017 Atinderjit Kaur. All rights reserved.
//

import UIKit
import CoreLocation
import GooglePlaces
import GooglePlacePicker

var roleForShowingLoc : String? = ""
class SendRequestViewController: UIViewController,GMSAutocompleteViewControllerDelegate {
    
    @IBOutlet var imgView_InPerson:        UIImageView!
    @IBOutlet var btn_SelectLocation:      UIButton!
    @IBOutlet var imgView_Virtually:       UIImageView!
    @IBOutlet var btn_SelectVirtualOption: UIButton!
    @IBOutlet var calender:                FSCalendar!
    @IBOutlet var txtView_Message:         UITextView!
    @IBOutlet var lbl_MessagePlaceholder:  UILabel!
    @IBOutlet var k_Constraint_ScroolViewTop: NSLayoutConstraint!
    @IBOutlet var scrollView:              UIScrollView!
    
    @IBOutlet weak var lbl_ShowTime:       UILabel!
    @IBOutlet weak var view_Picker:        UIView!
    @IBOutlet weak var pickerTime:         UIDatePicker!
    @IBOutlet weak var btn_Done:           UIButton!
    
    let timePicker =                      UIDatePicker()
    var user_Name:                        String?
    var request_id_fromRequestDetail:     NSNumber?
    var check_comingFromRequestDetail:    String = "NO"
    var location_comSchool :              String = ""
    fileprivate var str_date_selected:    String? = ""
    var userIdFromSendRequest :           NSNumber?
    var str_time :                        String? = ""

  
    
    
    override func viewWillLayoutSubviews() {
      
    }
    
    //Converts string into date
    let formatter: DateFormatter =
        {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.navigationItem.title = self.user_Name!
            self.btn_SelectLocation.layer.cornerRadius = 3.0
            self.btn_SelectLocation.layer.borderColor = Global.macros.themeColor_pink.cgColor
            self.btn_SelectLocation.layer.borderWidth = 1.0
            
            self.btn_SelectVirtualOption.layer.cornerRadius = 3.0
            self.btn_SelectVirtualOption.layer.borderColor = Global.macros.themeColor_pink.cgColor
            self.btn_SelectVirtualOption.layer.borderWidth = 1.0
            
            self.txtView_Message.layer.borderColor =  UIColor.darkGray.cgColor
            self.txtView_Message.layer.cornerRadius = 8.0
            self.txtView_Message.layer.borderWidth = 1.0
            
            self.calender.layer.borderColor = UIColor.darkGray.cgColor
            self.calender.layer.borderWidth = 1.0
            self.calender.layer.cornerRadius = 8.0
           
            self.CreateNavigationBackBarButton()
            
            if SavedPreferences.value(forKey: Global.macros.kUserId) as? NSNumber != self.userIdFromSendRequest {
            //Adding button to navigation bar
            let btn2 = UIButton(type: .custom)
            btn2.setImage(UIImage(named: "send_white"), for: .normal)
            btn2.frame = CGRect(x: self.view.frame.size.width - 25, y: 0, width: 25, height: 25)
            btn2.addTarget(self, action: #selector(self.Send), for: .touchUpInside)
            let item2 = UIBarButtonItem(customView: btn2)
            //Right items
            self.navigationItem.setRightBarButtonItems([item2], animated: true)
            
            }
            
            if self.check_comingFromRequestDetail == "YES" {
                self.setRequestData()
            }
            
                if roleForShowingLoc == "USER" {
               if SavedPreferences.value(forKey: Global.macros.krole) as? String == "COMPANY" || SavedPreferences.value(forKey: Global.macros.krole) as? String == "SCHOOL"{
                if SavedPreferences.value(forKey: "locComSchoolForUser") != nil {
                    
                    self.btn_SelectLocation.setTitle(SavedPreferences.value(forKey: "locComSchoolForUser") as? String, for: .normal)
                    self.imgView_InPerson.image = UIImage.init(named: "purple")
                    self.imgView_Virtually.image = UIImage.init(named: "blank")
                    self.btn_SelectLocation.isHidden = false
                    
                }
                    }
                    
                }
                
                else{
                    
                 //   if SavedPreferences.value(forKey: Global.macros.krole) as? String == "COMPANY" || SavedPreferences.value(forKey: Global.macros.krole) as? String == "SCHOOL"{
                    if self.location_comSchool != "" {
                    
                        self.btn_SelectLocation.setTitle(self.location_comSchool, for: .normal)
                        self.imgView_InPerson.image = UIImage.init(named: "purple")
                        self.imgView_Virtually.image = UIImage.init(named: "blank")
                        self.btn_SelectLocation.isHidden = false
                    
                    }
                    else {
                        
                        if SavedPreferences.value(forKey: "locComSchoolForUser") != nil {
                            
                            self.btn_SelectLocation.setTitle(SavedPreferences.value(forKey: "locComSchoolForUser") as? String, for: .normal)
                            self.imgView_InPerson.image = UIImage.init(named: "purple")
                            self.imgView_Virtually.image = UIImage.init(named: "blank")
                            self.btn_SelectLocation.isHidden = false
                            
                        }
                        
                        
                    }
                    
                   // }
                    
                 
                    
                }
                
                
            }
        
      
        
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
         DispatchQueue.main.async{
            self.scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 900) }

    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
      roleForShowingLoc = ""
    }
    

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        print(scrollView.contentOffset.y)
        print(scrollView.contentOffset.x)
        
   // self.txtView_Message.resignFirstResponder()

    }
    
  
    //MARK: - Button Actions
   
    
    @IBAction func SelectTime(_ sender: UIButton) {
        
        DispatchQueue.main.async{
             self.view.endEditing(true)
            self.view_Picker.isHidden = false
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "h:mm a"
            
            let date_ = dateFormatter.string(from: self.pickerTime.date)
            print(date_)
            self.lbl_ShowTime.text = "\(date_)"
            self.str_time =  self.lbl_ShowTime.text
            
        }
        
    }
    
    @IBAction func Action_CheckBtnLocation(_ sender: UIButton) {
        
        self.imgView_InPerson.image = UIImage.init(named: "purple")
        self.imgView_Virtually.image = UIImage.init(named: "blank")
        
        self.btn_SelectLocation.isHidden = false
        
       }
    
    @IBAction func Action_CheckBtnVirtualOption(_ sender: UIButton) {
        
        self.imgView_Virtually.image = UIImage.init( named: "purple")
        self.imgView_InPerson.image = UIImage.init(named: "blank")
        
        self.btn_SelectLocation.isHidden = true
        //   self.btn_SelectVirtualOption.isHidden = false
    }
    
    
    @IBAction func Action_SelectLocation(_ sender: Any) {
        
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
        
    }
    
    @IBAction func Action_SelectVirtualOption(_ sender: UIButton) {
        
        self.showAlert(Message: "Coming Soon", vc: self)
    }
    
    
    @IBAction func action_PickerDone(_ sender: UIButton) {
        
        DispatchQueue.main.async{
            self.view_Picker.isHidden = true
        }
    }
    
    @IBAction func action_Picker(_ sender: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        
        let date_ = dateFormatter.string(from: sender.date)
        print(date_)
        lbl_ShowTime.text = "\(date_)"
        str_time =  lbl_ShowTime.text
   
    }
    
    
    func localToUTC(date:String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.calendar = NSCalendar.current
        dateFormatter.timeZone = TimeZone.current
        
        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "H:mm a"
        return dateFormatter.string(from: dt!)
        
    }


    
    
    //MARK: - Send Request Functions
    
    func Send(){
        
        txtView_Message.resignFirstResponder()
        if self.imgView_Virtually.image == UIImage.init(named: "purple") || self.imgView_InPerson.image == UIImage.init(named: "purple"){
            
            if self.imgView_InPerson.image == UIImage.init(named: "purple") && self.btn_SelectLocation.currentTitle != "Select Location"{
                
                if str_date_selected != ""{
                    if txtView_Message.text != ""  {
                        
                        
                        if str_time != "" && str_time != nil {
                        self.SendRequest_Service()
                        }
                        
                        else{
                            self.showAlert(Message: "Please select time.", vc: self)
                        }
                        
                    }else{
                        self.showAlert(Message: "Please write message.", vc: self)
                    }
                }
                else{
                    self.showAlert(Message: "Please select a date.", vc: self)
                }
            }
            else if self.imgView_Virtually.image == UIImage.init(named: "purple"){
                if str_date_selected != ""{
                    if txtView_Message.text != ""  {
                        
                        if str_time != "" && str_time != nil {

                        self.SendRequest_Service()
                        }
                        else{
                            self.showAlert(Message: "Please write time.", vc: self)
                        }
                        
                    }
                    else{
                        self.showAlert(Message: "Please write message.", vc: self)
                    }
                    
                } else{
                    self.showAlert(Message: "Please select a date.", vc: self)
                }
                
            }
            else{
                self.showAlert(Message: "Please select a Location.", vc: self)
            }
        }
            
        else{
            self.showAlert(Message: "Please select atleast one option to meet.", vc: self)
        }
    }
    
    func SendRequest_Service()  {
        if self.checkInternetConnection(){
            
            DispatchQueue.main.async {
                self.pleaseWait()
            }
            
            let dict = NSMutableDictionary()
            
            let  user_Id = SavedPreferences.value(forKey: Global.macros.kUserId) as? NSNumber
            dict.setValue(user_Id, forKey: Global.macros.kUserId)
            dict.setValue(self.userIdFromSendRequest, forKey:Global.macros.kotherUserId)
            
            if imgView_InPerson.image == UIImage.init(named: "purple"){
                dict.setValue(btn_SelectLocation.currentTitle, forKey: Global.macros.k_location)
                
            }
            else if  imgView_Virtually.image == UIImage.init(named: "purple"){
                //dict.setValue(btn_SelectVirtualOption.currentTitle, forKey: Global.macros.k_mediumOfCommunication)
                
                dict.setValue("Video Call", forKey: Global.macros.k_mediumOfCommunication)
                
            }
            
            if self.check_comingFromRequestDetail == "YES" {
                
                dict.setValue(self.request_id_fromRequestDetail!, forKey: Global.macros.kId)

            }
            
            dict.setValue(str_date_selected!, forKey: Global.macros.k_SelectedDate)
            dict.setValue(txtView_Message.text!, forKey: Global.macros.k_message)
            dict.setValue(str_time!, forKey: "selectedTime")
            print(dict)
            
            Requests_API.sharedInstance.sendRequest(completionBlock: { (status, dict_Info) in
                
                DispatchQueue.main.async {
                    self.clearAllNotice()
                }
                
                switch status {
                    
                case 200:
                    
                    DispatchQueue.main.async {
                        
                        let TitleString = NSAttributedString(string: "Shadow", attributes: [
                            NSFontAttributeName : UIFont.systemFont(ofSize: 18),
                            NSForegroundColorAttributeName : Global.macros.themeColor_pink
                            ])
                        let MessageString = NSAttributedString(string: "Request successfully sent.", attributes: [
                            NSFontAttributeName : UIFont.systemFont(ofSize: 15),
                            NSForegroundColorAttributeName : Global.macros.themeColor_pink
                            ])
                        
                            let alert = UIAlertController(title: "Shadow", message: "", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {(action) in
                            
                                _ = self.navigationController?.popToRootViewController(animated: true)
                            
                            }))
                            alert.view.layer.cornerRadius = 10.0
                            alert.view.clipsToBounds = true
                            alert.view.backgroundColor = UIColor.white
                            alert.view.tintColor = Global.macros.themeColor_pink
                            
                            alert.setValue(TitleString, forKey: "attributedTitle")
                            alert.setValue(MessageString, forKey: "attributedMessage")
                            self.present(alert, animated: true, completion: nil)
                    }
                    
                    break
                    
                case 400:
                    DispatchQueue.main.async {
                        
                            let TitleString = NSAttributedString(string: "Shadow", attributes: [
                                NSFontAttributeName : UIFont.systemFont(ofSize: 18),
                                NSForegroundColorAttributeName : Global.macros.themeColor_pink
                                ])
                            let MessageString = NSAttributedString(string: "Your previous request is pending.", attributes: [
                                NSFontAttributeName : UIFont.systemFont(ofSize: 15),
                                NSForegroundColorAttributeName : Global.macros.themeColor_pink
                                ])
                        
                                let alert = UIAlertController(title: "Shadow", message: "", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {(action) in
                                    
                                _ = self.navigationController?.popToRootViewController(animated: true)
                                    
                                }))
                                alert.view.layer.cornerRadius = 10.0
                                alert.view.clipsToBounds = true
                                alert.view.backgroundColor = UIColor.white
                                alert.view.tintColor = Global.macros.themeColor_pink
                                
                                alert.setValue(TitleString, forKey: "attributedTitle")
                                alert.setValue(MessageString, forKey: "attributedMessage")
                                self.present(alert, animated: true, completion: nil)
                                
                            }
                    
                case 406 :
                    
                    DispatchQueue.main.async {
                        
                        let TitleString = NSAttributedString(string: "Shadow", attributes: [
                            NSFontAttributeName : UIFont.systemFont(ofSize: 18),
                            NSForegroundColorAttributeName : Global.macros.themeColor_pink
                            ])
                        let MessageString = NSAttributedString(string: "Request cannot be sent, because recipient has blocked his/her shadow profile.", attributes: [
                            NSFontAttributeName : UIFont.systemFont(ofSize: 15),
                            NSForegroundColorAttributeName : Global.macros.themeColor_pink
                            ])
                        
                        let alert = UIAlertController(title: "Shadow", message: "", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {(action) in
                            
                            _ = self.navigationController?.popToRootViewController(animated: true)
                            
                        }))
                        alert.view.layer.cornerRadius = 10.0
                        alert.view.clipsToBounds = true
                        alert.view.backgroundColor = UIColor.white
                        alert.view.tintColor = Global.macros.themeColor_pink
                        
                        alert.setValue(TitleString, forKey: "attributedTitle")
                        alert.setValue(MessageString, forKey: "attributedMessage")
                        self.present(alert, animated: true, completion: nil)
                        
                    }

                case 409:
                    DispatchQueue.main.async {
                        self.showAlert(Message: "You are not verified by admin yet.", vc: self)
                        
                    }
                    
                    break
                    default:
                    self.showAlert(Message: Global.macros.kError, vc: self)
                    break
                    
                }
                
            }, errorBlock: { (error) in
                DispatchQueue.main.async {
                    self.clearAllNotice()
                    self.showAlert(Message: Global.macros.kError, vc: self)
                }
                
            }, dict: dict)
            
            
        }else{
            
            self.showAlert(Message:Global.macros.kInternetConnection, vc: self)
        }
    }
    
    func setRequestData()  {
        
        let dict = NSMutableDictionary()
        let  user_Id = SavedPreferences.value(forKey: Global.macros.kUserId) as? NSNumber
        dict.setValue(user_Id, forKey: Global.macros.kUserId)
        dict.setValue(self.request_id_fromRequestDetail!, forKey: "id")
        print(dict)
        
        
        if self.checkInternetConnection(){
            
            DispatchQueue.main.async {
                self.pleaseWait()
            }
            
            Requests_API.sharedInstance.viewRequest(completionBlock: { (status, dict_Info) in
                DispatchQueue.main.async {
                    self.clearAllNotice()
                }
                switch status{
                    
                case 200:
                    
                    DispatchQueue.main.async {
                        
                        //setting radio button according to selected method to meet
                        //if video call is selected
                        if dict_Info[Global.macros.k_mediumOfCommunication] != nil{
                            
                        self.imgView_InPerson.image = UIImage.init(named: "blank")
                        self.imgView_Virtually.image = UIImage.init(named: "purple")
                        }
                        else if dict_Info[Global.macros.k_location] != nil{
                            
                        self.imgView_InPerson.image = UIImage.init(named: "purple")
                        self.imgView_Virtually.image = UIImage.init(named: "blank")
                        self.btn_SelectLocation.setTitle(dict_Info.value(forKey:Global.macros.k_location) as? String, for: .normal)
                            
                            
                        }
                        
                        
                        //setting date on calender
                        if dict_Info[Global.macros.k_SelectedDate] != nil{
                            
                            let str_date =   dict_Info.value(forKey: Global.macros.k_SelectedDate) as? String
                            let sdate = self.formatter.date(from: str_date!)
                            self.calender.deselect(sdate!)
                            self.calender.select(sdate!, scrollToDate: true)
                            
                        }
                        
                        //setting message
                        if dict_Info["message"] != nil &&  dict_Info["message"] as? String != ""{
                            
                            self.lbl_MessagePlaceholder.isHidden = true
                            self.txtView_Message.text = dict_Info.value(forKey: "message") as? String
                        }
                        else{
                            self.lbl_MessagePlaceholder.isHidden = false
                        }
                        
                    }
                    break
                    
                case 404:
                    DispatchQueue.main.async {
                        self.showAlert(Message: Global.macros.kError, vc: self)
                        
                    }
                    
               
                    
                default:
                    DispatchQueue.main.async {
                        self.showAlert(Message: Global.macros.kError, vc: self)

                    }
                    break
                }
                
            }, errorBlock: { (error) in
                DispatchQueue.main.async {
                    self.clearAllNotice()
                    self.showAlert(Message: Global.macros.kError, vc: self)
                }
            }, dictionary: dict)
        }
        else{
            self.showAlert(Message: Global.macros.kInternetConnection, vc: self)
        }

    }
    
    // MARK: - Delegate GMSAutocompleteViewController
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        print("Place name: \(place.name)")
        print("Place address: \(String(describing: place.formattedAddress))")
        print("Place attributions: \(String(describing: place.attributions))")
        self.btn_SelectLocation.setTitle(place.formattedAddress, for: .normal)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}

extension SendRequestViewController:UITextViewDelegate{
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n"
        {
            textView.resignFirstResponder()
        }
        return true
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        lbl_MessagePlaceholder.isHidden = true
        self.view_Picker.isHidden = true
         self.animateTextView(textView: textView, up: true, movementDistance: 350, scrollView:self.scrollView)
     
        
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        let str = textView.text.trimmingCharacters(in: .whitespaces)
        
        if str == ""
        {
            self.txtView_Message.text = ""
            lbl_MessagePlaceholder.isHidden = false
            
        }
        else{
            txtView_Message.text = textView.text
        }
        
            DispatchQueue.main.async {
                
                self.animateTextView(textView: textView, up: false, movementDistance: 350, scrollView:self.scrollView)
            }
        
    }
    
}
extension SendRequestViewController:FSCalendarDelegate,FSCalendarDataSource{
    
    
    //Called when available date is selected
    func calendar(_ calendar: FSCalendar, didSelect date: Date) {
        
        
        if date <= calendar.today!
        {
            calender.deselect(date)
            self.showAlert(Message: "Please select future date.", vc: self)
            return
        }
        else{
            
            str_date_selected = (self.formatter.string(from: date))
            
        }
        
    }
   
    //calendarCurrentPageDidChange
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        
     
    }
    
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        
        if date == calender.today
        {
            return "Today"
        }
        else{
            return nil
        }
    }
    
}
