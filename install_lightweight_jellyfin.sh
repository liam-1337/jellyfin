#!/bin/bash

# Conceptual Installation Script for Lightweight Jellyfin Backend
# This script outlines the steps to build the modified Jellyfin server.
# It assumes you have a Linux environment with necessary build tools.

# --- Prerequisites ---
echo "Checking prerequisites..."

# 1. Git (to clone the repository)
if ! command -v git &> /dev/null
then
    echo "Git could not be found. Please install Git."
    # Example: sudo apt-get update && sudo apt-get install git
    exit 1
fi

# 2. .NET SDK (Version should match the project's TargetFramework, e.g., net9.0)
#    Check Jellyfin.Server/Jellyfin.Server.csproj for the exact version.
if ! command -v dotnet &> /dev/null
then
    echo ".NET SDK could not be found. Please install the .NET SDK."
    # Example: Follow instructions at https://dotnet.microsoft.com/download
    exit 1
fi
# TODO: Add specific .NET version check if possible via CLI

echo "Prerequisites seem to be met."

# --- Configuration ---
JELLYFIN_REPO_URL="<URL_OF_YOUR_MODIFIED_JELLYFIN_REPO>" # User needs to set this
JELLYFIN_BRANCH="feature/lightweight-backend-1" # Or the branch with these changes
BUILD_DIR="jellyfin_lightweight_build"
RELEASE_OUTPUT_DIR="jellyfin_lightweight_release"

# --- Clone the Repository ---
echo "Cloning the repository..."
if [ -d "$BUILD_DIR" ]; then
    echo "Build directory '$BUILD_DIR' already exists. Pulling latest changes."
    cd "$BUILD_DIR"
    git pull
    git checkout "$JELLYFIN_BRANCH" || { echo "Branch checkout failed"; exit 1; }
    cd ..
else
    git clone --branch "$JELLYFIN_BRANCH" "$JELLYFIN_REPO_URL" "$BUILD_DIR" || { echo "Git clone failed"; exit 1; }
fi

cd "$BUILD_DIR" || exit 1

# --- Build the Solution ---
echo "Building the Jellyfin solution..."
# The main solution file is Jellyfin.sln
# We need to build the 'jellyfin' project which is the server executable.
# A publish command is typically used to get all necessary files for deployment.

# Clean previous build (optional, but good practice)
dotnet clean Jellyfin.sln --configuration Release

# Publish the server
# The RID (Runtime Identifier) might be needed depending on the target system.
# Examples: linux-x64, linux-arm64, win-x64
# For a generic Linux build, you might not need to specify it if building on the target arch.
# However, self-contained builds often benefit from a RID.
TARGET_RID="linux-x64" # Or choose another appropriate RID

echo "Publishing for RID: $TARGET_RID..."
dotnet publish Jellyfin.Server/Jellyfin.Server.csproj     --configuration Release     --runtime "$TARGET_RID"     --output "../$RELEASE_OUTPUT_DIR"     -p:PublishSingleFile=false     -p:PublishTrimmed=false # Trimming might remove too much with these modifications

# Note: PublishSingleFile and PublishTrimmed are advanced options.
# For initial stability with a heavily modified app, it's safer to start with them false.
# They can be experimented with later for further size reduction if the app is stable.

if [ $? -ne 0 ]; then
    echo "Build failed. Please check the output."
    exit 1
fi

echo "Build successful!"
echo "The lightweight Jellyfin backend has been built and published to: $(pwd)/../$RELEASE_OUTPUT_DIR"
echo ""
echo "--- Post-Build Steps (Manual) ---"
echo "1. Review the contents of '../$RELEASE_OUTPUT_DIR'."
echo "2. This directory contains the executable and all necessary files to run the server."
echo "3. You would typically copy this directory to your desired server location."
echo "4. Ensure necessary data directories (for config, cache, logs, media metadata) are set up with correct permissions."
echo "   Refer to official Jellyfin documentation for standard directory structure and configuration."
echo "5. Run the 'jellyfin' executable from the release directory to start the server."
echo "   Example: cd ../$RELEASE_OUTPUT_DIR && ./jellyfin"
echo ""
echo "This script provides a basic build outline. You may need to adapt it for your specific environment or packaging needs (e.g., creating a systemd service, Docker container, etc.)."

cd ..
exit 0
