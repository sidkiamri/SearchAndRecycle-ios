import SwiftUI
import MapKit
import CoreLocation

struct EventListView: View {
    @ObservedObject var eventListViewModel = EventListViewModel()

    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d, yyyy h:mm a"
        return formatter
    }()

    var body: some View {
        NavigationView {
            VStack {
                List(eventListViewModel.events ?? [], id: \.id) { event in
                    NavigationLink(destination: EventDetailView(event: event)) {
                        EventRowView(event: event, dateFormatter: dateFormatter)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.vertical, 8)
                }
                .listStyle(InsetListStyle())
                .padding(.vertical, 8)
            }
            .navigationBarTitle("Events", displayMode: .large)
            .navigationBarItems(trailing: NavigationLink(destination: CreateEventForm(viewModel: CreateEventViewModel()), label: {
                Image(systemName: "plus.circle.fill")
                    .font(.title)
                    .foregroundColor(.blue)
                    .padding(8)
                    .background(Color.white)
                    .clipShape(Circle())
                    .shadow(radius: 4)
            }))
            .onAppear() {
                eventListViewModel.fetchEvents()
            }
        }
    }
}

struct EventRowView: View {
    let event: Event
    let dateFormatter: DateFormatter
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(event.title)
                .font(.headline)

            if let date = dateFormatter.date(from: event.date) {
                Text(date, formatter: dateFormatter)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            } else {
                Text("Invalid date format")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
}



struct EventDetailView: View {
    @State private var event: Event
    @State private var userLocation: CLLocationCoordinate2D?
    
    public init(event: Event) {
        self._event = State(initialValue: event)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Use a large, bold font for the event title
              
                
                // Use a smaller, lighter font for the event owner name
                Text("Hosted by \(event.owner.name)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                // Use a more readable font for the event description
                Text(event.description)
                    .font(.body)
                
                // Use icons and a map for the event location
                HStack(spacing: 10) {
                    Image(systemName: "location.fill")
                        .foregroundColor(.blue)
                    
                    Text(event.address)
                        .font(.subheadline)
                }
                
                MapViewe(event: event, userLocation: userLocation)
                    .frame(height: 200)
                    .cornerRadius(10)
                
                // Use a horizontal stack of participant views with rounded corners
                Text("Participants")
                                    .font(.headline)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(event.participants, id: \.id) { participant in
                            ParticipantView(participant: participant)
                                .cornerRadius(10)
                        }
                    }
                }
            }
            .padding(20)
        }
        .navigationBarTitle(Text(event.title), displayMode: .inline)
        .onAppear {
            // Get the user's current location
            let locationManager = CLLocationManager()
            locationManager.requestWhenInUseAuthorization()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            userLocation = locationManager.location?.coordinate
        }
        // Use a consistent color scheme throughout the view
        .background(Color.white)
        .foregroundColor(Color.black)
    }
}


struct CustomTextView: View {
    var text: String
    var size: Font
    var color: Color = .primary
    
    var body: some View {
        Text(text)
            .font(size)
            .foregroundColor(color)
    }
}

struct ParticipantView: View {
    let participant: Participant
    
    var body: some View {
        VStack {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 60, height: 60, alignment: .center)
                .foregroundColor(.blue)
                Text(participant.name)
                .font(.caption)
                .multilineTextAlignment(.center)
                }
                }
                }

struct MapViewe: UIViewRepresentable {
    let event: Event
    let userLocation: CLLocationCoordinate2D?

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: .zero)
        mapView.showsUserLocation = true // Enable user location
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: event.location.coordinates[1], longitude: event.location.coordinates[0])
        uiView.addAnnotation(annotation)
        uiView.setRegion(MKCoordinateRegion(center: annotation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)), animated: true)
    }
}



    struct EventListView_Previews: PreviewProvider {
        static var previews: some View {
            EventListView()
        }
    }
