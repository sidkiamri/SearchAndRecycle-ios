//
//  AddAccountView.swift
//  Reducetrash
//
//  Created by taha majdoub on 25/2/2023.
//

import SwiftUI
struct AddAccountView: View {
   
       
        @State private var username = ""
        @State private var email = ""
        @State private var password = ""
        
        
        
        var body: some View {
            VStack {
                Image(systemName: "person.crop.circle.badge.plus")
                    .font(.system(size: 100))
                    .padding()
                
                TextField("Username", text: $username)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .padding(.horizontal)
                
                TextField("Email", text: $email)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .padding(.horizontal)
                
                
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .padding(.horizontal)
                
                Button(action: {
                    // Add account logic here
                }) {
                    Text("Add Account")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .cornerRadius(8)
                }
                .padding()
            }
            .navigationBarTitle("Add Account")
        }
}
