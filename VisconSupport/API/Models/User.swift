//
//  User.swift
//  VisconSupport
//
//  Created by ZoutigeWolf on 04/12/2023.
//

import Foundation

enum AccountType: Int, Decodable, CaseIterable, CustomStringConvertible {
    case User = 0
    case Employee = 1
    case Admin = 2
    
    var description: String {
        switch self {
        case .User:
            return "Customer"
        case .Employee:
            return "Employee"
        case .Admin:
            return "Admin"
        }
    }
}

struct UserData: ModelData {
    var id: Int
    var username: String
    var type: AccountType
    var companyId: Int?
    var unit: String?
    var phoneNumber: String?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case username
        case type
        case companyId
        case unit
        case phoneNumber
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try values.decode(Int.self, forKey: .id)
        self.username = try values.decode(String.self, forKey: .username)
        self.type = try values.decode(AccountType.self, forKey: .type)
        self.companyId = try values.decodeIfPresent(Int.self, forKey: .companyId)
        self.unit = try values.decodeIfPresent(String.self, forKey: .unit)
        self.phoneNumber = try values.decodeIfPresent(String.self, forKey: .phoneNumber)
    }
}

final class User : Model {
    typealias DataType = UserData
    
    static var collectiveName: String = "users"
    
    var data: UserData

    var id: Int
    var username: String
    var type: AccountType
    var companyId: Int?
    var unit: String?
    var phoneNumber: String?
    
    @Published var company: Company? = nil
    
    internal static var cache: [Int: User] = [:]
    
    init(data: DataType) {
        self.data = data
        
        self.id = data.id
        self.username = data.username
        self.type = data.type
        self.companyId = data.companyId
        self.unit = data.unit
        self.phoneNumber = data.phoneNumber
        
        self.fetchReferences()
    }
    
    func update(with data: DataType) {
        self.data = data
        
        self.username = data.username
        self.type = data.type
        self.companyId = data.companyId
        self.unit = data.unit
        self.phoneNumber = data.phoneNumber
        
        self.fetchReferences()
    }
    
    func fetchReferences() {
        if let companyId = self.companyId {
            Company.get(id: companyId) { company in
                DispatchQueue.main.async {
                    self.company = company
                    self.objectWillChange.send()
                }
            }
        }
    }
    
    func getIcon() -> String {
        switch self.type {
        case .User:
            return "person.circle.fill"
            
        case .Employee:
            return "stethoscope.circle.fill"
            
        case .Admin:
            return "gearshape.circle.fill"
        }
    }
}
