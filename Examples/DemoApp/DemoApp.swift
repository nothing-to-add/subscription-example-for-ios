// DemoApp.swift
// Demo application showing how to use the SubscriptionExample package

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

@main
struct DemoApp: App {
    init() {
        // Set your app's product identifiers when initializing the package
        SubscriptionExample.initialize(
            debugMode: true,
            productIdentifiers: [
                "com.yourcompany.yourapp.monthly", 
                "com.yourcompany.yourapp.yearly",
                "com.yourcompany.yourapp.lifetime"
            ]
        )
        
        // Print available localizations
        print("Available localizations: \(SubscriptionExample.availableLocalizations())")
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

// This preview is just for the App structure
#Preview("App Structure") {
    // For more reliable previews, consider using PreviewHelper.swift
    PreviewHelpers.createDemoApp()
}
