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

struct RestoreButtonView: View {
    @ObservedObject var subscriptionManager: SubscriptionManager
    
    init(subscriptionManager: SubscriptionManager) {
        self.subscriptionManager = subscriptionManager
    }
    
    var body: some View {
        Button(action: {
            Task {
                await subscriptionManager.restore()
            }
        }) {
            if case .purchasing = subscriptionManager.purchaseState {
                ProgressView()
                    .frame(height: 20)
                    .tint(.secondary)
            } else {
                Text(C.Text.ReRestoreButton.title.localized())
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(.secondary)
            }
        }
        .disabled(subscriptionManager.purchaseState == .purchasing)
    }
}

// Preview provider remains accessible from within the module
#Preview {
    RestoreButtonView(subscriptionManager: SubscriptionManager())
}
