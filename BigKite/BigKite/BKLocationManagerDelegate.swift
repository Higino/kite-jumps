import CoreLocation


class BKLocationManagerDelegate: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var userLocation: String = "N/A"
    private var locationManager: CLLocationManager?
    @Published var authorizationStatus: CLAuthorizationStatus?
    @Published var isLocationServicesEnabled = false

    override init() {
        super.init()
        setupLocationManager()
    }

    private func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        isLocationServicesEnabled = CLLocationManager.locationServicesEnabled()

        if isLocationServicesEnabled {
            locationManager?.requestWhenInUseAuthorization()
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            locationManager?.startUpdatingLocation()
        } else {
            print("Location services are disabled.")
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let altitude = location.ellipsoidalAltitude//location.altitude
            userLocation = "Altitude: \(String(format: "%.2f", altitude)) meters"
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus

        switch authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            locationManager?.startUpdatingLocation()
            break
        case .notDetermined:
            print("Location authorization is not determined.")
            manager.requestWhenInUseAuthorization()
            break
        case .restricted:
            print("Location services are restricted.")
            break
        case .denied:
            print("Location services are denied.")
            break
        @unknown default:
            print("Unknown authorization status.")
        }
    }
}
