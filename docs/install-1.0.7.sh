#!/bin/zsh
# Installation script for SubscriptionExample 1.0.7

echo "Installing SubscriptionExample 1.0.7..."

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo "Error: git is not installed. Please install git first."
    exit 1
fi

# Check if Xcode is installed
if ! command -v xcodebuild &> /dev/null; then
    echo "Error: Xcode is not installed. Please install Xcode first."
    exit 1
fi

# Create a temporary directory
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

# Clone the repository
git clone https://github.com/nothing-to-add/subscription-example-for-ios.git
cd subscription-example-for-ios

# Checkout the specific version
git checkout v1.0.7

# Open the directory in Finder
open .

echo "SubscriptionExample 1.0.7 has been downloaded to $TEMP_DIR/subscription-example-for-ios"
echo "You can now add it to your project using Swift Package Manager:"
echo "1. In Xcode, go to File > Add Packages..."
echo "2. Enter the repository URL: file://$TEMP_DIR/subscription-example-for-ios"
echo "3. Select version 1.0.7 and click 'Add Package'"
echo ""
echo "Alternatively, you can add it to your Package.swift file:"
echo "dependencies: ["
echo "    .package(url: \"file://$TEMP_DIR/subscription-example-for-ios\", from: \"1.0.7\")"
echo "]"
