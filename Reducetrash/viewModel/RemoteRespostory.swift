
import Foundation
import UIKit
import Combine

enum ApiError: Error {
    case buildUrl
    case jsonDecoder
}

class RemoteRepository {
    
    let BASE_URL = "https://us-central1-zero-waste-5fe61.cloudfunctions.net/app/"
    
    let categories: [String: String] = [
        "Paper": "Paper",
        "Biological waste" : "biological%20waste",
        "Clothes" : "Clothes",
        "White glass" : "white%20glass",
        "Stained glass" : "stained%20glass",
        "Plastic" : "Plastic",
        "Beverage cartons" : "beverage%20cartons",
        "Cans" : "Cans"
    ]
    
    func fetchWasteTypeInfo(category: String) async -> Result<WasteType, ApiError> {
        let wasteType: WasteType
        
        guard let url = URL(string: BASE_URL + "waste_type/\(categories[category]!.lowercased())") else {
            return .failure(.buildUrl)
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            wasteType = try JSONDecoder().decode(WasteType.self, from: data)
        } catch {
            print(error)
            return .failure(.jsonDecoder)
        }
        
        return .success(wasteType)
    }
    
    func fetchAllCans() async -> Result<[Can], ApiError> {
        let cans: [Can]
        
        guard let url = URL(string: BASE_URL + "cans/all") else {
            return .failure(.buildUrl)
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            cans = try JSONDecoder().decode([Can].self, from: data)
        } catch {
            print(error)
            return .failure(.jsonDecoder)
        }
        
        return .success(cans)
    }
    
    func fetchCansBy(category: String) async -> Result<[Can], ApiError> {
        let cans: [Can]

        guard let url = URL(string: BASE_URL + "cans?type=\(category)") else {
            return .failure(.buildUrl)
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            cans = try JSONDecoder().decode([Can].self, from: data)
        } catch {
            print(error)
            return .failure(.jsonDecoder)
        }
        
        return .success(cans)
    }
}
