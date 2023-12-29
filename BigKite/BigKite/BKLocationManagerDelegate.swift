import CoreLocation
import CoreMotion

class BKLocationManagerDelegate: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager: CLLocationManager?
    private var lastLocationData: CLLocation?
    @Published var isLocationServicesEnabled = false
    @Published var authorizationStatus: CLAuthorizationStatus?
    // Add a new property to store CMAltimeter data
    @Published var relativeAltitude: Double = -999999
    @Published var absoluteAltitude: Double = -999999
    private var altimeter = CMAltimeter()

    override init() {
        super.init()
        setupAltimeter()
        setupLocationManager()
    }

    private func setupAltimeter() {
        if CMAltimeter.isRelativeAltitudeAvailable() {
            altimeter.startRelativeAltitudeUpdates(to: .main) { [weak self] data, error in
                if let altitudeData = data {
                    self?.relativeAltitude = altitudeData.relativeAltitude.doubleValue
                }
            }
        } else {
            print("CMAltimeter is not available on this device.")
        }
        if CMAltimeter.isAbsoluteAltitudeAvailable() {
            altimeter.startAbsoluteAltitudeUpdates(to: .main) { [weak self] data, error in
                if let altitudeData = data {
                    self?.absoluteAltitude = altitudeData.altitude
                }
            }
        } else {
            print("CMAltimeter is not available on this device.")
        }
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
            lastLocationData = location
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
        case .none:
            print("Location services are uhnknown.")
            break
        @unknown default:
            print("Unknown authorization status.")
        }
    }
}
