# Jellyfin Lightweight Backend - Developer Guide

## 1. Introduction

This document describes a modified version of the Jellyfin backend, specifically tailored to be more "lightweight." The primary goal is to provide a Jellyfin server focused on **Movies and TV Shows**, removing several other media types and features to reduce complexity and potentially resource usage.

This version is intended for users or developers who:
*   Primarily use Jellyfin for movies and TV series.
*   Desire a smaller core feature set.
*   Are interested in potentially building a new, custom user interface that interacts with this streamlined backend.

**Important Note:** This is a backend-only modification. The standard Jellyfin web UI (`jellyfin-web`) might have issues or display empty sections for removed features. This lightweight backend is best paired with a custom UI designed for its reduced feature set, or used API-only.

## 2. Features Removed

To achieve a more lightweight server, the following features have been removed or significantly reduced from the core backend code:

*   **Live TV & DVR:** All Live TV and recording functionalities have been removed.
*   **Music:** Music library management, artist/album processing, MusicBrainz lookups, lyrics, and music-specific API endpoints are removed.
*   **Photos:** Photo library support, photo-specific image processing, and resolvers are removed. The `Emby.Photos` library has been excised.
*   **Books & Audiobooks:** Book and audiobook library support and related resolvers are removed. Naming conventions for audiobooks in `Emby.Naming` have also been removed.
*   **DLNA Server (DMS):** While core `DeviceProfile` support (used for transcoding to many devices) remains, dedicated DLNA server (DMS) functionality appears to be plugin-based in standard Jellyfin. This modified version does not include such a plugin by default. If you need DLNA server capabilities, you would need to find and install a compatible DLNA plugin separately (its compatibility with this heavily modified version is not guaranteed). Basic Jellyfin network discovery (UDP ping) is still present.

## 3. Building from Source

A conceptual shell script, `install_lightweight_jellyfin.sh`, is provided in the root of this repository to guide you through the build process.

**Prerequisites:**
*   **Git:** For cloning the repository.
*   **.NET SDK:** The version required by the `Jellyfin.Server.csproj` file (e.g., .NET 9.0 at the time of writing). Please check the project file for the exact version.

**Steps (as outlined in the script):**

1.  **Clone this Repository:**
    ```bash
    # Replace <URL_OF_THIS_REPO> with the actual URL
    git clone --branch <current-branch-name> <URL_OF_THIS_REPO> jellyfin_lightweight_build
    cd jellyfin_lightweight_build
    ```

2.  **Run the Installation Script:**
    The script automates the build (publish) process.
    ```bash
    ./install_lightweight_jellyfin.sh
    ```
    This script will:
    *   Check for prerequisites (Git, .NET SDK).
    *   Perform a `dotnet publish` for the `Jellyfin.Server` project.
    *   Output the compiled server to a `jellyfin_lightweight_release` directory (relative to where you cloned).

3.  **Review Output:** The `jellyfin_lightweight_release` directory will contain the executable (`jellyfin`) and all its dependencies.

**Manual Build (if not using the script):**
```bash
# Navigate to the cloned repository directory
# cd jellyfin_lightweight_build

# Clean (optional)
dotnet clean Jellyfin.sln --configuration Release

# Publish
# Replace linux-x64 with your target runtime identifier if needed (e.g., win-x64, linux-arm64)
dotnet publish Jellyfin.Server/Jellyfin.Server.csproj     --configuration Release     --runtime linux-x64     --output ./jellyfin_lightweight_release     -p:PublishSingleFile=false     -p:PublishTrimmed=false
```

## 4. Basic Server Setup (After Building)

1.  **Copy Release Files:** Copy the entire contents of the `jellyfin_lightweight_release` directory to your desired server location.
2.  **Data Directories:** Jellyfin requires several data directories for configuration, cache, logs, and metadata. By default, these are often created in standard system locations (e.g., `/var/lib/jellyfin`, `/etc/jellyfin`, `/var/log/jellyfin` on Linux, or within the user profile on Windows). Ensure these locations are writable by the user account that will run Jellyfin.
    *   Consult the official Jellyfin documentation for detailed information on data directories.
3.  **Run the Server:** Navigate to the directory where you copied the release files and execute the main program:
    ```bash
    ./jellyfin
    ```
4.  **Initial Setup via Web Browser:**
    *   Once the server starts, it will typically listen on port `8096` (HTTP) by default. Open a web browser and navigate to `http://<your-server-ip>:8096`.
    *   You should be guided through the initial Jellyfin setup wizard (creating an admin user, etc.).
5.  **Add Media Libraries:**
    *   After the initial setup, log in and navigate to the Admin Dashboard.
    *   Go to "Library" settings.
    *   Add new media libraries, selecting "Movies" or "Shows" as the content type.
    *   Point to the folders on your server where your movie and TV show files are stored.
    *   Jellyfin will then scan these libraries.

## 5. Custom User Interface

As mentioned, this backend is prepared for a new, custom user interface. The standard `jellyfin-web` UI might not function correctly or might show empty sections due to the removed features.

The API endpoints for Movies, TV Shows, Seasons, Episodes, user authentication, streaming (including HLS), metadata, and images are still available. Refer to the Jellyfin API documentation (accessible via your server instance, usually at `/api-docs/swagger`) for details on how to interact with the backend.

## 6. Important Considerations

*   **Testing:** This modified version has undergone significant code removal. While efforts were made to preserve core Movie/TV functionality, thorough testing in your own environment is crucial.
*   **Updates:** This version is detached from the official Jellyfin updates. You will need to manually pull changes from this specific repository branch and rebuild if updates are made here.
*   **Stability:** Removing large parts of a complex application can have unforeseen consequences. While the aim is a stable, lightweight server for a specific purpose, bugs related to the modifications might exist.

---
This guide provides a starting point. Refer to the official Jellyfin documentation for general concepts not covered here.
