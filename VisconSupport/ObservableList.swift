//
//  ObservableList.swift
//  VisconSupport
//
//  Created by ZoutigeWolf on 04/12/2023.
//

import Foundation

class ObservableList<T> : ObservableObject {
    @Published var items: [T] = []
    
    init(items: [T] = []) {
        self.items = items
    }
}
