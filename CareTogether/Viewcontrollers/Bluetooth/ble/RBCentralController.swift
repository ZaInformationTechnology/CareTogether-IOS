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

import RxSwift
import CoreBluetooth
import RxBluetoothKit

final class RBCentralController: CentralController {

    enum CentralError: Error {
        case centralAlreadyOn
        case centralAlreadyOff
    }

    var characteristicDidUpdateValue: ((Bool, Data?) -> Void)?
    private var subscriptionToCharacteristic: Disposable!
    private var central: CentralManager!
    private var echoCharacteristic: Characteristic?

    func turnOn() throws {
        let echoID = CBUUID(string: "ec00")
        central = CentralManager()
        subscriptionToCharacteristic = central
            .observeState()
            .startWith(central.state)
            .filter { $0 == .poweredOn }
            .flatMap { _ in self.central.scanForPeripherals(withServices: [echoID]) }
            .take(1)
            .flatMap { $0.peripheral.establishConnection() }
            .flatMap { $0.discoverServices([echoID]) }
            .flatMap { Observable.from($0) }
            .flatMap { $0.discoverCharacteristics([echoID]) }
            .subscribe { [weak self] characteristics in
                self?.echoCharacteristic = characteristics.element?.first
                self?.subscriptionToCharacteristic = self?.echoCharacteristic?
                    .observeValueUpdateAndSetNotification()
                    .subscribe {
                        self?.characteristicDidUpdateValue?(false, $0.element?.value)
                        return
                }
            }
    }

    func turnOff() throws {
        guard central != nil else { throw CentralError.centralAlreadyOff }
        subscriptionToCharacteristic.dispose()
        central = nil
    }

    func readValue() {
        _ = echoCharacteristic?
            .readValue()
            .asObservable()
            .take(1)
            .timeout(0.5, scheduler: MainScheduler.instance)
            .subscribe {
                self.characteristicDidUpdateValue?(true, $0.element?.value)
            }
    }

    func writeValue(_ value: Data) {
        echoCharacteristic?
            .writeValue(value, type: .withoutResponse)
            .subscribe()
            .dispose()
    }
}
