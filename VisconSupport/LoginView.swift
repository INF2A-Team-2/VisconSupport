//
//  ContentView.swift
//  VisconSupport
//
//  Created by ZoutigeWolf on 03/12/2023.
//

import SwiftUI
import AVKit

struct LoginView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @State var username: String = ""
    @State var password: String = ""
    
    @State var showInvalidCredentialsAlert: Bool = false
    
    @State var backgroundPlayer: AVPlayer = AVPlayer(url: Bundle.main.url(forResource: "background", withExtension: "mp4")!)

    var body: some View {
        ZStack {
            VStack {
                Image("LogoFull")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                
                Spacer()
                
                VStack {
                    VStack {
                        TextField("Username", text: self.$username)
                            .font(.custom("AvenirNext-Regular", size: UIFont.systemFontSize))
                            .autocapitalization(.none)
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                    }
                    .padding(.leading)
                    .padding(.trailing)
                    
                    VStack {

                        SecureField("Password", text: self.$password)
                            .font(.custom("AvenirNext-Regular", size: UIFont.systemFontSize))
                            .autocapitalization(.none)
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                    }
                    .padding(.leading)
                    .padding(.trailing)
                }
                .textFieldStyle(.roundedBorder)
                
                Button(action: OnLogin) {
                    Text("Login")
                        .font(.custom("AvenirNext-Regular", size: UIFont.systemFontSize))
                        .padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20))
                        .foregroundColor(self.colorScheme == .light ? .black : .white)
                }
                .background(self.colorScheme == .light ? .white : .black)
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
        Authentication.shared.login(self.username, self.password) { success in
            if !success {
                self.showInvalidCredentialsAlert = true
            }
        }
    }
}
#Preview {
    LoginView()
}
