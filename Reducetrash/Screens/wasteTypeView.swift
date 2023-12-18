//
//  WasteTypeView.swift
//  ReduceTrash
//
//  Created by Taha Majdoub on 11/4/2023.
//

import SwiftUI

struct WasteTypeListView: View {
    @State var wasteTypes: [WasteType] = []
    
    var body: some View {
        NavigationView {
            List(wasteTypes, id: \.description) { wasteType in
                NavigationLink(destination: WasteTypeDetailView(wasteType: wasteType)) {
                    WasteTypeRowView(wasteType: wasteType)
                }
            }
            .navigationBarTitle("Waste Types")
            .onAppear(perform: fetchWasteTypes)
        }
    }
    
    func fetchWasteTypes() {
        guard let url = URL(string: "http://localhost:9091/wasteType") else {
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode([WasteType].self, from: data) {
                    DispatchQueue.main.async {
                        self.wasteTypes = decodedResponse
                    }
                    return
                }
            }
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
    }
}

struct WasteTypeRowView: View {
    var wasteType: WasteType
    
    var body: some View {
        HStack {
            Image(systemName: "trash.circle.fill")
                .foregroundColor(.green)
                .font(.system(size: 32))
                .padding(.trailing, 10)
            VStack(alignment: .leading) {
                Text(wasteType.description)
                    .font(.headline)
                Text("\(wasteType.decompositionTime) days to decompose")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text("\(wasteType.kills) kills")
                    .font(.headline)
                Text("\(wasteType.cans) cans")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding()
    }
}

struct WasteTypeDetailView: View {
    var wasteType: WasteType
    @State var recycleWastes: [RecycleWaste] = []
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                CardView(imageURL: wasteType.imageUrl)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(wasteType.description)
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.primary)
                    
                    Text(wasteType.description)
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    HStack {
                        Image(systemName: "clock")
                            .foregroundColor(.secondary)
                        Text("\(wasteType.decompositionTime) days to decompose")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Divider()
                    
                    Text("Recycling Tips")
                        .font(.title)
                        .bold()
                        .foregroundColor(.primary)
                    
                    ForEach(recycleWastes) { recycleWaste in
                        RecyclingTipView(recycleWaste: recycleWaste)
                            .padding(.vertical, 8)
                    }
                }
                .padding()
            }
        }
        .navigationBarTitle(wasteType.description)
        .onAppear(perform: fetchRecyclingTips)
    }
    
    func fetchRecyclingTips() {
        guard let url = URL(string: "http://localhost:9091/recyclewaste/material/\(wasteType._id)") else {
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode([RecycleWaste].self, from: data) {
                    DispatchQueue.main.async {
                        self.recycleWastes = decodedResponse
                    }
                    return
                }
            }
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
    }
}

struct RecyclingTipView: View {
    var recycleWaste: RecycleWaste
    
    var body: some View {
        HStack {
            Image(systemName: "arrow.right.circle.fill")
                .foregroundColor(Color.green)
            
            Text(recycleWaste.name)
                .font(.headline)
                .foregroundColor(.primary)
            
            Spacer()
            
            Text("\(recycleWaste.points) pts")
                .font(.subheadline)
                .foregroundColor(Color.green)
        }
    }
}

struct CardView: View {
    var imageURL: String
    
    var body: some View {
        ZStack {
            Image(imageURL)
                .resizable()
                .aspectRatio(contentMode: .fill)
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Image(systemName: "leaf.fill")
                        .foregroundColor(.white)
                        .font(.title)
                    Text("Eco-friendly")
                        .bold()
                        .foregroundColor(.white)
                        .font(.headline)
                }
            }
        }
        .frame(height: 200)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

struct RecycleWaste:Identifiable, Decodable {
    let _id: String
    let name: String
    let description: String
    let points: Int
    let imageUrl: String
    let acceptedMaterials: [String]
    let recycleMethod: String
    let recyclable: Bool
    let createdAt: String
    let updatedAt: String
    var id: String { _id }

}
