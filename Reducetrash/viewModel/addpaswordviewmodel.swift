//
//  addpaswordviewmodel.swift
//  Reducetrash
//
//  Created by taha majdoub on 20/3/2023.
//



import Foundation

class AddPasswordViewModel: ObservableObject {
    
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var showPassword: Bool = false
    @Published var showConfirmPassword: Bool = false
    
    func createPassword(completion: @escaping (Bool) -> Void) {
        // Check that passwords match and meet requirements
        if password.count >= 8 && password.rangeOfCharacter(from: .decimalDigits) != nil && password == confirmPassword {
            // Make POST request to register user
            guard let email = UserDefaults.standard.string(forKey: "email"),
                  let phone = UserDefaults.standard.string(forKey: "Phone"),
                  let birth = UserDefaults.standard.string(forKey: "birthdate"),
                  let name = UserDefaults.standard.string(forKey: "name") else {
                return
            }
            let user = [
                "email": email,
                "phoneNumber": phone,
                "name": name,
                "dateOfBirth": birth,
                "password": password
            ]
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: user, options: .prettyPrinted)
                var request = URLRequest(url: URL(string: "http://localhost:9091/register")!)
                request.httpMethod = "POST"
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpBody = jsonData
                
                let session = URLSession.shared
                let task = session.dataTask(with: request) { data, response, error in
                    guard error == nil else {
                        print("Error: \(error!)")
                        completion(false)
                        return
                    }
                    guard let httpResponse = response as? HTTPURLResponse,
                          (200...299).contains(httpResponse.statusCode) else {
                        print("Error: invalid response")
                        completion(false)
                        return
                    }
                    
                    // Parse the response data to extract user ID
                    guard let data = data,
                          let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                          let userId = json["id"] as? String else {
                        print("Error: unable to extract user ID")
                        completion(false)
                        return
                    }
                    
                    // Save user data in UserDefaults
                    UserDefaults.standard.set(userId, forKey: "userId")
                    UserDefaults.standard.set(email, forKey: "emailuser")
                    UserDefaults.standard.set(phone, forKey: "phoneuser")
                    UserDefaults.standard.set(name, forKey: "nameuser")
                    UserDefaults.standard.set(birth, forKey: "birthdateuser")
                    UserDefaults.standard.synchronize()
                    
                    completion(true)
                }
                task.resume()
            } catch {
                print("Error: \(error)")
                completion(false)
            }
        } else {
            // Display error message
            completion(false)
        }
    }

}

