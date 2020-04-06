//
//  TrackDbUtils.swift
//  CareTogether
//
//  Created by CodigoHeinHtet on 04/04/2020.
//  Copyright © 2020 HEINHTET. All rights reserved.
//

import Foundation
import RealmSwift
import CoreLocation


protocol DatabaseCallback {
    func dataChanged(result : Results<TrackModel>)
    func changed()
}


class TrackDbUtils {
    var expire_date = Calendar.current.date(byAdding: .month, value: 3, to: Date())!
    static let instance = TrackDbUtils()
    var delegate : DatabaseCallback?
    
    
    
    
    
    func addNew(name : String,location : CLLocation){
        let data = TrackModel()
        
        DispatchQueue(label: "backgroundadd").async {
            autoreleasepool{
                let realm = try! Realm()
               
                try! realm.write {
                    data.phone = name
                    data.latitude  = location.coordinate.latitude
                    data.longitude = location.coordinate.longitude
                    data.expire_date = self.expire_date
                    realm.add(data)
                }
            }
            self.delegate?.changed()
        }
    }
    
    
    func checkAndUpdate(name : String,location : CLLocation){
        
        
        DispatchQueue(label: "backgroundupdate").async {
            autoreleasepool {
                let realm = try! Realm()
                let trackList = realm.objects(TrackModel.self).filter("phone = %@", name)
                let currentDateTime = Date()
                
                // initialize the date formatter and set the style
                let formatter = DateFormatter()
                formatter.timeStyle = .medium
                formatter.dateStyle = .long
                
                // get the date time String from the date object
                let dateStr =  formatter.string(from: currentDateTime)
                
                
                if(trackList.count > 0){
                    let trackModel = trackList.first
                    try! realm.write {
                        trackModel?.time = dateStr
                        print("date  \(dateStr)")
                        trackModel?.latitude = location.coordinate.latitude
                        trackModel?.longitude = location.coordinate.longitude
                        trackModel?.expire_date = self.expire_date
                        
                    }
                    self.delegate?.changed()
                }else{
                    self.addNew(name: name , location: location)
                }
            }
        }
        
    }
}

