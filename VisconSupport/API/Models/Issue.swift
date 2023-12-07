//
//  Issue.swift
//  VisconSupport
//
//  Created by ZoutigeWolf on 04/12/2023.
//

import Foundation

struct IssueData: ModelData {
    var id: Int
    var headline: String
    var actual: String
    var expected: String
    var tried: String
    var timeStamp: Date
    var userId: Int
    var machineId: Int
    
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
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try values.decode(Int.self, forKey: .id)
        self.headline = try values.decode(String.self, forKey: .headline)
        self.actual = try values.decode(String.self, forKey: .actual)
        self.expected = try values.decode(String.self, forKey: .expected)
        self.tried = try values.decode(String.self, forKey: .tried)
        self.timeStamp = Utils.ParseDate(date: try values.decode(String.self, forKey: .timeStamp), format: "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ")
        self.userId = try values.decode(Int.self, forKey: .userId)
        self.machineId = try values.decode(Int.self, forKey: .machineId)
    }
}

final class Issue : Model {
    typealias DataType = IssueData
    
    static var collectiveName: String = "issues"
    
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
    @Published var messages: [Message] = []
    @Published var attachments: [Attachment] = []
    
    internal static var cache: [Int: Issue] = [:]
    
    init(data: DataType) {
        self.id = data.id
        self.headline = data.headline
        self.actual = data.actual
        self.expected = data.expected
        self.tried = data.tried
        self.timeStamp = data.timeStamp
        self.userId = data.userId
        self.machineId = data.machineId
        
        self.fetchReferences()
    }
    
    func update(with data: DataType) {
        self.headline = data.headline
        self.actual = data.actual
        self.expected = data.expected
        self.tried = data.tried
        self.timeStamp = data.timeStamp
        self.userId = data.userId
        self.machineId = data.machineId
        
        self.fetchReferences()
    }
    
    func fetchReferences() {
        User.get(id: self.userId) { user in
            DispatchQueue.main.async {
                self.user = user
                self.objectWillChange.send()
            }
        }
        
        Machine.get(id: self.machineId) { machine in
            DispatchQueue.main.async {
                self.machine = machine
                self.objectWillChange.send()
            }
        }
        
        Message.getAll(issueId: self.id) { messages in
            DispatchQueue.main.async {
                self.messages = messages
                self.objectWillChange.send()
            }
        }
        
        Attachment.getAll(issueId: self.id) { attachments in
            DispatchQueue.main.async {
                self.attachments = attachments
            }
        }
    }
}
