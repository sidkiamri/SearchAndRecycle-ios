//
//  HelloScreen.swift
//  Reducetrash
//
//  Created by taha majdoub on 7/4/2023.
//

import SwiftUI

struct HelloScreen: View {
    @State private var isShowingAccountDetails = false
    
    var body: some View {
        let email = UserDefaults.standard.string(forKey: "emailuser") ?? ""
        let name = UserDefaults.standard.string(forKey: "nameuser") ?? ""
        
        NavigationView {
            ZStack {
                Color("").edgesIgnoringSafeArea(.all)
                
                VStack {
                    Image(uiImage: #imageLiteral(resourceName: "logo"))
                        .resizable()
                        .frame(width: 167, height: 156)
                        .clipped()
                        .frame(width: 167, height: 156)
                    
                    Text("Sign back in")
                        .font(.system(size: 28.2, weight: .bold))
                        .foregroundColor(Color(#colorLiteral(red: 0.29, green: 0.29, blue: 0.29, alpha: 1)))
                        .multilineTextAlignment(.center)
                    
                    Text("Choose from accounts saved on this device")
                        .font(.system(size: 21.2, weight: .medium))
                        .foregroundColor(Color(#colorLiteral(red: 0.47, green: 0.47, blue: 0.47, alpha: 1)))
                        .multilineTextAlignment(.center)
                    
                    
                    Button(action: {
                        isShowingAccountDetails = true
                    }) {
                        HStack {
                            Image("avatar")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                            
                            VStack(alignment: .leading) {
                                if name.isEmpty {
                                    Text(email)
                                        .font(.headline)
                                } else {
                                    Text(name)
                                        .font(.headline)
                                }
                                
                                Text(email)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            .fullScreenCover(isPresented: $isShowingAccountDetails) {
                                AccountDetailsView(isPresented: $isShowingAccountDetails)
                            }
                            
                           
                            .listStyle(GroupedListStyle())
                            .padding(.horizontal)
                            

                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(Color("text"))
                        }
                    }
                    .buttonStyle(AccountButtonStyle())
                    .padding(.horizontal, 20)
                    .padding(.top, 30)
                    
                    Spacer()
                }
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        // Handle back button action here
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(Color("text"))
                            .imageScale(.large)
                    }
                }
            }
        }
    }
}

struct AccountButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(10)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
    }
}

                 


