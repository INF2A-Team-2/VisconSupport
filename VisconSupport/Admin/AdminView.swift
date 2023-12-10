//
//  AdminView.swift
//  VisconSupport
//
//  Created by ZoutigeWolf on 04/12/2023.
//

import SwiftUI

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
            
            MapView()
                .tabItem {
                    Image(systemName: "map")
                    Text("Map")
                }
                .tag(2)
            
            Text("Logs")
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Logs")
                }
                .tag(3)
            
            AccountView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Account")
                }
                .tag(4)
        }
    }
}

#Preview {
    AdminView()
}
