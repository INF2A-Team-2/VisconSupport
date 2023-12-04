//
//  Message.swift
//  VisconSupport
//
//  Created by ZoutigeWolf on 04/12/2023.
//

import Foundation

class Message : Decodable {
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
    
    init(id: Int, body: String, timeStamp: Date, userId: Int, issueId: Int) {
        self.id = id
        self.body = body
        self.timeStamp = timeStamp
        self.userId = userId
        self.issueId = issueId
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try values.decode(Int.self, forKey: .id)
        self.body = try values.decode(String.self, forKey: .body)
        self.timeStamp = ISO8601DateFormatter().date(from: try values.decode(String.self, forKey: .timeStamp)) ?? Date.distantPast
        self.userId = try values.decode(Int.self, forKey: .userId)
        self.issueId = try values.decode(Int.self, forKey: .issueId)
    }
}
