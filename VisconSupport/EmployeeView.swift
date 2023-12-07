//
//  EmployeeView.swift
//  VisconSupport
//
//  Created by ZoutigeWolf on 04/12/2023.
//

import SwiftUI
import Awesome

struct EmployeeView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: self.$selectedTab) {
            EmployeeHomeView()
                .tabItem {
                    Awesome.Solid.home.image
                    Text("Home")
                }
                .tag(0)
            
            Text("Issues")
                .tabItem {
                    Awesome.Solid.list.image
                    Text("Issues")
                }
                .tag(1)
            
            Text("Customers")
                .tabItem {
                    Awesome.Solid.users.image
                    Text("Customers")
                }
                .tag(2)
            
            MapView()
                .tabItem {
                    Image(systemName: "map")
                    Text("Map")
                }
                .tag(3)
            
            AccountView()
                .tabItem {
                    Awesome.Solid.user.image
                    Text("Account")
                }
                .tag(3)
        }
    }
}

#Preview {
    EmployeeView()
}
