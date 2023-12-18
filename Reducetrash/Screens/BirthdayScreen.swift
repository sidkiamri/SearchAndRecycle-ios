//
//  BirthdayScreen.swift
//  Reducetrash
//
//  Created by taha majdoub on 16/3/2023.
//

import SwiftUI

struct BirthdayScreen: View {
    @State private var name = ""
    @State private var birthdate = Date()
    
    var body: some View {
        NavigationView {
            
            VStack {
                Text("Enter your name and birthdate")
                    .font(.system(size: 27.5, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
                
                TextField("Name", text: $name)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                DatePicker("Birthdate", selection: $birthdate, displayedComponents: [.date])
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                
                NavigationLink(
                    destination: EnterPhoneNumberView(),
                    label: {
                        Text("Next")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color("ColorButton"))
                            .cornerRadius(8)
                            .padding(.leading)
                    })
                
             
            }
            .padding()
            

        }
        .navigationBarTitle(" ")
        .navigationBarBackButtonHidden(true)
        .onChange(of: birthdate) { newValue in
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .none
            let dateString = formatter.string(from: newValue)
            UserDefaults.standard.set(dateString, forKey: "birthdate")
        }
        .onChange(of: name) { newValue in
                      UserDefaults.standard.set(newValue, forKey: "name")
                  }
    }
    }

