//
//  File name: StringExtensions.swift
//  Project name: SubscriptionExample
//  Workspace name: subscription-example-for-ios
//
//  Created by: nothing-to-add on 27/05/2025
//  Using Swift 6.0
//  Copyright (c) 2023 nothing-to-add
//

import Foundation
import SwiftUI

extension String {
    // Use this when you need a String (for UIKit or other APIs that don't support LocalizedStringKey)
    var localizedPackage: String {
        // Using NSLocalizedString for legacy .strings files
        self.toLocalizedForPackage(bundle: .module)
    }
    
    // Handle newline escape sequences
    var localizedStringPackage: String {
        self.localizedPackage.replacingOccurrences(of: "\\n", with: "\n")
    }
}
