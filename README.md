# SubscriptionExample

[![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)](https://swift.org)
[![iOS](https://img.shields.io/badge/iOS-16.0%2B-blue.svg)](https://developer.apple.com/ios/)
[![macOS](https://img.shields.io/badge/macOS-13.0%2B-blue.svg)](https://developer.apple.com/macos/)
[![watchOS](https://img.shields.io/badge/watchOS-9.0%2B-blue.svg)](https://developer.apple.com/watchos/)
[![visionOS](https://img.shields.io/badge/visionOS-1.0%2B-blue.svg)](https://developer.apple.com/visionos/)
[![GitHub tag](https://img.shields.io/github/v/tag/nothing-to-add/subscription-example-for-ios)](https://github.com/nothing-to-add/subscription-example-for-ios/tags)
[![GitHub stars](https://img.shields.io/github/stars/nothing-to-add/subscription-example-for-ios)](https://github.com/nothing-to-add/subscription-example-for-ios/stargazers)
[![GitHub issues](https://img.shields.io/github/issues/nothing-to-add/subscription-example-for-ios)](https://github.com/nothing-to-add/subscription-example-for-ios/issues)
[![GitHub contributors](https://img.shields.io/github/contributors/nothing-to-add/subscription-example-for-ios)](https://github.com/nothing-to-add/subscription-example-for-ios/graphs/contributors)
[![GitHub commit activity](https://img.shields.io/github/commit-activity/m/nothing-to-add/subscription-example-for-ios)](https://github.com/nothing-to-add/subscription-example-for-ios/commits/main)
[![GitHub top language](https://img.shields.io/github/languages/top/nothing-to-add/subscription-example-for-ios)](https://github.com/nothing-to-add/subscription-example-for-ios)
[![License](https://img.shields.io/github/license/nothing-to-add/subscription-example-for-ios)](https://github.com/nothing-to-add/subscription-example-for-ios/blob/main/LICENSE)

A Swift Package for implementing in-app subscriptions in iOS applications.

## Features

- Complete subscription management
- Ready-to-use subscription UI components
- Mock product support for testing
- StoreKit 2 integration
- Localization support
- Integration with CustomExtensions for String localization
- Clean public API with a single entry point

## Installation

### Swift Package Manager

#### Using Xcode:
1. In Xcode, go to File > Add Packages...
2. Enter the repository URL: `https://github.com/yourusername/subscription-example-for-ios.git`
3. Select the version you want to use and click "Add Package"

#### Using Package.swift:
```swift
dependencies: [
    .package(url: "https://github.com/yourusername/subscription-example-for-ios.git", from: "1.0.0")
]
```

The package automatically includes the required dependency:
- [swift-custom-extensions](https://github.com/nothing-to-add/swift-custom-extensions) (version 1.0.2+)

## Usage

```swift
import SwiftUI
import SubscriptionExample

struct ContentView: View {
    var body: some View {
        // Initialize the package with your product identifiers
        SubscriptionExample.initialize(
            debugMode: true,
            productIdentifiers: [
                "com.yourcompany.yourapp.monthly",
                "com.yourcompany.yourapp.yearly"
            ]
        )
        
        // Use the subscription view
        return SubscriptionView(useMockData: true)
    }
}
```

### Localization

The package includes built-in localizations. Constants are defined in `C.Text` and can be used with the localization extensions:

```swift
// In your SwiftUI views:
Text(C.Text.FreeTrial.title.localized())  // Use LocalizedStringKey for SwiftUI
Text(C.Text.FreeTrial.title.localized().toLocalizedString())  // Convert to String
```

### Example App

A complete example app is included in the `/Examples/DemoApp` directory showing how to integrate the package:

```swift
import SwiftUI
import SubscriptionExample

struct ContentView: View {
    @State private var showSubscriptionView = false
    
    var body: some View {
        Button("Show Subscription View") {
            showSubscriptionView = true
        }
        .fullScreenCover(isPresented: $showSubscriptionView) {
            SubscriptionView(useMockData: true)
        }
    }
}
```

See [Examples/DemoApp/README.md](Examples/DemoApp/README.md) for instructions on running the demo app.

## API Design

This package follows a clean modular design with minimal public API surface:

- `SubscriptionView` - The main view component that integrates all subscription functionality
- `SubscriptionExample` - Global configuration for the package
- `SubscriptionManager` - Manager class for handling purchases (usually used internally)
- `MockProduct` - Model for representing products during development

All internal components and subviews are encapsulated within the package, providing a clean, easy-to-use public interface while maintaining flexibility.

## Advanced Usage

### Configuring In-App Purchases

To configure your app's product identifiers, pass them when initializing the package:

```swift
// Initialize with your App Store Connect product identifiers
SubscriptionExample.initialize(
    debugMode: true,
    productIdentifiers: [
        "com.yourcompany.yourapp.monthly",
        "com.yourcompany.yourapp.yearly",
        "com.yourcompany.yourapp.lifetime"
    ]
)
```

These identifiers must match exactly what you've configured in App Store Connect.

### Testing with Mock Data

During development, you can use mock products instead of real StoreKit products:

```swift
// Show the subscription view with mock products for testing
SubscriptionView(useMockData: true)

// When ready to test with real products:
SubscriptionView(useMockData: false)
```

### Family Sharing and Ask to Buy

This package supports Apple's Family Sharing features, including the "Ask to Buy" functionality:

1. **Ask to Buy**: When a child in a Family Sharing group attempts to make a purchase, it will enter a "pending" state until approved by the family organizer.

2. **Handling Pending Purchases**: The package automatically detects when a purchase is in the "pending" state and provides appropriate user feedback.

For these features to work:

1. Configure Family Sharing for your in-app purchases in App Store Connect
2. The package's `PurchaseState` system will automatically handle the different states and provide user feedback

```swift
// Example of monitoring purchase state changes
.onChange(of: subscriptionManager.purchaseState) { state in
    switch state {
    case .pendingApproval:
        // Show message that purchase requires parent approval
    case .purchased:
        // Show success message
    case .failed(let message):
        // Show error message
    default:
        break
    }
}
```

For a complete integration example, see the demo app included in the package.
- Handling subscription state changes
- Mock data for testing
- UI customization options

## Components

The package includes the following components:

- `SubscriptionView`: The main view for displaying subscription options
- `SubscriptionManager`: Handles subscription purchases and verification
- `FreeTrialView`: Displays free trial information
- `ProductRowView`: Displays individual subscription options
- `SubscribeButtonView`: Button for purchasing subscriptions
- `RestoreButtonView`: Button for restoring previous purchases
- `SuccessView`: Displayed after successful subscription

## Changelog

See the [CHANGELOG.md](CHANGELOG.md) file for details on the version history and release notes.

## License

This package is available under the MIT license.
