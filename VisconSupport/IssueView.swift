//
//  IssueView.swift
//  VisconSupport
//
//  Created by ZoutigeWolf on 04/12/2023.
//

import SwiftUI
import AVKit
import Awesome

struct IssueView: View {
    var issue: Issue? = nil
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Text(issue?.headline ?? "headline")
                        .font(.title)
                    
                    Spacer()
                }
                .padding(.bottom, 4)
                
                HStack {
                    Image(systemName: "person.fill")
                        .frame(width: 24, height: 16)
                        .foregroundColor(.secondary)
                    Text(issue?.user?.username ?? "user")
                        .foregroundColor(.secondary)
                    
                    Spacer()
                }
                .padding(.bottom, 4)
                
                HStack {
                    Image(systemName: "gearshape.2.fill")
                        .frame(width: 24, height: 16)
                        .foregroundColor(.secondary)
                    Text(issue?.machine?.name ?? "machine")
                        .foregroundColor(.secondary)
                    
                    Spacer()
                }
                .padding(.bottom, 4)
                
                HStack {
                    Image(systemName: "building.fill")
                        .frame(width: 24, height: 16)
                        .foregroundColor(.secondary)
                    Text(issue?.user?.company?.name ?? "company")
                        .foregroundColor(.secondary)
                    
                    Spacer()
                }
                .padding(.bottom, 16)
            }
            
            VStack {
                VStack {
                    HStack {
                        Text("What happened")
                            .font(.headline)
                        
                        Spacer()
                    }
                        
                    HStack {
                        Text(issue?.actual ?? "actual")
                        
                        Spacer()
                    }
                }
                .padding(.bottom)
                
                VStack {
                    HStack {
                        Text("Expectations")
                            .font(.headline)
                        
                        Spacer()
                    }
                        
                    HStack {
                        Text(issue?.expected ?? "expected")
                        
                        Spacer()
                    }
                }
                .padding(.bottom)
                
                VStack {
                    HStack {
                        Text("What did you try")
                            .font(.headline)
                        
                        Spacer()
                    }
                        
                    HStack {
                        Text(issue?.tried ?? "tried")
                        
                        Spacer()
                    }
                }
                .padding(.bottom)
            }
            
            VStack {
                ForEach(issue?.attachments.sorted { $0.id < $1.id } ?? [], id: \.id) { a in
                    if let url = URL(string: a.url) {
                        switch a.type {
                        case AttachmentType.Image:
                            AsyncImage(url: url) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .padding()
                            } placeholder: {
                                ProgressView()
                            }
                                
                        case AttachmentType.Video:
                            VideoPlayer(player: AVPlayer(url: url))
                            
                        case AttachmentType.Other:
                            Text(a.name ?? String(a.id))
                        }
                    }
                }
            }
            .padding()
            
            ForEach(issue?.messages.sorted { $0.timeStamp < $1.timeStamp } ?? []) { m in
                VStack {
                    HStack {
                        Image(systemName: (m.user?.getIcon())!)
                        
                        Text(m.user?.username ?? "user")
                            .font(.headline)
                        
                        Spacer()
                    }
                    
                    HStack {
                        Text(Utils.FormatDate(date: m.timeStamp, format: "DD/MM/YYYY HH:mm"))
                            .font(.footnote)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                    }
                    .padding(.bottom, 5)
                
                    HStack {
                        Text(m.body)
                        
                        Spacer()
                    }
                }
                .padding(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.secondary, lineWidth: 1)
                )
                .padding(.bottom, 8)
            }
        }
        .padding()
        .navigationTitle(Text(issue?.headline ?? "headline"))
    }
}

#Preview {
    IssueView()
}
