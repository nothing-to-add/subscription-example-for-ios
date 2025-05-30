//
//  File name: Constants.swift
//  Project name: subscriptionexample
//  Workspace name: subscriptionexample
//
//  Created by: nothing-to-add on 23/05/2025
//  Using Swift 6.0
//  Copyright (c) 2023 nothing-to-add
//

import Foundation

public struct C {
    
    public struct Text {
        
        public struct FreeTrial {
            public static let title = "Free Trial Title %@"
            public static let subtitle = "Free Trial Subtitle"
        }
        
        public struct ReRestoreButton {
            public static let title = "Restore Purchases Button Title"
        }
        
        public struct SubscribeButton {
            public static let title = "Subscribe Button Title"
        }
        
        public struct SuccessView {
            public static let title = "Success View Title"
            public static let subtitle = "Success View Subtitle"
        }
        
        public struct SubscriptionView {
            public static let title = "Subscription View Title"
            public static let productsTitle = "Subscription View Products Title"
            public static let loadingText = "Subscription View Loading Text"
            public static let termsTitle = "Subscription View Terms Title"
            public static let monthlyPriceText = "Subscription View Monthly Price Text"
        }
    }
    
    public struct Image {
        
        public static let successLogo = "checkmark.circle.fill"
    }
}
