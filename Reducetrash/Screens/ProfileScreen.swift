//
//  ProfileScreen.swift
//  Reducetrash
//
//  Created by taha majdoub on 16/3/2023.
//

import SwiftUI

struct ProfileScreen: View {
    @State private var fullName = "John Doe"
    @State private var phoneNumber = "555-555-5555"
    var email = UserDefaults.standard.string(forKey: "emailuser") ?? ""
    var phone = UserDefaults.standard.string(forKey: "phoneuser") ?? ""
    var birth = UserDefaults.standard.string(forKey: "birthdateuser") ?? ""
    var name = UserDefaults.standard.string(forKey: "nameuser") ?? ""
    var body: some View {
        
        
        
        
        
        
        
        
        List {
            HStack{
                //Ellipse 12
                Image(uiImage: #imageLiteral(resourceName: "avatar"))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    .frame(width: 50, height: 50)
                VStack{
                    
                    Text(name).font(.system(size: 20, weight: .bold)).tracking(0.38)
                    
                    Text(email).font(.system(size: 16, weight: .regular)).underline().foregroundColor(Color(#colorLiteral(red: 0.11, green: 0.11, blue: 0.12, alpha: 1)))
                    
                }
                
            }
            // Profile photo section
            Section(header:Text("PROFILE PHOTO")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(Color(#colorLiteral(red: 0.56, green: 0.56, blue: 0.58, alpha: 1)))
            ) {
                Button(action: {
                    // Photo action here
                }) {
                    HStack {
                        Spacer()
                        Image(systemName: "camera")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(Color(#colorLiteral(red: 0.56, green: 0.56, blue: 0.58, alpha: 1)))
                        Text("Change Profile Photo")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(Color(#colorLiteral(red: 0.11, green: 0.11, blue: 0.12, alpha: 1)))
                        Spacer()
                    }
                }
            }
            Section(header: //ACCOUNT
                    Text("ACCOUNT").font(.system(size: 12, weight: .medium)).foregroundColor(Color(#colorLiteral(red: 0.56, green: 0.56, blue: 0.58, alpha: 1)))) {
                VStack(alignment: .leading) {
                    HStack {
                        ZStack {
                            Circle()
                                .fill(Color(#colorLiteral(red: 0, green: 0.5176470875740051, blue: 0, alpha: 1)))
                                .frame(width: 32, height: 32)
                            Image(systemName: "person")
                                .foregroundColor(.white)
                        }
                        //name
                        Text("name")
                            .font(.system(size: 16, weight: .regular))
                            .tracking(-0.38)
                        Spacer()
                        //taha majdoub
                        Text(name)
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(Color(#colorLiteral(red: 0.11, green: 0.11, blue: 0.12, alpha: 1)))
                    }
                    
                    
                }
                VStack(alignment: .leading) {
                    HStack {
                        ZStack {
                            Circle()
                                .fill(Color(#colorLiteral(red: 0, green: 0.5176470875740051, blue: 0, alpha: 1)))
                                .frame(width: 32, height: 32)
                            Image(systemName: "envelope")
                                .foregroundColor(.white)
                        }
                        //name
                        Text("email")
                            .font(.system(size: 16, weight: .regular))
                            .tracking(-0.38)
                        Spacer()
                        //taha majdoub
                        Text(email)
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(Color(#colorLiteral(red: 0.11, green: 0.11, blue: 0.12, alpha: 1)))
                    }
                    
                    
                }
                VStack(alignment: .leading) {
                    HStack {
                        ZStack {
                            Circle()
                                .fill(Color(#colorLiteral(red: 0, green: 0.5176470875740051, blue: 0, alpha: 1)))
                                .frame(width: 32, height: 32)
                            Image(systemName: "phone")
                                .foregroundColor(.white)
                        }
                        //name
                        Text("phone")
                            .font(.system(size: 16, weight: .regular))
                            .tracking(-0.38)
                        Spacer()
                        //taha majdoub
                        Text(phone)
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(Color(#colorLiteral(red: 0.11, green: 0.11, blue: 0.12, alpha: 1)))
                    }
                    
                    
                }
                
            }
            
            Section(header:Text("SETTINGS")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(Color(#colorLiteral(red: 0.56, green: 0.56, blue: 0.58, alpha: 1)))
            ) {
                NavigationLink(destination: WithdrawView()) {
                    Text("Withdraw")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(Color(#colorLiteral(red: 0.11, green: 0.11, blue: 0.12, alpha: 1)))
                }
                
                NavigationLink(destination: AboutView()) {
                    Text("About Application")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(Color(#colorLiteral(red: 0.11, green: 0.11, blue: 0.12, alpha: 1)))
                }
                
                Button(action: {
logout()                }) {
                    Text("Logout")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.red)
                }
            }
            
            
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle(Text("Profile"), displayMode: .large)
    }
    func logout() {
        // Remove user data from UserDefaults
        UserDefaults.standard.removeObject(forKey: "emailuser")
        UserDefaults.standard.removeObject(forKey: "phoneuser")
        UserDefaults.standard.removeObject(forKey: "birthdateuser")
        UserDefaults.standard.removeObject(forKey: "nameuser")
        
        // Navigate to the login screen (assuming you have a LoginView)
        UIApplication.shared.windows.first?.rootViewController = UIHostingController(rootView: HelloScreen())
    }

    
    struct ProfileScreen_Previews: PreviewProvider {
        static var previews: some View {
            ProfileScreen()
        }
    }
    
}
