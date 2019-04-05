//
//  Event.swift
//  EmergencyAlertApp
//
//  Created by Jonathan Cochran on 4/4/19.
//  Copyright © 2019 Jonathan Cochran. All rights reserved.
//

import Foundation

struct Event {
    
    var documentID: String?
    
    let lat: Double
    let long: Double
    var reportedDate: Date = Date()
    
}

extension Event{
    
    init(lat: Double, long: Double) {
        self.lat = lat
        self.long = long
        
    }
}

extension Event {
    
    func toDictionary() -> [String:Any]{
        return [
            "latitude": self.lat,
            "longitude": self.long,
            "reportedDate": self.reportedDate.formatToString()
        ]
    }
}
