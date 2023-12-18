import Foundation
import SwiftUI
import MapKit
import CoreLocation

class CreateEventViewModel: NSObject, ObservableObject, CLLocationManagerDelegate, MKMapViewDelegate {
    @Published var title: String = ""
    @Published var address: String = ""
    @Published var descriptionsd: String = ""

    @Published var owner: String = ""
    @Published var showAlert = false
    @Published var alertMessage = ""
    @Published var date = Date()
    @Published var coordinate = CLLocationCoordinate2D()
    @Published var annotations: [MKAnnotation] = []

    let locationManager = CLLocationManager()
    var mapView: MKMapView?

    override init() {
        super.init()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func requestLocationPermission() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            showAlert = true
            alertMessage = "Please enable location access in the Settings app"
        case .authorizedAlways:
            locationManager.startUpdatingLocation()
        @unknown default:
            break
        }
    }

    func createEvent() {
        guard let url = URL(string: "http://localhost:9091/event") else {
            showAlert = true
            alertMessage = "Invalid URL"
            return
        }

        let event = Eventse(
            title: title,
            description: descriptionsd,
            date: date,
            address: address,
            longitude: coordinate.longitude,
            latitude: coordinate.latitude,
            owner: owner
        )

        guard let data = try? JSONEncoder().encode(event) else {
            showAlert = true
            alertMessage = "Unable to encode event data"
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = data

        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }

            if let error = error {
                DispatchQueue.main.async {
                    self.showAlert = true
                    self.alertMessage = error.localizedDescription
                }
                return
            }

            guard let data = data, let response = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    self.showAlert = true
                    self.alertMessage = "Invalid server response"
                }
                return
            }

            if response.statusCode == 201 {
                DispatchQueue.main.async {
                    self.showAlert = true
                    self.alertMessage = "Event created successfully"
                }
            } else {
                DispatchQueue.main.async {
                    self.showAlert = true
                    self.alertMessage = "Unable to create event"
                }
            }
        }
        task.resume()
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation else { return }
        coordinate = annotation.coordinate
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }

        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView?.setRegion(region, animated: true)

        let annotation = MKPointAnnotation()
        annotation.coordinate = location.coordinate
        annotations.append(annotation)
        mapView?.addAnnotations(annotations)

        locationManager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        showAlert = true
        alertMessage = error.localizedDescription
    }
}

struct Eventse: Codable {
let title: String
let description: String
let date: Date
let address: String
let longitude: Double
let latitude: Double
let owner: String
}


import SwiftUI
import MapKit

struct CreateEventForm: View {
    @StateObject var viewModel = CreateEventViewModel()

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Event Details")) {
                    TextField("Title", text: $viewModel.title)
                    TextField("Address", text: $viewModel.address)
                    TextField("description", text: $viewModel.descriptionsd)
                    TextField("Owner", text: $viewModel.owner)
                    DatePicker("Select date and time", selection: $viewModel.date, displayedComponents: [.date, .hourAndMinute])
                }
                
                Section(header: Text("Location")) {
                    MapViewes(annotations: viewModel.annotations, coordinate: $viewModel.coordinate)
                        .frame(height: 300)
                        .onAppear {
                            viewModel.requestLocationPermission()
                            viewModel.mapView?.delegate = viewModel
                        }
                }
                
                Button("Create Event") {
                    viewModel.createEvent()
                }
            }
            .navigationTitle("Create Event")
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Error"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
}

struct MapViewes: UIViewRepresentable {
    var annotations: [MKAnnotation]
    @Binding var coordinate: CLLocationCoordinate2D

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.removeAnnotations(uiView.annotations)
        uiView.addAnnotations(annotations)

        if !annotations.isEmpty {
            let region = MKCoordinateRegion(center: annotations[0].coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            uiView.setRegion(region, animated: true)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapViewes

        init(_ parent: MapViewes) {
            self.parent = parent
        }

        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            guard let annotation = view.annotation else { return }
            parent.coordinate = annotation.coordinate
        }
    }
}
