//
//  Attachment.swift
//  VisconSupport
//
//  Created by ZoutigeWolf on 04/12/2023.
//

import Foundation

class Attachment : Decodable {
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
    
    init(id: Int, name: String? = nil, mimeType: String, issueId: Int) {
        self.id = id
        self.name = name
        self.mimeType = mimeType
        self.issueId = issueId
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try values.decode(Int.self, forKey: .id)
        self.name = try values.decode(String.self, forKey: .name)
        self.mimeType = try values.decode(String.self, forKey: .mimeType)
        self.issueId = try values.decode(Int.self, forKey: .issueId)
    }
}
