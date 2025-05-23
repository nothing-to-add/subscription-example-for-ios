// SuccessView.swift
// Success view shown after successful subscription

import SwiftUI

public struct SuccessView: View {
    public init() {}
    
    public var body: some View {
        VStack(spacing: 20) {
            Image(systemName: C.Image.successLogo)
                .font(.system(size: 60))
                .foregroundColor(.green)
                .padding()
            
            Text(C.Text.SuccessView.title.localized().toLocalizedString())
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .multilineTextAlignment(.center)
            
            Text(C.Text.SuccessView.subtitle.localized())
                .font(.system(size: 16, weight: .regular, design: .rounded))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding()
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    SuccessView()
}
