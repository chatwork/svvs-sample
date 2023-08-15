//
//  ContentView.swift
//  SVVSSample
//
//  Created by Yuta Koshizawa on 2023/08/15.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            UserView(id: "A")
        }
        .navigationViewStyle(.stack)
    }
}
