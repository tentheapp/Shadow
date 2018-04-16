//
//  NotificationsViewController.swift
//  Shadow
//
//  Created by Aditi on 26/07/17.
//  Copyright © 2017 Atinderjit Kaur. All rights reserved.
//

import UIKit

class NotificationsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var tblView_Notifications: UITableView!
    @IBOutlet var lbl_NoNotifications:   UILabel!
    
    fileprivate var array_allNotifications = NSMutableArray()
    fileprivate var item_trash =             UIBarButtonItem()
    private let refreshControl =             UIRefreshControl()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        DispatchQueue.main.async {
            self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Arial Rounded MT Bold", size: 16.0)!];
            self.navigationItem.title = "Notifications"
            self.navigationItem.setHidesBackButton(false, animated:true)
            self.tabBarController?.tabBar.isHidden = false
            
            //  self.CreateNavigationBackBarButton()
            self.getAllNotifications()
            
            //navigation clear button
            let btn_trash = UIButton(type: .custom)
            btn_trash.setImage(UIImage(named: "trash"), for: .normal)
            btn_trash.frame = CGRect(x: self.view.frame.size.width - 20, y: 0, width: 20, height: 25)
            btn_trash.addTarget(self, action: #selector(self.btn_Clear), for: .touchUpInside)
            self.item_trash = UIBarButtonItem(customView: btn_trash)
            self.navigationItem.setRightBarButtonItems([self.item_trash], animated: true)
            
            //adding view to table footer
            self.tblView_Notifications.tableFooterView = UIView()
            
            if self.revealViewController() != nil {
                
                self.revealViewController().panGestureRecognizer().isEnabled = false
                self.revealViewController().tapGestureRecognizer().isEnabled = false
                
            }
            
            // Add Refresh Control to Table View
            if #available(iOS 10.0, *) {
                self.tblView_Notifications.refreshControl = self.refreshControl
            } else {
                self.tblView_Notifications.addSubview(self.refreshControl)
            }
            
            self.refreshControl.addTarget(self, action: #selector(self.refreshWeatherData(_:)), for: .valueChanged)

        }

    }

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false

    }
    
    @objc private func refreshWeatherData(_ sender: Any) {
        // Fetch Weather Data
        getAllNotifications()
        self.refreshControl.endRefreshing()

    }
    
    //MARK: -  Functions
    
  fileprivate func getAllNotifications(){
    
        let dict = NSMutableDictionary()
        dict.setValue(SavedPreferences.value(forKey: Global.macros.kUserId) as? NSNumber, forKey: Global.macros.kUserId)
        print(dict)
        
        if self.checkInternetConnection(){
            
            DispatchQueue.main.async {
                self.pleaseWait()
            }
            
            
            Notification_API.sharedInstance.retrieveNotifications(dict: dict, completionBlock: { (response) in
                print(response)
                DispatchQueue.main.async {
                    self.clearAllNotice()
                }
                let status = response.value(forKey: "status") as? NSNumber
                switch(status!){
                    
                case 200:
                    
                    self.array_allNotifications = (response.value(forKey: "data") as! NSArray).mutableCopy() as! NSMutableArray
                    DispatchQueue.main.async {
                        self.tblView_Notifications.isHidden = false
                        self.tblView_Notifications.reloadData()
                        self.lbl_NoNotifications.isHidden = true
                        self.item_trash.isEnabled = true
                        self.tblView_Notifications.reloadData()
                    }
                    
                    break
                    
                case 404:
                    DispatchQueue.main.async {
                        self.tblView_Notifications.isHidden = true
                        self.lbl_NoNotifications.isHidden = false
                        self.item_trash.isEnabled = false
                    }
                    
                    break
                    
                case 401:
                    DispatchQueue.main.async {

                    self.AlertSessionExpire()
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
            })
        }else{
            self.showAlert(Message: Global.macros.kInternetConnection, vc: self)
        }
    }
    
    
  @objc fileprivate func btn_Clear(){
    
    
    let TitleString = NSAttributedString(string: "Shadow", attributes: [
        NSFontAttributeName : UIFont.systemFont(ofSize: 18),
        NSForegroundColorAttributeName : Global.macros.themeColor_pink
        ])
    let MessageString = NSAttributedString(string: "Do you want to clear all notifications?", attributes: [
        NSFontAttributeName : UIFont.systemFont(ofSize: 15),
        NSForegroundColorAttributeName : Global.macros.themeColor_pink
        ])
    
    DispatchQueue.main.async {
        self.clearAllNotice()
        
        let alert = UIAlertController(title: "Shadow", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: {(action) in
            
            let dict = NSMutableDictionary()
            dict.setValue(SavedPreferences.value(forKey: Global.macros.kUserId) as? NSNumber, forKey: Global.macros.kUserId)
            print(dict)
            
            if self.checkInternetConnection(){
                
                DispatchQueue.main.async {
                    self.pleaseWait()
                }
                
                Notification_API.sharedInstance.clearNotifications(dict: dict, completionBlock: { (response) in
                    print(response)
                    
                    DispatchQueue.main.async {
                        self.clearAllNotice()
                    }
                    let status = response.value(forKey: "status") as? NSNumber
                    switch(status!){
                        
                    case 200:
                        
                        self.array_allNotifications.removeAllObjects()
                        DispatchQueue.main.async {
                            self.tblView_Notifications.reloadData()
                            self.tblView_Notifications.isHidden = true
                            self.lbl_NoNotifications.isHidden = false
                        }
                        
                        break
                        
                    case 404:
                        DispatchQueue.main.async {
                            
                            self.showAlert(Message: "Already cleared", vc: self)
                            self.tblView_Notifications.isHidden = true
                            self.lbl_NoNotifications.isHidden = false
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
                })
                
                
                
            }
            else{
                
                self.showAlert(Message: Global.macros.kInternetConnection, vc: self)
            }
            
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil))
        alert.view.layer.cornerRadius = 10.0
        alert.view.clipsToBounds = true
        alert.view.backgroundColor = UIColor.white
        alert.view.tintColor = Global.macros.themeColor_pink
        
        alert.setValue(TitleString, forKey: "attributedTitle")
        alert.setValue(MessageString, forKey: "attributedMessage")
        self.present(alert, animated: true, completion: nil)

             }
    }
    
    
    
    //MARK: - UITableview Datasource and delegate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NotificationTableViewCell
        
        cell.dataToCell(dict: self.array_allNotifications.object(at: indexPath.row) as! NSDictionary)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.array_allNotifications.count
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let dict = self.array_allNotifications.object(at: indexPath.row) as! NSDictionary
        
        if dict.value(forKey: "type") as! String != "Verified" {
        
        let dict_UserInfo = (dict.value(forKey: "requestDTO") as! NSDictionary).value(forKey: "userDTO") as! NSDictionary

       if dict.value(forKey: "type") as! String == "Rating" || dict.value(forKey: "type")  == nil  || dict.value(forKey: "type") as! String  == "rating" {
        
         let requestID = ((array_allNotifications.object(at: indexPath.row) as! NSDictionary).value(forKey: "requestDTO") as! NSDictionary).value(forKey: "otherUserId") as? NSNumber
        
        let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "ratingView") as! RatingViewController
        vc.userIdForRating = requestID
        ratingview_name = self.navigationItem.title
        _ = self.navigationController?.pushViewController(vc, animated: true)
        

        }
        
        else {
        
        
        
        let requestID = ((array_allNotifications.object(at: indexPath.row) as! NSDictionary).value(forKey: "requestDTO") as! NSDictionary).value(forKey: Global.macros.kId) as? NSNumber

        
        let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "Request_Details") as! RequestDetailsViewController
        vc.username =  self.navigationItem.title
        vc.request_Id = requestID!
        _ = self.navigationController?.pushViewController(vc, animated: true)
 
        
        }
        }
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}
