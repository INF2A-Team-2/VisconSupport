//
//  IssueView.swift
//  VisconSupport
//
//  Created by ZoutigeWolf on 04/12/2023.
//

import SwiftUI

struct IssueView: View {
    var issue: Issue? = nil
    
    var body: some View {
        VStack {
            Text("Some Issue")
        }
        .navigationTitle(Text("Issue"))
    }
}

#Preview {
    IssueView()
}
