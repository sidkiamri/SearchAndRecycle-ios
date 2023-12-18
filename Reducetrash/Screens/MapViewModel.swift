import Foundation
import Combine

class MapViewModel : ObservableObject {
        
    @Published var cans: [Can] = []
    var remoteRepositoryImpl = RemoteRepository()
    
    init() {
        fetchAllCans()        
    }
    
    func fetchAllCans() {
        Task {
            let result = await remoteRepositoryImpl.fetchAllCans()
            
            switch (result) {
            case let .success(data):
                DispatchQueue.main.async {
                    self.cans = data
                }
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func fetchCansBy(category: String) {
        Task {
            let result = await remoteRepositoryImpl.fetchCansBy(category: category)
            
            switch (result) {
            case let .success(data):
                DispatchQueue.main.async {
                    self.cans = data
                }
            case let .failure(error):
                print(error)
            }
        }
    }
}
