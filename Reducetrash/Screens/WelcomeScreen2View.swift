//
//  WelcomeScreen2View.swift
//  Reducetrash
//
//  Created by taha majdoub on 16/3/2023.
//

import SwiftUI

struct WelcomeScreen2View: View {
    @State private var isNextButtonTapped = false
    @State private var isVerifyPhoneNumberViewActive = false

    @State private var email = UserDefaults.standard.string(forKey: "email") ?? ""
    private let termsAndPolicyText = Text("By continuing, you agree to ").font(.system(size: 16)).foregroundColor(Color(#colorLiteral(red: 0.54, green: 0.55, blue: 0.56, alpha: 1))) + Text("Trash").font(.system(size: 16, weight: .bold)) + Text(" ").font(.system(size: 16, weight: .medium)) + Text("reduce’s").font(.system(size: 16, weight: .bold)) + Text(" ").font(.system(size: 16)).foregroundColor(Color(#colorLiteral(red: 0.54, green: 0.55, blue: 0.56, alpha: 1))) + Text("Terms of Service").font(.system(size: 16, weight: .bold)) + Text(" and confirm that you have read ").font(.system(size: 16)).foregroundColor(Color(#colorLiteral(red: 0.54, green: 0.55, blue: 0.56, alpha: 1))) + Text("Trash reduce’s").font(.system(size: 16, weight: .bold)).foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.81))) + Text(" ").font(.system(size: 16)).foregroundColor(Color(#colorLiteral(red: 0.54, green: 0.55, blue: 0.56, alpha: 1))) + Text("Privacy Policy").font(.system(size: 16, weight: .bold)) + Text(".").font(.system(size: 16)).foregroundColor(Color(#colorLiteral(red: 0.54, green: 0.55, blue: 0.56, alpha: 1)))
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
       
        NavigationView {

            VStack(alignment: .leading, spacing: 20) {
               

                Text("Email")
                    .font(.system(size: 27.5, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
                
                Text("You can change this later.")
                    .font(.system(size: 16.1))
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
                
                TextField("Email", text: $email)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)

                termsAndPolicyText
                    .lineSpacing(4)
                    .multilineTextAlignment(.leading)
                    .padding()
                
                NavigationLink(
                               destination: BirthdayScreen(),

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
            .navigationBarTitle(" ")
            .navigationBarHidden(true) // hides the navigation bar
            .navigationBarBackButtonHidden(true)

            .navigationBarItems(leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
                
            }) {
                Image(systemName: "xmark")
                    .font(.system(size: 23, weight: .medium))
                    .foregroundColor(Color(#colorLiteral(red: 0, green: 0.52, blue: 0, alpha: 1)))
                    .tracking(0)
                    .padding(.leading)
            })
        }
        .onChange(of: email) { newValue in
                      UserDefaults.standard.set(newValue, forKey: "email")
                  }

    }

}

