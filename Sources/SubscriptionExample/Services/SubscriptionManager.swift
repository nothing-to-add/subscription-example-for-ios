//
//  File name: SubscriptionManager.swift
//  Project name: subscriptionexample
//  Workspace name: subscriptionexample
//
//  Created by: nothing-to-add on 01/04/2025
//  Using Swift 6.0
//  Copyright (c) 2023 nothing-to-add
//

import StoreKit
import SwiftUI

@MainActor
public class SubscriptionManager: NSObject, ObservableObject {
    @Published public var isSubscribed: Bool = false
    @Published public var products: [Product] = []
    @Published public var mockProducts: [MockProduct] = []
    @Published public var purchaseState: PurchaseState = .ready
    private var transactionListener: Task<Void, Error>?
    
    // Flag to use mock data during development
    private let useMockData: Bool
    
    // Product identifiers for StoreKit
    private let productIdentifiers: [String]
    
    /// Initialize the Subscription Manager
    /// - Parameters:
    ///   - useMockData: When true, mock products will be used instead of real StoreKit products
    ///   - productIdentifiers: Array of product identifiers registered in App Store Connect
    public init(useMockData: Bool = true, productIdentifiers: [String] = ["com.example.subscription"]) {
        self.useMockData = useMockData
        self.productIdentifiers = productIdentifiers
        super.init()
        Task {
            transactionListener = await listenForTransactions()
            if useMockData {
                createMockProductsUI()
            } else {
                await fetchProducts()
            }
        }
    }
    
    deinit {
        transactionListener?.cancel()
    }
    
    public func fetchProducts() async {
        do {
            let storeProducts = try await Product.products(for: productIdentifiers)
            self.products = storeProducts
        } catch {
            print("Failed to fetch products: \(error.localizedDescription)")
        }
    }
    
    public func purchaseSubscription(product: Product) async throws {
        purchaseState = .purchasing
        
        do {
            let result = try await product.purchase()
            
            switch result {
            case .success(let verification):
                let transaction = try checkVerified(verification)
                await updateSubscriptionStatus()
                await transaction.finish()
                purchaseState = .purchased
                
            case .pending:
                // This occurs when the purchase requires approval by a family organizer
                // (Ask to Buy, Family Sharing settings)
                purchaseState = .pendingApproval
                if SubscriptionExample.debugMode {
                    print("Purchase is pending authorization from a family organizer (Ask to Buy).")
                }
                
            case .userCancelled:
                purchaseState = .cancelled
                if SubscriptionExample.debugMode {
                    print("User cancelled the purchase")
                }
                
            @unknown default:
                purchaseState = .failed("Unknown purchase result")
                if SubscriptionExample.debugMode {
                    print("Unknown purchase result")
                }
            }
        } catch {
            purchaseState = .failed(error.localizedDescription)
            if SubscriptionExample.debugMode {
                print("Purchase failed: \(error.localizedDescription)")
            }
            throw error
        }
    }
    
    public func restorePurchases() async throws {
        do {
            try await AppStore.sync()
            let oldStatus = isSubscribed
            await updateSubscriptionStatus()
            
            if !oldStatus && isSubscribed {
                // We successfully restored a subscription
                if SubscriptionExample.debugMode {
                    print("Successfully restored purchases")
                }
            } else if !isSubscribed {
                if SubscriptionExample.debugMode {
                    print("No purchases to restore")
                }
                throw StoreError.noPurchasesToRestore
            }
        } catch {
            if SubscriptionExample.debugMode {
                print("Failed to restore purchases: \(error.localizedDescription)")
            }
            throw error
        }
    }
    
    private func updateSubscriptionStatus() async {
        var isCurrentlySubscribed = false
        
        for await result in Transaction.currentEntitlements {
            do {
                let transaction = try checkVerified(result)
                
                // Check if this transaction is for a subscription
                if transaction.productType == .autoRenewable {
                    isCurrentlySubscribed = true
                }
            } catch {
                print("Transaction verification failed: \(error.localizedDescription)")
            }
        }
        
        self.isSubscribed = isCurrentlySubscribed
    }
    
    private func listenForTransactions() async -> Task<Void, Error> {
        return Task.detached {
            for await result in Transaction.updates {
                do {
                    let transaction = try await self.checkVerified(result)
                    await self.updateSubscriptionStatus()
                    await transaction.finish()
                } catch {
                    print("Transaction verification failed: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreError.failedVerification
        case .verified(let safe):
            return safe
        }
    }
    
    // Create UI-only mock products for development
    private func createMockProductsUI() {
        let mockItems = [
            MockProduct(
                id: "com.yourapp.subscription.monthly",
                displayName: "Monthly Premium",
                description: "Unlimited access to all premium features with monthly billing",
                displayPrice: "$9.99",
                subscription: true,
                period: "Monthly"
            ),
            MockProduct(
                id: "com.yourapp.subscription.yearly",
                displayName: "Yearly Premium (Save 20%)",
                description: "Unlimited access to all premium features with annual billing",
                displayPrice: "$79.99",
                subscription: true,
                period: "Yearly"
            ),
            MockProduct(
                id: "com.yourapp.lifetime",
                displayName: "Lifetime Access",
                description: "One-time purchase for unlimited lifetime access to all premium features",
                displayPrice: "$199.99",
                subscription: false,
                period: nil
            )
        ]
        
        // Set the mock products directly
        self.mockProducts = mockItems
    }
}

public enum StoreError: Error {
    case failedVerification
    case noPurchasesToRestore
}

/// Represents the current state of a purchase transaction
public enum PurchaseState: Equatable {
    /// Ready to make a purchase
    case ready
    /// Purchase is in progress
    case purchasing
    /// Purchase succeeded
    case purchased
    /// Purchase is waiting for approval (Family Sharing, Ask to Buy)
    case pendingApproval
    /// Purchase was cancelled by the user
    case cancelled
    /// Purchase failed with an error
    case failed(String)
    
    /// Returns a user-friendly message for the current state
    public var message: String {
        switch self {
        case .ready:
            return ""
        case .purchasing:
            return "Processing your purchase..."
        case .purchased:
            return "Thank you for your purchase!"
        case .pendingApproval:
            return "Your purchase is waiting for approval. A family organizer may need to approve this purchase."
        case .cancelled:
            return "Purchase was cancelled."
        case .failed(let message):
            return "Purchase failed: \(message)"
        }
    }
}

// Extension for convenience methods
public extension SubscriptionManager {
    func purchase() async {
        if let product = products.first {
            do {
                try await purchaseSubscription(product: product)
            } catch {
                if SubscriptionExample.debugMode {
                    print("Failed to purchase: \(error.localizedDescription)")
                }
                purchaseState = .failed(error.localizedDescription)
            }
        } else if useMockData && !mockProducts.isEmpty {
            // Simulate successful purchase with mock products
            Task { @MainActor in
                purchaseState = .purchasing
                // Simulate network delay
                try? await Task.sleep(for: .seconds(1.5))
                isSubscribed = true
                purchaseState = .purchased
            }
        }
    }
    
    func restore() async {
        purchaseState = .purchasing
        do {
            try await restorePurchases()
            if isSubscribed {
                purchaseState = .purchased
            } else {
                purchaseState = .failed("No purchases to restore")
            }
        } catch {
            purchaseState = .failed("Restore failed: \(error.localizedDescription)")
        }
    }
    
    /// Reset the purchase state to ready
    func resetPurchaseState() {
        purchaseState = .ready
    }
}
