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
import BlueCapKit

final class BCCentralController: CentralController {

    public enum CentralError : Error {
        case centralAlreadyOn
        case centralAlreadyOff
        case dataCharactertisticNotFound
        case enabledCharactertisticNotFound
        case updateCharactertisticNotFound
        case serviceNotFound
        case notPoweredOn
        case unlikely
    }

    var characteristicDidUpdateValue: ((Bool, Data?) -> Void)?
    private var central: CentralManager!
    private var peripheral: Peripheral?
    private var echoCharacteristic: Characteristic?
    private var subscriptionFuture: FutureStream<Data?>? {
        didSet {
            subscriptionFuture?.onSuccess { data in
                self.characteristicDidUpdateValue?(false, data)
            }
        }
    }

    func turnOn() throws {
        guard central == nil else { throw CentralError.centralAlreadyOn }
        central = CentralManager()
        let echoID = CBUUID(string: "ec00")
        let discoveryFuture = central.whenStateChanges()
            .flatMap { [weak central] state -> FutureStream<Peripheral> in
                guard let central = central, state == .poweredOn else { throw CentralError.notPoweredOn }
                return central.startScanning(forServiceUUIDs: [echoID])
            }.flatMap { [weak self] discoveredPeripheral  -> FutureStream<Void> in
                self?.central.stopScanning()
                self?.peripheral = discoveredPeripheral
                return discoveredPeripheral.connect(connectionTimeout: 10.0)
            }.flatMap { [weak self] () -> Future<Void> in
                guard let peripheral = self?.peripheral else {
                    throw CentralError.unlikely
                }
                return peripheral.discoverServices([echoID])
            }.flatMap { [weak self] () -> Future<Void> in
                guard
                    let peripheral = self?.peripheral,
                    let service = peripheral.services(withUUID: echoID)?.first
                else {
                    throw CentralError.serviceNotFound
                }
                return service.discoverCharacteristics([echoID])
            }

        subscriptionFuture = discoveryFuture
            .flatMap { [weak self] () -> Future<Void> in
                guard
                    let self = self,
                    let peripheral = self.peripheral,
                    let service = peripheral.services(withUUID: echoID)?.first
                else {
                    throw CentralError.serviceNotFound
                }
                guard let characteristic = service
                    .characteristics(withUUID: echoID)?
                    .first
                else {
                    throw CentralError.dataCharactertisticNotFound
                }
                self.echoCharacteristic = characteristic
                return self.echoCharacteristic!.startNotifying()
            }.flatMap { [weak self] () -> FutureStream<Data?> in
                guard let characteristic = self?.echoCharacteristic else {
                    throw CentralError.dataCharactertisticNotFound
                }
                return characteristic.receiveNotificationUpdates()
            }
    }

    func turnOff() throws {
        guard central != nil else { throw CentralError.centralAlreadyOff }
        central.stopScanning()
        central = nil
    }

    func readValue() {
        echoCharacteristic?.read().onSuccess { [weak self] in
            guard let data = self?.echoCharacteristic?.dataValue else { return }
            self?.characteristicDidUpdateValue?(true, data)
        }
    }

    func writeValue(_ value: Data) {
        _ = echoCharacteristic?.write(data: value, timeout: .infinity, type: .withoutResponse)
    }
}
