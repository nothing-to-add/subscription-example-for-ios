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

// Use the same button style as in SubscribeButtonView for consistency
private struct RestoreButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .contentShape(Rectangle())
    }
}

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
                Text(C.Text.ReRestoreButton.title.localizedPackage)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.secondary)
            }
        }
        .buttonStyle(RestoreButtonStyle())
        .disabled(subscriptionManager.purchaseState == .purchasing)
    }
}

// Preview provider remains accessible from within the module
// Preview for German locale
struct RestoreButtonView_Previews_DE: PreviewProvider {
    static var previews: some View {
        RestoreButtonView(subscriptionManager: SubscriptionManager())
            .environment(\.locale, .init(identifier: "de"))
            .previewDisplayName("German")
    }
}

// Preview for English locale
struct RestoreButtonView_Previews_EN: PreviewProvider {
    static var previews: some View {
        RestoreButtonView(subscriptionManager: SubscriptionManager())
            .environment(\.locale, .init(identifier: "en"))
            .previewDisplayName("English")
    }
}
