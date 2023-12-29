import SwiftUI

struct ContentView: View {
    @ObservedObject private var locationManagerDelegate = BKLocationManagerDelegate()

    var body: some View {
        ZStack {
            Color.black
            
            VStack {
                if locationManagerDelegate.isLocationServicesEnabled {
                    if let authorizationStatus = locationManagerDelegate.authorizationStatus {
                        switch authorizationStatus {
                        case .authorizedWhenInUse, .authorizedAlways:
                            Text("Relative Altitude: \(String(format: "%.2f", locationManagerDelegate.relativeAltitude))")
                                .font(.title)
                                .foregroundColor(.white)
                            Text("Absolute Altitude: \(String(format: "%.2f", locationManagerDelegate.absoluteAltitude))")
                                .font(.title)
                                .foregroundColor(.white)
                        case .notDetermined:
                            Text("Waiting for authorization...")
                                .font(.title)
                                .foregroundColor(.white)
                        case .restricted:
                            Text("Location services are restricted.")
                                .font(.title)
                                .foregroundColor(.white)
                        case .denied:
                            Text("Location services are denied.")
                                .font(.title)
                                .foregroundColor(.white)
                        @unknown default:
                            Text("Unknown authorization status.")
                                .font(.title)
                                .foregroundColor(.white)
                        }
                    }
                } else {
                    Text("Location services are disabled.")
                        .font(.title)
                        .foregroundColor(.white)
                }
                
                Image(systemName: "arrow.up.circle.fill")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                    .foregroundColor(.white)
            }
            .padding()
        }
        .ignoresSafeArea()
    }
}
