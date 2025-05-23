// SubscriptionExample.swift
// Main package export file 

// Export all components from the package
@_exported import SwiftUI
@_exported import StoreKit
@_exported import CustomExtensions

// Re-export all the submodules
public struct SubscriptionExample {
    /// Whether to show debug information in the console
    public static var debugMode: Bool = false
    
    /// Initialize the SubscriptionExample package with configuration options
    /// - Parameter debugMode: Set to true to enable debug logging
    public static func initialize(debugMode: Bool = false) {
        Self.debugMode = debugMode
        
        if debugMode {
            print("SubscriptionExample package initialized with localizations from \(Bundle.module.bundlePath)")
        }
    }
    
    /// Get a listing of all available localizations in the package
    public static func availableLocalizations() -> [String] {
        return Bundle.module.localizations
    }
}
