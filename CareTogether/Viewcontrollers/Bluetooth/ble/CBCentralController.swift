/**
 * Copyright (c) 2019 Mikołaj Skawiński
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import CoreBluetooth

final class CBCentralController: NSObject, CentralController {

    enum CentralError: Error {
        case centralAlreadyOn
        case centralAlreadyOff
    }

    var characteristicDidUpdateValue: ((Bool, Data?) -> Void)?
    private let echoID = CBUUID(string: "ec00")
    private var central: CBCentralManager!
    private var echoPeripheral: CBPeripheral?
    private var echoCharacteristic: CBCharacteristic?
    private var isReadingCharacteristicValue = false

    func turnOn() throws {
        guard central == nil else { throw CentralError.centralAlreadyOn }
        central = CBCentralManager(delegate: self, queue: nil)
    }

    func turnOff() throws {
        guard central != nil, central.state == .poweredOn else { throw CentralError.centralAlreadyOff }
        central.stopScan()
        central = nil
    }

    func readValue() {
        guard let characteristic = echoCharacteristic else { return }
        echoPeripheral?.readValue(for: characteristic)
        isReadingCharacteristicValue = true
    }

    func writeValue(_ value: Data) {
        guard let characteristic = echoCharacteristic else { return }
        echoPeripheral?.writeValue(value, for: characteristic, type: .withoutResponse)
    }
}

extension CBCentralController: CBCentralManagerDelegate {

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        guard central.state == .poweredOn else { return }
        central.scanForPeripherals(withServices: [echoID])
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        central.stopScan()
        central.connect(peripheral)
        echoPeripheral = peripheral
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.delegate = self
        peripheral.discoverServices([echoID])
    }
}

extension CBCentralController: CBPeripheralDelegate {

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let service = peripheral.services?.first(where:  { $0.uuid == echoID }) else { return }
        peripheral.discoverCharacteristics([echoID], for: service)
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristic = service.characteristics?.first(where: { $0.uuid == echoID}) else { return }
        echoPeripheral?.setNotifyValue(true, for: characteristic)
        echoCharacteristic = characteristic
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        characteristicDidUpdateValue?(isReadingCharacteristicValue, characteristic.value)
        isReadingCharacteristicValue = false
    }
}
