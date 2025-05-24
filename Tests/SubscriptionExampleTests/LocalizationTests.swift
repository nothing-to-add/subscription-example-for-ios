import XCTest
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
            // Get localized string using the same method the UI uses
            let localized = NSLocalizedString(key, bundle: .module, comment: "")
            
            // If localization fails, we get back the same string
            XCTAssertNotEqual(key, localized, "String '\(key)' is not localized, check Localizable.xcstrings")
            
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
