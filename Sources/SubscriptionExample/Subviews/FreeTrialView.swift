// FreeTrialView.swift
// Free trial promotional view

import SwiftUI

public struct FreeTrialView: View {
    public init() {}
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(C.Text.FreeTrial.title.localized().toLocalizedString())
                .font(.system(size: 45, weight: .heavy, design: .rounded))
                .foregroundColor(.blue)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(C.Text.FreeTrial.subtitle.localized())
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundColor(.secondary)
        }
        .padding(10)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    FreeTrialView()
}
