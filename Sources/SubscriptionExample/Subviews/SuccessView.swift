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
            
            Text(C.Text.SuccessView.title.localizedPackage)
                .font(.system(size: 24, weight: .bold))
                .multilineTextAlignment(.center)
            
            Text(C.Text.SuccessView.subtitle.localizedPackage)
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding()
        .frame(maxWidth: .infinity)
    }
}

// Preview provider remains accessible from within the module
struct SuccessView_Previews_DE: PreviewProvider {
    static var previews: some View {
        SuccessView()
            .environment(\.locale, .init(identifier: "de"))
            .previewDisplayName("German")
    }
}

// Preview for English locale
struct SuccessView_Previews_EN: PreviewProvider {
    static var previews: some View {
        SuccessView()
            .environment(\.locale, .init(identifier: "en"))
            .previewDisplayName("English")
    }
}
