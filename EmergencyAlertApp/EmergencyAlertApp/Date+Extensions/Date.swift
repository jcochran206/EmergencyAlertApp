//
//  Date.swift
//  EmergencyAlertApp
//
//  Created by Jonathan Cochran on 4/4/19.
//  Copyright © 2019 Jonathan Cochran. All rights reserved.
//

import Foundation

extension Date{
    
    func formatToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: self)
    }
}
