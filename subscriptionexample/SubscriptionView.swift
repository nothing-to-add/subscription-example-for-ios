//
//  File name: SubscriptionView.swift
//  Project name: subscriptionexample
//  Workspace name: subscriptionexample
//
//  Created by: nothing-to-add on 21/05/2025
//  Using Swift 6.0
//  Copyright (c) 2023 nothing-to-add
//

import SwiftUI
import StoreKit

struct SubscriptionView: View {
    @StateObject private var subscriptionManager = SubscriptionManager()
    @State private var selectedProduct: Product?
    @State private var selectedMockProduct: MockProduct?
    @State private var purchaseInProgress = false
    @State private var errorMessage: String? = nil

    var body: some View {
        VStack {
            if subscriptionManager.isSubscribed {
                Text("Thank you for subscribing!")
                    .font(.title)
                    .padding()
            } else {
                Text("Subscribe to unlock premium features")
                    .font(.title2)
                    .padding()

                // Display mock products if available
                if !subscriptionManager.mockProducts.isEmpty {
                    mockProductsView
                }
                // Display real products if available
                else if !subscriptionManager.products.isEmpty {
                    availableProductsView
                }
                
                subscribeButton
                
                // Error message if present
                if let error = errorMessage {
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding(.top, 4)
                }

                restoreButton
                
                // Display loading indicator while fetching products
                if subscriptionManager.products.isEmpty && subscriptionManager.mockProducts.isEmpty && !subscriptionManager.isSubscribed {
                    ProgressView("Loading products...")
                        .padding()
                }
            }
        }
    }
    
    private var restoreButton: some View {
        Button(action: {
            Task {
                await subscriptionManager.restore()
            }
        }) {
            Text("Restore Purchases")
                .font(.subheadline)
                .padding()
        }
    }
    
    private var subscribeButton: some View {
        Button(action: {
            Task {
                await purchaseSelectedProduct()
            }
        }) {
            if purchaseInProgress {
                ProgressView()
                    .tint(Color.white)
            } else {
                Text("Subscribe Now")
                    .font(.headline)
            }
        }
        .disabled((selectedProduct == nil && selectedMockProduct == nil) || purchaseInProgress)
        .padding()
        .frame(maxWidth: .infinity)
        .background((selectedProduct == nil && selectedMockProduct == nil) || purchaseInProgress ? Color.gray : Color.blue)
        .foregroundColor(.white)
        .cornerRadius(10)
        .padding(.horizontal)
        .padding(.top, 10)
    }
    
    @ViewBuilder
    private var mockProductsView: some View {
        Text("Available Plans:")
            .font(.headline)
            .padding(.top)
        
        ForEach(subscriptionManager.mockProducts) { product in
            ProductRowView(
                name: product.displayName,
                description: product.description,
                price: product.displayPrice,
                periodText: product.period.map { "Billed \($0)" },
                isSelected: selectedMockProduct?.id == product.id
            )
            .onTapGesture {
                selectedMockProduct = product
                selectedProduct = nil
            }
        }
    }
    
    @ViewBuilder
    private var availableProductsView: some View {
        Text("Available Plans:")
            .font(.headline)
            .padding(.top)
        
        ForEach(subscriptionManager.products, id: \.id) { product in
            ProductRowView(
                name: product.displayName,
                description: product.description,
                price: product.displayPrice,
                periodText: product.subscription?.subscriptionPeriod.value.description,
                isSelected: selectedProduct?.id == product.id
            )
            .onTapGesture {
                selectedProduct = product
                selectedMockProduct = nil
            }
        }
    }
    
    private func purchaseSelectedProduct() async {
        purchaseInProgress = true
        errorMessage = nil
        
        defer { purchaseInProgress = false }
        
        // Handle mock products
        if selectedMockProduct != nil {
            // Simulate purchase with mock data
            try? await Task.sleep(nanoseconds: 2 * 1_000_000_000) // 2 second delay to simulate network request
            
            // For demo purposes, automatically succeed with mock products
            subscriptionManager.isSubscribed = true
            return
        }
        
        // Handle real products
        if let product = selectedProduct {
            do {
                try await subscriptionManager.purchaseSubscription(product: product)
            } catch {
                errorMessage = "Purchase failed: \(error.localizedDescription)"
            }
        }
    }
}

#Preview {
    SubscriptionView()
}
