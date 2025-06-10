# Frontend Strategy: 03 - UI to Backend API Mapping

This document maps the conceptual UI views and components to the relevant backend API endpoints of the slimmed-down Jellyfin server. All API calls require an `X-Emby-Token` (or `Authorization: MediaBrowser Token="..."`) header with the user's AccessToken, unless otherwise specified. Many playback-related calls also require a client-generated `DeviceId`.

## I. Authentication & User

1.  **`LoginPage` (Login Action):**
    *   `POST /Users/AuthenticateByName`
        *   Request: `{ Username: "...", Pw: "..." }`
        *   Response: `AuthenticationResult` (contains `UserDto`, `AccessToken`)

2.  **`UserProfileMenu` (Logout Action):**
    *   `POST /Sessions/Logout`

3.  **User Information (e.g., for `UserProfileMenu`, `SettingsPage`):**
    *   `GET /Users/{userId}`
        *   Response: `UserDto`

## II. Dashboard & Library Overviews

1.  **`<ContinueWatchingSection>`:**
    *   `GET /Users/{userId}/Items/Resume`
        *   Params: `Fields=PrimaryImageAspectRatio,BasicSyncInfo`, `ImageTypeLimit=1`, `EnableImageTypes=Primary,Backdrop,Thumb`, `MediaTypes=Video`
        *   Response: `QueryResult<BaseItemDto>`

2.  **`<NextUpSection>` (TV Shows):**
    *   `GET /Shows/NextUp`
        *   Params: `UserId={userId}`, `Fields=PrimaryImageAspectRatio,BasicSyncInfo`, `ImageTypeLimit=1`, `EnableImageTypes=Primary,Backdrop,Thumb`
        *   Response: `QueryResult<BaseItemDto>`

3.  **`<RecentlyAddedMoviesSection>`:**
    *   `GET /Users/{userId}/Items/Latest`
        *   Params: `IncludeItemTypes=Movie`, `Fields=PrimaryImageAspectRatio,BasicSyncInfo`, `ImageTypeLimit=1`, `EnableImageTypes=Primary,Backdrop,Thumb`
        *   Response: `QueryResult<BaseItemDto>`

4.  **`<RecentlyAddedTvShowsSection>`:**
    *   `GET /Users/{userId}/Items/Latest`
        *   Params: `IncludeItemTypes=Series`, `Fields=PrimaryImageAspectRatio,BasicSyncInfo`, `ImageTypeLimit=1`, `EnableImageTypes=Primary,Backdrop,Thumb`
        *   Response: `QueryResult<BaseItemDto>`

## III. Library Browsing (Movies & TV Shows)

1.  **`MovieLibraryPage` / `TvShowLibraryPage` (Fetching Items):**
    *   `GET /Users/{userId}/Items`
        *   Params:
            *   `IncludeItemTypes=Movie` or `Series`
            *   `Recursive=true`, `Fields=PrimaryImageAspectRatio,BasicSyncInfo,Path`
            *   `ImageTypeLimit=1`, `EnableImageTypes=Primary,Backdrop,Thumb`
            *   `SortBy`, `SortOrder` (user selected)
            *   Optional filters: `Filters=IsUnplayed,IsPlayed`, `Genres={name}`, `Years={year}`
            *   Pagination: `StartIndex={offset}`, `Limit={pageSize}`
        *   Response: `QueryResult<BaseItemDto>`

2.  **`<FilterControls>` (Populating Genre Filter):**
    *   `GET /Genres`
        *   Params: `UserId={userId}`, `IncludeItemTypes=Movie` or `Series`
        *   Response: `QueryResult<BaseItemDto>` (genre items)

## IV. Item Detail Pages

1.  **Main Item Data (Movie, TV Show, Season, Episode):**
    *   `GET /Users/{userId}/Items/{itemId}`
        *   Response: `BaseItemDto` (rich with details: Overview, People, Genres, Studios, etc.)

2.  **Images (Posters, Backdrops, etc.):**
    *   URLs often derived from `ImageTags` in `BaseItemDto`.
    *   Direct Image API: `GET /Items/{itemId}/Images/{imageType}`
        *   `imageType`: Primary, Backdrop, Thumb, Logo.
        *   Params: `maxWidth`, `maxHeight`, `quality` for dynamic resizing.

3.  **`TvShowDetailPage` (Fetching Seasons):**
    *   `GET /Shows/{seriesId}/Seasons`
        *   Params: `UserId={userId}`, `Fields=PrimaryImageAspectRatio,BasicSyncInfo`
        *   Response: `QueryResult<BaseItemDto>` (season items)

4.  **`SeasonDetailPage` (Fetching Episodes):**
    *   `GET /Shows/{seriesId}/Episodes`
        *   Params: `SeasonId={seasonId}`, `UserId={userId}`, `Fields=PrimaryImageAspectRatio,BasicSyncInfo,Overview`
        *   Response: `QueryResult<BaseItemDto>` (episode items)

5.  **Cast & Crew Details (if more info needed beyond item DTO):**
    *   `GET /Persons/{personName}` or `GET /Users/{userId}/Items` with `PersonIds={personId}`
        *   Response: `BaseItemDto` (for person) or `QueryResult<BaseItemDto>`

## V. Playback

1.  **Initiate Playback (Get Streaming Info):**
    *   `GET /Items/{itemId}/PlaybackInfo`
        *   Params: `UserId={userId}`
        *   Response: `PlaybackInfoResponse` (contains `MediaSources` to determine direct play/transcode and construct stream URL)

2.  **Streaming URL (Example for HLS):**
    *   `/Videos/{itemId}/main.m3u8?MediaSourceId={mediaSourceId}&DeviceId={deviceId}&UserId={userId}&PlaySessionId={playSessionId}` (parameters depend on direct play/transcode)

3.  **Report Playback Start:**
    *   `POST /Sessions/Playing`
        *   Request Body: `PlaybackStartInfo` DTO.

4.  **Report Playback Progress:**
    *   `POST /Sessions/Playing/Progress`
        *   Request Body: `PlaybackProgressInfo` DTO.

5.  **Report Playback Stop/Finish:**
    *   `POST /Sessions/Playing/Stopped`
        *   Request Body: `PlaybackStopInfo` DTO.

6.  **Subtitles:**
    *   Internal subtitles listed in `MediaSource.MediaStreams` (from `PlaybackInfoResponse`).
    *   Stream URL usually part of `MediaStream` object or selected via HLS manifest.
    *   External subtitle search (if UI implements it): `GET /Items/{itemId}/RemoteSearch/Subtitles/{language}`

7.  **Audio Tracks:**
    *   Listed in `MediaSource.MediaStreams`. Selection typically handled by the HLS player.

## VI. Search

1.  **`GlobalSearchInput` / `SearchResultsPage`:**
    *   Primary: `GET /Users/{userId}/Items`
        *   Params: `SearchTerm={query}`, `IncludeItemTypes=Movie,Series`, `Recursive=true`, `Fields=PrimaryImageAspectRatio,BasicSyncInfo`, `EnableImageTypes=Primary`
    *   Suggestions (optional): `GET /Search/Hints`
        *   Params: `SearchTerm={query}`, `UserId={userId}`
        *   Response: `SearchHintResult`

## VII. Settings

1.  **User Display Preferences:**
    *   Get: `GET /DisplayPreferences/usersettings` (ID is 'usersettings' by convention, not a variable).
    *   Update: `POST /DisplayPreferences/usersettings`
        *   Request Body: `DisplayPreferencesDto`
