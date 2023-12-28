import CoreLocation


class BKLocationManagerDelegate: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var userLocation: Double = -999999
    private var locationManager: CLLocationManager?
    @Published var authorizationStatus: CLAuthorizationStatus?
    @Published var isLocationServicesEnabled = false
    @Published var altitude: Double = -999999
    private var lastAltitude : Double?
    private var lastUserLocation : Double?

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
            if let previousAltitude = lastAltitude, let previousUserLocation = lastUserLocation{
                altitude = previousAltitude - location.altitude
                userLocation = previousUserLocation - location.ellipsoidalAltitude
            }
            lastAltitude = location.altitude
            lastUserLocation = location.ellipsoidalAltitude
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
