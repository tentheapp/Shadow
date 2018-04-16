//
//  OccupationDetailViewController.swift
//  Shadow
//
//  Created by Atinderjit Kaur on 22/08/17.
//  Copyright © 2017 Atinderjit Kaur. All rights reserved.
//

import UIKit
import Charts

var bool_FromOccupation : Bool = false


class OccupationDetailViewController: UIViewController {
    
    
    @IBOutlet weak var barChartView:          BarChartView!
    @IBOutlet weak var lbl_avgRating:         UILabel!
    @IBOutlet weak var lbl_AvgSalary:         UILabel!
    @IBOutlet weak var lbl_GrowthPercentage:  UILabel!
    @IBOutlet weak var lbl_UsersWithThisOccupation:  UILabel!
    @IBOutlet weak var lbl_UserThatShadowedThis:     UILabel!
    @IBOutlet weak var txtfield_Occupation:          UILabel!
    @IBOutlet weak var scroll_View:                  UIScrollView!
    @IBOutlet weak var collectionViewCompany:        UICollectionView!
    @IBOutlet weak var collectionViewSchool:         UICollectionView!
    var dic_Occupation = NSMutableDictionary()
    
    var arr_school =                             NSMutableArray()
    var arr_company =                            NSMutableArray()
    
    var arr_NoOfEmployees =                      NSMutableArray() //x axis
    var arr_Salary =                             NSMutableArray() //y axis
    
    var occupationId :                           NSNumber?
    @IBOutlet weak var kheightViewBehindCompany: NSLayoutConstraint!
    @IBOutlet weak var kheightViewBehindSchool:  NSLayoutConstraint!
    @IBOutlet weak var kHeightCC:                NSLayoutConstraint!
    @IBOutlet weak var kHeightSC:                NSLayoutConstraint!
    @IBOutlet weak var kheight_DescriptionView:  NSLayoutConstraint!
    @IBOutlet weak var kHeightlblDescription:    NSLayoutConstraint!
    @IBOutlet weak var lbl_RatingCount:          UILabel!
    @IBOutlet weak var lbl_About:                UILabel!
    
    var user_id :                                NSNumber?
    var rating_number  :                         String?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.barChartView.xAxis.drawGridLinesEnabled =     false
        self.barChartView.rightAxis.drawGridLinesEnabled = false
        self.barChartView.rightAxis.drawAxisLineEnabled =  false
        self.barChartView.rightAxis.drawLabelsEnabled =    false
        self.barChartView.leftAxis.drawGridLinesEnabled =  false
        self.barChartView.leftAxis.drawAxisLineEnabled =   false
        self.barChartView.leftAxis.drawLabelsEnabled =     false
        self.barChartView.xAxis.drawAxisLineEnabled =      false
        self.barChartView.xAxis.drawLabelsEnabled =        false
        self.barChartView.legend.enabled =                 false
        self.barChartView.highlightPerTapEnabled =         false
        self.barChartView.highlightFullBarEnabled =        false
        self.barChartView.chartDescription?.text =         ""
        self.barChartView.isUserInteractionEnabled = false
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        let myBackButton:UIButton = UIButton()
        myBackButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        myBackButton.setImage(UIImage(named:"back-new"), for: UIControlState())
        myBackButton.addTarget(self, action: #selector(self.PopTo_RootViewController), for: UIControlEvents.touchUpInside)
        let leftBackBarButton:UIBarButtonItem = UIBarButtonItem(customView: myBackButton)
        self.navigationItem.leftBarButtonItem = leftBackBarButton
        
        // Do any additional setup after loading the view.
        
    }
    
    func PopTo_RootViewController()
    {
        bool_FromOccupation = false
        bool_UserIdComingFromSearch = false
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        if self.revealViewController() != nil {
            
            self.revealViewController().panGestureRecognizer().isEnabled = false
            self.revealViewController().tapGestureRecognizer().isEnabled = false
            
        }
        self.tabBarController?.tabBar.isHidden = true
        self.tabBarController?.tabBar.isTranslucent = true
        DispatchQueue.main.async {
            self.GetData()
        }
        
    }
    
    //MARK: API CALL
    func GetData() {
        
        let dict = NSMutableDictionary()
        dict.setValue(SavedPreferences.value(forKey: Global.macros.kUserId) as? NSNumber, forKey: Global.macros.kUserId)
        dict.setValue(occupationId, forKey: "occupationId")
        
        print(dict)
        
        if self.checkInternetConnection(){
            
            DispatchQueue.main.async {
                self.pleaseWait()
            }
            
            
            ProfileAPI.sharedInstance.OccupationDetail(dict: dict, completion: { (response) in
                print(response)
                DispatchQueue.main.async {
                    self.clearAllNotice()
                }
                
                let status = response.value(forKey: "status") as? NSNumber
                switch(status!){
                    
                case 200:
                    print(response)
                    
                    self.dic_Occupation = (response.value(forKey: "data") as! NSDictionary).mutableCopy() as! NSMutableDictionary
                    DispatchQueue.main.async {
                        
                        self.navigationItem.title = (self.dic_Occupation.value(forKey: "name") as? String)?.capitalized
                        self.lbl_About.text = "About" + " " + ((self.dic_Occupation.value(forKey: "name") as? String)?.capitalized)!
                       self.rating_number = "\((self.dic_Occupation.value(forKey: "avgRating")!))"
                        
                        let dbl = 2.0
                        
                        if  dbl.truncatingRemainder(dividingBy: 1) == 0
                        {
                            self.lbl_avgRating.text = self.rating_number! + ".0"
                            
                        }
                        else {
                            
                            self.lbl_avgRating.text = self.rating_number!
                            
                        }
                        
                        
                        
                        
                        self.lbl_RatingCount.text = "\((self.dic_Occupation.value(forKey: "ratingCount")!))"
                        
                         self.user_id =  self.dic_Occupation.value(forKey: "id") as? NSNumber
                        
                        
                        if self.dic_Occupation["users"]  != nil {
                        let arr = self.dic_Occupation["users"] as! NSArray
                        
                       if  arr.count > 0{
                        
                        
                            self.lbl_UsersWithThisOccupation.text = "\((arr[0] as! NSDictionary).value(forKey: "count")!)"

                        
                        }
                            
                        }

                        
                        self.txtfield_Occupation.text = (self.dic_Occupation.value(forKey: "description") as? String)
                        
                        
                        let growth = self.dic_Occupation.value(forKey: "growth") as? String
                        
                        if growth != "" && growth != nil {
                            self.lbl_GrowthPercentage.text = growth! + "%"
                        }
                        else {
                            self.lbl_GrowthPercentage.text = "0%"
                            
                        }
                        
                        DispatchQueue.main.async {
                            self.txtfield_Occupation.frame.size.height = self.txtfield_Occupation.intrinsicContentSize.height
                            self.kheight_DescriptionView.constant = self.txtfield_Occupation.frame.size.height + 42
                        }
                        
                        if self.dic_Occupation.value(forKey: "salary") != nil {
                        let morePrecisePI = Double((self.dic_Occupation.value(forKey: "salary") as? String)!)
                        
                        let myInteger = Int(morePrecisePI!)
                        let myNumber = NSNumber(value:myInteger)
                        print(myNumber)
                        self.lbl_AvgSalary.text = self.suffixNumber(number: myNumber) as String
                        }
                        
                        else{
                            self.lbl_AvgSalary.text = "0.0"
                            
                        }
                        
                        
                        
                        if self.dic_Occupation.value(forKey: "companys") != nil {
                            self.arr_company = (self.dic_Occupation.value(forKey: "companys") as! NSArray).mutableCopy() as! NSMutableArray
                            print("atinder")
                            print( self.arr_company)
                            
                        }
                        if  self.arr_company.count == 0 {
                            
                            self.collectionViewCompany.isHidden = true
                        }
                        
                        else {
                            
                            self.collectionViewCompany.isHidden = false
                        }
                        
                        if self.dic_Occupation.value(forKey: "schools") != nil {
                            self.arr_school = (self.dic_Occupation.value(forKey: "schools") as! NSArray).mutableCopy() as! NSMutableArray
                        }
                        if self.arr_school.count == 0 {
                            
                            self.collectionViewSchool.isHidden = true
                        }
                        else {
                            self.collectionViewSchool.isHidden = false

                            
                        }
                        
                        self.setChart()
                        
                        self.collectionViewSchool.reloadData()
                        self.collectionViewCompany.reloadData()
                    }
                    
                    break
                    
                case 404:
                    DispatchQueue.main.async {
                        self.collectionViewSchool.isHidden = true
                        self.collectionViewCompany.isHidden = false
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
    
    func suffixNumber(number:NSNumber) -> NSString {
        
        var num:Double = number.doubleValue;
        let sign = ((num < 0) ? "-" : "" );
        
        num = fabs(num);
        
        if (num < 1000.0){
            return "\(sign)\(num)" as NSString;
        }
        
        let exp:Int = Int(log10(num) / 3.0 ); //log10(1000));
        
        let units:[String] = ["K","M","G","T","P","E"];
        
        let roundedNum:Double = round(10 * num / pow(1000.0,Double(exp))) / 10;
        
        return "\(sign)\(roundedNum)\(units[exp-1])" as NSString;
    }
    
    
    func setChart() {
        
        let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        let unitsSold = [20.0, 4.0, 3.0, 6.0, 12.0, 16.0, 4.0, 18.0, 2.0, 4.0, 5.0, 4.0]
        barChartView.setBarChartData(xValues: months, yValues: unitsSold, label: "")
        
    }
    
    
    //MARK : ACTIONS
    
    
    @IBAction func ActionList(_ sender: UIButton) {
        
        var type:String?
        var navigation_title:String?
        
        if sender.tag == 1{//shadowers
            
            type = Global.macros.kShadow
            navigation_title =  "Shadowers"
            let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "listing") as! ListingViewController
            vc.ListuserId = self.user_id
            vc.navigation_title = "Users with this occupation"
            vc.comingFromOcc = true
            _ = self.navigationController?.pushViewController(vc, animated: true)
            
            
        } else if sender.tag == 2{ //shadowed
            
            type = Global.macros.kShadowed
            navigation_title = "Shadowed Users"
            
        }
    }
    
    @IBAction func RatingList(_ sender: Any) {
        
        DispatchQueue.main.async {
           
        bool_FromOccupation = true
        let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "ratingView") as! RatingViewController
        vc.occ_id = self.user_id
        vc.title_occ = (self.dic_Occupation.value(forKey: "name") as? String)?.capitalized
        _ = self.navigationController?.pushViewController(vc, animated: true)
 
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
   
    
}
extension OccupationDetailViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 8
        let size:CGSize?
        if Global.DeviceType.IS_IPHONE_6 || Global.DeviceType.IS_IPHONE_6P || Global.DeviceType.IS_IPHONE_X {
            size = CGSize(width: ((collectionView.frame.width/3 - 5) ), height: 45)
        }
        else{
            
            size = CGSize(width: ((collectionView.frame.width/2 - 5) ), height: 45)
            
        }
        return size!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        var cell = UICollectionViewCell()
        
        if collectionView == collectionViewCompany {
            
            let company_cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "company", for: indexPath)as! CompanyCollectionViewCell
            
            if arr_company.count > 0 {
                
                if  let dict =  (arr_company[indexPath.row] as! NSDictionary).value(forKey: "userDTO") as? NSDictionary {
                    DispatchQueue.main.async {
                        //let dict = (self.arr_company[indexPath.row]as! NSDictionary).value(forKey: "userDTO") as! NSMutableDictionary
                        
                        company_cell.lbl_CompanyName.text = dict.value(forKey: "companyName") as? String
                        
                    }
                    
                }
            }
            
            cell = company_cell
            
        }
        
        if collectionView == collectionViewSchool{
            let school_cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "school", for: indexPath)as! SchoolCollectionViewCell
            
            if arr_school.count > 0 {
                if  let dict =  (arr_school[indexPath.row]as! NSDictionary).value(forKey: "userDTO") as? NSDictionary {
                    DispatchQueue.main.async {
                        
                        
                        school_cell.lbl_SchoolName.text = dict.value(forKey: "schoolName") as? String
                    }
                }
            }
            
            cell = school_cell
            
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        var count:Int?
        
        if collectionView == collectionViewCompany{
            
            count = arr_company.count
            if count! <= 2 {
                self.kheightViewBehindCompany.constant = 100
                
            }
                
                
            else if count == 4 {
                self.kheightViewBehindCompany.constant = 150
                
            }
            else {
                
                DispatchQueue.main.async {
                    
                    self.kHeightCC.constant =  self.collectionViewCompany.contentSize.height
                    self.kheightViewBehindCompany.constant =  self.collectionViewCompany.contentSize.height + 35
                }
            }
            
            if Global.DeviceType.IS_IPHONE_5 {
                
                if count == 3 {
                    self.kheightViewBehindCompany.constant = 150
                    
                }
                
                
            }
            
            
        }
        
        if collectionView == collectionViewSchool{
            
            count = arr_school.count
            if count! <= 2 {
                self.kheightViewBehindSchool.constant = 100
            }
            else if count == 4 {
                self.kheightViewBehindSchool.constant = 150
                
            }
            else {
                DispatchQueue.main.async {
                    
                    self.kHeightSC.constant =  self.collectionViewSchool.contentSize.height
                    self.kheightViewBehindSchool.constant =  self.collectionViewSchool.contentSize.height + 35
                }
                
            }
            
            if Global.DeviceType.IS_IPHONE_5 {
                
                if count == 3 {
                    self.kheightViewBehindSchool.constant = 150
                    
                }
            }
        }
        
        DispatchQueue.main.async {

            self.scroll_View.contentSize = CGSize(width: self.view.frame.size.width, height: 500 + self.kheight_DescriptionView.constant + self.kheightViewBehindCompany.constant + self.kheightViewBehindSchool.constant)
       
        }
        
        return count!
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        bool_UserIdComingFromSearch = true
        let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "company") as! ComapanySchoolViewController

        
        if collectionView == collectionViewCompany {
            if  let dict =  (arr_company[indexPath.row] as! NSDictionary).value(forKey: "userDTO") as? NSDictionary {
                let dic = dict.value(forKey: "companyDTO") as? NSDictionary
                vc.userIdFromSearch = dic?.value(forKey: "companyUserId") as? NSNumber
            }
        }
            
        else {
            
            if  let dict =  (arr_school[indexPath.row] as! NSDictionary).value(forKey: "userDTO") as? NSDictionary {
                let dic = dict.value(forKey: "schoolDTO") as? NSDictionary

                vc.userIdFromSearch = dic?.value(forKey: "schoolUserId") as? NSNumber
            }
        }
        
        _ = self.navigationController?.pushViewController(vc, animated: true)
        
        
        
    }
}


extension BarChartView {
    
    class BarChartFormatter: NSObject, IAxisValueFormatter {
        
        var labels: [String] = []
        
        func stringForValue(_ value: Double, axis: AxisBase?) -> String {
            return labels[Int(value)]
        }
        
        init(labels: [String]) {
            super.init()
            self.labels = labels
        }
    }
    
    func setBarChartData(xValues: [String], yValues: [Double], label: String) {
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<yValues.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: yValues[i])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: label)
        let color = UIColor.init(red: 242.0/255.0, green: 105.0/255.0, blue: 78.0/255.0, alpha: 1.0)
        chartDataSet.setColors(color)
        chartDataSet.drawValuesEnabled = false
        
        let chartData = BarChartData(dataSet: chartDataSet)
        
        let chartFormatter = BarChartFormatter(labels: xValues)
        let xAxis = XAxis()
        xAxis.valueFormatter = chartFormatter
        self.xAxis.valueFormatter = xAxis.valueFormatter
        
        self.data = chartData
        
        
    }
}

