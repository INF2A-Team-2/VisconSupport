//
//  Attachment.swift
//  VisconSupport
//
//  Created by ZoutigeWolf on 04/12/2023.
//

import Foundation

enum AttachmentType: String {
    case Image = "image"
    case Video = "video"
    case Other
}

struct AttachmentData: ModelData {
    var id: Int
    var name: String?
    var mimeType: String
    var issueId: Int
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case mimeType
        case issueId
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try values.decode(Int.self, forKey: .id)
        self.name = try values.decode(String.self, forKey: .name)
        self.mimeType = try values.decode(String.self, forKey: .mimeType)
        self.issueId = try values.decode(Int.self, forKey: .issueId)
    }
}

final class Attachment: Model {
    typealias DataType = AttachmentData
    
    var data: AttachmentData
    
    var id: Int
    var name: String?
    var mimeType: String
    var issueId: Int
    var url: String
    var type: AttachmentType
    
    @Published var issue: Issue? = nil
    
    static var collectiveName: String = "attachments"
    
    internal static var cache: [Int : Attachment] = [:]

    init(data: AttachmentData) {
        self.data = data
        
        self.id = data.id
        self.name = data.name
        self.mimeType = data.mimeType
        self.issueId = data.issueId
        self.url = Requests.ServerUrl + "api/attachments/\(self.id)"
        self.type = AttachmentType(rawValue: data.mimeType.components(separatedBy: "/")[0]) ?? AttachmentType.Other
    }
    
    
    func update(with data: AttachmentData) {
        self.data = data
        
        self.id = data.id
        self.name = data.name
        self.mimeType = data.mimeType
        self.issueId = data.issueId
    }
    
    func fetchReferences() {
        Issue.get(id: self.issueId) { issue in
            DispatchQueue.main.async {
                self.issue = issue
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
    
    static func get(id: Int, issueId: Int, completion: @escaping (Attachment?) -> Void) {
        Requests.Get(url: Requests.ServerUrl + "api/issues/\(issueId)/\(collectiveName)/\(id)", responseType: DataType.self) { result in
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
                print("Failed to get from issues/\(issueId)/\(collectiveName) with ID: \(id)")
                print(error)
                completion(nil)
            }
        }
    }
    
    static func getAll(issueId: Int, completion: @escaping ([Attachment]) -> Void) {
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
