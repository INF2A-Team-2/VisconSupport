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

protocol Model: Identifiable, Decodable, ObservableObject {
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
    static func Get(id: Int, completion: @escaping (Self?) -> Void) {
        Requests.Get(url: Requests.ServerUrl + "api/\(collectiveName)/\(id)", responseType: DataType.self) { result in
            switch result {
            case .success(let data):
                if let obj = cache[id] {
                    obj.update(with: data)
                } else {
                    cache[id] = Self(data: data)
                }
                
                completion(self.cache[id])
            
            case .failure(let error):
                print("Failed to get from \(collectiveName) with ID: \(id)")
                print(error)
                completion(nil)
            }
        }
    }
    
    static func GetAll(completion: @escaping ([Self]) -> Void) {
        Requests.Get(url: Requests.ServerUrl + "api/\(collectiveName)", responseType: [DataType].self) { result in
            switch result {
            case .success(let data):
                data.forEach { d in
                    if let obj = cache[d.id] {
                        obj.update(with: d)
                    } else {
                        cache[d.id] = Self(data: d)
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
