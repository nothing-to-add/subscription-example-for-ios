#!/bin/zsh
# generate_preview_schemes.sh
# This script generates an Xcode scheme for the DemoApp to help with previews

# Go to the DemoApp directory
cd "$(dirname "$0")"

# Check if the xcodeproj exists
if [ ! -d "DemoApp.xcodeproj" ]; then
  echo "Error: DemoApp.xcodeproj not found!"
  exit 1
fi

# Create the schemes directory if it doesn't exist
mkdir -p DemoApp.xcodeproj/xcshareddata/xcschemes

# Create the scheme file for DemoApp
cat > DemoApp.xcodeproj/xcshareddata/xcschemes/DemoApp.xcscheme << 'EOL'
<?xml version="1.0" encoding="UTF-8"?>
<Scheme
   LastUpgradeVersion = "1500"
   version = "1.7">
   <BuildAction
      parallelizeBuildables = "YES"
      buildImplicitDependencies = "YES">
      <BuildActionEntries>
         <BuildActionEntry
            buildForTesting = "YES"
            buildForRunning = "YES"
            buildForProfiling = "YES"
            buildForArchiving = "YES"
            buildForAnalyzing = "YES">
            <BuildableReference
               BuildableIdentifier = "primary"
               BlueprintIdentifier = "DemoApp"
               BuildableName = "DemoApp.app"
               BlueprintName = "DemoApp"
               ReferencedContainer = "container:DemoApp.xcodeproj">
            </BuildableReference>
         </BuildActionEntry>
      </BuildActionEntries>
   </BuildAction>
   <TestAction
      buildConfiguration = "Debug"
      selectedDebuggerIdentifier = "Xcode.DebuggerFoundation.Debugger.LLDB"
      selectedLauncherIdentifier = "Xcode.DebuggerFoundation.Launcher.LLDB"
      shouldUseLaunchSchemeArgsEnv = "YES"
      shouldAutocreateTestPlan = "YES">
   </TestAction>
   <LaunchAction
      buildConfiguration = "Debug"
      selectedDebuggerIdentifier = "Xcode.DebuggerFoundation.Debugger.LLDB"
      selectedLauncherIdentifier = "Xcode.DebuggerFoundation.Launcher.LLDB"
      launchStyle = "0"
      useCustomWorkingDirectory = "NO"
      ignoresPersistentStateOnLaunch = "NO"
      debugDocumentVersioning = "YES"
      debugServiceExtension = "internal"
      allowLocationSimulation = "YES">
      <BuildableProductRunnable
         runnableDebuggingMode = "0">
         <BuildableReference
            BuildableIdentifier = "primary"
            BlueprintIdentifier = "DemoApp"
            BuildableName = "DemoApp.app"
            BlueprintName = "DemoApp"
            ReferencedContainer = "container:DemoApp.xcodeproj">
         </BuildableReference>
      </BuildableProductRunnable>
   </LaunchAction>
   <ProfileAction
      buildConfiguration = "Release"
      shouldUseLaunchSchemeArgsEnv = "YES"
      savedToolIdentifier = ""
      useCustomWorkingDirectory = "NO"
      debugDocumentVersioning = "YES">
      <BuildableProductRunnable
         runnableDebuggingMode = "0">
         <BuildableReference
            BuildableIdentifier = "primary"
            BlueprintIdentifier = "DemoApp"
            BuildableName = "DemoApp.app"
            BlueprintName = "DemoApp"
            ReferencedContainer = "container:DemoApp.xcodeproj">
         </BuildableReference>
      </BuildableProductRunnable>
   </ProfileAction>
   <AnalyzeAction
      buildConfiguration = "Debug">
   </AnalyzeAction>
   <ArchiveAction
      buildConfiguration = "Release"
      revealArchiveInOrganizer = "YES">
   </ArchiveAction>
</Scheme>
EOL

echo "Scheme generated successfully!"
echo "To use this scheme:"
echo "1. Open DemoApp.xcodeproj in Xcode"
echo "2. Select the DemoApp scheme from the scheme selector"
echo "3. Clean build folder and restart Xcode if needed"
