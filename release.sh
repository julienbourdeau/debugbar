#!/bin/bash

# Check if e_arrow is defined (ie: I'm on my laptop); if not, use echo
if ! declare -f e_arrow >/dev/null; then
  e_arrow() { printf "➜ %s\n" "$@"; }
  e_success() { printf "✔ %s\n" "$@"; }
  e_error() { printf "✖ %s\n" "$@"; }
  e_note() { printf "Note: %s\n" "$@"; }
fi

# Step 1: Prompt for the version number
e_arrow "Enter the new version number (e.g., 0.4.2):"
read NEW_VERSION

if [[ -z "$NEW_VERSION" ]]; then
  e_error "Error: You must provide a valid version number."
  exit 1
fi

# Step 2: Update the version in `version.rb`
VERSION_FILE="lib/debugbar/version.rb"
if [[ -f "$VERSION_FILE" ]]; then
  sed -i.bak "s/VERSION = \".*\"/VERSION = \"$NEW_VERSION\"/" $VERSION_FILE && rm "${VERSION_FILE}.bak"
  e_success "Version updated to $NEW_VERSION in $VERSION_FILE"
else
  e_error "Error: $VERSION_FILE not found."
  exit 1
fi

# Step 3: Update the CHANGELOG.md
CHANGELOG_FILE="CHANGELOG.md"
CURRENT_DATE=$(date +'%Y-%m-%d')
if [[ -f "$CHANGELOG_FILE" ]]; then
  # Replace "UNRELEASED" with the new version and current date
  sed -i.bak "s/## UNRELEASED/## v$NEW_VERSION - $CURRENT_DATE/" $CHANGELOG_FILE && rm "${CHANGELOG_FILE}.bak"
  e_success "Changelog updated with version $NEW_VERSION and date $CURRENT_DATE."
else
  e_error "Error: $CHANGELOG_FILE not found."
  exit 1
fi

# Step 4: Run the build script
BUILD_SCRIPT="./build_client.sh"
if [[ -f "$BUILD_SCRIPT" ]]; then
  bash $BUILD_SCRIPT
  e_success "Build script completed."
else
  e_error "Error: $BUILD_SCRIPT not found."
  exit 1
fi

# Step 5: Commit the changes
e_arrow "Committing the changes..."
git add $VERSION_FILE $CHANGELOG_FILE
git commit -m "v$NEW_VERSION"
e_arrow "Tagging the release..."
git tag -a "v$NEW_VERSION"
e_arrow "Pushing the changes..."
git push origin master
git push origin "v$NEW_VERSION"
e_success "$NEW_VERSION published on GitHub."

# Step 7: Publish the release on RubyGems
e_note "Publishing on RubyGems.org should require 2FA code"
gem build debugbar.gemspec
gem push "debugbar-$NEW_VERSION.gem"
e_success "$NEW_VERSION published on RubyGems."

echo
echo "Done."
