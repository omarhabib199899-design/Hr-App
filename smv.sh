#!/bin/bash

# Read the current version from pubspec.yaml
current_version=$(grep 'version: ' pubspec.yaml | awk '{print $2}')

# Extract the major, minor, and patch version components
major_version=$(echo $current_version | cut -d. -f1)
minor_version=$(echo $current_version | cut -d. -f2)
patch_version=$(echo $current_version | cut -d. -f3 | cut -d+ -f1)
build_number=$(echo $current_version | awk -F'[+]' '{print $2}' | tr -d '\r')

# Increment the patch version and build number
((patch_version++))
((build_number++))

# Construct the new version string
new_version="$major_version.$minor_version.$patch_version+$build_number"

# Update the pubspec.yaml file with the new version
sed -i.bak "s/version: $current_version/version: $new_version/g" pubspec.yaml

# Remove the backup file created by sed
rm pubspec.yaml.bak

# Print the new version
echo "New version: $new_version"