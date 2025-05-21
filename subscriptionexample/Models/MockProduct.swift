//
//  File name: MockProduct.swift
//  Project name: subscriptionexample
//  Workspace name: subscriptionexample
//
//  Created by: nothing-to-add on 21/05/2025
//  Using Swift 6.0
//  Copyright (c) 2023 nothing-to-add
//

import Foundation
import StoreKit

// Mock product class to use for UI display during development
class MockProduct: Identifiable {
    let id: String
    let displayName: String
    let description: String
    let displayPrice: String
    let subscription: Bool
    let period: String?
    
    init(id: String, displayName: String, description: String, displayPrice: String, subscription: Bool, period: String?) {
        self.id = id
        self.displayName = displayName
        self.description = description
        self.displayPrice = displayPrice
        self.subscription = subscription
        self.period = period
    }
    
    init?(dictionary: [String: Any]) {
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
