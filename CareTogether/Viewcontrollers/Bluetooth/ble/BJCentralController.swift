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

import Bluejay

final class BJCentralController: CentralController {

    enum CentralError: Error {
        case centralAlreadyOn
        case centralAlreadyOff
    }

    var characteristicDidUpdateValue: ((Bool, Data?) -> Void)?
    private let echoServiceID = ServiceIdentifier(uuid: "ec00")
    private lazy var echoCharacteristicID = CharacteristicIdentifier(uuid: "ec00", service: echoServiceID)
    private var bluejay: Bluejay!
//    private var echoPeripheral: Peripheral?

    func turnOn() throws {
        guard bluejay == nil else { throw CentralError.centralAlreadyOn }
        bluejay = Bluejay()
        bluejay.start()
        bluejay.scan(serviceIdentifiers: [echoServiceID], discovery: { (discovery, _) -> ScanAction in
            return .connect(discovery, .seconds(0.3), .default, { (result) in
                guard case .failure(let error) = result else { return }
                print(error)
            })
        }) { (_, error) in
            print(error ?? "Error scanning for peripherals")
        }
    }

    func turnOff() throws {
        guard bluejay != nil else { throw CentralError.centralAlreadyOff }
        bluejay.cancelEverything()
        bluejay = nil
    }

    // Can't read while listening is on
    func readValue() {
//        echoPeripheral?.read(from: echoCharacteristicID, completion: { [weak self] (result: ReadResult<Data>) in
//            switch result {
//            case .success(let data):
//                self?.characteristicDidUpdateValue?(true, data)
//            case .failure(let error):
//                print(error)
//            }
//        })
    }

    func writeValue(_ value: Data) {
//        echoPeripheral?.write(to: echoCharacteristicID, value: value, type: .withoutResponse) { result in
//            guard case .failure(let error) = result else { return }
//            print(error)
//        }
    }
}

extension BJCentralController: ConnectionObserver {
//    func connected(to peripheral: Peripheral) {
//        peripheral.listen(to: echoCharacteristicID) { [weak self] (result: ReadResult<Data>) in
//            switch result {
//            case .success(let data):
//                self?.characteristicDidUpdateValue?(false, data)
//            case .failure(let error):
//                print(error)
//            }
//        }
//        echoPeripheral = peripheral
//    }
}
