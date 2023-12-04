//
//  UserHomeView.swift
//  VisconSupport
//
//  Created by ZoutigeWolf on 03/12/2023.
//

import SwiftUI
import Awesome

struct UserHomeView: View {
    @ObservedObject var authentication = Authentication.shared
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Welcome, \(authentication.currentUser?.username ?? "User")")
                    .font(.title)
                
                List {
                    Section {
                        NavigationLink(destination: IssueView()) {
                            VStack {
                                HStack {
                                    Text("Issue 1")
                                    
                                    Spacer()
                                }
                                
                                HStack {
                                    Awesome.Solid.cogs.image.size(16)
                                    Text("Machine")
                                        .font(.caption)
                                    
                                    Spacer()
                                }
                            }
                        }
                    } header: {
                        Text("Recent issues")
                    }
                }
            }
        }
    }
}

#Preview {
    UserHomeView()
}
