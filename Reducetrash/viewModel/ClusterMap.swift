import SwiftUI
import MapKit
import UserNotifications
import CoreLocation
import CoreLocationUI
struct ClusterMap: UIViewRepresentable {
    @Binding var selectedCan: Can?
    @Binding var showingDetail: Bool
    @State var userLocation: CLLocationCoordinate2D?
    @State var cans: [Can] = []
    @State var notificationCenter = UNUserNotificationCenter.current()
    
    func makeUIView(context: Context) -> MKMapView {
            let mapView = MKMapView()
            mapView.showsUserLocation = true // enable user location tracking

            // Set up location manager to track user location and show notifications
            let locationManager = LocationManager(userLocation: $userLocation, cans: $cans, notificationCenter: notificationCenter)
            locationManager.startUpdatingLocation()

            mapView.delegate = context.coordinator

            return mapView
        }
    
  
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        // 1. Fetch data from the server
        let url = URL(string: "http://localhost:9091/can")!
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            do {
                let cans = try JSONDecoder().decode([Can].self, from: data)
                DispatchQueue.main.async {
                    // 2. Add markers to the map view
                    mapView.removeAnnotations(mapView.annotations)
                    mapView.addAnnotations(cans.map { $0.toAnnotation() })
                }
            } catch let error {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        
        var parent: ClusterMap
        
        init(_ parent: ClusterMap) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            guard let annotation = view.annotation as? CanAnnotation else { return }
            parent.selectedCan = annotation.can
            parent.showingDetail = true
        }
        
       
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard annotation is CanAnnotation else { return nil }

            let identifier = "Can"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

            if annotationView == nil {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView!.canShowCallout = true
                annotationView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            } else {
                annotationView!.annotation = annotation
            }

            return annotationView
        }
    }
    
}


class LocationManager: NSObject, CLLocationManagerDelegate {
    @Binding var userLocation: CLLocationCoordinate2D?
    @Binding var cans: [Can]
    let notificationCenter: UNUserNotificationCenter

    let locationManager = CLLocationManager()

    init(userLocation: Binding<CLLocationCoordinate2D?>, cans: Binding<[Can]>, notificationCenter: UNUserNotificationCenter) {
        self._userLocation = userLocation
        self._cans = cans
        self.notificationCenter = notificationCenter

        super.init()

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation() // Start updating location
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations.last?.coordinate

        for can in cans {
            let canLocation = CLLocation(latitude: can.latitude, longitude: can.longitude)
            if let userLocation = userLocation, canLocation.distance(from: CLLocation(latitude:userLocation.latitude, longitude: userLocation.longitude)) < 100 {
                let content = UNMutableNotificationContent()
                content.title = "Recycling Can Nearby"
                content.subtitle = "There is a recycling can within 100 meters of your current location."
                content.sound = UNNotificationSound.default
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
                notificationCenter.add(request)
            }
            
            // Check if the distance between user location and can location is 0
            if let userLocation = userLocation, canLocation.distance(from: CLLocation(latitude:userLocation.latitude, longitude: userLocation.longitude)) == 0 {
                let content = UNMutableNotificationContent()
                content.title = "You have reached a recycling can"
                content.subtitle = "You are now within the recycling can's range."
                content.sound = UNNotificationSound.default
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
                notificationCenter.add(request)
            }
        }
    }





    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    
}

class CanAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var can: Can

    init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?, can: Can) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.can = can
    }
}
extension CLLocationCoordinate2D {
    func distance(to coordinate: CLLocationCoordinate2D) -> CLLocationDistance {
        let location1 = CLLocation(latitude: self.latitude, longitude: self.longitude)
        let location2 = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        return location1.distance(from: location2)
    }
  

  
}
