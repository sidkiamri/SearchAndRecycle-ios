//
//  AddPasswordView.swift
//  Reducetrash
//
//  Created by taha majdoub on 16/3/2023.
//

import SwiftUI

struct AddPasswordView: View {

    @ObservedObject var viewModel = AddPasswordViewModel()
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var showDashboard = false
    
    var body: some View {
        VStack {
            Text("Create a Password")
                .font(.system(size: 28, weight: .bold))
                .padding(.top, 20)
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Image(systemName: "lock")
                        .foregroundColor(.gray)
                    if viewModel.showPassword {
                        TextField("Password", text: $viewModel.password)
                    } else {
                        SecureField("Password", text: $viewModel.password)
                    }
                    Button(action: {
                        viewModel.showPassword.toggle()
                    }) {
                        Image(systemName: viewModel.showPassword ? "eye.slash" : "eye")
                            .foregroundColor(.gray)
                    }
                }
                HStack {
                    Image(systemName: "lock")
                        .foregroundColor(.gray)
                    if viewModel.showConfirmPassword {
                        TextField("Confirm Password", text: $viewModel.confirmPassword)
                    } else {
                        SecureField("Confirm Password", text: $viewModel.confirmPassword)
                    }
                    Button(action: {
                        viewModel.showConfirmPassword.toggle()
                    }) {
                        Image(systemName: viewModel.showConfirmPassword ? "eye.slash" : "eye")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding()
            Button(action: {
                viewModel.createPassword()
                                         { success in
                    if success {
                        showDashboard = true
                    } else {
                        showAlert = true
                        alertMessage = "Password creation failed. Please try again."
                    }
                }
            }) {
                
                Text("Create Password")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .cornerRadius(8)
                    .background(viewModel.password.count >= 8 && viewModel.password.rangeOfCharacter(from: .decimalDigits) != nil && viewModel.password == viewModel.confirmPassword ? Color.white : Color("ColorButton"))
                    .cornerRadius(10)
                    .padding(.all)

            }
            .disabled(viewModel.password.count < 8 || viewModel.password.rangeOfCharacter(from: .decimalDigits) == nil || viewModel.password != viewModel.confirmPassword)
            Spacer(minLength: 50)
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .fullScreenCover(isPresented: $showDashboard, content: {
            DashboardView()
        })
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading:
                                Button(action: {
                                    // Pop the view to go back
                                }) {
            Image(systemName: "chevron.left")
                .foregroundColor(.blue)
                .imageScale(.large)
        }
        )
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
    }
}
