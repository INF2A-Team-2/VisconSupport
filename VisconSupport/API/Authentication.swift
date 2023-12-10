//
//  Authentication.swift
//  VisconSupport
//
//  Created by ZoutigeWolf on 03/12/2023.
//

import Foundation
import Security

class Authentication : ObservableObject {
    public static let shared = Authentication()
    
    public var token: String? = nil
    
    @Published public var currentUser: User? = nil
    
    init() {
        DispatchQueue.global().async {
            if let credentials = self.loadCredentialFromKeychain() {
                let (username, password) = credentials
                print(username)
                print(password)
                
                self.login(username, password) { res in
                    if res {
                        print("Authenticated using keychain credentials")
                    } else {
                        print("Failed to authenticate using keychain credentials")
                    }
                }
            }
        }
    }
    
    public func login(_ username: String, _ password: String, completion: @escaping (Bool) -> Void) {
        print("Logging in", username, password)
        Requests.Post(url: Requests.ServerUrl + "api/login", parameters: ["username": username, "password": password], responseType: [String: String].self) { result in
            switch result {
            case .success(let data):
                self.token = data["token"]
                print("Login successful")
            
            case .failure(let error):
                print("Failed to login")
                print(error)
                completion(false)
                
                return
            }
            
            self.storeCredentialsInKeychain(username, password)
            
            self.fillCaches()
            
            self.fetchUser() { res in
                completion(res)
            }
        }
    }
    
    public func logout() {
        self.token = nil
        self.currentUser = nil
        
        self.clearCaches()
        
        self.deleteCredentialFromKeychain()
    }
    
    private func fetchUser(completion: @escaping (Bool) -> Void) {
        Requests.Get(url: Requests.ServerUrl + "api/login", responseType: UserData.self) { result in
            switch result {
            case .success(let data):
                User.get(id: data.id) {user in
                    if user != nil {
                        DispatchQueue.main.async {
                            self.currentUser = user
                        }
                        completion(true)
                    } else {
                        completion(false)
                    }
                }
                
            case .failure(let error):
                print("Failed to fetch user")
                print(error)
                self.currentUser = nil
                completion(false)
            }
        }
    }
    
    private func fillCaches() {
        User.fillCache()
        Company.fillCache()
        Machine.fillCache()
        
        Issue.getAll() { issues in
            Message.fillCache(issues.map { $0.id })
            Attachment.fillCache(issues.map { $0.id })
        }
    }
    
    private func clearCaches() {
        User.clearCache()
        Issue.clearCache()
        Company.clearCache()
        Machine.clearCache()
        Message.clearCache()
        Attachment.clearCache()
    }
    
    private func storeCredentialsInKeychain(_ username: String, _ password: String) {
        let attributes: [String: Any] = [
            kSecClass as String: kSecClassInternetPassword,
            kSecAttrAccount as String: username,
            kSecValueData as String: password.data(using: .utf8)!,
            kSecAttrServer as String: Requests.ServerUrl
        ]
        
        let status = SecItemAdd(attributes as CFDictionary, nil)
 
        if status == noErr {
            print("Saved credentials to keychain")
        } else if status == errSecDuplicateItem {
            self.updateCredentialsInKeychain(username, password)
        } else {
            print("Failed to save credentails to keychain \(status)")
        }
    }
    
    private func updateCredentialsInKeychain(_ username: String, _ password: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassInternetPassword,
            kSecAttrServer as String: Requests.ServerUrl
        ]
        
        let attributes: [String: Any] = [
            kSecAttrAccount as String: username,
            kSecValueData as String: password.data(using: .utf8)!
        ]
        
        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
  
        if status == noErr {
            print("Updated keychain credentials")
        } else {
            print("Failed to update keychain credentials \(status)")
        }
    }
    
    private func loadCredentialFromKeychain() -> (String, String)? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassInternetPassword,
            kSecAttrServer as String: Requests.ServerUrl,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true
        ]
        
        var item: CFTypeRef?
        
        let status = SecItemCopyMatching(query as CFDictionary, &item)

        if status == noErr {
            if let i = item as? [String: Any],
               let username = i[kSecAttrAccount as String] as? String,
               let passwordData = i[kSecValueData as String] as? Data,
               let password = String(data: passwordData, encoding: .utf8), !password.isEmpty {
                print("Retrieved credentials from keychain")
                return (username, password)
            } else {
                print("Failed to retrieve credentials from keychain \(status)")
                return nil
            }
        }
        
        return nil
    }
    
    private func deleteCredentialFromKeychain() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassInternetPassword,
            kSecAttrServer as String: Requests.ServerUrl
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        if status == noErr {
            print("Deleted credentials from keychain")
        } else {
            print("Failed to delete credentials from keychain \(status)")
        }
    }
}
