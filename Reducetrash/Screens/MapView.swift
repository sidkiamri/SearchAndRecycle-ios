//
//  MapView.swift
//  Reducetrash
//
//  Created by taha majdoub on 16/3/2023.
//

import SwiftUI
import MapKit
import CoreLocation
import CoreLocationUI

struct DetailView: View {
    @Binding var can: Can?
    @Binding var isPresented: Bool
    @State var region: MKCoordinateRegion
    
    var body: some View {
        NavigationView {
            VStack {
                Text(can?.name ?? "Unknown")
                    .font(.title)
                    .padding()
                Text("Commodity Waste Separated: \(can?.commodityWasteSeparated ?? "Unknown")")
                    .padding()
                Spacer()
                
                // Center map on user's location button
                Button(action: {
                    if let userLocation = CLLocationManager().location?.coordinate {
                        region = MKCoordinateRegion(center: userLocation, span: region.span)
                    }
                }) {
                    Text("Center on my location")
                }
                .padding()
            }
            .navigationBarTitle(Text(can?.name ?? ""), displayMode: .inline)
            .navigationBarItems(trailing: Button("Done") {
                isPresented = false
            })
        }
        .onAppear {
            // set initial region to user's location
            if let userLocation = CLLocationManager().location?.coordinate {
                region = MKCoordinateRegion(center: userLocation, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
            }
        }
    }
}


struct MapView: View {
    
    
    @State var selectedCan: Can?
    @State var showingDetail = false
    @Binding var userLocation: CLLocationCoordinate2D?
    @State var cans: [Can] = []
    
    
    
    var body: some View {
        ZStack {
            
            ClusterMap(selectedCan: $selectedCan, showingDetail: $showingDetail, userLocation: userLocation, cans: cans)
                .navigationBarTitle("Map")
                .sheet(isPresented: $showingDetail) {
                    if selectedCan != nil {
                        DetailView(can: $selectedCan, isPresented: $showingDetail, region: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)))
                    }
                }
        }
    }
    
}
