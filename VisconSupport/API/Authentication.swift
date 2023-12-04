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
        Requests.Post(url: Requests.ServerUrl + "api/login", parameters: ["username": username, "password": password], responseType: [String: String].self) { result in
            switch result {
            case .success(let data):
                self.token = data["token"]
                print("Login successful")
            
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
        Requests.Get(url: Requests.ServerUrl + "api/login", responseType: User.self) { result in
            switch result {
            case .success(let data):
                self.currentUser = data
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
