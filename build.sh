#!/usr/bin/env bash
# Exit on error
set -o errexit

# Make gradlew executable
chmod +x gradlew

# Build the project
./gradlew clean build -x test --no-daemon
