//
//  Company.swift
//  VisconSupport
//
//  Created by ZoutigeWolf on 04/12/2023.
//

import Foundation

struct CompanyData : ModelData {
    var id: Int
    var name: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try values.decode(Int.self, forKey: .id)
        self.name = try values.decode(String.self, forKey: .name)
    }
}

final class Company: Model {
    typealias DataType = CompanyData
    
    static var collectiveName: String = "companies"
    
    var data: CompanyData
    
    var id: Int
    var name: String
    
    internal static var cache: [Int: Company] = [:]
    
    init(data: DataType) {
        self.data = data
        
        self.id = data.id
        self.name = data.name
    }
    
    func update(with data: DataType) {
        self.data = data
        
        self.name = data.name
        
        self.fetchReferences()
    }
    
    func fetchReferences() {
        
    }
}
