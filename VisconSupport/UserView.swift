//
//  UserView.swift
//  VisconSupport
//
//  Created by ZoutigeWolf on 04/12/2023.
//

import SwiftUI
import Awesome

struct UserView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: self.$selectedTab) {
            UserHomeView()
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
            
            Text("New issue")
                .tabItem {
                    Awesome.Solid.plus.image
                    Text("New issue")
                }
                .tag(2)
            
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
    UserView()
}
