//
//  AccountDetailsView.swift
//  Reducetrash
//
//  Created by taha majdoub on 25/2/2023.
//

import SwiftUI


struct AccountDetailsView: View {
    @Binding var isPresented: Bool
    
    var email = UserDefaults.standard.string(forKey: "emailuser") ?? ""
    var phone = UserDefaults.standard.string(forKey: "phoneuser") ?? ""
    var birth = UserDefaults.standard.string(forKey: "birthdateuser") ?? ""
    var name = UserDefaults.standard.string(forKey: "nameuser") ?? ""
    
    @State private var password: String = ""
    @State private var showDashboard: Bool = false
    @State private var showPasswordRecovery: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
                    func login() {
                        let url = URL(string: "http://localhost:9091/register/login")!
                        var request = URLRequest(url: url)
                        request.httpMethod = "POST"
                        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                        
                        let parameters = ["email": email, "password": password]
                        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
                            return
                        }
                        request.httpBody = httpBody
                        
                        let session = URLSession.shared
                        let task = session.dataTask(with: request) { [self] (data, response, error) in
                            if let error = error {
                                self.showAlert = true
                                return
                            }
                            
                            guard let httpResponse = response as? HTTPURLResponse else {
                                self.alertMessage = "Error: No response from server"
                                self.showAlert = true
                                return
                            }
                            
                            if httpResponse.statusCode == 200 {
                                // Login successful, save user data and dismiss view
                                UserDefaults.standard.setValue(email, forKey: "emailuser")
                                // ... save other user data as needed
                                DispatchQueue.main.async {
                                    self.showDashboard = true
                                }
                            } else {
                                self.alertMessage = "Invalid email or password"
                                self.showAlert = true
                            }
                        }
                        task.resume()
                    }


    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .padding()
                    .shadow(radius: 5)
                
                Text(name)
                    .font(.title)
                    .padding(.bottom, 10)
                
                Text(email)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 10)
                
                Button(action: {
                    // Call the login function here
                    login()
                }) {
                    Text("Login")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                        .background(Color("ColorButton"))
                        .cornerRadius(8)
                        .padding(.horizontal, 50)
                        .padding(.vertical, 20)
                }
                .padding(.top, 20)
                
                Button(action: {
                    showPasswordRecovery = true
                }) {
                    Text("Forgot Password?")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                

                                                                                Spacer()
                                                            }
                                                            .navigationBarTitle("")
                                                            .navigationBarBackButtonHidden(true)
                                                            .navigationBarItems(
                                                                                leading:
                                                                                                    Button(action: {
                                                                                                                        // dismiss the current view
                                                                                                                        isPresented = false
                                                                                                    }, label: {
                                                                                                                        Image(systemName: "chevron.left")
                                                                                                                                            .foregroundColor(Color("ColorButton"))
                                                                                                                                            .font(.headline)
                                                                                                    })
                                                                                                    .padding(.leading, 16)
                                                                                                    .padding(.top, 16),
                                                                                trailing:
                                                                                                    EmptyView()
                                                            )
                                                            .padding(.horizontal, 20)
                                                            .background(Color.white.edgesIgnoringSafeArea(.all))
                                                            .sheet(isPresented: $showPasswordRecovery) {
                                                                                PasswordRecoveryView()
                                                            }
                                                            .background(
                                                                                NavigationLink(destination: DashboardView(), isActive: $showDashboard) {
                                                                                                    EmptyView()
                                                                                }
                                                            )
                                        }}
                    struct PasswordRecoveryView: View {
                                        @State private var email: String = ""
                                        
                                        var body: some View {
                                                            VStack {
                                                                                Text("Forgot Password?")
                                                                                                    .font(.custom("Montserrat-Bold", size: 30))
                                                                                                    .foregroundColor(.black)
                                                                                                    .padding(.top, 50)
                                                                                
                                                                                
                                                                                Spacer()
                                                                                
                                                                                VStack(alignment: .leading, spacing: 20) {
                                                                                                    Text("Enter your email address to receive a recovery link:")
                                                                                                                        .font(.custom("Montserrat-Medium", size: 20))
                                                                                                                        .foregroundColor(.white)
                                                                                                    
                                                                                                    TextField("Email Address", text: $email)
                                                                                                                        .padding(.vertical, 10)
                                                                                                                        .padding(.horizontal, 20)
                                                                                                                        .background(
                                                                                                                                            RoundedRectangle(cornerRadius: 8)
                                                                                                                                                                .fill(Color.white)
                                                                                                                                                                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                                                                                                                        )
                                                                                                                        .font(.custom("Montserrat-Regular", size: 18))
                                                                                                                        .autocapitalization(.none)
                                                                                                                        .keyboardType(.emailAddress)
                                                                                                                        .disableAutocorrection(true)
                                                                                                    
                                                                                                    Spacer()
                                                                                                    
                                                                                                    Button(action: {
                                                                                                                        // Add password recovery logic here
                                                                                                                        print("Password recovery initiated for email: \(email)")
                                                                                                    }) {
                                                                                                                        Text("Submit")
                                                                                                                                            .font(.custom("Montserrat-Bold", size: 20))
                                                                                                                                            .foregroundColor(.white)
                                                                                                                                            .padding(.vertical, 12)
                                                                                                                                            .frame(maxWidth: .infinity)
                                                                                                                                            .background(
                                                                                                                                                                RoundedRectangle(cornerRadius: 8)
                                                                                                                                                                                    .fill(Color("ColorButton"))
                                                                                                                                                                                    .shadow(color: Color("ColorButton").opacity(0.6), radius: 5, x: 0, y: 2)
                                                                                                                                            )
                                                                                                                                            .padding(.horizontal, 50)
                                                                                                                                            .padding(.vertical, 20)
                    }
                                                            .disabled(email.isEmpty)
                                                            .opacity(email.isEmpty ? 0.5 : 1)
                                                                                }.padding(.horizontal, 20)
                                                                                .padding(.bottom, 50)
                                                                                .background(Image("background").resizable().scaledToFill().opacity(0.9))
                                                                                .cornerRadius(20)
                                                                                .padding(.horizontal, 20)
                                                                                Spacer()
                                                            }.background(Color("BackgroundColor").edgesIgnoringSafeArea(.all)
                                                            )
                                        }
                    }
}
