//
//  HomeView.swift
//  VisconSupport
//
//  Created by ZoutigeWolf on 03/12/2023.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var authentication = Authentication.shared
    
    var body: some View {
        Group {
            if let user = authentication.currentUser {
                switch user.type {
                case .User:
                    UserView()
                case .Employee:
                    EmployeeView()
                case .Admin:
                    AdminView()
                }
            } else {
                LoginView()
            }
        }
    }
}

#Preview {
    HomeView()
}
