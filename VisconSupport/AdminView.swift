//
//  AdminView.swift
//  VisconSupport
//
//  Created by ZoutigeWolf on 04/12/2023.
//

import SwiftUI
import Awesome

struct AdminView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: self.$selectedTab) {
            AdminHomeView()
                .tabItem {
                    Awesome.Solid.home.image
                    Text("Home")
                }
                .tag(0)
            
            AdminManageView()
                .tabItem {
                    Awesome.Solid.cogs.image
                    Text("Manage")
                }
                .tag(1)
            
            Text("Logs")
                .tabItem {
                    Awesome.Solid.list.image
                    Text("Logs")
                }
                .tag(4)
            
            AccountView()
                .tabItem {
                    Awesome.Solid.user.image
                    Text("Account")
                }
                .tag(5)
        }
    }
}

#Preview {
    AdminView()
}
