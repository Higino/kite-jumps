import SwiftUI

struct ContentView: View {
    @ObservedObject private var locationManagerDelegate = BKLocationManagerDelegate()
    @State private var isLocationTracking = false

    var body: some View {
        ZStack {
            Color.black
            ScrollView {
                VStack {
                    if locationManagerDelegate.isLocationServicesEnabled {
                        if let authorizationStatus = locationManagerDelegate.authorizationStatus {
                            switch authorizationStatus {
                            case .authorizedWhenInUse, .authorizedAlways:
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("Relative Atl: " + locationManagerDelegate.relativeAltitude)
                                            .font(.caption)
                                            .foregroundColor(.white)
                                    }
                                    .padding(25)
                                    Spacer()
                                }
                                .padding(.top) // Add top padding to move it to the top-left corner
                                Spacer()
                                Text("Altitude:")
                                    .font(.title)
                                    .foregroundColor(.yellow)
                                
                                Text(locationManagerDelegate.absoluteAltitude)
                                    .font(.system(size: 30))
                                    .foregroundColor(.yellow)
                                Button(action: {
                                    if isLocationTracking {
                                        locationManagerDelegate.stopMeasurements()
                                    } else {
                                        locationManagerDelegate.restartMeasurements()
                                    }
                                    isLocationTracking.toggle()
                                }) {
                                    Text(isLocationTracking ? "Stop" : "Start")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .padding()
                                        .cornerRadius(10)
                                }

                                
                                Spacer()
                            case .notDetermined:
                                Text("Waiting for authorization. Please enable location services in your settings for this app")
                                    .font(.title)
                                    .foregroundColor(.white)
                            case .restricted:
                                Text("Location services are restricted. Please enable location services in your settings for this app")
                                    .font(.title)
                                    .foregroundColor(.white)
                            case .denied:
                                Text("Location services are denied. Please enable location services in your settings for this app")
                                    .font(.title)
                                    .foregroundColor(.white)
                            @unknown default:
                                Text("Unknown authorization status.")
                                    .font(.title)
                                    .foregroundColor(.white)
                            }
                        }
                    } else {
                        Text("Location services are disabled. Please enable location services in your settings for this app")
                            .font(.title)
                            .foregroundColor(.white)
                    }
                }
                .padding()
            }

        }
        .ignoresSafeArea()
    }
}
