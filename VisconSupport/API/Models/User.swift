//
//  User.swift
//  VisconSupport
//
//  Created by ZoutigeWolf on 04/12/2023.
//

import Foundation

enum AccountType: Int {
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

class User {
    var id: Int
    var username: String
    var type: AccountType
    var companyId: Int?
    var unit: String?
    var phoneNumber: String?
    
    init(id: Int, username: String, type: AccountType, companyId: Int? = nil, unit: String? = nil, phoneNumber: String? = nil) {
        self.id = id
        self.username = username
        self.type = type
        self.companyId = companyId
        self.unit = unit
        self.phoneNumber = phoneNumber
    }
}
