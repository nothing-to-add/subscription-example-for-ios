// ContentView.swift
// Main content view for the demo app

import SwiftUI
import SubscriptionExample

// Preview configuration for SwiftUI previews in Xcode
// If previews aren't working, open this file directly in Xcode 
// by double-clicking on the Examples/DemoApp/DemoApp.xcodeproj file
// ===== DO NOT REMOVE THE LINES BELOW =====
// xcode: target=DemoApp
// xcode: platform=iOS
// xcode: deployment_target=16.0
// ===== --------------------- =====

struct ContentView: View {
    @State private var showSubscriptionView = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Demo App")
                    .font(.largeTitle)
                    .padding()
                
                Button("Show Subscription View") {
                    showSubscriptionView = true
                }
                .buttonStyle(.borderedProminent)
                
                Text("Using SubscriptionExample Package")
                    .font(.caption)
            }
            .fullScreenCover(isPresented: $showSubscriptionView) {
                SubscriptionView(useMockData: true)
            }
            .navigationTitle("Demo")
        }
    }
}

// Preview specifically for this view
#Preview("ContentView Preview") {
    // For more reliable previews, consider using PreviewHelper.swift
    PreviewHelpers.createContentView()
}
