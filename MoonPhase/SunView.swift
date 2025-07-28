//
//  SunView.swift
//  MoonPhase
//
//  Created by Jerzy Żerdziński on 03/06/2025.
//

import SwiftUI
import CoreLocation
import SwiftAA

struct SunView: View {
    
    @Binding var location : CLLocationCoordinate2D
    @State var date = Date()
    
    @State var sunriseText: String = ""
    @State var transitText: String = ""
    @State var sunsetText: String = ""
    @State var dayLenghtText: String = ""

    
    var body: some View {
        VStack {
            HStack {
                DatePicker(selection: $date, displayedComponents: .date) {
                    Text("Select date")
                }
                Spacer()
                Button("Today") {
                    date = Date()
                }
            }
            Spacer()
            Image("sun").resizable().scaledToFit()

            Spacer()
            HStack {
                Text("Sunrise")
                Spacer()
                Text(sunriseText)
            }
            HStack {
                Text("Transit")
                Spacer()
                Text(transitText)
            }
            HStack {
                Text("Sunset")
                Spacer()
                Text(sunsetText)
            }.onAppear() {
                updateSunTexts()
            }
            HStack {
                Text("Day lenght")
                Spacer()
                Text(dayLenghtText)
            }.onChange(of: date) {oldDate, newDate in
                updateSunTexts()
            }
        }
    }
    
    init(location: Binding<CLLocationCoordinate2D>) {
     _location = location
     }
    
    func updateSunTexts(){
        let jd=JulianDay(date)
        let sun = Sun(julianDay: jd)
        
        let coordinates=GeographicCoordinates(CLLocation(location)!)
        let times=sun.riseTransitSetTimes(for: coordinates)
        
        if let rise = times.riseTime?.date as Date? {
            sunriseText = rise.timeOnly
        }
        else{
            sunriseText = "Not defined"
        }
        
        if let transit = times.transitTime?.date as Date? {
            transitText = transit.timeOnly
        }
        else{
            transitText = "Not defined"
        }
        
        if let set = times.setTime?.date as Date? {
            sunsetText = set.timeOnly
        }
        else{
            sunsetText = "Not defined"
        }
        
        dayLenghtText = "Not defined"
        if let sunSet = times.setTime?.date as Date?  {
            if let sunRise = times.riseTime?.date as Date? {
                let delta = sunSet.timeIntervalSince(sunRise)
                let formatter = DateComponentsFormatter()
                formatter.unitsStyle = .abbreviated
                formatter.allowedUnits = [.hour, .minute, .second]
                dayLenghtText = formatter.string(from: delta) ?? "00:00.00"
            }
        }
        
    }
    
    func updateDayLenght() {
        
    }
}
