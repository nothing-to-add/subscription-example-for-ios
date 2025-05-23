// RestoreButtonView.swift
// Button for restoring previous purchases

import SwiftUI

public struct RestoreButtonView: View {
    @ObservedObject var subscriptionManager: SubscriptionManager
    
    public init(subscriptionManager: SubscriptionManager) {
        self.subscriptionManager = subscriptionManager
    }
    
    public var body: some View {
        Button(action: {
            Task {
                await subscriptionManager.restore()
            }
        }) {
            Text(C.Text.ReRestoreButton.title.localized())
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    RestoreButtonView(subscriptionManager: SubscriptionManager())
}
