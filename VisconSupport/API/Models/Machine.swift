//
//  Machine.swift
//  VisconSupport
//
//  Created by ZoutigeWolf on 04/12/2023.
//

import Foundation

class Machine : Decodable {
    var id: Int
    var name: String
    
    private static var cache: [Int: Machine] = [:]
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
    }
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try values.decode(Int.self, forKey: .id)
        self.name = try values.decode(String.self, forKey: .name)
    }
    
    func Update(data: Machine) {
        self.name = data.name
        
        self.FetchReferences()
    }
    
    func FetchReferences() {

    }
    
    static func Get(id: Int, completion: @escaping (Machine?) -> Void) {
        Requests.Get(url: Requests.ServerUrl + "api/machines/\(id)", responseType: Machine.self) { result in
            switch result {
            case .success(let data):
                if let machine = self.cache[id] {
                    machine.Update(data: data)
                } else {
                    self.cache[id] = data
                }
                
                completion(self.cache[id])
            
            case .failure(let error):
                print("Failed to get machine with ID: \(id)")
                print(error)
                completion(nil)
            }
        }
    }
    
    static func GetAll(completion: @escaping ([Machine]) -> Void) {
        Requests.Get(url: Requests.ServerUrl + "api/machines", responseType: [Machine].self) { result in
            switch result {
            case .success(let data):
                data.forEach { mData in
                    if let machine = self.cache[mData.id] {
                        machine.Update(data: mData)
                    } else {
                        self.cache[mData.id] = mData
                    }
                }
                
                completion(Array(self.cache.values))
            
            case .failure(let error):
                print("Failed to get machines")
                print(error)
                completion([])
            }
        }
    }
}
