//
//  TrackModel.swift
//  CareTogether
//
//  Created by HeinHtet on 04/04/2020.
//  Copyright © 2020 HEINHTET. All rights reserved.
//

import Foundation
import RealmSwift

class TrackModel: Object {
    @objc dynamic var time = ""
    @objc dynamic var phone = ""
    @objc dynamic var latitude = 0.0
    @objc dynamic var longitude = 0.0
    @objc dynamic var expire_date = Date()
}
