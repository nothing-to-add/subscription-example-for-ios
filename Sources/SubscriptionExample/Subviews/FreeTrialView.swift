//
//  File name: FreeTrialView.swift
//  Project name: subscriptionexample
//  Workspace name: subscriptionexample
//
//  Created by: nothing-to-add on 22/05/2025
//  Using Swift 6.0
//  Copyright (c) 2023 nothing-to-add
//

import SwiftUI

struct FreeTrialView: View {
    @Environment(\.locale) var locale
    
    init() {}
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(C.Text.FreeTrial.title.localizedStringPackage)
                .font(.system(size: 45, weight: .heavy))
                .foregroundColor(.blue)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(C.Text.FreeTrial.subtitle.localizedPackage)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.secondary)
        }
        .padding(10)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// Preview for German locale
struct FreeTrialView_Previews_DE: PreviewProvider {
    static var previews: some View {
        FreeTrialView()
            .environment(\.locale, .init(identifier: "de"))
            .previewDisplayName("German")
    }
}

// Preview for English locale
struct FreeTrialView_Previews_EN: PreviewProvider {
    static var previews: some View {
        FreeTrialView()
            .environment(\.locale, .init(identifier: "en"))
            .previewDisplayName("English")
    }
}
