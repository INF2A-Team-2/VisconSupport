//
//  Model.swift
//  VisconSupport
//
//  Created by ZoutigeWolf on 05/12/2023.
//

import Foundation

protocol ModelData: Decodable {
    var id: Int { get}
}

protocol Model: Identifiable, ObservableObject {
    associatedtype DataType: ModelData
    
    var id: Int { get set }
    
    static var collectiveName: String { get }
    
    static var cache: [Int: Self] { get set }
    
    init(data: DataType)
    
    func update(with data: DataType)
    func fetchReferences()
    
    static func get(id: Int, completion: @escaping (Self?) -> Void)
    static func getAll(completion: @escaping ([Self]) -> Void)
}

extension Model {
    static func fillCache() {
        Self.getAll() { data in
            print("Filled \(self.collectiveName) cache")
        }
    }
    
    static func get(id: Int, completion: @escaping (Self?) -> Void) {
        Requests.Get(url: Requests.ServerUrl + "api/\(collectiveName)/\(id)", responseType: DataType.self) { result in
            switch result {
            case .success(let data):
                if let obj = self.cache[id] {
                    obj.update(with: data)
                } else {
                    self.cache[id] = Self(data: data)
                    self.cache[id]?.fetchReferences()
                }
                
                completion(self.cache[id])
            
            case .failure(let error):
                print("Failed to get from \(collectiveName) with ID: \(id)")
                print(error)
                completion(nil)
            }
        }
    }
    
    static func getAll(completion: @escaping ([Self]) -> Void) {
        Requests.Get(url: Requests.ServerUrl + "api/\(collectiveName)", responseType: [DataType].self) { result in
            switch result {
            case .success(let data):
                data.forEach { d in
                    if let obj = self.cache[d.id] {
                        obj.update(with: d)
                    } else {
                        self.cache[d.id] = Self(data: d)
                        self.cache[d.id]?.fetchReferences()
                    }
                }
                
                completion(Array(self.cache.values))
            
            case .failure(let error):
                print("Failed to get \(collectiveName)")
                print(error)
                completion([])
            }
        }
    }
}
