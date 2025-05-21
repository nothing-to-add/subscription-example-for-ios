//
//  File name: RestoreButtonView.swift
//  Project name: subscriptionexample
//  Workspace name: subscriptionexample
//
//  Created by: nothing-to-add on 22/05/2025
//  Using Swift 6.0
//  Copyright (c) 2023 nothing-to-add
//

import SwiftUI

struct RestoreButtonView: View {
    @ObservedObject var subscriptionManager: SubscriptionManager
    
    var body: some View {
        Button(action: {
            Task {
                await subscriptionManager.restore()
            }
        }) {
            Text("Restore Purchases")
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    RestoreButtonView(subscriptionManager: SubscriptionManager())
}
