//
//  File name: SubscriptionExample.swift
//  Project name: subscriptionexample
//  Workspace name: subscriptionexample
//
//  Created by: nothing-to-add on 21/05/2025
//  Using Swift 6.0
//  Copyright (c) 2023 nothing-to-add
//

// Export all components from the package
@_exported import SwiftUI
@_exported import StoreKit
@_exported import CustomExtensions

// Re-export all the submodules
public struct SubscriptionExample {
    /// Whether to show debug information in the console
    public static var debugMode: Bool = false
    
    /// Default product identifiers for StoreKit integration
    public static var productIdentifiers: [String] = ["com.example.subscription"]
    
    /// Default number of days for free trial
    public static var defaultFreeTrialDays: Int = 5
    
    /// Initialize the SubscriptionExample package with configuration options
    /// - Parameters:
    ///   - debugMode: Set to true to enable debug logging
    ///   - productIdentifiers: Array of product identifiers registered in App Store Connect
    ///   - defaultFreeTrialDays: Default number of days for the free trial period
    ///
    /// Example usage:
    /// ```swift
    /// // Configure at app launch
    /// SubscriptionExample.initialize(
    ///     debugMode: true,
    ///     productIdentifiers: [
    ///         "com.yourcompany.yourapp.monthly",
    ///         "com.yourcompany.yourapp.yearly"
    ///     ],
    ///     defaultFreeTrialDays: 5
    /// )
    /// ```
    ///
    /// Note: For family sharing features like "Ask to Buy" to work, you need to configure
    /// Family Sharing for your in-app purchases in App Store Connect. When a child attempts to
    /// make a purchase, it will enter a "pending" state awaiting parent approval.
    public static func initialize(debugMode: Bool = false, productIdentifiers: [String]? = nil, defaultFreeTrialDays: Int = 5) {
        Self.debugMode = debugMode
        Self.defaultFreeTrialDays = defaultFreeTrialDays
        
        if let identifiers = productIdentifiers {
            Self.productIdentifiers = identifiers
        }
        
        if debugMode {
            print("SubscriptionExample package initialized with localizations from \(Bundle.module.bundlePath)")
            print("Using product identifiers: \(Self.productIdentifiers)")
        }
    }
    
    /// Get a listing of all available localizations in the package
    public static func availableLocalizations() -> [String] {
        return Bundle.module.localizations
    }
}
