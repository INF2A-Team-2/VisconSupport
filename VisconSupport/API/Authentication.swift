//
//  Authentication.swift
//  VisconSupport
//
//  Created by ZoutigeWolf on 03/12/2023.
//

import Foundation

class Authentication : ObservableObject {
    public static let shared = Authentication()
    
    public var token: String? = nil
    
    @Published public var currentUser: User? = nil
    
    private init() {
        
    }
    
    public func Login(username: String, password: String, completion: @escaping (Bool) -> Void) {
        Requests.Post(url: Requests.ServerUrl + "api/login", parameters: ["username": username, "password": password]) { result in
            switch result {
            case .success(let data):
                if let token = data?["token"] as? String {
                    self.token = token
                    print("Login successful")
                }
            
            case .failure(let error):
                print("Failed to login")
                print(error)
                completion(false)
            }
            
            self.FetchUser() { res in
                completion(res)
            }
        }
    }
    
    public func Logout() {
        self.token = nil
        self.currentUser = nil
    }
    
    private func FetchUser(completion: @escaping (Bool) -> Void) {
        Requests.Get(url: Requests.ServerUrl + "api/login") { result in
            switch result {
            case .success(let data):
                print(data!)
                
                self.currentUser = User(
                    id: data?["id"] as! Int,
                    username: data?["username"] as! String,
                    type: AccountType(rawValue: data?["type"] as! Int)!,
                    companyId: data?["companyId"] as? Int,
                    unit: data?["unit"] as? String,
                    phoneNumber: data?["phoneNumber"] as? String
                )
                
                completion(true)
                
            case .failure(let error):
                print("Failed to fetch user")
                print(error)
                self.currentUser = nil
                completion(false)
            }
        }
    }
}
