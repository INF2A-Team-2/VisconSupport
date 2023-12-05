//
//  ContentView.swift
//  VisconSupport
//
//  Created by ZoutigeWolf on 03/12/2023.
//

import SwiftUI
import AVKit

struct LoginView: View {
    @State var username = ""
    @State var password = ""
    
    @State var showInvalidCredentialsAlert = false
    
    @State var backgroundPlayer = AVPlayer(url: Bundle.main.url(forResource: "background", withExtension: "mp4")!)
                                           
    var body: some View {
        ZStack {
            VStack {
                Image("LogoFull")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                
                Spacer()
                
                VStack(alignment: .center, spacing: 16) {
                    VStack {
                        HStack {
                            Text("Username")
                                .foregroundColor(.white)
                                
                                
                            
                            Spacer()
                        }
                        
                        TextField("", text: self.$username)
                            .autocapitalization(.none)
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                    }
                    .padding()
                    
                    VStack {
                        HStack {
                            Text("Password")
                                .foregroundColor(.white)
                            
                            Spacer()
                        }
                        
                        SecureField("", text: self.$password)
                            .autocapitalization(.none)
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                    }
                    .padding()
                }
                .textFieldStyle(.roundedBorder)
                
                Button(action: OnLogin) {
                    Text("Login")
                        .padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20))
                        .foregroundColor(.black)
                }
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 4))
                
                Spacer()
            }
            .frame(width: UIScreen.main.bounds.width)
        }
        .background(
            VideoPlayer(player: backgroundPlayer)
                .aspectRatio(CGSize(width: 32, height: 9), contentMode: .fill)
                .ignoresSafeArea(edges: .all)
                .onAppear {

                    backgroundPlayer.play()

                    NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime,
                                                           object: backgroundPlayer.currentItem,
                                                           queue: .main) { _ in
                        backgroundPlayer.seek(to: .zero)
                        backgroundPlayer.play()
                    }
                }
                .onDisappear {
                    NotificationCenter.default.removeObserver(self)
                }
                .disabled(true)
                .overlay(.black.opacity(0.75))
                .blur(radius: 10)
        )
        .alert(isPresented: $showInvalidCredentialsAlert) {
            Alert(
                title: Text("Login failed"),
                message: Text("Invalid username or password")
            )
        }
    }
    
    func OnLogin() {
        Authentication.shared.login(username: self.username, password: self.password) { success in
            if success {
                print(Authentication.shared.currentUser!)
            } else {
                self.showInvalidCredentialsAlert = true
            }
        }
    }
}
#Preview {
    LoginView()
}
