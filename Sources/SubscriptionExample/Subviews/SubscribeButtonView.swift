// SubscribeButtonView.swift
// Button for purchasing subscriptions

import SwiftUI
import StoreKit

public struct SubscribeButtonView: View {
    @ObservedObject var subscriptionManager: SubscriptionManager
    @State private var purchaseInProgress = false
    @Binding var selectedProduct: Product?
    @Binding var selectedMockProduct: MockProduct?
    @Binding var errorMessage: String?
    
    public init(subscriptionManager: SubscriptionManager, 
         selectedProduct: Binding<Product?>,
         selectedMockProduct: Binding<MockProduct?>,
         errorMessage: Binding<String?>) {
        self.subscriptionManager = subscriptionManager
        self._selectedProduct = selectedProduct
        self._selectedMockProduct = selectedMockProduct
        self._errorMessage = errorMessage
    }
    
    public var body: some View {
        Button(action: {
            Task {
                await purchaseSelectedProduct()
            }
        }) {
            if purchaseInProgress {
                ProgressView()
                    .tint(.white)
                    .frame(height: 20)
            } else {
                Text(C.Text.SubscribeButton.title.localized())
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(.white) // Ensuring white text for better contrast
            }
        }
        .disabled((selectedProduct == nil && selectedMockProduct == nil) || purchaseInProgress)
        .padding()
        .frame(height: 50)
        .frame(maxWidth: .infinity)
        .background(
            (selectedProduct == nil && selectedMockProduct == nil) || purchaseInProgress ?
                LinearGradient(gradient: Gradient(colors: [Color.gray, Color.gray.opacity(0.7)]), startPoint: .leading, endPoint: .trailing) :
                LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing)
        )
        .cornerRadius(15)
        .shadow(color: (selectedProduct == nil && selectedMockProduct == nil) || purchaseInProgress ? Color.clear : Color.black.opacity(0.25), radius: 5, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.white.opacity(0.3), lineWidth: 1)
        )
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
