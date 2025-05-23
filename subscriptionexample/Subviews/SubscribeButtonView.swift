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
import CustomExtensions

struct SubscribeButtonView: View {
    @ObservedObject var subscriptionManager: SubscriptionManager
    @State private var purchaseInProgress = false
    @Binding var selectedProduct: Product?
    @Binding var selectedMockProduct: MockProduct?
//    @State private var purchaseInProgress = false
    @Binding var errorMessage: String?
    
    var body: some View {
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
                LinearGradient(gradient: Gradient(colors: [Color(hex: 0x3366FF), Color(hex: 0x6633CC)]), startPoint: .leading, endPoint: .trailing)
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

//#Preview {
//    SubscribeButtonView(subscriptionManager: SubscriptionManager(), selectedProduct: nil, selectedMockProduct: nil, errorMessage: nil)
//}
