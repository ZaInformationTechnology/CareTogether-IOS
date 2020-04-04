//
//  BLECentralDelegate.swift
//  CareTogether
//
//  Created by CodigoHeinHtet on 04/04/2020.
//  Copyright © 2020 HEINHTET. All rights reserved.
//

import Foundation
import CoreBluetooth

protocol BLECentralDelegate {
    func didDiscoverPeripheral(_ peripheral: CBPeripheral!)
}
