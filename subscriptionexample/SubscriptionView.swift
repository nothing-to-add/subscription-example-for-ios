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

struct SubscriptionView: View {
    @StateObject private var subscriptionManager = SubscriptionManager()

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

                Button(action: {
                    Task {
                        await subscriptionManager.purchase()
                    }
                }) {
                    Text("Subscribe Now")
                        .font(.headline)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                Button(action: {
                    Task {
                        await subscriptionManager.restore()
                    }
                }) {
                    Text("Restore Purchases")
                        .font(.subheadline)
                        .padding()
                }
                
                if !subscriptionManager.products.isEmpty {
                    Text("Available Products:")
                        .font(.headline)
                        .padding(.top)
                    
                    ForEach(subscriptionManager.products, id: \.id) { product in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(product.displayName)
                                    .font(.subheadline)
                                    .bold()
                                Text(product.description)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Text(product.displayPrice)
                                .font(.headline)
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                        .padding(.horizontal)
                        .onTapGesture {
                            Task {
                                try? await subscriptionManager.purchaseSubscription(product: product)
                            }
                        }
                    }
                }
            }
            
            // Display loading indicator while fetching products
            if subscriptionManager.products.isEmpty && !subscriptionManager.isSubscribed {
                ProgressView("Loading products...")
                    .padding()
            }
        }
        .onAppear {
            Task {
                await subscriptionManager.fetchProducts()
            }
        }
    }
}

#Preview {
    SubscriptionView()
}
