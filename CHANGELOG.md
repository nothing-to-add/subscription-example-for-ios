# Changelog

All notable changes to the SubscriptionExample package will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.4] - 2025-05-29

### Added
- Updated documentation clarifying localization requirements for importing projects
- Added explicit notes about legacy `.strings` files compatibility in README

### Changed
- Migrated from String Catalog (.xcstrings) to legacy string localization files (.strings)
- Updated StringExtensions.swift to use NSLocalizedString instead of String Catalog approach
- Improved compatibility with older iOS versions and build systems
- Updated localization tests to work with legacy string files
- Improved StringExtensions with better naming conventions
- Enhanced localization examples in documentation

## [1.0.3] - 2025-05-24

### Changed
- Improved API design with better encapsulation
- Made subviews internal instead of public for cleaner API
- Updated documentation to reflect the simplified API surface
- Improved preview handling for SwiftUI previews

## [1.0.2] - 2025-05-23

### Added
- New `PurchaseState` enum for tracking purchase lifecycle
- Improved handling of pending purchases (Ask to Buy feature)
- Better user feedback for purchase states
- Enhanced error handling and user-friendly error messages

### Changed
- Updated SubscribeButtonView to handle purchase states
- Updated RestoreButtonView with loading state
- Enhanced documentation about Family Sharing features

## [1.0.1] - 2025-05-23

### Added
- Customizable product identifiers for StoreKit integration
- Improved configuration options for the SubscriptionManager
- Enhanced documentation for App Store integration
- Helper methods for product identifier management

### Changed
- Updated the DemoApp to demonstrate custom product identifier usage
- Improved README with better explanation of in-app purchase configuration

## [1.0.0] - 2025-05-23

### Added
- Initial release of the SubscriptionExample package
- Complete subscription UI components
- StoreKit 2 integration for handling in-app purchases
- Mock products for development and testing
- Free trial promotion view
- Success view for confirmed subscriptions
- Subscription options display with product selection
- Monthly price calculation for different subscription periods
- Restore purchases functionality
- Localization support with Localizable.xcstrings
- Integration with CustomExtensions package for string localization
- Example app demonstrating package usage

### Requirements
- iOS 16.0+
- macOS 13.0+
- Swift 5.9+
