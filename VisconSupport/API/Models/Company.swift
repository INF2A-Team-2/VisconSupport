//
//  Company.swift
//  VisconSupport
//
//  Created by ZoutigeWolf on 04/12/2023.
//

import Foundation

class Company : Identifiable, Decodable {
    var id: Int
    var name: String
    
    private static var cache: [Int: Company] = [:]
    
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
    
    func Update(data: Company) {
        self.name = data.name
        
        self.FetchReferences()
    }
    
    func FetchReferences() {
        
    }
    
    static func Get(id: Int, completion: @escaping (Company?) -> Void) {
        Requests.Get(url: Requests.ServerUrl + "api/companies/\(id)", responseType: Company.self) { result in
            switch result {
            case .success(let data):
                if let company = self.cache[id] {
                    company.Update(data: data)
                } else {
                    self.cache[id] = data
                }
                
                completion(self.cache[id])
            
            case .failure(let error):
                print("Failed to get company with ID: \(id)")
                print(error)
                completion(nil)
            }
        }
    }
    
    static func GetAll(completion: @escaping ([Company]) -> Void) {
        Requests.Get(url: Requests.ServerUrl + "api/companies", responseType: [Company].self) { result in
            switch result {
            case .success(let data):
                data.forEach { cData in
                    if let company = self.cache[cData.id] {
                        company.Update(data: cData)
                    } else {
                        self.cache[cData.id] = cData
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
