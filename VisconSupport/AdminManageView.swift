//
//  AdminManageView.swift
//  VisconSupport
//
//  Created by ZoutigeWolf on 04/12/2023.
//

import SwiftUI
import Awesome

struct AdminManageView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: AdminManageIssuesView()) {
                    Awesome.Solid.list.image
                    Text("Issues")
                }
                
                NavigationLink(destination: AdminManageUsersView()) {
                    Awesome.Solid.users.image
                    Text("Users")
                }
                
                NavigationLink(destination: AdminManageCompaniesView()) {
                    Awesome.Solid.building.image
                    Text("Companies")
                }
            }
        }
    }
}

#Preview {
    AdminManageView()
}
