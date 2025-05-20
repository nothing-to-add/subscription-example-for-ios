//
//  File name: SubscriptionManager.swift
//  Project name: subscriptionexample
//  Workspace name: Untitled 1
//
//  Created by: nothing-to-add on 01/04/2025
//  Using Swift 6.0
//  Copyright (c) 2023 nothing-to-add
//

import StoreKit

@MainActor
class SubscriptionManager: NSObject, ObservableObject {
    @Published var isSubscribed: Bool = false
    @Published var products: [Product] = []
    private var transactionListener: Task<Void, Error>?
    
    override init() {
        super.init()
        Task {
            transactionListener = await listenForTransactions()
            await fetchProducts()
        }
    }
    
    deinit {
        transactionListener?.cancel()
    }
    
    func fetchProducts() async {
        do {
            let storeProducts = try await Product.products(for: ["com.yourapp.subscription"])
            self.products = storeProducts
        } catch {
            print("Failed to fetch products: \(error.localizedDescription)")
        }
    }
    
    func purchaseSubscription(product: Product) async throws {
        let result = try await product.purchase()
        
        switch result {
        case .success(let verification):
            let transaction = try checkVerified(verification)
            await updateSubscriptionStatus()
            await transaction.finish()
        case .pending:
            print("Purchase is pending authorization")
        case .userCancelled:
            print("User cancelled the purchase")
        @unknown default:
            print("Unknown purchase result")
        }
    }
    
    func restorePurchases() async {
        do {
            try await AppStore.sync()
            await updateSubscriptionStatus()
        } catch {
            print("Failed to restore purchases: \(error.localizedDescription)")
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
}

enum StoreError: Error {
    case failedVerification
}

// Extension for convenience methods
extension SubscriptionManager {
    func purchase() async {
        if let product = products.first {
            do {
                try await purchaseSubscription(product: product)
            } catch {
                print("Failed to purchase: \(error.localizedDescription)")
            }
        }
    }
    
    func restore() async {
        await restorePurchases()
    }
}
