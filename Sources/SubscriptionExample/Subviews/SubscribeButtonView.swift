//
//  File name: SubscribeButtonView.swift
//  Project name: subscriptionexample
//  Workspace name: subscriptionexample
//
//  Created by: nothing-to-add on 22/05/2025
//  Using Swift 6.0
//  Copyright (c) 2023 nothing-to-add
//

import SwiftUI
import StoreKit

// Custom button style to ensure consistent appearance across platforms
struct SubscriptionButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .contentShape(Rectangle()) // Ensures the entire area is tappable
    }
}

struct SubscribeButtonView: View {
    @ObservedObject var subscriptionManager: SubscriptionManager
    @Binding var selectedProduct: Product?
    @Binding var selectedMockProduct: MockProduct?
    @Binding var errorMessage: String?
    
    init(subscriptionManager: SubscriptionManager, 
         selectedProduct: Binding<Product?>,
         selectedMockProduct: Binding<MockProduct?>,
         errorMessage: Binding<String?>) {
        self.subscriptionManager = subscriptionManager
        self._selectedProduct = selectedProduct
        self._selectedMockProduct = selectedMockProduct
        self._errorMessage = errorMessage
    }
    
    var body: some View {
        Button(action: {
            Task {
                await purchaseSelectedProduct()
            }
        }) {
            if case .purchasing = subscriptionManager.purchaseState {
                ProgressView()
                    .tint(.white)
                    .frame(height: 20)
            } else {
                Text(C.Text.SubscribeButton.title.localizedPackage)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white) // Ensuring white text for better contrast
            }
        }
        .buttonStyle(SubscriptionButtonStyle()) // Use custom button style
        .disabled((selectedProduct == nil && selectedMockProduct == nil) || 
                 subscriptionManager.purchaseState == .purchasing)
        .padding()
        .frame(height: 50)
        .frame(maxWidth: .infinity)
        .background(
            Group {
                if (selectedProduct == nil && selectedMockProduct == nil) || 
                    subscriptionManager.purchaseState == .purchasing {
                    LinearGradient(
                        gradient: Gradient(colors: [Color.gray, Color.gray.opacity(0.7)]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                } else {
                    LinearGradient(
                        gradient: Gradient(colors: [Color.blue, Color.purple]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                }
            }
            .cornerRadius(15)
        )
        .cornerRadius(15)
        .shadow(color: (selectedProduct == nil && selectedMockProduct == nil) || 
               subscriptionManager.purchaseState == .purchasing ? 
               Color.clear : Color.black.opacity(0.25), radius: 5, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.white.opacity(0.3), lineWidth: 1)
        )
        .onChange(of: subscriptionManager.purchaseState) { state in
            if case .failed(let message) = state {
                errorMessage = message
            } else if case .pendingApproval = state {
                errorMessage = state.message
            } else if case .cancelled = state {
                errorMessage = nil
                // Reset purchase state after a short delay
                Task { @MainActor in
                    try? await Task.sleep(for: .seconds(1.5))
                    subscriptionManager.resetPurchaseState()
                }
            } else {
                errorMessage = nil
            }
        }
    }
    
    private func purchaseSelectedProduct() async {
        // Always reset any previous error state
        errorMessage = nil
        
        // Handle mock products
        if selectedMockProduct != nil {
            await subscriptionManager.purchase()
            return
        }
        
        // Handle real products
        if let product = selectedProduct {
            do {
                try await subscriptionManager.purchaseSubscription(product: product)
            } catch {
                // The error handling is now done through the purchaseState
                // in the onChange handler above
            }
        }
    }
}

// Preview provider remains accessible from within the module
#Preview {
    SubscribeButtonView(
        subscriptionManager: SubscriptionManager(),
        selectedProduct: .constant(nil),
        selectedMockProduct: .constant(MockProduct(
            id: "mock.product",
            displayName: "Test Product",
            description: "Test Product Description",
            displayPrice: "$9.99",
            subscription: true,
            period: "Monthly"
        )),
        errorMessage: .constant(nil)
    )
    .padding()
}
