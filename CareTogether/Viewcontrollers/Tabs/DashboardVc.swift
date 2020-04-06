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

class DashboardVc: BaseVc {
    
    @IBOutlet weak var ivFoundUser: UIImageView!
    @IBOutlet weak var lbFoundUserMessage: UILabel!
    
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
    
    @IBOutlet weak var lyCardWarningInfo: RoundCardView!
    @IBOutlet weak var lbUserCount: UILabel!
    @IBAction func btnLogout(_ sender: Any) {
        Store.instance.setPhoneNumber(phone: "")
        Router.instance.navigate(routeName: "PhoneVerifyVc", storyboard: "Main")
    }
    
    @IBOutlet weak var btnLogout: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        refreshTrackingDb()
        TrackDbUtils.instance.delegate = self
        
        virusWarningApiCall()
        
    }
    
    
    func refreshTrackingDb(){
        
        checkFoundUserFromDb()
        
        
    }
    
    
    func checkFoundUserFromDb(){
        let realm = try! Realm()
        let trackingList = realm.objects(TrackModel.self)
        print("after data changed \(trackingList)")
        if  trackingList.count > 0 {
            self.showCount(count: trackingList.count)
        }else {
            DispatchQueue.main.async {
                self.lbUserCount.isHidden = true
            }
        }
        
    }
    
    
    func showCount(count : Int){
        DispatchQueue.main.async {
            self.ivFoundUser.image = UIImage(named: "ic_rader")
            self.lbUserCount.isHidden = false
            self.lbUserCount.text = String(count)
            self.lbFoundUserMessage.text = Const.instance.sawPerson
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
            lbWarningTitle.text = Const.instance.indentifiedCount(count: count)
            lbWarningMessage.text = Const.instance.safeInfo
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
        }else{
            showPermissionErrorLayout(locationOn: locationIsOn, bluetoothOn: bluetoothIsOn)
            stopFindDevice()
            scanStop()
        }
    }
    
    func showPermissionErrorLayout(locationOn : Bool,bluetoothOn : Bool){
        var message = ""
        if !allServiceAreAvaliable {
            message = Const.instance.permissionRequestBleAndLocation
        }
        if !bluetoothOn {
            message = Const.instance.perimssionRequestBle
        }
        
        if !locationOn {
            message = Const.instance.permissionRequestLocation
        }
        
        self.lyPermissionDeniedView.isHidden = false
        self.lyDashboardView.isHidden = true
        self.lyPermissionDeniedView.lbErrorMessage.text = message
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
