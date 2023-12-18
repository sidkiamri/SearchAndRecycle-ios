//
//  ContentView.swift
//  Reducetrash
//
//  Created by taha majdoub on 21/2/2023.
//

import SwiftUI

struct Account: Identifiable {
    let id: String
    let username: String
    let email: String
    let avatar: UIImage
    
}
struct Accounts: Identifiable {
    let id: String
    let username: String
    let email: String
    let avatar: UIImage
    let phone : String
    let birthday:String
    let name : String
    
    
}
let account = [
    Accounts(id: "1", username: "JohnDoe", email: "john.doe@example.com", avatar: UIImage(named: "avatar")!,phone:"21254238",birthday:"11-08-1998",name:"faraj"),
    Accounts(id: "2", username: "JaneDoe", email: "jane.doe@example.com", avatar: UIImage(named: "avatar")!,phone:"21254238",birthday:"11-08-1998",name:"salah live bin")
]
struct ContentView: View {
    var body: some View {
        
        PhotoView()
    }
}




struct PrimaryButton:View{
    
    var title: String
    var body: some View{
        
        //Get started
        Text(title).font(.title3).fontWeight(.bold)
            .foregroundColor(.white).frame(maxWidth: .infinity).padding().background(Color("ColorButton")).cornerRadius(20).textCase(.uppercase)

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

