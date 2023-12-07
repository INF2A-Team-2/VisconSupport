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
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)
            
            AdminManageView()
                .tabItem {
                    Image(systemName: "gearshape.2.fill")
                    Text("Manage")
                }
                .tag(1)
            
            Text("Logs")
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Logs")
                }
                .tag(4)
            
            AccountView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Account")
                }
                .tag(5)
        }
    }
}

#Preview {
    AdminView()
}
