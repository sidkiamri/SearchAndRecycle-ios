import Foundation

struct WasteType: Codable, Equatable, Hashable, Identifiable {
    let _id: String
    let description: String
    let imageUrl: String
    let decompositionTime: String
    let kills: Int
    let cans: Int
    
    var id: String {
        return _id
    }
}


