import Foundation
import Vision
import CoreImage
import UIKit
import CoreML
import Combine

class PhotoViewModel: ObservableObject {
    
    @Published var detectedObjects: [VNClassificationObservation]? = nil
    
    func pictureIdentifyML(image: UIImage) {
        guard let model = try? VNCoreMLModel(for: Resnet50().model) else {
            fatalError("Cannot load ML model")
        }
        
        let request = VNCoreMLRequest(model: model) { request, error in
            guard let results = request.results as? [VNClassificationObservation], let _ = results.first else {
                fatalError("Cannot get result from VNCoreMLRequest")
            }
            
            DispatchQueue.main.async {
                self.detectedObjects = results.filter { $0.confidence > 0.1 }
            }
        }
        
        guard let ciImage = CIImage(image: image) else {
            fatalError("Cannot convert to CIImage")
        }
                
        DispatchQueue.global(qos: .userInteractive).async {
            do {
                try VNImageRequestHandler(ciImage: ciImage).perform([request])
            } catch {
                print("Error \(error)")
            }
        }
    }
    
    func identifyCategory(obj: String) -> String {
        switch obj.lowercased() {
        case "banana":
            return "Biological waste"
        case "sweatshirt":
            return "Clothes"
        case "pop bottle", "water bottle", "beer bottle", "lighter":
            return "Plastic"
        case "water jug":
            return "Stained glass"
        case "carton":
            return "Beverage cartons"
        default:
            return "Paper"
        }
    }
}
