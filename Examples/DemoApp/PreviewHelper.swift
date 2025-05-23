// PreviewHelper.swift
// Helper file for SwiftUI previews in the demo app

import SwiftUI
import SubscriptionExample

// This file contains helper functions and extensions to make SwiftUI previews work

// Preview configuration for SwiftUI previews in Xcode
// If previews aren't working, open this file directly in Xcode 
// by double-clicking on the Examples/DemoApp/DemoApp.xcodeproj file
// ===== DO NOT REMOVE THE LINES BELOW =====
// xcode: target=DemoApp
// xcode: platform=iOS
// xcode: deployment_target=16.0
// ===== --------------------- =====

/// Sample content to use in previews
struct PreviewHelpers {
    /// Create a preview-ready instance of the SubscriptionView
    static func createSubscriptionView() -> some View {
        SubscriptionExample.initialize(debugMode: true)
        return SubscriptionView(useMockData: true)
    }
    
    /// Create a preview-ready instance of the ContentView
    static func createContentView() -> some View {
        ContentView()
    }
    
    /// Create a preview-ready instance of the DemoApp
    static func createDemoApp() -> some View {
        Text("Demo App")
            .font(.largeTitle)
            .padding()
    }
}

#Preview("ContentView") {
    PreviewHelpers.createContentView()
}

#Preview("SubscriptionView") {
    PreviewHelpers.createSubscriptionView()
}

#Preview("DemoApp") {
    PreviewHelpers.createDemoApp()
}
