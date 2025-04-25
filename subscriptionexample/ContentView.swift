//
//  File name: ContentView.swift
//  Project name: subscriptionexample
//  Workspace name: Untitled 1
//
//  Created by: nothing-to-add on 01/04/2025
//  Using Swift 6.0
//  Copyright (c) 2023 nothing-to-add
//


//change text to "My first SwiftUI app" and change the image to "star.fill"


import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "star.fill")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("My first SwiftUI app")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
