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
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("5 DAYS FREE \nTRIAL")
                .font(.system(size: 45, weight: .heavy, design: .rounded))
                .foregroundColor(.blue)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("Cancel anytime before your trial ends")
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
