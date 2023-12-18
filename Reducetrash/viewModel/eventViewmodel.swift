import Foundation

struct Event: Codable, Identifiable {
    let id: String
    let title: String
    let description: String
    let date: String
    let address: String
    let location: Location
    let owner: Owner
    let participants: [Participant]

    var formattedDate: Date? {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            return dateFormatter.date(from: date)
        }
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title, description, date, address, location, owner, participants
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        date = try container.decode(String.self, forKey: .date)

        address = try container.decode(String.self, forKey: .address)
        location = try container.decode(Location.self, forKey: .location)
        owner = try container.decode(Owner.self, forKey: .owner)
        participants = try container.decode([Participant].self, forKey: .participants)
       
        
   
    
    }
}

struct Location: Codable {
    let type: String
    let coordinates: [Double]
}

struct Owner: Codable {
    let id: String
    let name: String

    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name

    }
}

struct Participant: Codable {
    let id: String
    let name: String

    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name

    }
}

class EventListViewModel: ObservableObject {
    @Published var events: [Event] = []
    
    func fetchEvents() {
        // Call the backend API to fetch events
        let url = URL(string: "http://localhost:9091/event")!
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    let decodedResponse = try decoder.decode([Event].self, from: data)
                    DispatchQueue.main.async {
                                        self.events = decodedResponse
                                        print("Events count: \(self.events.count)")
                                    }
                                } catch let DecodingError.dataCorrupted(context) {
                                    print(context)
                                } catch let DecodingError.keyNotFound(key, context) {
                                    print("Key '\(key)' not found:", context.debugDescription)
                                    print("codingPath:", context.codingPath)
                                } catch let DecodingError.valueNotFound(value, context) {
                                    print("Value '\(value)' not found:", context.debugDescription)
                                    print("codingPath:", context.codingPath)
                                } catch let DecodingError.typeMismatch(type, context) {
                                    print("Type '\(type)' mismatch:", context.debugDescription)
                                    print("codingPath:", context.codingPath)
                                } catch {
                                    print("JSON decode failed: \(error.localizedDescription)")
                                }
                            } else if let error = error {
                                print("Network request failed: \(error.localizedDescription)")
                            }
                            // Handle errors
                        }.resume()
    }
}


