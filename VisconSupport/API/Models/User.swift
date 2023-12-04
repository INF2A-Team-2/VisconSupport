//
//  User.swift
//  VisconSupport
//
//  Created by ZoutigeWolf on 04/12/2023.
//

import Foundation

enum AccountType: Int, Decodable {
    case User = 0
    case Employee = 1
    case Admin = 2
    
    var toString: String {
        switch self {
        case .User:
            return "User"
        case .Employee:
            return "Employee"
        case .Admin:
            return "Admin"
        }
    }
}

class User : Identifiable, Decodable, ObservableObject {
    var id: Int
    var username: String
    var type: AccountType
    var companyId: Int?
    var unit: String?
    var phoneNumber: String?
    
    @Published var company: Company? = nil
    
    private static var cache: [Int: User] = [:]
    
    private enum CodingKeys: String, CodingKey {
        case id
        case username
        case type
        case companyId
        case unit
        case phoneNumber
    }
    
    init(id: Int, username: String, type: AccountType, companyId: Int? = nil, unit: String? = nil, phoneNumber: String? = nil, company: Company? = nil) {
        self.id = id
        self.username = username
        self.type = type
        self.companyId = company?.id ?? companyId
        self.unit = unit
        self.phoneNumber = phoneNumber
        
        self.company = company
        
        self.FetchReferences()
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try values.decode(Int.self, forKey: .id)
        self.username = try values.decode(String.self, forKey: .username)
        self.type = try values.decode(AccountType.self, forKey: .type)
        self.companyId = try values.decodeIfPresent(Int.self, forKey: .companyId)
        self.unit = try values.decodeIfPresent(String.self, forKey: .unit)
        self.phoneNumber = try values.decodeIfPresent(String.self, forKey: .phoneNumber)
        
        self.FetchReferences()
    }
    
    func Update(data: User) {
        self.username = data.username
        self.type = data.type
        self.companyId = data.companyId
        self.unit = data.unit
        self.phoneNumber = data.phoneNumber
        
        self.FetchReferences()
    }
    
    func FetchReferences() {
        if let companyId = self.companyId {
            Company.Get(id: companyId) { company in
                DispatchQueue.main.async {
                    self.company = company
                    self.objectWillChange.send()
                }
            }
        }
    }
    
    static func Get(id: Int, completion: @escaping (User?) -> Void) {
        Requests.Get(url: Requests.ServerUrl + "api/users/\(id)", responseType: User.self) { result in
            switch result {
            case .success(let data):
                if let user = self.cache[id] {
                    user.Update(data: data)
                } else {
                    self.cache[id] = data
                }
                
                completion(self.cache[id])
            
            case .failure(let error):
                print("Failed to get user with ID: \(id)")
                print(error)
                completion(nil)
            }
        }
    }
    
    static func GetAll(completion: @escaping ([User]) -> Void) {
        Requests.Get(url: Requests.ServerUrl + "api/users", responseType: [User].self) { result in
            switch result {
            case .success(let data):
                data.forEach { uData in
                    if let user = self.cache[uData.id] {
                        user.Update(data: uData)
                    } else {
                        self.cache[uData.id] = uData
                    }
                }
                
                completion(Array(self.cache.values))
            
            case .failure(let error):
                print("Failed to get users")
                print(error)
                completion([])
            }
        }
    }
}
