//
//  CustomCollectionViewCell.swift
//  SliderView
//
//  Created by Atinderjit Kaur on 27/06/17.
//  Copyright © 2017 Atinderjit Kaur. All rights reserved.
//

import UIKit
import Charts

class CustomCollectionViewCell: UICollectionViewCell {
    
    var months: [String]!

    @IBOutlet weak var btn_Company: UIButton!
    @IBOutlet weak var topCollectionView: NSLayoutConstraint!
    @IBOutlet weak var btn_PlayVideo:            UIButton!
    @IBOutlet weak var kHeight_BehindDetailView: NSLayoutConstraint!
    @IBOutlet weak var customScrollView:         UIScrollView!
    @IBOutlet var view_OnScrollView:             UIView!
    @IBOutlet var imgView_Star1:                 UIImageView!
    @IBOutlet var imgView_Star2:                 UIImageView!
    @IBOutlet var imgView_Star3:                 UIImageView!
    @IBOutlet var imgView_Star4:                 UIImageView!
    @IBOutlet var imgView_Star5:                 UIImageView!
    @IBOutlet var imgView_ProfilePic:            UIImageView!
    @IBOutlet var btn_SocialSite1:               UIButton!
    @IBOutlet var btn_SocialSite2:               UIButton!
    @IBOutlet var btn_SocialSite3:               UIButton!
    @IBOutlet var view_Fields:                   UIView!
    @IBOutlet var lbl_CompanySchoolUserName:     UILabel!
    @IBOutlet var lbl_Location:                  UILabel!
    @IBOutlet var lbl_Url:                       UILabel!
    @IBOutlet var lbl_Count_ShadowersVerified:   UILabel!
    @IBOutlet var lbl_Count_ShadowedByShadowUser: UILabel!
    @IBOutlet var lbl_Count_CompanySchoolWithOccupations: UILabel!
    @IBOutlet var lbl_Count_NumberOfUsers:       UILabel!
    @IBOutlet weak var lbl_Description:          UILabel!
    @IBOutlet weak var kHeightProfileView:       NSLayoutConstraint!
    @IBOutlet weak var view_BehindTxtView:       UIView!
    @IBOutlet weak var view_BehindProfile:       UIView!
    @IBOutlet weak var btn_ViewFullProfile:      UIButton!
    @IBOutlet var btn_OpenUrl:                   UIButton!
    @IBOutlet weak var lbl_occupation:           UILabel!
    @IBOutlet weak var lbl_attend:               UILabel!
    @IBOutlet weak var view_line:                UIView!
    @IBOutlet weak var view_BehindNumericTems:   UIView!
    @IBOutlet weak var lbl_RatingFloat:          UILabel!
    @IBOutlet var tbl_View_SocialSite:           UITableView!
    @IBOutlet var k_Constraint_Height_TableviewSocialSite:   NSLayoutConstraint!
    @IBOutlet var k_Constraint_Top_tblViewSocialSite:        NSLayoutConstraint!
    @IBOutlet var k_Constraint_Top_imageViewUrl:             NSLayoutConstraint!
    @IBOutlet var k_Constraint_Top_btnUrl:                   NSLayoutConstraint!
    @IBOutlet var k_Constraint_Top_labelUrl:                 NSLayoutConstraint!
    @IBOutlet var k_Constraint_ViewDescriptionHeight:        NSLayoutConstraint!
    @IBOutlet var imgView_Url:                   UIImageView!
    @IBOutlet var imgView_Location:              UIImageView!
    @IBOutlet var lbl_totalRatingCount:          UILabel!
    @IBOutlet weak var btn_Shadow:               UIButton!
    @IBOutlet weak var kleadingshadowbtn:        NSLayoutConstraint!
    @IBOutlet weak var kwidthShadowbtn:          NSLayoutConstraint!
    @IBOutlet weak var k_leading_calendericon:   NSLayoutConstraint!
    //Outlets for occupation view
    
    @IBOutlet weak var view_MainOccupation:    UIView!
    @IBOutlet weak var lbl_Rating:             UILabel!
    @IBOutlet weak var lbl_avgSalary:          UILabel!
    @IBOutlet weak var lbl_Growth:             UILabel!
    @IBOutlet weak var lbl_UserWithOccupation: UILabel!
    @IBOutlet weak var txtView_Description:    UILabel!
    @IBOutlet weak var lbl_UserShadowed:       UILabel!
    
    @IBOutlet weak var barChartView:           BarChartView!
    @IBOutlet weak var lbl_Abt:                UILabel!
    @IBOutlet weak var lbl_RatingCount:        UILabel!
    @IBOutlet weak var btn_Rating:             UIButton!
    
    @IBOutlet weak var lbl_ShadowOthers: UILabel!
    
    @IBOutlet weak var kheightdescription: NSLayoutConstraint!
    
    @IBOutlet weak var kheightShadowBtn: NSLayoutConstraint!
    @IBOutlet weak var kwidthShadowBtn: NSLayoutConstraint!
    
    @IBOutlet weak var ktopCalenderIcon: NSLayoutConstraint!
    //chat
    @IBOutlet weak var ktopShadowTextt: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        DispatchQueue.main.async {
            

            if Global.DeviceType.IS_IPHONE_6{

                self.k_leading_calendericon.constant = 22
                self.kleadingshadowbtn.constant = 12
                self.kwidthShadowBtn.constant = 97
                self.ktopCalenderIcon.constant  = 95
                self.ktopShadowTextt.constant  = 95
                self.kheightShadowBtn.constant = 34
            }

         if Global.DeviceType.IS_IPHONE_X {

//                self.kwidthShadowbtn.constant = 98
               self.k_leading_calendericon.constant = 22
               self.kleadingshadowbtn.constant = 12
                self.kwidthShadowBtn.constant = 97
                self.ktopCalenderIcon.constant  = 95
                self.ktopShadowTextt.constant  = 95
                self.kheightShadowBtn.constant = 34

                self.topCollectionView.constant = 130
            }
            
            else  if Global.DeviceType.IS_IPHONE_6P {
                
                //                self.kwidthShadowbtn.constant = 98
                self.k_leading_calendericon.constant = 30
                self.kleadingshadowbtn.constant = 18
            }
            
          
            self.btn_Shadow.layer.cornerRadius = 8.0
            self.btn_Shadow.clipsToBounds = true
            self.barChartView.xAxis.drawGridLinesEnabled = false
            self.barChartView.rightAxis.drawGridLinesEnabled = false
            self.barChartView.rightAxis.drawAxisLineEnabled = false
            self.barChartView.rightAxis.drawLabelsEnabled = false
            self.barChartView.leftAxis.drawGridLinesEnabled = false
            self.barChartView.leftAxis.drawAxisLineEnabled = false
            self.barChartView.leftAxis.drawLabelsEnabled = false
            self.barChartView.xAxis.drawAxisLineEnabled = false
            self.barChartView.xAxis.drawLabelsEnabled = false
            self.barChartView.legend.enabled = false
            self.barChartView.highlightPerTapEnabled = false
            self.barChartView.highlightFullBarEnabled = false
            self.barChartView.chartDescription?.text = ""

              self.barChartView.isUserInteractionEnabled = false
            
            self.imgView_ProfilePic.layer.cornerRadius = 60.0
            self.imgView_ProfilePic.clipsToBounds = true
            
            self.customView(view: self.view_BehindTxtView)
            self.customView(view: self.view_BehindProfile)
            self.customView(view: self.view_BehindNumericTems)

            
        }
    }
    
    func customView(view : UIView) {
        
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        view.layer.borderColor = UIColor.init(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 0.5).cgColor
        view.layer.borderWidth = 1.0
        
    }
    
    func setChart() {
        
        let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        let unitsSold = [20.0, 4.0, 3.0, 6.0, 12.0, 16.0, 4.0, 18.0, 2.0, 4.0, 5.0, 4.0]
        barChartView.setBarChartData(xValues: months, yValues: unitsSold, label: "")
        
    }
    
 
}




