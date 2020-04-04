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

import BlueSwift

final class BSCentralController: CentralController {

    enum CentralError: Error {
        case centralAlreadyOn
        case centralAlreadyOff
    }

    var characteristicDidUpdateValue: ((Bool, Data?) -> Void)?
    private let connection = BluetoothConnection.shared
    private var echoCharacteristic: Characteristic!
    private var echoPeripheral: Peripheral<Connectable>?

    func turnOn() throws {
        guard echoPeripheral == nil else { throw CentralError.centralAlreadyOn }
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
