//
//  File name: SuccessView.swift
//  Project name: subscriptionexample
//  Workspace name: subscriptionexample
//
//  Created by: nothing-to-add on 22/05/2025
//  Using Swift 6.0
//  Copyright (c) 2023 nothing-to-add
//

import SwiftUI

struct SuccessView: View {
    init() {}
    
    var body: some View {
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

// Preview provider remains accessible from within the module
#Preview {
    SuccessView()
}
