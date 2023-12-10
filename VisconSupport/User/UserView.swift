//
//  UserView.swift
//  VisconSupport
//
//  Created by ZoutigeWolf on 04/12/2023.
//

import SwiftUI

struct UserView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: self.$selectedTab) {
            UserHomeView()
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
            
            Text("New issue")
                .tabItem {
                    Image(systemName: "text.badge.plus")
                    Text("New issue")
                }
                .tag(2)
            
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
    UserView()
}
