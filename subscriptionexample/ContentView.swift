//
//  File name: ContentView.swift
//  Project name: subscriptionexample
//  Workspace name: Untitled 1
//
//  Created by: nothing-to-add on 01/04/2025
//  Using Swift 6.0
//  Copyright (c) 2023 nothing-to-add
//

import SwiftUI
import StoreKit

struct ContentView: View {
    var body: some View {
        VStack {
            SubscriptionView()
        }
        .padding()
    }
}

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
                    subscriptionManager.purchaseSubscription()
                }) {
                    Text("Subscribe Now")
                        .font(.headline)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                Button(action: {
                    subscriptionManager.restorePurchases()
                }) {
                    Text("Restore Purchases")
                        .font(.subheadline)
                        .padding()
                }
            }
        }
        .onAppear {
            subscriptionManager.fetchProducts()
        }
    }
}

#Preview {
    ContentView()
}

#Preview {
    SubscriptionView()
}
