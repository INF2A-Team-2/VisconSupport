//
//  AdminManageCompaniesView.swift
//  VisconSupport
//
//  Created by ZoutigeWolf on 04/12/2023.
//

import SwiftUI

struct AdminManageCompaniesView: View {
    var body: some View {
        List {
            NavigationLink(destination: AdminCompanyView()) {
                Text("Some Company")
            }
        }
        .navigationTitle(Text("Companies"))
    }
}

#Preview {
    AdminManageCompaniesView()
}
