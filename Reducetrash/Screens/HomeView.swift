import SwiftUI
struct HomeView: View {
    @State private var showEventDetails = false
    
    var body: some View {
        VStack {
            VStack {
                Text("Home")
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
            .frame(maxWidth: .infinity)
            .background(Color.white)
            
            VStack(alignment: .leading, spacing: 16) {
                Text("Welcome back")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Sidki Amri")
                    .font(.headline)
                    .foregroundColor(.gray)
                
                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField("Event Search", text: .constant(""))
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .padding(.horizontal)
                
                Text("Friends")
                    .font(.headline)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        Image("pluss")
                            .resizable()
                            .frame(width: 50, height: 50)
                        ForEach(1..<10) { index in
                            Image("user")
                                .resizable()
                                .frame(width: 60, height: 60)
                        }
                    }
                    .padding(.horizontal)
                }
                
                Text("Events")
                    .font(.headline)
                
                ScrollView(.vertical, showsIndicators: true) {
                    VStack(spacing: 16) {
                        ForEach(1..<10) { index in
                            EventCell()
                                .onTapGesture {
                                    showEventDetails = true
                                }
                        }
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
            }
            .padding(16)
        }
        .background(Color.white)
        .cornerRadius(16)
        .shadow(radius: 5, x: 0, y: 5)
        .navigationBarTitle("Home")
        .sheet(isPresented: $showEventDetails) {
            EventDetailsView()
        }
    }
}

struct EventCell: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image("eventimage1") // use the parameter for the image name
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 150)
                .cornerRadius(8)
            HStack(alignment: .center, spacing: 8) {
                Text("Event Title")
                    .font(.headline)
                Spacer()
                Image(systemName: "calendar")
                Text("Mar 30, 2023 6:30PM")
                    .font(.caption)
            }
            
            HStack(alignment: .center, spacing: 8) {
                Image(systemName: "person.2")
                Text("10 Participants")
                    .font(.caption)
                Spacer()
                Image(systemName: "location")
                Text("123 Main St")
                    .font(.caption)
            }
        }
        .padding(.horizontal)
    }
}

struct EventDetailsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Event Details")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Image("eventimage1")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity)
                .frame(height: 200)
                .padding(.bottom, 16)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Cleaning Cap angela Forest")
                    .font(.title)
                    .fontWeight(.bold)
                
                HStack(alignment: .center, spacing: 8) {
                    Image(systemName: "calendar")
                    Text("Mar 30, 2023 6:30PM")
                        .font(.caption)
                }
                
                HStack(alignment: .center, spacing: 8) {
                    Image(systemName: "person.2")
                    Text("10 Participants")
                        .font(.caption)
                    Spacer()
                    Image(systemName: "location")
                    Text("Cap angela forest")
                        .font(.caption)
                }
                
                Text("Event Description")
                    .font(.headline)
                
                Text("Join us for an unforgettable experience of cleaning a forest! This event is a great opportunity to connect with nature !")
                    .font(.body)
                    .lineLimit(nil)
            }
            .padding(16)
            
            Spacer()
            
            VStack {
                Spacer()
                Button(action: {
                    // Handle participate button action here
                }, label: {
                    Text("Participate")
                        .foregroundColor(.white)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 16)
                        .background(Color.green)
                        .cornerRadius(8)
                        .shadow(radius: 5, x: 0, y: 5)
                })
                Spacer(minLength: 8)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 16)
        }
        .background(Color.white)
        .cornerRadius(16)
        .padding(16)
        .shadow(radius: 5, x: 0, y: 5)
    }
}
