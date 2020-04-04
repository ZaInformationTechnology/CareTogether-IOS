//
//  BaseVc.swift
//  CareTogether
//
//  Created by CodigoHeinHtet on 04/04/2020.
//  Copyright © 2020 HEINHTET. All rights reserved.
//

import UIKit
import CoreLocation
import CoreBluetooth
import BlueSwift



protocol BaseManagerDelegate {
    func serviceChanged(locationIsOn : Bool,bluetoothIsOn : Bool)
}



class BaseVc: UIViewController {
    
    var locationManager: CLLocationManager?
    var currentLocation : CLLocation?
    var centralManager: CBCentralManager?
    
    var delegate : BaseManagerDelegate?
    
    
    let advertisement = BluetoothAdvertisement.shared
    var characteristicDidUpdateValue: ((Bool, Data?) -> Void)?
    private let connection = BluetoothConnection.shared
    private var echoCharacteristic: Characteristic!
    private var echoPeripheral: Peripheral<Connectable>?
    
    var bluetoothServiceIsOn = false
    var locationServiceIsOn = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initLocationManager()
        initBluetoothManager()
        NotificationCenter.default.addObserver(self, selector: #selector(onResume), name: NSNotification.Name(rawValue: "Active"), object: nil)
        
    }
    
    
    @objc func onResume(){
        print("Resume")
        isLocationPermissionIsAllowed()
    }
    
    
    private func initLocationManager(){
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
    }
    
    
    private func initBluetoothManager(){
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    
    func isLocationPermissionIsAllowed(){
        if CLLocationManager.locationServicesEnabled() {
            print("location status \(CLLocationManager.authorizationStatus().rawValue)")
            switch CLLocationManager.authorizationStatus() {
            case .restricted, .denied:
                self.openLocationSetting()
                self.locationServiceIsOn = false
                self.delegate?.serviceChanged(locationIsOn: false, bluetoothIsOn: self.bluetoothServiceIsOn)
            case .authorizedWhenInUse,.authorizedAlways :
                self.locationServiceIsOn = true
                self.getCurrentLocation()
                self.delegate?.serviceChanged(locationIsOn: locationServiceIsOn, bluetoothIsOn: self.bluetoothServiceIsOn)
            @unknown default:
                break
            }
        } else {
            print("Location services are not enabled")
            self.openLocationSetting()
        }
    }
    
    
    func getCurrentLocation()  {
        locationServiceIsOn = true
        self.currentLocation = locationManager?.location
        print("Current Location \(String(describing: self.currentLocation?.coordinate))")
        delegate?.serviceChanged(locationIsOn: true, bluetoothIsOn: bluetoothServiceIsOn)
    }
    
    
    func scanStop(){
         centralManager?.stopScan()
     }
     
     func startScan(){
         centralManager?.scanForPeripherals(withServices: nil, options: nil)

     }
     
}


extension BaseVc : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("location \(locations)")
        
    }
    
    func openLocationSetting(){
        
        self.locationServiceIsOn = false
        showErrorMessageAlertWithCloseWithCallback(message: "Location အားဖွင့်ထားပေးရန် နှင့် ခွင့်ပြုချက်အားပေးထားပေးရန် လိုအပ်ပါသည်။") { (isOkPressed) in
            if isOkPressed {
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)") // Prints true
                    })
                }
            }else{
                print("cancel press")
                self.locationServiceIsOn = false
                self.delegate?.serviceChanged(locationIsOn: false, bluetoothIsOn: self.bluetoothServiceIsOn)
            }
        }
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            openLocationSetting()
            break
            
        case .authorizedAlways , .authorizedWhenInUse:
            self.getCurrentLocation()
            
            break
        case .restricted , .denied:
            self.openLocationSetting()
            break
        default:
            break
        }
    }
    
    
}

extension BaseVc: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unknown:
            print("central.state is .unknown")
            self.bluetoothServiceIsOn = false
        case .resetting:
            print("central.state is .resetting")
            self.bluetoothServiceIsOn = false
        case .unsupported:
            print("central.state is .unsupported")
            self.bluetoothServiceIsOn = false
        case .unauthorized:
            print("central.state is .unauthorized")
            self.bluetoothServiceIsOn = false
        case .poweredOff:
            print("central.state is .poweredOff")
            self.bluetoothServiceIsOn = false
        case .poweredOn:
            print("central.state is .poweredOn")
            self.bluetoothServiceIsOn = true
            self.startScan()
            
        @unknown default:
            print("unknown case ")
        }
        delegate?.serviceChanged(locationIsOn: locationServiceIsOn, bluetoothIsOn: bluetoothServiceIsOn)
    }
    
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber){
        print("ble name \(peripheral)")
    }
    
    
    
    func turnOn() {
        guard echoPeripheral == nil else {
            print("arrrr")
            return
        }
        let echoIDString = "ec00"
        echoCharacteristic = try! Characteristic(uuid: echoIDString, shouldObserveNotification: true)
        echoCharacteristic.notifyHandler = { [weak self] data in
            self?.characteristicDidUpdateValue?(false, data)
        }
        let echoService = try! Service(uuid: echoIDString, characteristics: [echoCharacteristic])
        let configuration = try! Configuration(services: [echoService], advertisement: echoIDString)
        echoPeripheral = Peripheral(configuration: configuration)
        
        connection.connect(echoPeripheral!) { error in
            print(error ?? "error connecting to peripheral")
            
        }
        let  peripheral: Peripheral<Advertisable> = {
            let configuration = try! Configuration(services: [echoService], advertisement: "1004FD87-820F-438A-B757-7AC2C15C2D56")
            return Peripheral(configuration: configuration, advertisementData: [.localName("CT-Hein Htet Testing Phone"), .servicesUUIDs("1004FD87-820F-438A-B757-7AC2C15C2D56")])
        }()
        advertisement.advertise(peripheral: peripheral) { _ in
            // handle possible error
            print("advertisement error \(peripheral)")
        }
    }
    
    
    enum CentralError: Error {
        case centralAlreadyOn
        case centralAlreadyOff
    }
    
    
 
    
    
    func turnOff() throws {
        guard echoPeripheral != nil else { throw CentralError.centralAlreadyOff }
        try connection.disconnect(echoPeripheral!)
        echoPeripheral = nil
    }
    
    func readValue() {
        echoPeripheral?.read(echoCharacteristic) { [weak self] (data, error) in
            guard error == nil else { return }
            self?.characteristicDidUpdateValue?(true, data)
        }
    }
    
}
