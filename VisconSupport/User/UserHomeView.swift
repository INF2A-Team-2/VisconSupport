//
//  UserHomeView.swift
//  VisconSupport
//
//  Created by ZoutigeWolf on 03/12/2023.
//

import SwiftUI

struct UserHomeView: View {
    @ObservedObject var authentication = Authentication.shared
    
    @State var issues: [Issue] = []
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Welcome, \(authentication.currentUser?.username ?? "User")")
                    .font(.title)
                
                List {
                    Section {
                        ForEach(issues.sorted { $1.timeStamp < $0.timeStamp }.prefix(3), id: \.id) { i in
                            NavigationLink(destination: IssueView(issue: i)) {
                                VStack {
                                    HStack {
                                        Text(i.headline)
                                            .lineLimit(1)
                                        
                                        Spacer()
                                    }
                                    
                                    HStack {
                                        Image(systemName: "gearshape.2.fill")
                                            .foregroundColor(.secondary)
                                            .frame(width: 24, height: 16)
                                        
                                        Text(String(i.machine?.name ?? "-"))
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                        
                                        Spacer()
                                    }
                                    
                                    HStack {
                                        Image(systemName: "person.fill")
                                            .foregroundColor(.secondary)
                                            .frame(width: 24, height: 16)
                                        
                                        Text(i.user?.username ?? "-")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                        
                                        Spacer()
                                    }
                                    
                                    HStack {
                                        Image(systemName: "building.fill")
                                            .foregroundColor(.secondary)
                                            .frame(width: 24, height: 16)
                                        
                                        Text(i.user?.company?.name ?? "-")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                        
                                        Spacer()
                                    }
                                    
                                    HStack {
                                        Image(systemName: "calendar")
                                            .foregroundColor(.secondary)
                                            .frame(width: 24, height: 16)
                                        
                                        Text(Utils.FormatDate(date: i.timeStamp, format: "d MMMM yyyy"))
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                        
                                        Spacer()
                                    }
                                    
                                    HStack {
                                        Image(systemName: "clock")
                                            .foregroundColor(.secondary)
                                            .frame(width: 24, height: 16)
                                        
                                        Text(Utils.FormatDate(date: i.timeStamp, format: "HH:mm"))
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                        
                                        Spacer()
                                    }
                                }
                            }
                        }
                    } header: {
                        Text("Recent issues")
                    }
                }
            }
        }
        .onAppear {
            Issue.getAll() { issues in
                DispatchQueue.main.async {
                    self.issues = issues
                }
            }
        }
    }
}

#Preview {
    UserHomeView()
}
