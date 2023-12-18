//
//  WelcomeScreenView.swift
//  Reducetrash
//
//  Created by taha majdoub on 21/2/2023.
//

import SwiftUI

struct WelcomeScreenView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color("").edgesIgnoringSafeArea(.all)
                VStack {
                    Spacer()
                    Image(uiImage: #imageLiteral(resourceName: "logo"))
                        .resizable()
                        .frame(width: 247, height: 231)
                        .clipped()
                        .frame(width: 247, height: 231)
                    Text("Trash Reduce")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(Color(#colorLiteral(red: 0.47, green: 0.78, blue: 0, alpha: 1)))
                        .multilineTextAlignment(.center)
                    Text("Search And Recycle")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color(#colorLiteral(red: 0.47, green: 0.47, blue: 0.47, alpha: 1)))
                        .multilineTextAlignment(.center)
                    Spacer()
                    VStack {
                        NavigationLink(destination: WelcomeScreen2View()) {
                            PrimaryButton(title: "Get Started")
                        }
                        NavigationLink(destination: HelloScreen()) {
                            Text("I already have an account")
                                .font(.system(size: 16.6, weight: .bold))
                                .foregroundColor(Color(#colorLiteral(red: 0.55, green: 0.78, blue: 0.25, alpha: 1)))
                                .multilineTextAlignment(.center)
                                .textCase(.uppercase)
                                .frame(maxWidth: .infinity,minHeight: 30)
                                .padding()
                                .background(Color("Color"))
                                .cornerRadius(20)
                        }
                        .navigationBarBackButtonHidden(true)


                    }
                    .padding(.horizontal, 20);
                                      
                  
            }
                
            }
           
        }

    }
}


struct NextScreen: View {
    var body: some View {
        Text("Enter your name and birthdate")
            .font(.system(size: 27.5, weight: .bold))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading)
        
    }
}




                          







