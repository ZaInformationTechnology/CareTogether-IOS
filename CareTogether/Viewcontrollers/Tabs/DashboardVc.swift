//
//  DashboardVc.swift
//  CareTogether
//
//  Created by HeinHtet on 29/03/2020.
//  Copyright © 2020 HEINHTET. All rights reserved.
//

import BlueSwift
import UIKit
import CoreBluetooth
import RealmSwift
import Localize_Swift

class DashboardVc: BaseVc {
    
    @IBOutlet weak var constLyErrorAlertHeight: NSLayoutConstraint!
    @IBOutlet weak var ivFoundUser: UIImageView!
    @IBOutlet weak var lbFoundUserMessage: UILabel!
    @IBOutlet weak var lbErrorAlertMessage: UILabel!
    @IBOutlet weak var lyErrorAlertView: RoundCardView!
    @IBOutlet weak var lyPhoneToolbar: PhoneToolbar!
    @IBOutlet weak var lyCardDashboard: UIView!
    @IBOutlet weak var lyDashboardView: UIView!
    @IBOutlet weak var lyPermissionDeniedView: ServiceView!
    var allServiceAreAvaliable = false
    var timerIsStarted = false
    var fetchNearBlueToothDeivceTImer : Timer?
    var alradyAdvertised  = false
    @IBOutlet weak var lbWarningTitle: UILabel!
    @IBOutlet weak var lbWarningMessage: UILabel!
    @IBOutlet weak var ivWarning: UIImageView!
    let useCase = AnalyticsUseCase()
    
    @IBOutlet weak var lyStackInfoAndTerm: UIStackView!
    @IBOutlet weak var lyCardWarningInfo: RoundCardView!
    
    @IBOutlet weak var lbTitleDashboard: UILabel!
    
    var countFromDb = 0
    var countFromAPI  = 0
    
    
    @IBOutlet weak var lbUserCount: UILabel!
    @IBAction func btnLogout(_ sender: Any) {
        Store.instance.setPhoneNumber(phone: "")
        Router.instance.navigate(routeName: "PhoneVerifyVc", storyboard: "Main")
    }
    
    @IBOutlet weak var btnLogout: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        lyPhoneToolbar.delegate = self
        
        refreshTrackingDb()
        TrackDbUtils.instance.delegate = self
        initComponent()
        virusWarningApiCall()
        
    }
    
    
    @IBOutlet weak var btnInformation: UIButton!
    @IBOutlet weak var btnAppInfo: UIButton!
    func initComponent(){
        lbWarningTitle.text = "dashboard_normal_title".localized()
        lbWarningMessage.text = "dashboard_info_for_description".localized()
        lbFoundUserMessage.text = "dashboard_info_with_touch_people".localized()
        initForLocalized()
        
    }
    
    
    func initForLocalized(){
        btnAppInfo.setTitle("text_app_info".localized(), for: .normal)
        btnInformation.setTitle("text_term".localized(), for: .normal)
        lbTitleDashboard.text = "dashboard_title".localized()

    }
    
    
    func refreshTrackingDb(){
        
        checkFoundUserFromDb()
        
        
    }
    
    @IBAction func btnPressedTerm(_ sender: Any) {
     //   let vc   = storyboard?.instantiateViewController(identifier: "TermVc") as! TermVc
        //self.navigationController?.pushViewController(vc, animated: true)
        
        let webView = storyboard?.instantiateViewController(identifier: "ToolbarWebVc") as! ToolbarWebVc
             
             webView.url = "\(Const.instance.PRIVACY_URL)?language=\(getLocaleName())"
             webView.hideToolbar = false
             webView.toolbarTitle = "text_term".localized()
             self.navigationController?.pushViewController(webView, animated: true)
        
    }
    
    
    
    @IBAction func btnPressedInfo(_ sender: Any) {
     //   let vc   = storyboard?.instantiateViewController(identifier: "AboutVc") as! AboutVcViewController
        let webView = storyboard?.instantiateViewController(identifier: "ToolbarWebVc") as! ToolbarWebVc
        webView.url = "\(Const.instance.ABOUT_URL)?language=\(getLocaleName())"
        webView.hideToolbar = false
        webView.toolbarTitle = "text_app_info".localized()
        self.navigationController?.pushViewController(webView, animated: true)
        
        
    }

    
    func getLocaleName () -> String{
        var language = Store.instance.getCurrentLanguage()?.locale
        if(language == nil){
            language = "mm"
        }
        return language!
    }
    
    
    @objc func changeLocalelized(){
        showCount(count: countFromDb)
        showWarningInfo(count: self.countFromAPI)
        initForLocalized()
        
    }
    
    func checkFoundUserFromDb(){
        let realm = try! Realm()
        let trackingList = realm.objects(TrackModel.self)
        print("after data changed \(trackingList)")
        if  trackingList.count > 0 {
            self.showCount(count: trackingList.count)
            self.countFromDb = trackingList.count
        }else {
            DispatchQueue.main.async {
                self.lbUserCount.isHidden = true
            }
        }
        
    }
    
    
    func showCount(count : Int){
        DispatchQueue.main.async {
            self.ivFoundUser.image = UIImage(named: "ic_rader")
            //            self.lbUserCount.isHidden = false
            self.lbUserCount.text = String(count)
            self.lbFoundUserMessage.text = "dashboard_info_with_touched_people".localizedFormat(String(count))
        }
    }
    
    
    func virusWarningApiCall(){
        if Reachability.isConnectedToNetwork() {
            useCase.fetchCountForUserr { (state) in
                switch state  {
                case .CountSuccess(let response) :
                    self.showWarningInfo(count : response.count)
                default :
                    print("other")
                }
            }
        }
        
    }
    
    
    func showWarningInfo(count : Int){
        if(count > 0){
            lbWarningMessage.textColor = .white
            lbWarningTitle.textColor = .white
            lyCardWarningInfo.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            lbWarningMessage.textAlignment = .left
            lbWarningTitle.text = "dashboard_warning_info_title".localizedFormat(String(count))
            lbWarningMessage.text = "dashboard_warning_message".localized()
            self.ivWarning.image = UIImage(named: "ic_virus")
            self.countFromAPI = count
            
        }else{
            lyCardWarningInfo.backgroundColor = .white
            self.ivWarning.image = UIImage(named: "green_tick")
            lbWarningMessage.textColor = .black
            lbWarningTitle.textColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            lbWarningMessage.text = "dashboard_normal_message".localized()
            lbWarningTitle.text = "dashboard_normal_warning_title".localized()
            lbFoundUserMessage.text = "dashboard_info_with_touch_people".localized()
        }
    }
    
    
    func startFindDevice()  {
        timerIsStarted = true
        
        if !alradyAdvertised {
            alradyAdvertised = true
            turnOn()
        }
        
        fetchNearBlueToothDeivceTImer?.invalidate()
        fetchNearBlueToothDeivceTImer = Timer.scheduledTimer(timeInterval: 180, target: self, selector: #selector(startFindCT), userInfo: nil, repeats: true)
        startScan()
    }
    
    func stopFindDevice()  {
        timerIsStarted = false
        fetchNearBlueToothDeivceTImer?.invalidate()
    }
    
    
    @objc func startFindCT()
    {
        print("Start Find")
        startScan()
        self.currentLocation = locationManager?.location
    }
    
}


extension DashboardVc : BaseManagerDelegate {
    func serviceChanged(locationIsOn: Bool, bluetoothIsOn: Bool) {
        print("service changed \(locationIsOn) bluetooth is on \(bluetoothIsOn)")
        self.allServiceAreAvaliable = locationIsOn && bluetoothIsOn
        if(allServiceAreAvaliable){
            if(!timerIsStarted){
                startFindDevice()
                startScan()
            }
            self.lyPermissionDeniedView.isHidden = true
            self.lyDashboardView.isHidden = false
            self.lyErrorAlertView.isHidden = true
            self.constLyErrorAlertHeight.constant = 0
        }else{
            showPermissionErrorLayout(locationOn: locationIsOn, bluetoothOn: bluetoothIsOn)
            stopFindDevice()
            scanStop()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(changeLocalelized), name: NSNotification.Name( LCLLanguageChangeNotification), object: nil)
        lyPhoneToolbar.checkLanguage()
    }
    
    func showPermissionErrorLayout(locationOn : Bool,bluetoothOn : Bool){
//        var message = ""
//        if !allServiceAreAvaliable {
//            message = Const.instance.permissionRequestBleAndLocation
//        }
//        if !bluetoothOn {
//            message = Const.instance.perimssionRequestBle
//        }
//
//        if !locationOn {
//            message = Const.instance.permissionRequestLocation
//        }
//
//        self.lyPermissionDeniedView.isHidden = false
//        self.lyDashboardView.isHidden = true
//        self.lyPermissionDeniedView.lbErrorMessage.text = message
        
            
        lyErrorAlertView.isHidden = false
        constLyErrorAlertHeight.constant = 110
        lbErrorAlertMessage.text = "permission_error_alert_message".localized()
    }
}



extension DashboardVc : DatabaseCallback {
    func dataChanged(result: Results<TrackModel>) {
        print("data changed \(result)")
        self.checkFoundUserFromDb()
        
    }
    
    func changed() {
        self.checkFoundUserFromDb()
    }
    
}

extension DashboardVc : PhoneToolbarCallback{
    func goSettingVc() {
        self.navigationController?.pushViewController(storyboard?.instantiateViewController(identifier: "SettingVc") as! SettingVc, animated: true)
    }

    func goPPLVc() {
        
    }
    
    func goInfoVc() {
        self.navigationController?.pushViewController(storyboard?.instantiateViewController(identifier: "ShareHealthVc") as! ShareHealthVc, animated: true)
    }
}
