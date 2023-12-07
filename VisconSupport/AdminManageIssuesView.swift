//
//  AdminManageIssuesView.swift
//  VisconSupport
//
//  Created by ZoutigeWolf on 04/12/2023.
//

import SwiftUI
import Awesome

struct AdminManageIssuesView: View {
    @ObservedObject var issues: ObservableList<Issue> = ObservableList<Issue>()
    
    var body: some View {
        List(issues.items.sorted { $1.timeStamp < $0.timeStamp }, id: \.id) { i in
            NavigationLink(destination: IssueView(issue: i)) {
                VStack {
                    HStack {
                        Text(i.headline)
                            .lineLimit(1)
                        
                        Spacer()
                    }
                    
                    HStack {
                        Image(systemName: "gearshape.2.fill")
                        Text(String(i.machine?.name ?? "-"))
                            .font(.caption)
                        
                        Spacer()
                    }
                    
                    HStack {
                        Image(systemName: "person.fill")
                        Text(i.user?.username ?? "-")
                            .font(.caption)
                        
                        Spacer()
                    }
                    
                    HStack {
                        Image(systemName: "building.fill")
                        Text(i.user?.company?.name ?? "-")
                            .font(.caption)
                        
                        Spacer()
                    }
                    
                    HStack {
                        Image(systemName: "calendar")
                        Text(Utils.FormatDate(date: i.timeStamp, format: "d MMMM yyyy"))
                            .font(.caption)
                        
                        Spacer()
                    }
                    
                    HStack {
                        Image(systemName: "clock")
                        Text(Utils.FormatDate(date: i.timeStamp, format: "HH:mm"))
                            .font(.caption)
                        
                        Spacer()
                    }
                }
            }
        }
        .navigationTitle(Text("Issues"))
        .onAppear {
            Issue.getAll() { issues in
                DispatchQueue.main.async {
                    self.issues.items = issues
                }
            }
        }
    }
}

#Preview {
    AdminManageIssuesView()
}
