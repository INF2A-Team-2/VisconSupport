//
//  AdminManageIssuesView.swift
//  VisconSupport
//
//  Created by ZoutigeWolf on 04/12/2023.
//

import SwiftUI

struct AdminManageIssuesView: View {
    var body: some View {
        List {
            NavigationLink(destination: IssueView()) {
                Text("Some issue")
            }
        }
        .navigationTitle(Text("Issues"))
    }
}

#Preview {
    AdminManageIssuesView()
}
