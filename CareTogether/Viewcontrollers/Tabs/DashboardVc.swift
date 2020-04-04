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
    var centralManager: CBCentralManager!
    @IBAction func btnLogout(_ sender: Any) {
        Store.instance.setPhoneNumber(phone: "")
        Router.instance.navigate(routeName: "PhoneVerifyVc", storyboard: "Main")
    }
    
    @IBOutlet weak var btnLogout: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
    }
    
    enum CentralError: Error {
        case centralAlreadyOn
        case centralAlreadyOff
    }
    
    
    let advertisement = BluetoothAdvertisement.shared
    var characteristicDidUpdateValue: ((Bool, Data?) -> Void)?
    private let connection = BluetoothConnection.shared
    private var echoCharacteristic: Characteristic!
    private var echoPeripheral: Peripheral<Connectable>?
    
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
    
    func writeValue(_ value: Data) {
        echoPeripheral?.write(command: .data(value), characteristic: echoCharacteristic) { (error) in
            print(error ?? "error writing characteristic value")
        }
    }
}




extension DashboardVc: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unknown:
            print("central.state is .unknown")
        case .resetting:
            print("central.state is .resetting")
        case .unsupported:
            print("central.state is .unsupported")
        case .unauthorized:
            print("central.state is .unauthorized")
        case .poweredOff:
            print("central.state is .poweredOff")
        case .poweredOn:
            print("central.state is .poweredOn")
            centralManager.scanForPeripherals(withServices: nil, options: nil)//
            turnOn()
            
        @unknown default:
            print("unknown case ")
        }
    }
  func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber){

    print("ble name \(peripheral)")
    }
    
    
    
    
}
