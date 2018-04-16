//
//  TextfieldExtension_Login.swift
//  Pocket_BloodBank
//
//  Created by Atinderjit Kaur on 28/11/16.
//  Copyright © 2016 Atinderjit Kaur. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation



/**
 This class is used to extend UIviewcontroller methods so that you can simply use them using "Self" in any class
 */

extension UIViewController {
    /**
     This method is used to create custom alert.
     :param:  text contains message to display on alert.
     :param:  viewcontroller on which we want to presen alert.
     */
    override func showAlert(Message:String , vc:UIViewController)
    {
        let TitleString = NSAttributedString(string: "Shadow", attributes: [
            NSFontAttributeName : UIFont.systemFont(ofSize: 18),
            NSForegroundColorAttributeName : Global.macros.themeColor_pink
            ])
        let MessageString = NSAttributedString(string: Message, attributes: [
            NSFontAttributeName : UIFont.systemFont(ofSize: 15),
            NSForegroundColorAttributeName : Global.macros.themeColor_pink
            ])
        
        DispatchQueue.main.async {
            self.clearAllNotice()
            
            let alert = UIAlertController(title: "Shadow", message: Message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            alert.view.layer.cornerRadius = 10.0
            alert.view.clipsToBounds = true
            alert.view.backgroundColor = UIColor.white
            alert.view.tintColor = Global.macros.themeColor_pink
            
            alert.setValue(TitleString, forKey: "attributedTitle")
            alert.setValue(MessageString, forKey: "attributedMessage")
            vc.present(alert, animated: true, completion: nil)
            
        }
    }
    
    func AlertSessionExpire() {
        
        let TitleString = NSAttributedString(string: "Shadow", attributes: [
            NSFontAttributeName : UIFont.systemFont(ofSize: 18),
            NSForegroundColorAttributeName : Global.macros.themeColor_pink
            ])
        let MessageString = NSAttributedString(string: "Session expired, Please try to login again.", attributes: [
            NSFontAttributeName : UIFont.systemFont(ofSize: 15),
            NSForegroundColorAttributeName : Global.macros.themeColor_pink
            ])
        
        let alert = UIAlertController(title: "Shadow", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "Yes", style: .default, handler: { (alert) in
            
            DispatchQueue.main.async {
                self.clearAllNotice()
                
                
                bool_fromMobile = false
                bool_NotVerified = false
                bool_LocationFilter = false
                bool_PlayFromProfile = false
                bool_AllTypeOfSearches = false
                bool_CompanySchoolTrends = false
                bool_fromVerificationMobile = false
                bool_UserIdComingFromSearch = false
                
                SavedPreferences.set(nil, forKey: "user_verified")
                SavedPreferences.set(nil, forKey: "sessionToken")
                SavedPreferences.removeObject(forKey: Global.macros.kUserId)
                
                let deviceIdentifier: String = UIDevice.current.identifierForVendor!.uuidString
                
                QBRequest.unregisterSubscription(forUniqueDeviceIdentifier: deviceIdentifier, successBlock: { (QBResponse) in
                    
                    let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "Login")
                    Global.macros.kAppDelegate.window?.rootViewController = vc
                    
                    
                }, errorBlock: {(err) in
                    DispatchQueue.main.async {
                        self.clearAllNotice()
                        
                        let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "Login")
                        Global.macros.kAppDelegate.window?.rootViewController = vc
                    }
                })
                
            }
            
        }))
        
        alert.addAction(UIAlertAction.init(title: "No", style: .default, handler:nil))
        alert.view.layer.cornerRadius = 10.0
        alert.view.clipsToBounds = true
        alert.view.backgroundColor = UIColor.white
        alert.view.tintColor = Global.macros.themeColor_pink
        
        alert.setValue(TitleString, forKey: "attributedTitle")
        alert.setValue(MessageString, forKey: "attributedMessage")
        self.present(alert, animated: true, completion: nil)

        
        
    }
    
    
    
    
    func CreateAlert()
    {
        
        let alert = UIAlertController(title: "Shadow", message: "Choose option to validate your account.", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "via Email", style: .default, handler: {(action) -> Void in
            
            let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "Email") as! EnterEmailVC
            _ = self.navigationController?.pushViewController(vc, animated: true)
            
        }))
//        alert.addAction(UIAlertAction(title: "via Phone Number", style: .default, handler: {(action) -> Void in
//            
//            let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "PhoneNumber") as! EnterPhoneNumberVC
//            _ = self.navigationController?.pushViewController(vc, animated: true)
//            
//        }))
//        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler:nil))
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
        
        
        
    }
    
    
     /**
     notice is used to display a toast rather than a alert.
     
     :param:  text contains text to display on toast.
     
     :param:  autoClear a Bool variable if true will remove toast automatically otherwise user have to click on it.
     */
    
    func notice(_ text: String, type: NoticeType, autoClear: Bool = true){
        SwiftNotice.showNoticeWithText(type, text: text, autoClear: autoClear)
    }
    
       /**
     setRootView is used to set any view controller to root , So you do this only in half single line just sending an identifier.
     
     :param:  identifier View controller's storyboard identifier.
     */
    
  public  func setRootView(_ identifier:String) {
        
        let chooseCVC = Global.macros.Storyboard.instantiateViewController(withIdentifier: identifier)
        
        let kappdelegate = UIApplication.shared.delegate  as! AppDelegate// a shortcut to get Appdelegate reference.
        // Because self.window is an optional you should check it's value first and assign your rootViewController
        if let window = kappdelegate.window {
            window.rootViewController = chooseCVC
        }
    
    }
    
    /**
     getViewController is used to get any view controller from storyboard , So you do this only in half single line just sending an identifier.
     
     :param:  identifier View controller's storyboard identifier.
     */
    
    func getViewController(_ identifier:String) -> UIViewController {
        
        let chooseCVC = Global.macros.Storyboard.instantiateViewController(withIdentifier: identifier)
        
        return chooseCVC
        
    }
    
    //MARK: Methods
    
    /**
     setAppDefaultNavigationBar is used to set Apps default Status bar color.
     
     :param:  identifier View controller's storyboard identifier.
     */
    
    func setAppDefaultNavigationBar(_ navigationController:UINavigationController) {
        
        navigationController.navigationBar.barTintColor = UIColor(netHex:0xFF9933)
        navigationController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navigationController.navigationBar.tintColor = UIColor.white
    }
    
    /**
     showDialogAlert is used to show dialog Type alert.
     
     :param: message contains the message which needs to be displayed.
     */
    
    func showDialogAlert(_ message:String) {
        //simple alert dialog
        let alert=UIAlertController(title: "SHADOW", message: message, preferredStyle: UIAlertControllerStyle.alert);
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil));
        //show it
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
    
        }
    }
    
  func add_padding(textfield:UITextField) {
    let paddingView = UIView(frame:CGRect(x: 0, y: 0, width: 10, height: 30))
    textfield.leftView=paddingView;
    textfield.leftViewMode = UITextFieldViewMode.always
    }

    /**
     showDialogAlert is used to show Action sheet style Type alert.
     
     :param: message contains the message which needs to be displayed.
     */
    
    func showStyleAlert(_ message:String) {
        
        DispatchQueue.main.async(execute: {
            
            var importantAlert: UIAlertController!
            
            switch UIDevice.current.userInterfaceIdiom {
            case .phone:
                // It's an iPhone
                importantAlert = UIAlertController(title: "SHADOW", message:message as String, preferredStyle: .actionSheet)
                break
            case .pad:
                // It's an iPad
                importantAlert = UIAlertController(title: "SHADOW", message:message as String, preferredStyle: .alert)
                break
            default:
                break
            }
            
            importantAlert.addAction(UIAlertAction.init(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil))
            
            if let popoverPresentationController = importantAlert.popoverPresentationController {
                popoverPresentationController.sourceView = self.view
                popoverPresentationController.sourceRect = UIScreen.main.bounds
            }
            
           // Global.sharedInstance.kAppDelegate.window!.rootViewController?.present(importantAlert, animated: true, completion: nil)
            
        })
    }
 
    
    
    /**
     Please Wait is simply a loader , it starts whenever called.
     */
    
    func pleaseWait() {
        SwiftNotice.wait()
        NotificationCenter.default.addObserver(self, selector: #selector(self.rotatedForLoader), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
    }
    
    /**
     noticeOnlyText is shows toast when called.
     
     :param: text contains message to show.
     */
    
    func noticeOnlyText(_ text: String) {
        SwiftNotice.showText(text)
    }
    
    /**
     clearAllNotice is used to hide loaders.
     */
    
    func clearAllNotice() {
        DispatchQueue.main.async(execute: {
            
            SwiftNotice.clear()
            
        })
        
    }
    
    /**
     rotatedForLoader is used to centralise the loader if .
     */
    
    func rotatedForLoader(){
        SwiftNotice.updateView()
        self.setNeedsStatusBarAppearanceUpdate()
        
    }
    
    
    /**
     heightForView is used to calculate height for a label .
     */
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        
        
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        
        print(label.frame.height)
        
        return label.frame.height
        
    }
    
    func WidthForlbl(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        
        
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: CGFloat.greatestFiniteMagnitude, height: width))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        
        print(label.frame.width)
        
        return label.frame.width
        
    }
    
    func getMonthNameFromNumber(monthNumber: Int) -> String {
        
        
        let dateFormatter: DateFormatter = DateFormatter()
        
        let monthName = (((dateFormatter.monthSymbols) as NSArray).object(at: monthNumber - 1))
        
        return monthName as! String
        
    }
    
    func SetButtonCustomAttributes (_ button:UIButton)
    {
        button.backgroundColor = UIColor.white
        button.setTitleColor(Global.macros.themeColor_pink, for: .normal)
        button.layer.cornerRadius = 5.0
        button.layer.borderWidth = 1.0
        button.clipsToBounds = true;
        button.layer.borderColor = Global.macros.themeColor_pink.cgColor
     
    }
    
    
    func SetButtonCustomAttributesGrey (_ button:UIButton)
    {
        button.backgroundColor = UIColor.white
      //  button.setTitleColor(Global.macros.themeColor_pink, for: .normal)
        button.layer.cornerRadius = 5.0
        button.layer.borderWidth = 1.0
        button.clipsToBounds = true;
        button.layer.borderColor = Global.macros.themeColor_pink.cgColor
         button.titleLabel!.font =  UIFont.systemFont(ofSize: 18, weight: UIFontWeightThin)
         button.titleLabel!.font =  UIFont.systemFont(ofSize: 16, weight: UIFontWeightMedium)
        
    }
    
    func SetButtonCustomAttributesGreen (_ button:UIButton)
    {
        button.backgroundColor = UIColor.white
        button.setTitleColor(Global.macros.themeColor_Green , for: .normal)
        button.layer.cornerRadius = 5.0
        button.layer.borderWidth = 1.0
        button.clipsToBounds = true;
        button.layer.borderColor = Global.macros.themeColor_Green.cgColor
       // button.titleLabel!.font =  UIFont.systemFont(ofSize: 18, weight: UIFontWeightThin)
       // button.titleLabel!.font =  UIFont.systemFont(ofSize: 16, weight: UIFontWeightMedium)
        
    }
    
    
    
    func SetButtonCustomAttributesPurple (_ button:UIButton)
    {
        button.backgroundColor = Global.macros.themeColor_pink
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 5.0
        button.layer.borderWidth = 1.0
        button.clipsToBounds = true;
        button.layer.borderColor = UIColor.white.cgColor
        button.titleLabel!.font =  UIFont.systemFont(ofSize: 18, weight: UIFontWeightThin)
        button.titleLabel!.font =  UIFont.systemFont(ofSize: 16, weight: UIFontWeightMedium)
        
    }
    
    func SetButtonCustomAttributesPurpleGallery (_ button:UIButton)
    {
        button.backgroundColor = Global.macros.themeColor_pink
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 5.0
        button.layer.borderWidth = 1.0
        button.clipsToBounds = true;
        button.layer.borderColor = UIColor.white.cgColor
        button.titleLabel!.font =  UIFont.systemFont(ofSize: 14, weight: UIFontWeightThin)
        button.titleLabel!.font =  UIFont.systemFont(ofSize: 12, weight: UIFontWeightMedium)
        
    }
}

enum NoticeType{
    case success
    case error
    case info
}



/**
 SwiftNotice is used for various purpose like showing loaders , toasts etc
 */

class SwiftNotice: NSObject {
    
    static var mainViews = Array<UIView>()
    static let rv = Global.macros.AppWindow//
    static func clear() {
        for i in mainViews {
            i.removeFromSuperview()
        }
    }
    static func updateView(){
        for i in mainViews {
            i.center = rv.center
        }
        
    }
    static func wait() {
        
        let mainView = UIView(frame: CGRect(x: 0, y: 0, width: 6000 , height: 6000))
        mainView.layer.cornerRadius = 12
        mainView.backgroundColor = UIColor(red:0, green:0, blue:0, alpha: 0.4)
        
        let ai = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        ai.frame = CGRect(x: 21, y: 21, width: 36, height: 36)
        ai.startAnimating()
        ai.center = mainView.center
        mainView.addSubview(ai)
        
        mainView.center = rv.center
        rv.addSubview(mainView)
        
        mainViews.append(mainView)
    }
    
    static func showText(_ text: String) {
        let frame = CGRect(x: 0, y: 0, width: 200, height: 60)
        let mainView = UIView(frame: frame)
        mainView.layer.cornerRadius = 12
        mainView.backgroundColor = UIColor(red:0, green:0, blue:0, alpha: 0.8)
        
        let label = UILabel(frame: frame)
        label.text = text
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor.white
        mainView.addSubview(label)
        
        mainView.center = rv.center
        rv.addSubview(mainView)
        
        mainViews.append(mainView)
    }
    
    static func showNoticeWithText(_ type: NoticeType,text: String, autoClear: Bool) {
        let mainView = UIView(frame: CGRect(x: 0, y: 0, width: 90, height: 90))
        mainView.layer.cornerRadius = 10
        mainView.backgroundColor = UIColor(red:0, green:0, blue:0, alpha: 0.7)
        
        var image = UIImage()
        switch type {
        case .success:
            image = SwiftNoticeSDK.imageOfCheckmark
            break
        case .error:
            image = SwiftNoticeSDK.imageOfCross
            break
        case .info:
            image = SwiftNoticeSDK.imageOfInfo
            break
        }
        let checkmarkView = UIImageView(image: image)
        checkmarkView.frame = CGRect(x: 27, y: 15, width: 36, height: 36)
        mainView.addSubview(checkmarkView)
        
        let label = UILabel(frame: CGRect(x: 0, y: 60, width: 90, height: 16))
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.white
        label.text = text
        label.textAlignment = NSTextAlignment.center
        mainView.addSubview(label)
        
        mainView.center = rv.center
        rv.addSubview(mainView)
        
        mainViews.append(mainView)
        
        if autoClear {
            let selector = #selector(SwiftNotice.hideNotice(_:))
            self.perform(selector, with: mainView, afterDelay: 3)
        }
    }
    
    static func hideNotice(_ sender: AnyObject) {
        if sender is UIView {
            sender.removeFromSuperview()
        }
    }
}


/**
 SwiftNoticeSDK is used to create loader.
 */

class SwiftNoticeSDK {
    struct Cache {
        static var imageOfCheckmark: UIImage?
        static var imageOfCross: UIImage?
        static var imageOfInfo: UIImage?
    }
    
    
    /**
     draw is used to create loader.
     
     :param:  type Notice type object.
     */
    
    class func draw(_ type: NoticeType) {
        let checkmarkShapePath = UIBezierPath()
        
        // draw circle
        checkmarkShapePath.move(to: CGPoint(x: 36, y: 18))
        checkmarkShapePath.addArc(withCenter: CGPoint(x: 18, y: 18), radius: 17.5, startAngle: 0, endAngle: CGFloat(M_PI*2), clockwise: true)
        checkmarkShapePath.close()
        
        switch type {
        case .success: // draw checkmark
            checkmarkShapePath.move(to: CGPoint(x: 10, y: 18))
            checkmarkShapePath.addLine(to: CGPoint(x: 16, y: 24))
            checkmarkShapePath.addLine(to: CGPoint(x: 27, y: 13))
            checkmarkShapePath.move(to: CGPoint(x: 10, y: 18))
            checkmarkShapePath.close()
            break
        case .error: // draw X
            checkmarkShapePath.move(to: CGPoint(x: 10, y: 10))
            checkmarkShapePath.addLine(to: CGPoint(x: 26, y: 26))
            checkmarkShapePath.move(to: CGPoint(x: 10, y: 26))
            checkmarkShapePath.addLine(to: CGPoint(x: 26, y: 10))
            checkmarkShapePath.move(to: CGPoint(x: 10, y: 10))
            checkmarkShapePath.close()
            break
        case .info:
            checkmarkShapePath.move(to: CGPoint(x: 18, y: 6))
            checkmarkShapePath.addLine(to: CGPoint(x: 18, y: 22))
            checkmarkShapePath.move(to: CGPoint(x: 18, y: 6))
            checkmarkShapePath.close()
            
            UIColor.white.setStroke()
            checkmarkShapePath.stroke()
            
            let checkmarkShapePath = UIBezierPath()
            checkmarkShapePath.move(to: CGPoint(x: 18, y: 27))
            checkmarkShapePath.addArc(withCenter: CGPoint(x: 18, y: 27), radius: 1, startAngle: 0, endAngle: CGFloat(M_PI*2), clockwise: true)
            checkmarkShapePath.close()
            
            UIColor.white.setFill()
            checkmarkShapePath.fill()
            break
        }
        
        UIColor.white.setStroke()
        checkmarkShapePath.stroke()
    }
    
    /**
     imageOfCheckmark is used to create Image used in loader.
     */
    
    class var imageOfCheckmark: UIImage {
        if (Cache.imageOfCheckmark != nil) {
            return Cache.imageOfCheckmark!
        }
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 36, height: 36), false, 0)
        
        SwiftNoticeSDK.draw(NoticeType.success)
        
        Cache.imageOfCheckmark = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return Cache.imageOfCheckmark!
    }
    
    /**
     imageOfCross is used to create cross Image used in loader.
     */
    
    class var imageOfCross: UIImage {
        if (Cache.imageOfCross != nil) {
            return Cache.imageOfCross!
        }
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 36, height: 36), false, 0)
        
        SwiftNoticeSDK.draw(NoticeType.error)
        
        Cache.imageOfCross = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return Cache.imageOfCross!
    }
    
    /**
     imageOfInfo is used to create cross Image used in loader.
     */
    
    class var imageOfInfo: UIImage {
        if (Cache.imageOfInfo != nil) {
            return Cache.imageOfInfo!
        }
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 36, height: 36), false, 0)
        
        SwiftNoticeSDK.draw(NoticeType.info)
        
        Cache.imageOfInfo = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return Cache.imageOfInfo!
    }
    
}
extension UINavigationBar {
    
    func setBottomBorderColor(color: UIColor) {
        
        let navigationSeparator = UIView(frame: CGRect(x: 0, y: self.frame.size.height - 0.5, width: self.frame.size.width, height: 0.5 ))
            
            //UIView(frame: CGRectMake(0, self.frame.size.height - 0.5, self.frame.size.width, 0.5))
        navigationSeparator.backgroundColor = color
        navigationSeparator.isOpaque = true
        navigationSeparator.tag = 123
        if let oldView = self.viewWithTag(123) {
            oldView.removeFromSuperview()
        }
        self.addSubview(navigationSeparator)
        
    }
}
