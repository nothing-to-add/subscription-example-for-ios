// MockProduct.swift
// Mock product model for UI display during development

import Foundation
import StoreKit

// Mock product class to use for UI display during development
public class MockProduct: Identifiable {
    public let id: String
    public let displayName: String
    public let description: String
    public let displayPrice: String
    public let subscription: Bool
    public let period: String?
    
    public init(id: String, displayName: String, description: String, displayPrice: String, subscription: Bool, period: String?) {
        self.id = id
        self.displayName = displayName
        self.description = description
        self.displayPrice = displayPrice
        self.subscription = subscription
        self.period = period
    }
    
    public init?(dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? String,
              let displayName = dictionary["displayName"] as? String,
              let description = dictionary["description"] as? String,
              let displayPrice = dictionary["displayPrice"] as? String,
              let subscription = dictionary["subscription"] as? Bool else {
            return nil
        }
        
        self.id = id
        self.displayName = displayName
        self.description = description
        self.displayPrice = displayPrice
        self.subscription = subscription
        self.period = dictionary["period"] as? String
    }
}
