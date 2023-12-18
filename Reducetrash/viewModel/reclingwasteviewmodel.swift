import Foundation

enum Recyclability: String, Codable, CaseIterable {
    case recyclable
    case notRecyclable
}

struct RecyclableWaste: Codable {
    let name: String
    let description: String
    let points: Int
    let imageUrl: String
    let recycleMethod: String
    let recyclability: Recyclability
    let acceptedMaterials: WasteType
}

typealias CreateRecyclableWasteCompletion = (Result<Void, Error>) -> Void

class RecyclingWasteViewModel: ObservableObject {
    @Published var name = ""
    @Published var description = ""
    @Published var points = 0
    @Published var imageUrl = ""
    @Published var recycleMethod = ""
    @Published var recyclability = Recyclability.recyclable
    @Published var selectedAcceptedMaterial: WasteType?
    {
        didSet {
            print(selectedAcceptedMaterial?.description ?? "nil")
        }
    }
    @Published var acceptedMaterialsDescription = ""
    
    var wasteTypes = [WasteType]() {
        didSet {
            acceptedMaterialsDescription = wasteTypes.map { $0.description }.joined(separator: ", ")
            selectedAcceptedMaterial = wasteTypes.first
        }
    }
    
    public func getWasteTypes() -> [WasteType] {
        return self.wasteTypes
    }
    init() {
        fetchWasteTypes()
    }
    private func fetchWasteTypes() {
        let urlString = "http://localhost:9091/wasteType"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                print(error ?? "Unknown error")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let wasteTypes = try decoder.decode([WasteType].self, from: data)
                DispatchQueue.main.async {
                    self.wasteTypes = wasteTypes
                }
            } catch {
                print(error)
            }
        }.resume()
    }

    func createRecyclableWaste(completion: @escaping CreateRecyclableWasteCompletion) {
        guard let acceptedMaterial = selectedAcceptedMaterial else {
            completion(.failure(NSError(domain: "RecyclingWasteViewModel", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid accepted material"])))
            return
        }
        
        let urlString = "http://localhost:9091/recyclewaste"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "RecyclingWasteViewModel", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(RecyclableWaste(name: name, description: description, points: points, imageUrl: imageUrl, recycleMethod: recycleMethod, recyclability: recyclability, acceptedMaterials: acceptedMaterial))
            request.httpBody = jsonData
        } catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
                completion(.failure(error ?? NSError(domain: "RecyclingWasteViewModel", code: 0
                                                     , userInfo: [NSLocalizedDescriptionKey: "Unknown error"])))
                return
            }
            guard response.statusCode == 200 else {
                completion(.failure(NSError(domain: "RecyclingWasteViewModel", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey: "Error creating recyclable waste"])))
                return
            }
            
            completion(.success(()))
        }.resume()
    }
}
