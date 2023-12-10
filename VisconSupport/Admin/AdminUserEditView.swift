//
//  AdminUserView.swift
//  VisconSupport
//
//  Created by ZoutigeWolf on 04/12/2023.
//

import SwiftUI

struct AdminUserEditView: View {
    var user: User? = nil
    
    @State var isEditing: Bool = false
    @State var editData: UserData? = nil
    
    @State var editUsername: String = ""
    
    var body: some View {
        VStack {
            if !isEditing {
                HStack {
                    Text(user?.username ?? "user")
                        .font(.title)
                    
                    Spacer()
                }
                .padding(.bottom, 4)
                
                HStack {
                    Image(systemName: user?.getIcon() ?? "questionmark.circle.fill")
                        .frame(width: 24, height: 16)
                        .foregroundColor(.secondary)
                    
                    Text(user?.type.description ?? "type")
                        .foregroundColor(.secondary)
                    
                    Spacer()
                }
                
                if user?.type == .User || user?.type == .Employee {
                    HStack {
                        Image(systemName: "building.fill")
                            .frame(width: 24, height: 16)
                            .foregroundColor(.secondary)
                        Text(user?.type == .User ? "\(user?.unit ?? "unit") @ \(user?.company?.name ?? "company")" : user?.unit ?? "unit")
                            .foregroundColor(.secondary)
                        
                        Spacer()
                    }
                }
                
                if user?.phoneNumber != nil {
                    HStack {
                        Image(systemName: "phone.fill")
                            .frame(width: 24, height: 16)
                            .foregroundColor(.secondary)
                        Text(user?.phoneNumber ?? "tel")
                            .foregroundColor(.secondary)
                        
                        Spacer()
                    }
                }
            } else {
                TextField("Username", text: self.$editUsername)
                    .onSubmit {
                        self.editData?.username = self.editUsername
                    }
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle(Text(user?.username ?? "User"))
        .toolbar {
            Button(isEditing ? "Cancel" : "Edit") {
                self.isEditing.toggle()
                
                if self.isEditing {
                    self.editData = user?.data
                    self.editUsername = self.editData?.username ?? ""
                }
            }
        }
    }
}

#Preview {
    AdminUserEditView()
}
