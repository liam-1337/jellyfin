# Frontend Strategy: 04 - User Flows

This document describes key user flows for the lightweight Movie/TV focused Jellyfin frontend.

## 1. New User - First Launch & Login

1.  **User Action:** Opens the web application.
2.  **UI:** Displays `LoginPage`.
3.  **User Action:** Enters username and password, clicks "Login."
4.  **Frontend:** Sends credentials to `POST /Users/AuthenticateByName`.
5.  **Backend:**
    *   Validates credentials.
    *   On Success: Returns `AuthenticationResult` (User DTO, AccessToken).
    *   On Failure: Returns error (e.g., 401 Unauthorized).
6.  **Frontend (On Success):**
    *   Stores AccessToken securely.
    *   Stores basic User DTO in global state (e.g., Zustand store).
    *   Redirects to `DashboardPage`.
7.  **Frontend (On Failure):** Displays error message on `LoginPage`.

## 2. Existing User - App Launch

1.  **User Action:** Opens the web application.
2.  **Frontend:**
    *   Checks for a stored AccessToken.
    *   **If AccessToken exists:**
        *   *Recommended:* Validate token (e.g., `GET /System/Info`).
        *   If valid: Fetch user data (`GET /Users/{userId}`), set user state, redirect to `DashboardPage`.
        *   If invalid: Clear token, redirect to `LoginPage`.
    *   **If no AccessToken:** Redirect to `LoginPage`.

## 3. Browse Movies & Play a Movie

1.  **User Action:** Navigates to "Movies" (from `Sidebar` or `DashboardPage`).
2.  **UI:** Displays `MovieLibraryPage`.
3.  **Frontend:** Fetches initial movies (`GET /Users/{userId}/Items` with `IncludeItemTypes=Movie`).
4.  **User Action:** Scrolls (triggers pagination) or uses `<FilterControls>`.
5.  **Frontend:** Fetches more movies or filtered movies accordingly.
6.  **User Action:** Clicks on a movie's `<MediaItemCard>`.
7.  **UI:** Navigates to `MovieDetailPage` (`/movie/{movieId}`).
8.  **Frontend:** Fetches movie details (`GET /Users/{userId}/Items/{movieId}`).
9.  **User Action:** Clicks `<PlayButton>`.
10. **Frontend:**
    *   Fetches playback info (`GET /Items/{movieId}/PlaybackInfo`).
    *   Determines stream URL (direct play/transcode).
    *   Navigates to `VideoPlayerPage`.
    *   Reports playback start (`POST /Sessions/Playing`).
11. **UI (`VideoPlayerPage`):** Video plays.
12. **Frontend:** Periodically reports progress (`POST /Sessions/Playing/Progress`).
13. **User Action:** Movie ends or user stops/navigates away.
14. **Frontend:** Reports playback stopped (`POST /Sessions/Playing/Stopped`).

## 4. Browse TV Shows, Select Season/Episode, Play Episode

1.  **User Action:** Navigates to "TV Shows."
2.  **UI:** Displays `TvShowLibraryPage`.
3.  **Frontend:** Fetches TV shows.
4.  **User Action:** Clicks a TV show's `<MediaItemCard>`.
5.  **UI:** Navigates to `TvShowDetailPage` (`/tvshow/{showId}`).
6.  **Frontend:** Fetches show details and seasons (`GET /Users/{userId}/Items/{showId}`, `GET /Shows/{showId}/Seasons`).
7.  **User Action:** Clicks a `<SeasonCard>`.
8.  **UI:** Navigates to `SeasonDetailPage` (`/tvshow/{showId}/season/{seasonNumber}`).
9.  **Frontend:** Fetches episodes for the season (`GET /Shows/{showId}/Episodes?SeasonId={seasonId}`).
10. **User Action:** Clicks play on an `<EpisodeListItem>`.
11. **Frontend:**
    *   Fetches episode playback info (`GET /Items/{episodeId}/PlaybackInfo`).
    *   Constructs stream URL.
    *   Navigates to `VideoPlayerPage`.
    *   Reports playback start.
    *   (Playback continues as per movie flow).

## 5. Search for Media

1.  **User Action:** Types query into `<GlobalSearchInput>`, submits.
2.  **UI:** Navigates to `SearchResultsPage` (`/search?query={searchText}`).
3.  **Frontend:** Fetches search results (`GET /Users/{userId}/Items` with `SearchTerm` and `IncludeItemTypes=Movie,Series`).
4.  **UI:** Displays results (possibly categorized).
5.  **User Action:** Clicks a search result.
6.  **UI:** Navigates to the item's detail page.

## 6. Change a Setting

1.  **User Action:** Navigates to "Settings."
2.  **UI:** Displays `SettingsPage`.
3.  **Frontend:** Fetches current display preferences (`GET /DisplayPreferences/usersettings`).
4.  **User Action:** Modifies a setting.
5.  **Frontend:** Sends updated settings (`POST /DisplayPreferences/usersettings`).
6.  **UI:** Shows confirmation/error.

## 7. Resume Watching an In-Progress Item

1.  **User Action:** On `DashboardPage`, views `<ContinueWatchingSection>`.
2.  **Frontend:** Items fetched via `GET /Users/{userId}/Items/Resume`.
3.  **User Action:** Clicks a `<MediaItemCard>` from this section.
4.  **Frontend:**
    *   Retrieves `UserData.PlaybackPositionTicks` from the item.
    *   Fetches playback info (`GET /Items/{itemId}/PlaybackInfo`).
    *   Constructs streaming URL, potentially with `StartPositionTicks`.
    *   Navigates to `VideoPlayerPage`, starting from the saved position.
    *   Reports playback start (as resume).
