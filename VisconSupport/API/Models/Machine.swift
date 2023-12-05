//
//  Machine.swift
//  VisconSupport
//
//  Created by ZoutigeWolf on 04/12/2023.
//

import Foundation

struct MachineData : ModelData {
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

final class Machine: Model {
    typealias DataType = MachineData
    
    static var collectiveName: String = "machines"
    
    var id: Int
    var name: String
    
    internal static var cache: [Int: Machine] = [:]
    
    init(data: DataType) {
        self.id = data.id
        self.name = data.name
    }
    
    func update(with data: DataType) {
        self.name = data.name
        
        self.fetchReferences()
    }
    
    func fetchReferences() {
        
    }
}

