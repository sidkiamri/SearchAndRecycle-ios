//
//  VerifyPhoneNumberView.swift
//  Reducetrash
//
//  Created by taha majdoub on 16/3/2023.
//

import SwiftUI

struct VerifyPhoneNumberView: View {
    @State private var verificationCode = ""
    @Environment(\.presentationMode) var presentationMode
    var phone = UserDefaults.standard.string(forKey: "Phone") ?? ""
    @State private var isVerificationScreenActive = false


    func verifyCode() {
        guard let url = URL(string: "http://localhost:9091/register/verify-code") else {
            return
        }
        let body: [String: Any] = ["phoneNumber": phone, "code": verificationCode]
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    print("success")
                    DispatchQueue.main.async {
                        isVerificationScreenActive = true
                    }
                }
                else {
                    print("Error: HTTP status code \(httpResponse.statusCode)")
                }
            }
        }
        task.resume()
    }

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Enter verification code")
                    .font(.system(size: 27.5, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)

                Text("We sent a verification code to your phone number.")
                    .font(.system(size: 16.1))
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)

                TextField("Verification code", text: $verificationCode)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Button(action: {
                    verifyCode()
                }, label: {
                    Text("Verify")
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
            .fullScreenCover(isPresented: $isVerificationScreenActive, content: {
                AddPasswordView()
            })
        }
        .navigationBarTitle(" ")
        .navigationBarBackButtonHidden(true)
    }
}
