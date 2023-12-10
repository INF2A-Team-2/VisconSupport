//
//  AdminManageView.swift
//  VisconSupport
//
//  Created by ZoutigeWolf on 04/12/2023.
//

import SwiftUI

struct AdminManageView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: AdminManageIssuesView()) {
                    Image(systemName: "list.bullet")
                    Text("Issues")
                }
                
                NavigationLink(destination: AdminManageUsersView()) {
                    Image(systemName: "person.2.fill")
                    Text("Users")
                }
                
                NavigationLink(destination: AdminManageCompaniesView()) {
                    Image(systemName: "building.2.fill")
                    Text("Companies")
                }
            }
        }
    }
}

#Preview {
    AdminManageView()
}
