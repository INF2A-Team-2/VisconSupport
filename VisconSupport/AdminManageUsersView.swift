//
//  AdminManageUsersView.swift
//  VisconSupport
//
//  Created by ZoutigeWolf on 04/12/2023.
//

import SwiftUI

struct AdminManageUsersView: View {
    var body: some View {
        List {
            NavigationLink(destination: AdminUserView()) {
                Text("Some User")
            }
        }
        .navigationTitle(Text("Users"))
    }
}

#Preview {
    AdminManageUsersView()
}
