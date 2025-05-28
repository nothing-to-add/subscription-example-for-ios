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

public struct SubscriptionView: View {
    @StateObject private var subscriptionManager: SubscriptionManager
    @State private var selectedProduct: Product?
    @State private var selectedMockProduct: MockProduct?
    @State private var errorMessage: String? = nil
    
    /// Initialize the SubscriptionView with configuration options
    /// - Parameters:
    ///   - useMockData: When true, mock products will be displayed instead of real App Store products
    ///   - productIdentifiers: Array of product identifiers registered in App Store Connect
    public init(useMockData: Bool = true, productIdentifiers: [String]? = nil) {
        // Need to use _subscriptionManager because @StateObject can't be initialized directly in init
        self._subscriptionManager = StateObject(
            wrappedValue: SubscriptionManager(
                useMockData: useMockData,
                productIdentifiers: productIdentifiers ?? SubscriptionExample.productIdentifiers
            )
        )
    }

    public var body: some View {
        GeometryReader { geo in
            ZStack {
                backgroundGradient
                
                VStack(spacing: 10) {
                    
                    if subscriptionManager.isSubscribed {
                        SuccessView()
                    } else {
                        // Main content with spacing adjusted to fill screen
                        VStack(spacing: 16) {
                            // Header - integrated with premium visual element
                            headerView
                            
                            // Free trial - prominent
                            FreeTrialView()
                            
                            // Products - compact
                            productsView
                            
                            // Bottom area
                            bottomView
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
            gradient: Gradient(colors: [Color.gray.opacity(0.8),
                                        Color.gray.opacity(0.2)]),
            startPoint: .topTrailing,
            endPoint: .bottomLeading
        )
        .ignoresSafeArea()
    }
    
    private var headerView: some View {
        Text(C.Text.SubscriptionView.title.localizedPackage)
            .font(.system(size: 24, weight: .bold, design: .rounded))
    }
    
    @ViewBuilder
    private var productsView: some View {
        VStack(alignment: .center, spacing: 8) {
            Text(C.Text.SubscriptionView.productsTitle.localizedPackage)
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .padding(.leading, 4)
            
            if !subscriptionManager.mockProducts.isEmpty {
                mockProductsView
            } else
            if !subscriptionManager.products.isEmpty {
                availableProductsView
            } else if !subscriptionManager.isSubscribed {
                ProgressView(C.Text.SubscriptionView.loadingText.localizedPackage)
                    .font(.system(size: 14, design: .rounded))
                    .padding()
            }
        }
    }
    
    @ViewBuilder
    private var mockProductsView: some View {
        VStack(spacing: 10) {
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
    
    private var footer: some View {
        VStack(spacing: 16) {
            // Restore purchases
            RestoreButtonView(subscriptionManager: subscriptionManager)
            
            // Terms & Privacy - minimal
            Text(C.Text.SubscriptionView.termsTitle.localizedPackage)
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundColor(.blue)
                .underline()
        }
        .padding(.top, 5)
    }
    
    private var bottomView: some View {
        VStack(spacing: 12) {
            // Subscribe button with improved text contrast
            SubscribeButtonView(subscriptionManager: subscriptionManager,
                                selectedProduct: $selectedProduct,
                                selectedMockProduct: $selectedMockProduct,
                                errorMessage: $errorMessage)
            
            // Error message if present
            if let error = errorMessage {
                Text(error)
                    .font(.system(size: 14, design: .rounded))
                    .foregroundColor(.red)
            }
            
            // Footer elements
            footer
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
            return formatMonthlyPrice(monthlyPrice, for: product)
            
        case .week:
            // Calculate monthly price (price * 4 weeks)
            let monthlyPrice = priceDecimal * Decimal(4) / Decimal(period.value)
            return formatMonthlyPrice(monthlyPrice, for: product)
            
        case .month:
            if period.value == 1 {
                return nil // Already monthly
            } else {
                let monthlyPrice = priceDecimal / Decimal(period.value)
                return formatMonthlyPrice(monthlyPrice, for: product)
            }
            
        case .year:
            // Calculate monthly price (price / 12 months)
            let monthlyPrice = priceDecimal / Decimal(12 * period.value)
            return formatMonthlyPrice(monthlyPrice, for: product)
            
        default:
            return nil
        }
    }
    
    private func formatMonthlyPrice(_ monthlyPrice: Decimal, for product: Product) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = product.priceFormatStyle.locale
        if let formattedPrice = formatter.string(from: monthlyPrice as NSDecimalNumber) {
            return String(format: C.Text.SubscriptionView.monthlyPriceText.localizedPackage, formattedPrice)
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
            return String(format: C.Text.SubscriptionView.monthlyPriceText.localizedPackage, String(format: "$%.2f", monthlyPrice))
        } else if period.contains("year") || period.contains("annual") {
            // Yearly to monthly: price / 12
            let monthlyPrice = priceValue / 12
            return String(format: C.Text.SubscriptionView.monthlyPriceText.localizedPackage, String(format: "$%.2f", monthlyPrice))
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
}

#Preview {
    SubscriptionView()
        .environment(\.locale, .init(identifier: "de"))
}

