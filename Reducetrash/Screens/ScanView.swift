//
//  ScanView.swift
//  Reducetrash
//
//  Created by taha majdoub on 16/3/2023.
//

//
//  ObjectDetectionView.swift
//  ReduceTrash
//
//  Created by Taha Majdoub on 16/3/2023.
//

import SwiftUI
import PhotosUI
import CoreML
import UIKit
import Vision
import SwiftUI
import Foundation
import SwiftUI

struct CreateRecyclingWasteView: View {
    @State private var name = ""
       @State private var description = ""
       @State private var points = 0
       @State private var imageUrl = ""
       @State private var acceptedMaterials = ""
       @State private var recycleMethod = ""
       @State private var recyclable = false
       @State private var errorMessage = ""
       @State private var showImagePicker = false
       @State private var selectedImage: UIImage?
       @State var wasteTypes: [WasteType] = []
       @State var selectedwasteTypes: WasteType?
       @State private var showAlert = false
       @State private var alertTitle = ""
       @State private var alertMessage = ""

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Create Recycling Waste")
                        .font(.title)
                        .bold()
                    
                    TextField("Name", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    TextField("Description", text: $description)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    Stepper("Points: \(points)", value: $points, in: 0...10)
                        .padding(.horizontal)
                    
                    Button(action: {
                        showImagePicker = true
                    }, label: {
                        if let image = selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 200)
                        } else {
                            Text("Select Image")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green)
                                .cornerRadius(10)
                        }
                    })
                    .sheet(isPresented: $showImagePicker, onDismiss: loadImage) {
                        ImagePicker(selectedImage: $selectedImage)
                    }
                    .padding(.horizontal)
                    
                    Picker("Accepted material", selection: $acceptedMaterials) {
                        ForEach(wasteTypes, id: \.id) { wasteType in
                            Text(wasteType.description).tag(wasteType._id)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .onAppear {
                        fetchWasteTypes()
                        if !wasteTypes.isEmpty {
                            acceptedMaterials = wasteTypes[0].description
                        }
                    }
                    .padding(.horizontal)
                    
                    TextField("Recycle Method", text: $recycleMethod)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    Toggle("Recyclable", isOn: $recyclable)
                        .toggleStyle(SwitchToggleStyle(tint: Color.green))
                        .padding(.horizontal)
                    
                   
                    
                    Button(action: {
                                            createRecyclingWaste()
                                        }, label: {
                                            Text("Create Recycling Waste")
                                                .font(.headline)
                                                .foregroundColor(.white)
                                                .frame(maxWidth: .infinity)
                                                .padding()
                                                .background(Color.green)
                                                .cornerRadius(10)
                                        })
                                        .padding(.horizontal)
                                        .padding(.top)

                                        Text(errorMessage)
                                            .foregroundColor(.red)
                                            .padding(.horizontal)
                                            .padding(.top)
                                    }
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(20)
                                    .shadow(radius: 10)
                                }
                                .navigationBarTitle("", displayMode: .inline)
                                  .navigationBarItems(trailing:
                                                                        Button(action: {
                                                                            showAlert = true
                                                                        }, label: {
                                                                            Image(systemName: "info.circle")
                                                                                .foregroundColor(.black)
                                                                        })
                                                                    )
                                                                    .alert(isPresented: $showAlert, content: {
                                                                        Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                                                                    })
                                                            }
                                                        }
            func fetchWasteTypes() {
                guard let url = URL(string: "http://localhost:9091/wasteType?acceptedForRecycling=true") else {
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
            func createRecyclingWaste() {
                guard !name.isEmpty, !description.isEmpty, !acceptedMaterials.isEmpty, !recycleMethod.isEmpty else {
                    errorMessage = "Please fill in all fields."
                    return
                }
                
                guard let image = selectedImage, let imageData = image.jpegData(compressionQuality: 0.8) else {
                    errorMessage = "Please select an image."
                    return
                }
                
                let acceptedMaterialsList = [acceptedMaterials]
                
                let parameters: [String: Any] = [
                    "name": name,
                    "description": description,
                    "points": points,
                    "imageUrl": imageUrl,
                    "acceptedMaterials": acceptedMaterialsList,
                    "recycleMethod": recycleMethod,
                    "recyclable": recyclable
                ]
                
                guard let jsonData = try? JSONSerialization.data(withJSONObject: parameters) else {
                    errorMessage = "Failed to create JSON data."
                    return
                }
                
                guard let url = URL(string: "http://localhost:9091/recyclewaste") else {
                    errorMessage = "Invalid URL."
                    return
                }
                
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.httpBody = jsonData
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                
                URLSession.shared.dataTask(with: request) { data, response, error in
                    guard error == nil else {
                        DispatchQueue.main.async {
                            errorMessage = error?.localizedDescription ?? "Unknown error"
                        }
                        return
                    }
                    
                    guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                        DispatchQueue.main.async {
                            errorMessage = "Failed to create Recycling Waste"
                        }
                        return
                    }
                    
                    DispatchQueue.main.async {
                        errorMessage = ""
                        name = ""
                        description = ""
                        points = 0
                        imageUrl = ""
                        acceptedMaterials = ""
                        recycleMethod = ""
                        recyclable = false
                    }
                    
                    print("Recycling Waste created successfully")
                }.resume()
            }
            func loadImage() {
                guard let selectedImage = selectedImage else { return }
                imageUrl = "data:image/jpeg;base64,\(selectedImage.jpegData(compressionQuality: 0.8)?.base64EncodedString() ?? "")"
            }
        }
    
struct CreateRecyclingWasteView_Previews: PreviewProvider {
    static var previews: some View {
        CreateRecyclingWasteView()
    }
}



struct PhotoView: View {
    
    @State var selectedItems: [PhotosPickerItem] = []
    @State var data: Data?
    @State var isShown = false
    @State var sourceType: UIImagePickerController.SourceType = .camera
    @State var selectedImage: UIImage?
    
    @StateObject var photoViewModel = PhotoViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if let data = data, let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 300)
                        .cornerRadius(15)
                        .padding()
                    
                    List {
                        Section(header: Text("Machine identifies this object as:")
                            .font(.headline)
                            .foregroundColor(.secondary)) {
                                ForEach(photoViewModel.detectedObjects ?? [], id: \.self) { item in
                                    NavigationLink(destination: CreateRecyclingWasteView()) {
                                        Text(item.identifier.capitalized)
                                            .foregroundColor(.primary)
                                    }
                                }
                            }
                    }
                    .listStyle(.insetGrouped)
                    .frame(height: 200)
                    .cornerRadius(15)
                    .padding(.horizontal)
                } else {
                    Image("Placeholder")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 300)
                        .cornerRadius(15)
                        .padding()
                }
                
                PhotosPicker(
                    selection: $selectedItems,
                    maxSelectionCount: 1,
                    matching: .images
                ) {
                    Text("Pick Photo")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(RoundedRectangle(cornerRadius: 15).fill(Color.green))
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal)
                }
                .onChange(of: selectedItems) { newValue in
                    if let item = selectedItems.first {
                        item.loadTransferable(type: Data.self) { result in
                            switch result {
                            case .success(let data):
                                if let data = data {
                                    self.data = data
                                    photoViewModel.pictureIdentifyML(image: UIImage(data: data)!)
                                    
                                    // Save the selected image to UserDefaults
                                    UserDefaults.standard.set(data, forKey: "selectedImage")
                                } else {
                                    print("Data is nil")
                                }
                            case .failure(let failure):
                                fatalError("\(failure)")
                            }
                        }
                    }
                }
                
                Spacer()
                
            }
            .navigationBarTitle(
                Text("Object Detection")
                    .font(.system(size: 25, weight: .bold, design: .default))
                    .foregroundColor(.white),
                displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .background(Color.green.opacity(0.2).ignoresSafeArea())
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        // Handle back button action here
                    }, label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.leading, 5)
                    })
                }
            }
        }
    }
    
}
