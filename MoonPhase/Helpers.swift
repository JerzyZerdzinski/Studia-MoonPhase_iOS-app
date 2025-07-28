//
//  Helpers.swift
//  MoonPhase
//
//  Created by Jerzy Żerdziński on 03/06/2025.
//

import Foundation
import CoreLocation

enum Hemisphere:Double {
    case Northern = 0
    case Southern = 180
}
extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        if lhs.longitude == rhs.longitude && lhs.latitude == rhs.latitude {
            return true
        }
        return false
    }
}

extension CLLocation {
    convenience init?(_ coordinate2D: CLLocationCoordinate2D) {
        guard CLLocationCoordinate2DIsValid(coordinate2D) else { return nil }
        self.init(latitude: coordinate2D.latitude, longitude: coordinate2D.longitude)
    }
}

extension Double {
    func format(decimalPlaces: Int) -> String {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.groupingSeparator = " "
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = decimalPlaces
        formatter.minimumFractionDigits = decimalPlaces
        return formatter.string(from: self as NSNumber)!
    }
}

extension Date {
    var short: String {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM, HH:mm"
            return dateFormatter.string(from: self)
        }
    }
    
    var dateOnly: String {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            return dateFormatter.string(from: self)
        }
    }
    
    var timeOnly: String {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            return dateFormatter.string(from: self)
        }
    }
}
