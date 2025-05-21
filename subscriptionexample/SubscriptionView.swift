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
        GeometryReader { geo in
            ZStack {
                backgroundGradient
                
                VStack(spacing: 10) {
                    
                    if subscriptionManager.isSubscribed {
                        successView
                    } else {
                        // Main content with spacing adjusted to fill screen
                        VStack(spacing: 16) {
                            // Header - integrated with premium visual element
                            headerView
                            
                            // Free trial - prominent
                            freeTrialView
                            
                            // Products - compact
                            productsView
                            
                            // Bottom area
                            VStack(spacing: 12) {
                                // Subscribe button with improved text contrast
                                subscribeButton
                                
                                // Error message if present
                                if let error = errorMessage {
                                    Text(error)
                                        .font(.system(size: 12, design: .rounded))
                                        .foregroundColor(.red)
                                }
                                
                                // Footer elements
                                VStack(spacing: 16) {
                                    // Restore purchases
                                    restoreButton
                                    
                                    // Terms & Privacy - minimal
                                    Text("Terms & Privacy")
                                        .font(.system(size: 12, weight: .medium, design: .rounded))
                                        .foregroundColor(.blue)
                                        .underline()
                                }
                                .padding(.top, 5)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)
                        .padding(.bottom, 25)
                    }
                }
                .frame(width: geo.size.width, height: geo.size.height)
            }
        }
    }
    
    private var backgroundGradient: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color(.systemGray2).opacity(0.8),
                                        Color(.systemGray6)]),
            startPoint: .topTrailing,
            endPoint: .bottomLeading
        )
        .ignoresSafeArea()
    }
    
    private var successView: some View {
        VStack(spacing: 20) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 60))
                .foregroundColor(.green)
                .padding()
            
            Text("Thank you for subscribing!")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .multilineTextAlignment(.center)
            
            Text("Enjoy full access to all premium features")
                .font(.system(size: 16, weight: .regular, design: .rounded))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding()
        .frame(maxWidth: .infinity)
    }
    
    private var headerView: some View {
        Text("Premium Access")
            .font(.system(size: 24, weight: .bold, design: .rounded))
    }
    
    private var freeTrialView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("5 DAYS FREE \nTRIAL")
                .font(.system(size: 45, weight: .heavy, design: .rounded))
                .foregroundColor(.blue)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("Cancel anytime before your trial ends")
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundColor(.secondary)
//                .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .background(
//            RoundedRectangle(cornerRadius: 16)
//                .fill(Color.blue.opacity(0.1))
//                .overlay(
//                    RoundedRectangle(cornerRadius: 16)
//                        .stroke(Color.blue.opacity(0.3), lineWidth: 1)
//                )
//        )
    }
    
    @ViewBuilder
    private var productsView: some View {
        VStack(alignment: .center, spacing: 8) {
            Text("Choose Your Plan")
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .padding(.leading, 4)
            
            if !subscriptionManager.mockProducts.isEmpty {
                mockProductsView
            } else
            if !subscriptionManager.products.isEmpty {
                availableProductsView
            } else if !subscriptionManager.isSubscribed {
                ProgressView("Loading plans...")
                    .font(.system(size: 14, design: .rounded))
                    .padding()
            }
        }
    }
    
    @ViewBuilder
    private var mockProductsView: some View {
        VStack(spacing: 10) {
//        LazyVGriD(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
            ForEach(subscriptionManager.mockProducts) { product in
                ProductRowView(
                    name: product.displayName,
                    description: product.description,
                    price: product.displayPrice,
                    periodText: product.period,
                    isSelected: selectedMockProduct?.id == product.id,
                    monthlyPrice: calculateMonthlyPrice(price: product.displayPrice, period: product.period)
                )
                .onTapGesture {
                    withAnimation(.spring(response: 0.2, dampingFraction: 0.7)) {
                        selectedMockProduct = product
                        selectedProduct = nil
                    }
                }
            }
        }
        .onAppear {
            if let product = subscriptionManager.mockProducts.first {
                selectedMockProduct = product
                selectedProduct = nil
            }
        }
    }
    
    @ViewBuilder
    private var availableProductsView: some View {
        VStack(spacing: 10) {
//        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
            ForEach(subscriptionManager.products, id: \.id) { product in
                let subscriptionPeriodType = product.subscription?.subscriptionPeriod.unit
                let periodText = formatPeriod(for: subscriptionPeriodType)
                
                ProductRowView(
                    name: product.displayName,
                    description: product.description,
                    price: product.displayPrice,
                    periodText: periodText,
                    isSelected: selectedProduct?.id == product.id,
                    monthlyPrice: calculateMonthlyPrice(product: product)
                )
                .onTapGesture {
                    withAnimation(.spring(response: 0.2, dampingFraction: 0.7)) {
                        selectedProduct = product
                        selectedMockProduct = nil
                    }
                }
            }
        }
        .onAppear {
            if let product = subscriptionManager.products.first {
                selectedProduct = product
                selectedMockProduct = nil
            }
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
                    .tint(.white)
                    .frame(height: 20)
            } else {
                Text("SUBSCRIBE NOW")
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
    
    private var restoreButton: some View {
        Button(action: {
            Task {
                await subscriptionManager.restore()
            }
        }) {
            Text("Restore Purchases")
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundColor(.secondary)
        }
    }
    
    private func calculateMonthlyPrice(product: Product) -> String? {
        guard let subscription = product.subscription else { return nil }
        
        let priceDecimal = product.price
        let period = subscription.subscriptionPeriod
        
        switch period.unit {
        case .day:
            // Calculate monthly price (price * 30 days)
            let monthlyPrice = priceDecimal * Decimal(30) / Decimal(period.value)
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.locale = product.priceFormatStyle.locale
            if let formattedPrice = formatter.string(from: monthlyPrice as NSDecimalNumber) {
                return "\(formattedPrice) /month"
            }
            
        case .week:
            // Calculate monthly price (price * 4 weeks)
            let monthlyPrice = priceDecimal * Decimal(4) / Decimal(period.value)
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.locale = product.priceFormatStyle.locale
            if let formattedPrice = formatter.string(from: monthlyPrice as NSDecimalNumber) {
                return "\(formattedPrice) /month"
            }
            
        case .month:
            if period.value == 1 {
                return nil // Already monthly
            } else {
                let monthlyPrice = priceDecimal / Decimal(period.value)
                let formatter = NumberFormatter()
                formatter.numberStyle = .currency
                formatter.locale = product.priceFormatStyle.locale
                if let formattedPrice = formatter.string(from: monthlyPrice as NSDecimalNumber) {
                    return "\(formattedPrice) /month"
                }
            }
            
        case .year:
            // Calculate monthly price (price / 12 months)
            let monthlyPrice = priceDecimal / Decimal(12 * period.value)
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.locale = product.priceFormatStyle.locale
            if let formattedPrice = formatter.string(from: monthlyPrice as NSDecimalNumber) {
                return "\(formattedPrice) /month"
            }
            
        default:
            return nil
        }
        
        return nil
    }
    
    // Calculate monthly price for mock products
    private func calculateMonthlyPrice(price: String, period: String?) -> String? {
        guard let period = period?.lowercased() else { return nil }
        
        // Extract numeric value from price string (e.g., "$9.99" -> 9.99)
        let priceString = price.replacingOccurrences(of: "$", with: "")
        guard let priceValue = Double(priceString) else { return nil }
        
        if period.contains("week") {
            // Weekly to monthly: price * 4
            let monthlyPrice = priceValue * 4
            return String(format: "$%.2f /month", monthlyPrice)
        } else if period.contains("year") || period.contains("annual") {
            // Yearly to monthly: price / 12
            let monthlyPrice = priceValue / 12
            return String(format: "$%.2f /month", monthlyPrice)
        } else if period.contains("month") {
            // Already monthly
            return nil
        }
        
        return nil
    }
    
    private func formatPeriod(for unit: Product.SubscriptionPeriod.Unit?) -> String? {
        guard let unit = unit else { return nil }
        
        switch unit {
        case .day:
            return "Daily"
        case .week:
            return "Weekly"
        case .month:
            return "Monthly"
        case .year:
            return "Yearly"
        @unknown default:
            return nil
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

// Color extension to use hex values
extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 8) & 0xff) / 255,
            blue: Double(hex & 0xff) / 255,
            opacity: alpha
        )
    }
}

#Preview {
    SubscriptionView()
}
