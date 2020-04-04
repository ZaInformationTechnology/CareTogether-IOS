//
//  DashboardVc.swift
//  CareTogether
//
//  Created by CodigoHeinHtet on 29/03/2020.
//  Copyright © 2020 HEINHTET. All rights reserved.
//

import BlueSwift
import UIKit
import CoreBluetooth

class DashboardVc: BaseVc {
    
    
    @IBOutlet weak var lyDashboardView: UIView!
    @IBOutlet weak var lyPermissionDeniedView: ServiceView!
    var allServiceAreAvaliable = false
    var timerIsStarted = false
    var fetchNearBlueToothDeivceTImer : Timer?
    
    
    
    @IBAction func btnLogout(_ sender: Any) {
        Store.instance.setPhoneNumber(phone: "")
        Router.instance.navigate(routeName: "PhoneVerifyVc", storyboard: "Main")
    }
    
    @IBOutlet weak var btnLogout: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
    
    
    func startFindDevice()  {
        timerIsStarted = true
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
            message = "သင့်တည်နေရာနဲ့ တွေ့ဆုံဖူးသောသူများအားရယူနိုင်ရန်အတွက် Location နှင့် Bluetooth တို့အားဖွင့်ထားရန်လိုအပ်ပီး Permission အားခွင့်ပြုပေးရန်လိုအပ်ပါသည်"
        }
        if !bluetoothOn {
            message = "သင်နှင့် တွေ့ဆုံဖူးသောသူများအားရယူနိုင်ရန်အတွက်  Bluetooth အားဖွင့်ထားရန်လိုအပ်ပီး Permission အားခွင့်ပြုပေးရန်လိုအပ်ပါသည်"
        }
        
        if !locationOn {
            message = "သင့်တည်နေရာ အားရယူနိုင်ရန်အတွက် Location အားဖွင့်ထားရန်လိုအပ်ပီး Permission အားခွင့်ပြုပေးရန်လိုအပ်ပါသည်"
        }
        
        self.lyPermissionDeniedView.isHidden = false
        self.lyDashboardView.isHidden = true
        
        self.lyPermissionDeniedView.lbErrorMessage.text = message
        
    }
}


