//
//  dashboardView.swift
//  Reducetrash
//
//  Created by taha majdoub on 16/3/2023.
//

import SwiftUI
import CoreLocation

struct DashboardView: View {
    @State private var userLocation: CLLocationCoordinate2D?
       @State private var cans: [Can] = []

    enum Tab {
        case home, map, scan, recycle,Profile
    }
    
    @State private var selectedTab: Tab = .home
    
    var body: some View {
        TabView(selection: $selectedTab) {
            EventListView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(Tab.home)
            
            MapView(userLocation: $userLocation, cans: cans)

                .tabItem {
                    Image(systemName: "map.fill")
                    Text("Map")
                }
                .tag(Tab.map)
            
            PhotoView()
                .tabItem {
                    Image(systemName: "qrcode.viewfinder")
                    Text("Scan")
                }
                .tag(Tab.scan)
            
            WasteTypeListView()
                .tabItem {
                    Image(systemName: "arrow.triangle.2.circlepath")
                        .foregroundColor(Color("ColorButton"))
                    Text("Recycle")
                }
                .tag(Tab.recycle)
            ProfileScreen().tabItem {
                    Image(systemName: "person.circle.fill")
                    Text("profile")
                }
                .tag(Tab.Profile)
        }
        .accentColor(.green)
        // change navigation bar button color

        .navigationBarTitle(" ")
        
        .navigationBarBackButtonHidden(true)
        
    }
       
}
