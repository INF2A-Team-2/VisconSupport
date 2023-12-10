//
//  AdminManageIssuesView.swift
//  VisconSupport
//
//  Created by ZoutigeWolf on 04/12/2023.
//

import SwiftUI

struct AdminManageIssuesView: View {
    @State var issues: [Issue] = []
    @State var users: [User] = []
    @State var machines: [Machine] = []
    
    @State private var searchQuery: String = ""
    
    @State private var filterDateStart: Date = Date.distantPast
    @State private var filterDateEnd: Date = Date.distantFuture
    
    @State private var filterUserId: Int = -1
    @State private var filterMachineId: Int = -1
    
    private var searchResults: [Issue] {
        var data: [Issue] = []
        if searchQuery.isEmpty {
            data = issues
        } else {
            data = issues.filter { i in
                i.headline.lowercased().contains(self.searchQuery.lowercased())
            }
        }
        
        data = data.filter { i in
            i.timeStamp >= filterDateStart && i.timeStamp <= filterDateEnd
        }
        
        if filterUserId != -1 {
            data = data.filter { i in
                i.userId == filterUserId
            }
        }
        
        if filterMachineId != -1 {
            data = data.filter { i in
                i.machineId == filterMachineId
            }
        }
        
        return data
    }
    
    var body: some View {
        List {
            Section {
                DatePicker(selection: self.$filterDateStart) {
                    Text("From")
                }
                
                DatePicker(selection: self.$filterDateEnd) {
                    Text("To")
                }
                
                Picker("User", selection: self.$filterUserId) {
                    Text("Any")
                        .tag(-1)
                    
                    ForEach(users.filter { u in u.type == AccountType.User }) { u in
                        Text(u.username)
                            .tag(u.id)
                    }
                }
                
                Picker("Machine", selection: self.$filterMachineId) {
                    Text("Any")
                        .tag(-1)
                    
                    ForEach(machines) { m in
                        Text(m.name)
                            .tag(m.id)
                    }
                }
            } header: {
                Text("Filters")
            }
            
            Section {
                ForEach(searchResults.sorted { $1.timeStamp < $0.timeStamp }, id: \.id) { i in
                    NavigationLink(destination: IssueView(issue: i)) {
                        VStack {
                            HStack {
                                Text(i.headline)
                                    .lineLimit(1)
                                
                                Spacer()
                            }
                            
                            HStack {
                                Text("#\(i.id)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                
                                Spacer()
                            }
                            .padding(.bottom, 4)
                            
                            HStack {
                                Image(systemName: "person.fill")
                                    .foregroundColor(.secondary)
                                    .font(.system(size: 12))
                                    .frame(width: 12)
                                
                                Text("\(i.user?.username ?? "-") @ \(i.user?.company?.name ?? "-")")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                
                                Spacer()
                            }
                            
                            HStack {
                                Image(systemName: "clock")
                                    .foregroundColor(.secondary)
                                    .font(.system(size: 12))
                                    .frame(width: 12)
                                
                                Text("\(Utils.FormatDate(date: i.timeStamp, format: "d MMMM yyyy")) \(Utils.FormatDate(date: i.timeStamp, format: "HH:mm"))")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                
                                Spacer()
                            }
                            
                            HStack {
                                Image(systemName: "gearshape.2.fill")
                                    .foregroundColor(.secondary)
                                    .font(.system(size: 12))
                                    .frame(width: 12)
                                
                                Text(String(i.machine?.name ?? "-"))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                
                                Spacer()
                            }
                        }
                    }
                    .swipeActions(allowsFullSwipe: false) {
                        Button(role: .destructive) {
                            print("Deleted issue \(i.id)")
                        } label: {
                            Label("", systemImage: "trash")
                        }
                    }
                }
            }
        }
        .navigationTitle(Text("Issues"))
        .searchable(text: self.$searchQuery)
        .onAppear {
            Issue.getAll() { issues in
                DispatchQueue.main.async {
                    self.issues = issues
                    self.filterDateStart = issues.min { a, b in a.timeStamp < b.timeStamp }?.timeStamp ?? Date.distantPast
                    self.filterDateEnd = issues.max { a, b in a.timeStamp < b.timeStamp }?.timeStamp ?? Date.distantFuture
                }
            }
            
            User.getAll() { users in
                DispatchQueue.main.async {
                    self.users = users
                }
            }
            
            Machine.getAll() { machines in
                DispatchQueue.main.async {
                    self.machines = machines
                }
            }
        }
    }
}

#Preview {
    AdminManageIssuesView()
}
