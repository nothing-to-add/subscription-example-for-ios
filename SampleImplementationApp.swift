// SampleImplementationApp.swift
// Sample app implementing the SubscriptionExample package

import SwiftUI
import SubscriptionExample

@main
struct SampleImplementationApp: App {
    init() {
        // Initialize the package
        SubscriptionExample.initialize(debugMode: true)
    }
    
    var body: some Scene {
        WindowGroup {
            // Use the SubscriptionView from the package
            SubscriptionExample.SubscriptionView(useMockData: true)
        }
    }
}
