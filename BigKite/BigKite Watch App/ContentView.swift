//
//  ContentView.swift
//  BigKite Watch App
//
//  Created by Higino Silva on 27/12/2023.
//

import SwiftUI
import CoreMotion

struct ContentView: View {
    @State private var altitude: Double? = nil
    
    var body: some View {
        ZStack {
            Color.black // Set the background color to black
            
            VStack {
                Text("Last Jump!")
                    .font(.title)
                    .foregroundColor(.white) // Set text color to white
                
                if let altitude = altitude {
                    Text("\(String(format: "%.2f", altitude)) meters")
                        .font(.title)
                        .foregroundColor(.white) // Set text color to white
                } else {
                    Text("N/A")
                        .font(.title)
                        .foregroundColor(.white) // Set text color to white
                }
                Image(systemName: "arrow.up.circle.fill")
                    .imageScale(.large) // Increase the icon size
                    .foregroundStyle(.tint)
                    .foregroundColor(.white) // Set icon color to white
                
            }
            .padding()
        }
        .ignoresSafeArea() // Ignore safe area edges to fill the entire screen
        .onAppear {
            startAltitudeUpdates()
        }
    }
    
    func startAltitudeUpdates() {
        if CMAltimeter.isRelativeAltitudeAvailable() {
            let altimeter = CMAltimeter()
            altimeter.startRelativeAltitudeUpdates(to: .main) { (data, error) in
                if let altitudeData = data {
                    let altitude = altitudeData.relativeAltitude.doubleValue
                    self.altitude = altitude
                } else {
                    self.altitude = nil
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
