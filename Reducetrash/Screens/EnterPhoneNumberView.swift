import SwiftUI

struct EnterPhoneNumberView: View {
    @State private var phoneNumber = ""
    @State private var isVerificationScreenActive = false
    
    @Environment(\.presentationMode) var presentationMode
    
    func sendVerificationCode() {
        guard let url = URL(string: "http://localhost:9091/register/send-verification-code") else {
            return
        }
        let body: [String: Any] = ["phoneNumber": phoneNumber]
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
                Text("Enter your phone number")
                    .font(.system(size: 27.5, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
                Text("We'll send you a text message to verify your phone number.")
                    .font(.system(size: 16.1))
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
                
                TextField("Phone number", text: $phoneNumber)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Button(action: {
                    sendVerificationCode()
                }, label: {
                    Text("Verify Phone Number")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("ColorButton"))
                        .cornerRadius(8)
                        .padding(.horizontal)
                })
                .padding()
                .disabled(phoneNumber.isEmpty)
                .onChange(of: phoneNumber) { newValue in
                  
                    UserDefaults.standard.set(phoneNumber, forKey: "Phone")
                }
                .fullScreenCover(isPresented: $isVerificationScreenActive, content: {
                    VerifyPhoneNumberView()
                })
            }
           
         
            .navigationViewStyle(StackNavigationViewStyle())
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: EmptyView())
        }
  
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: EmptyView())
    }

}
