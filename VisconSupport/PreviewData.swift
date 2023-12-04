//
//  PreviewData.swift
//  VisconSupport
//
//  Created by ZoutigeWolf on 04/12/2023.
//

import Foundation

class PreviewData {
    static var users = [
        User(id: 1, username: "test_customer", type: AccountType.User),
        User(id: 2, username: "test_employee", type: AccountType.Employee),
        User(id: 3, username: "test_admin", type: AccountType.Admin)
    ]
    static var issues = [
        Issue(id: 1, headline: "Test 1", actual: "Test", expected: "Test", tried: "Test", timeStamp: Date.now, userId: 1, machineId: 1, user: users[0], machine: machines[0]),
        Issue(id: 2, headline: "Test 2", actual: "Test", expected: "Test", tried: "Test", timeStamp: Date.now, userId: 1, machineId: 2, user: users[0], machine: machines[1]),
        Issue(id: 3, headline: "Test 3", actual: "Test", expected: "Test", tried: "Test", timeStamp: Date.now, userId: 1, machineId: 3, user: users[0], machine: machines[2])
    ]
    
    static var machines = [
        Machine(id: 1, name: "Test Machine 1"),
        Machine(id: 2, name: "Test Machine 2"),
        Machine(id: 3, name: "Test Machine 3")
    ]
}
