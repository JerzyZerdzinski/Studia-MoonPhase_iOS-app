//
//  MoonView.swift
//  MoonPhase
//
//  Created by Jerzy Żerdziński on 03/06/2025.
//

import SwiftUI
import CoreLocation
import SwiftAA
import Foundation

struct MoonView: View {
    @State private var moonPhase: Double = 75
    @State private var hemisphere = Hemisphere.Northern
    @State private var date = Date()
    @State private var previousNewMoon = Date()
    @State private var nextNewMoon = Date()
    @State private var fullMoon = Date()
    @State private var illumination = 0.0
    
    @Binding var location: CLLocationCoordinate2D
    
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
            
            MoonControl(phase: $moonPhase, hemisphere: $hemisphere)
            
            Spacer()
            
            HStack {
                Text("Illumination %")
                Spacer()
                Text(illumination.format(decimalPlaces: 2))
            }
            HStack {
                Text("Previous new moon")
                Spacer()
                Text(previousNewMoon.short)
            }
            HStack {
                Text("Next new moon")
                Spacer()
                Text(nextNewMoon.short)
            }
            HStack {
                Text("Next full moon")
                Spacer()
                Text(fullMoon.short)
            }
        }
        .onAppear {
            calculatePhase()
        }
        .onChange(of: date) { _, _ in
            calculatePhase()
        }
        .onChange(of: location) { _, newLocation in
            hemisphere = newLocation.latitude < 0 ? .Southern : .Northern
            calculatePhase()
        }
    }
    
    init(location: Binding<CLLocationCoordinate2D>) {
        _location = location
    }
    
    func calculatePhase() {
        let jd = JulianDay(date)
        let moon = Moon(julianDay: jd)
        fullMoon = moon.time(of: .fullMoon).date
        previousNewMoon = moon.time(of: .newMoon, forward: false).date
        nextNewMoon = moon.time(of: .newMoon, forward: true).date
        illumination = moon.illuminatedFraction() * 100
        
        var phasePercent = illumination / 2
        if nextNewMoon < fullMoon {
            phasePercent = 100 - phasePercent
        }
        moonPhase = phasePercent
    }
}

#Preview {
    @State var location = CLLocationCoordinate2D(latitude: 17.0, longitude: 52.0)
    return MoonView(location: $location)
}
