//
//  AdminManageUsersView.swift
//  VisconSupport
//
//  Created by ZoutigeWolf on 04/12/2023.
//

import SwiftUI

struct AdminManageUsersView: View {
    @State var users: [User] = []
    
    @State private var searchQuery = ""
    @State private var filterAccountType: Int = -1
    
    private var searchResults: [User] {
        var data: [User] = []
        if searchQuery.isEmpty {
            data = users
        } else {
            data = users.filter { u in
                u.username.lowercased().contains(self.searchQuery.lowercased())
            }
        }
        
        if filterAccountType != -1 {
            data = data.filter { u in
                u.type == AccountType(rawValue: filterAccountType)
            }
        }
        
        return data
    }
    
    var body: some View {
        List {
            Section {
                Picker("Type", selection: self.$filterAccountType) {
                    Text("Any")
                        .tag(-1)
                    
                    Text("Customer")
                        .tag(0)
                    
                    Text("Employee")
                        .tag(1)
                    
                    Text("Admin")
                        .tag(2)
                }
            } header: {
                Text("Filters")
            }
            
            Section {
                ForEach(searchResults.sorted { $0.id < $1.id }) { u in
                    NavigationLink(destination: AdminUserEditView(user: u)) {
                        VStack {
                            HStack {
                                Text(u.username)
                                    .lineLimit(1)
                                
                                Spacer()
                            }
                            
                            HStack {
                                Text("#\(u.id)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                
                                Spacer()
                            }
                            .padding(.bottom, 4)
                            
                            HStack {
                                Image(systemName: u.getIcon())
                                    .foregroundColor(.secondary)
                                    .font(.system(size: 12))
                                    .frame(width: 12)
                                
                                Text(u.type.description)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                
                                Spacer()
                            }
                            
                            if u.type == .User || u.type == .Employee {
                                HStack {
                                    Image(systemName: "building.fill")
                                        .foregroundColor(.secondary)
                                        .font(.system(size: 12))
                                        .frame(width: 12)
                                    
                                    Text(u.type == .User ? "\(u.unit ?? "unit") @ \(u.company?.name ?? "company")" : u.unit ?? "unit")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    
                                    Spacer()
                                }
                            }
                        }
                    }
                    .swipeActions(allowsFullSwipe: false) {
                        Button(role: .destructive) {
                            print("Deleted user \(u.id)")
                        } label: {
                            Label("", systemImage: "trash")
                        }
                    }
                }
            }
        }
        .navigationTitle(Text("Users"))
        .searchable(text: self.$searchQuery)
        .onAppear {
            User.getAll() { users in
                DispatchQueue.main.async {
                    self.users = users
                }
            }
        }
    }
}

#Preview {
    AdminManageUsersView()
}
