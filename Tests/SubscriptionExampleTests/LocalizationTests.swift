import XCTest
import SwiftUI
@testable import SubscriptionExample

final class LocalizationTests: XCTestCase {
    func testLocalizable() throws {
        // Check that the localization bundle exists
        XCTAssertNotNil(Bundle.module, "Bundle.module should not be nil")
        
        // Test all localizable strings used in the package
        let keys = [
            C.Text.FreeTrial.title,
            C.Text.FreeTrial.subtitle,
            C.Text.SubscriptionView.title,
            C.Text.SubscriptionView.productsTitle,
            C.Text.SubscriptionView.loadingText,
            C.Text.SubscriptionView.termsTitle,
            C.Text.SubscriptionView.monthlyPriceText,
            C.Text.SuccessView.title,
            C.Text.SuccessView.subtitle,
            C.Text.SubscribeButton.title,
            C.Text.ReRestoreButton.title
        ]
        
        for key in keys {
            // For legacy .strings files we can use NSLocalizedString directly
            let localizedString = NSLocalizedString(key, tableName: "Localizable", bundle: .module, comment: "")
            
            // Check that the string is actually localized (not same as the key)
            XCTAssertNotEqual(localizedString, key, "String '\(key)' is not localized, check Localizable.strings")
            
            // We could add more specific tests for the expected values
            // but that would require updating the test every time we change translations
        }
    }
    
    func testBundleContainsLocalizations() throws {
        // Check that the bundle contains localizations
        let localizations = Bundle.module.localizations
        
        // At minimum we should have English
        XCTAssertTrue(localizations.contains("en"), "Bundle should contain English localization")
        
        // We should have at least one localization
        XCTAssertGreaterThan(localizations.count, 0, "Bundle should contain localizations")
        
        print("Available localizations: \(localizations)")
    }
}
