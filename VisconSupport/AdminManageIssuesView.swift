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
        List(issues.items, id: \.id) { i in
            NavigationLink(destination: IssueView(issue: i)) {
                VStack {
                    HStack {
                        Text(i.headline)
                            .lineLimit(1)
                        
                        Spacer()
                    }
                    
                    HStack {
                        Awesome.Solid.cogs.image.size(16)
                        Text(String(i.machine?.name ?? "-"))
                            .font(.caption)
                        
                        Spacer()
                    }
                    
                    HStack {
                        Awesome.Solid.user.image.size(16)
                        Text(i.user?.username ?? "-")
                            .font(.caption)
                        
                        Spacer()
                    }
                    
                    HStack {
                        Awesome.Solid.building.image.size(16)
                        Text(i.user?.company?.name ?? "-")
                            .font(.caption)
                        
                        Spacer()
                    }
                    
                    HStack {
                        Awesome.Solid.calendarDay.image.size(16)
                        Text(Utils.FormatDate(date: i.timeStamp, format: "d MMMM yyyy"))
                            .font(.caption)
                        
                        Spacer()
                    }
                    
                    HStack {
                        Awesome.Solid.clock.image.size(16)
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
