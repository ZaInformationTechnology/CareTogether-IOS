//
//  BaseVc.swift
//  CareTogether
//
//  Created by CodigoHeinHtet on 04/04/2020.
//  Copyright © 2020 HEINHTET. All rights reserved.
//

import UIKit
import CoreLocation

class BaseVc: UIViewController {
    
    var locationManager: CLLocationManager?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initLocationManager()
    }
    

    private func initLocationManager(){
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
    }
    
    
    private func initBluetooth(){
        
    }
    
}


extension BaseVc : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("location \(locations)")
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            manager.requestAlwaysAuthorization()
            
            break
            
        case .authorizedAlways , .authorizedWhenInUse:
            manager.startUpdatingLocation()
            break
        case .restricted , .denied:
            
            showErrorMessageAlertWithCloseWithCallback(message: "Location အားဖွင့်ထားပေးရန်လိုအပ်ပါသည်။") {
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)") // Prints true
                    })
                }
            }
            
            break
        default:
            break
        }
    }
}
