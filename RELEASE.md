# Release Process

This document describes the process for releasing new versions of the SubscriptionExample package.

## Preparing a new release

1. Update the version number in README and CHANGELOG files
2. Make sure all changes are committed and pushed
3. Create and push a new tag for the release

## Creating a release tag

To create a new release tag, run the following commands:

```bash
# Tag the release (replace X.Y.Z with the actual version)
git tag -a vX.Y.Z -m "Release version X.Y.Z"

# Push the tag to the remote repository
git push origin vX.Y.Z
```

### Creating the 1.0.0 Release

For the initial 1.0.0 release, you can use:

```bash
git tag -a v1.0.0 -m "Initial release"
git push origin v1.0.0
```

## After Release

After creating a new release:

1. Create a new release on GitHub using the tag
2. Include release notes from the CHANGELOG
3. Start working on the next version by updating the CHANGELOG with a new "Unreleased" section
