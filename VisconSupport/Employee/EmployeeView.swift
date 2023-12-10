//
//  EmployeeView.swift
//  VisconSupport
//
//  Created by ZoutigeWolf on 04/12/2023.
//

import SwiftUI

struct EmployeeView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: self.$selectedTab) {
            EmployeeHomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)
            
            Text("Issues")
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Issues")
                }
                .tag(1)
            
            Text("Customers")
                .tabItem {
                    Image(systemName: "person.2.fill")
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
                    Image(systemName: "person.fill")
                    Text("Account")
                }
                .tag(3)
        }
    }
}

#Preview {
    EmployeeView()
}
