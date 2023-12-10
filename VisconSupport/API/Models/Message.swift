//
//  Message.swift
//  VisconSupport
//
//  Created by ZoutigeWolf on 04/12/2023.
//

import Foundation

struct MessageData: ModelData {
    var id: Int
    var body: String
    var timeStamp: Date
    var userId: Int
    var issueId: Int
    
    private enum CodingKeys: String, CodingKey {
        case id
        case body
        case timeStamp
        case userId
        case issueId
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try values.decode(Int.self, forKey: .id)
        self.body = try values.decode(String.self, forKey: .body)
        self.timeStamp = Utils.ParseDate(date: try values.decode(String.self, forKey: .timeStamp), format: "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ")
        self.userId = try values.decode(Int.self, forKey: .userId)
        self.issueId = try values.decode(Int.self, forKey: .issueId)
    }
}

final class Message: Model {
    typealias DataType = MessageData
    
    static var collectiveName: String = "messages"
    
    var data: MessageData
    
    var id: Int
    var body: String
    var timeStamp: Date
    var userId: Int
    var issueId: Int
    
    @Published var user: User? = nil
    @Published var issue: Issue? = nil
    
    internal static var cache: [Int : Message] = [:]

    init(data: MessageData) {
        self.data = data
        
        self.id = data.id
        self.body = data.body
        self.timeStamp = data.timeStamp
        self.userId = data.userId
        self.issueId = data.issueId
    }
    
    func update(with data: MessageData) {
        self.data = data
        
        self.id = data.id
        self.body = data.body
        self.timeStamp = data.timeStamp
        self.userId = data.userId
        self.issueId = data.issueId
    }
    
    func fetchReferences() {
        User.get(id: self.userId) { user in
            DispatchQueue.main.async {
                self.user = user
                self.objectWillChange.send()
            }
        }
        
        Issue.get(id: self.issueId) { issue in
            DispatchQueue.main.async {
                self.issue = issue
                self.objectWillChange.send()
            }
        }
    }
    
    static func fillCache(_ issues: [Int]) {
        issues.forEach { i in
            self.getAll(issueId: i) { _ in
                print("Filled \(self.collectiveName) cache for issue \(i)")
            }
        }
    }
    
    static func get(id: Int, issueId: Int, completion: @escaping (Message?) -> Void) {
        Requests.Get(url: Requests.ServerUrl + "api/issues/\(issueId)/\(collectiveName)/\(id)", responseType: DataType.self) { result in
            switch result {
            case .success(let data):
                if let obj = self.cache[id] {
                    obj.update(with: data)
                } else {
                    print("created new \(self.collectiveName)")
                    self.cache[id] = Self(data: data)
                    self.cache[id]?.fetchReferences()
                }
                
                completion(self.cache[id])
            
            case .failure(let error):
                print("Failed to get from issues/\(issueId)/\(collectiveName) with ID: \(id)")
                print(error)
                completion(nil)
            }
        }
    }
    
    static func getAll(issueId: Int, completion: @escaping ([Message]) -> Void) {
        Requests.Get(url: Requests.ServerUrl + "api/issues/\(issueId)/\(collectiveName)", responseType: [DataType].self) { result in
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
                
                completion(Array(self.cache.values.filter { $0.issueId == issueId }))
            
            case .failure(let error):
                print("Failed to get issues/\(issueId)/\(collectiveName)")
                print(error)
                completion([])
            }
        }
    }
}
