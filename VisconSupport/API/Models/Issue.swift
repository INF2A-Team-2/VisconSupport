//
//  Issue.swift
//  VisconSupport
//
//  Created by ZoutigeWolf on 04/12/2023.
//

import Foundation

class Issue : Identifiable, Decodable, ObservableObject {
    var id: Int
    var headline: String
    var actual: String
    var expected: String
    var tried: String
    var timeStamp: Date
    var userId: Int
    var machineId: Int
    
    @Published var user: User? = nil
    @Published var machine: Machine? = nil
    
    private static var cache: [Int: Issue] = [:]
    
    private enum CodingKeys: String, CodingKey {
        case id
        case headline
        case actual
        case expected
        case tried
        case timeStamp
        case userId
        case machineId
    }
    
    init(id: Int, headline: String, actual: String, expected: String, tried: String, timeStamp: Date, userId: Int, machineId: Int,
         user: User? = nil,
         machine: Machine? = nil) {
        self.id = id
        self.headline = headline
        self.actual = actual
        self.expected = expected
        self.tried = tried
        self.timeStamp = timeStamp
        self.userId = user?.id ?? userId
        self.machineId = machine?.id ?? machineId
        
        self.user = user
        self.machine = machine
        
        self.FetchReferences()
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try values.decode(Int.self, forKey: .id)
        self.headline = try values.decode(String.self, forKey: .headline)
        self.actual = try values.decode(String.self, forKey: .actual)
        self.expected = try values.decode(String.self, forKey: .expected)
        self.tried = try values.decode(String.self, forKey: .tried)
        self.timeStamp = Utils.ParseDate(date: try values.decode(String.self, forKey: .timeStamp), format: "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ")
        self.userId = try values.decode(Int.self, forKey: .userId)
        self.machineId = try values.decode(Int.self, forKey: .machineId)
        
        self.FetchReferences()
    }
    
    func Update(data: Issue) {
        self.headline = data.headline
        self.actual = data.actual
        self.expected = data.expected
        self.tried = data.tried
        self.timeStamp = data.timeStamp
        self.userId = data.userId
        self.machineId = data.machineId
        
        self.FetchReferences()
    }
    
    func FetchReferences() {
        User.Get(id: self.userId) { user in
            DispatchQueue.main.async {
                self.user = user
                self.objectWillChange.send()
            }
        }
    }
    
    static func Get(id: Int, completion: @escaping (Issue?) -> Void) {
        Requests.Get(url: Requests.ServerUrl + "api/issues/\(id)", responseType: Issue.self) { result in
            switch result {
            case .success(let data):
                if let issue = self.cache[id] {
                    issue.Update(data: data)
                } else {
                    self.cache[id] = data
                }
                
                completion(self.cache[id])
            
            case .failure(let error):
                print("Failed to get issues with ID: \(id)")
                print(error)
                completion(nil)
            }
        }
    }
    
    static func GetAll(completion: @escaping ([Issue]) -> Void) {
        Requests.Get(url: Requests.ServerUrl + "api/issues", responseType: [Issue].self) { result in
            switch result {
            case .success(let data):
                data.forEach { iData in
                    if let user = self.cache[iData.id] {
                        user.Update(data: iData)
                    } else {
                        self.cache[iData.id] = iData
                    }
                }
                
                completion(Array(self.cache.values))
            
            case .failure(let error):
                print("Failed to get issues")
                print(error)
                completion([])
            }
        }
    }
}
