# Demo App Instructions

This directory contains a sample app demonstrating the usage of the SubscriptionExample package.

## Running the Demo App

### Option 1: Using Xcode (Recommended)
1. Open the DemoApp directory in Xcode:
   ```
   open -a Xcode /path/to/subscription-example-for-ios/Examples/DemoApp
   ```
2. Select a simulator device from the scheme dropdown
3. Click Run or press Cmd+R

### Option 2: Using Swift Package Manager
```bash
cd /path/to/subscription-example-for-ios/Examples/DemoApp
swift run
```

## Using SwiftUI Previews

The files contain special Xcode configuration comments that enable previews to work even without a full Xcode project:

```swift
// xcode: target=DemoApp
// xcode: platform=iOS
// xcode: deployment_target=16.0
```

## Troubleshooting SwiftUI Previews

If you see the error "Active scheme does not build this file":

1. **Important**: Double-click the `DemoApp.xcodeproj` file to open it in Xcode directly
2. Run the included script to generate Xcode schemes:
   ```bash
   cd /path/to/Examples/DemoApp
   ./generate_preview_schemes.sh
   ```
3. Make sure the active scheme is set to "DemoApp" (not "SubscriptionExample")
4. Clean the build folder (Product → Clean Build Folder)
5. Close and reopen the file you want to preview
6. Try using the `PreviewHelper.swift` file which contains working preview configurations

Advanced troubleshooting:
1. Create a new scheme specifically for the DemoApp target in Xcode
2. Make sure all dependencies have been resolved
3. Open in a new Xcode window rather than as part of the package workspace
