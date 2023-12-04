//
//  AccountView.swift
//  VisconSupport
//
//  Created by ZoutigeWolf on 04/12/2023.
//

import SwiftUI

struct AccountView: View {
    var user = Authentication.shared.currentUser
    
    var body: some View {
        List {
            Button(action: OnLogout) {
                Text("Logout")
            }
        }
    }
    
    func OnLogout() {
        Authentication.shared.Logout()
    }
}

#Preview {
    AccountView()
}
