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

import UIKit

final class DashVc: UIViewController {

    private var centralController: CentralController?

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Echo characteristic"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let centralSwitch: UISwitch = {
        let sw = UISwitch()
        sw.addTarget(self, action: #selector(centralSwitchChanged), for: .valueChanged)
        sw.translatesAutoresizingMaskIntoConstraints = false
        return sw
    }()

    private let bluetoothLibrariesSegmented: UISegmentedControl = {
        let segmentedControl = UISegmentedControl()
        segmentedControl.insertSegment(withTitle: "CB", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "BS", at: 1, animated: false)
        segmentedControl.insertSegment(withTitle: "BC", at: 2, animated: false)
        segmentedControl.insertSegment(withTitle: "RB", at: 3, animated: false)
        segmentedControl.insertSegment(withTitle: "BJ", at: 4, animated: false)
        segmentedControl.addTarget(self, action: #selector(bluetoothLibraryChanged), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()

    private let readLabel: UILabel = {
        let label = UILabel()
        label.text = "Read value: "
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let notifiedLabel: UILabel = {
        let label = UILabel()
        label.text = "Notified value: "
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let writeLabel: UILabel = {
        let label = UILabel()
        label.text = "Write value"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let writeTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Value to write"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let readButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Read", for: .normal)
        button.addTarget(self, action: #selector(readButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var readStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [readLabel, readButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    lazy var writeStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [writeLabel, writeTextField])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
        writeTextField.delegate = self
    }

    private func setupLayout() {
        [titleLabel, centralSwitch, bluetoothLibrariesSegmented, readStackView, notifiedLabel, writeStackView].forEach { view.addSubview($0) }
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            centralSwitch.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            centralSwitch.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bluetoothLibrariesSegmented.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bluetoothLibrariesSegmented.topAnchor.constraint(equalTo: centralSwitch.bottomAnchor, constant: 10),
            readStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            readStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            readStackView.topAnchor.constraint(equalTo: bluetoothLibrariesSegmented.bottomAnchor, constant: 10),
            notifiedLabel.topAnchor.constraint(equalTo: readStackView.bottomAnchor, constant: 8),
            notifiedLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            notifiedLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            writeStackView.topAnchor.constraint(equalTo: notifiedLabel.bottomAnchor, constant: 8),
            writeStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            writeStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    @objc
    private func readButtonTapped() {
        centralController?.readValue()
    }

    @objc
    private func centralSwitchChanged() {
        try! centralSwitch.isOn ? centralController?.turnOn() : centralController?.turnOff()
        bluetoothLibrariesSegmented.isEnabled = !centralSwitch.isOn
    }

    @objc
    private func bluetoothLibraryChanged() {
        switch bluetoothLibrariesSegmented.selectedSegmentIndex {
        case 0:
            centralController = CBCentralController()
        case 1:
            centralController = BSCentralController()
        case 2:
            centralController = BCCentralController()
        case 3:
            centralController = RBCentralController()
        case 4:
            centralController = BJCentralController()
        default:
            break
        }
        centralController?.characteristicDidUpdateValue = { [unowned self] isReading, value in
            guard let value = value else { return }
            let stringValue = String(data: value, encoding: .utf8)
            if isReading {
                self.readLabel.text = "Read value: \(stringValue ?? "")"
            } else {
                self.notifiedLabel.text = "Notified value: \(stringValue ?? "")"
            }
        }
    }
}

extension DashVc: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        guard let text = textField.text, let data = text.data(using: .utf8) else { return false }
        centralController?.writeValue(data)
        return true
    }
}
