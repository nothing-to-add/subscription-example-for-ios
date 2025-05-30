# SubscriptionExample 1.0.7 Release

**Release Date:** May 31, 2025

## Overview

Version 1.0.7 of the SubscriptionExample package introduces a significant enhancement to the subscription UI by adding support for customizable free trial periods. This allows developers to dynamically specify the number of free trial days offered to users, with text that automatically updates in the UI based on the chosen number of days.

## New Features

### Customizable Free Trial Period

- Added a required `freeTrialDays` parameter to the `SubscriptionView` initializer
- Updated the `FreeTrialView` to display the number of days dynamically
- Added localization support for free trial text in both English and German
- Set a new default of 5 days for the free trial

## Implementation

### Usage Options

There are two ways to set the free trial days:

1. **Global Default:**
   ```swift
   SubscriptionExample.initialize(
       debugMode: true,
       productIdentifiers: ["com.example.product"],
       defaultFreeTrialDays: 5
   )
   ```

2. **Per Instance Override:**
   ```swift
   SubscriptionView(
       useMockData: true,
       freeTrialDays: 30,  // Override with 30 days for this specific view
       onCloseButtonTapped: { /* handle close */ }
   )
   ```

### Localization Updates

The localization strings have been updated to accommodate dynamic free trial days:

**English:**
```
"Free Trial Title %@" = "%@ DAYS FREE \nTRIAL";
```

**German:**
```
"Free Trial Title %@" = "%@ TAGE KOSTENLOS TESTEN";
```

## Compatibility

This update is fully backward compatible with existing code that doesn't specify the free trial days parameter, as it will fall back to the default value (now 5 days).

## Upgrading

To upgrade to version 1.0.7, update your Swift Package Manager dependency:

```swift
dependencies: [
    .package(url: "https://github.com/yourusername/subscription-example-for-ios.git", from: "1.0.7")
]
```

## Installation Commands

```bash
# Tag the release
git tag -a v1.0.7 -m "Release version 1.0.7 with customizable free trial days"
git push origin v1.0.7
```
