# Frontend Strategy: 02 - Core UI Views & Components (Conceptual)

This document outlines the conceptual design of core User Interface (UI) views and components for the lightweight Jellyfin frontend. This design is based on a React framework, likely using Material UI (MUI) as a base component library.

## I. Global Elements & Layout

1.  **`AppLayout` Component:**
    *   **Purpose:** Main application shell.
    *   **Contains:** `<Navbar>`, optional `<Sidebar>`, main content area for routed pages.
    *   **Styling:** Clean, modern, Material You principles.

2.  **`Navbar` Component (Top Bar):**
    *   **Purpose:** Primary top navigation and actions.
    *   **Elements:** Menu icon (for Sidebar), App Logo/Title, `<GlobalSearchInput>`, `<UserProfileMenu>`.
    *   **Styling:** MUI `AppBar` base.

3.  **`Sidebar` Component (Navigation Drawer/Panel):**
    *   **Purpose:** Primary navigation links.
    *   **Elements:** Links: Home, Movies, TV Shows, Settings.
    *   **Styling:** MUI `Drawer`. Active link highlighting.

4.  **`GlobalSearchInput` Component:**
    *   **Purpose:** Universal search functionality.
    *   **Behavior:** Navigates to `SearchResultsPage` or shows overlay/dropdown.
    *   **Styling:** MUI `TextField`.

5.  **`UserProfileMenu` Component:**
    *   **Purpose:** User-specific actions.
    *   **Elements:** Avatar, dropdown menu (Settings, Logout).
    *   **Styling:** MUI `Avatar`, `Menu`.

## II. Page-Level Views

1.  **`DashboardPage` (`/` or `/home`):**
    *   **Purpose:** Landing page with personalized content.
    *   **Sections:** "Continue Watching," "Next Up (TV)," "Recently Added Movies," "Recently Added TV Shows." Each section uses horizontal scrollable lists of `<MediaItemCard>`.

2.  **`MovieLibraryPage` (`/movies`):**
    *   **Purpose:** Browse all movies.
    *   **Elements:** `<FilterControls>`, `<MovieGrid>` (of `<MediaItemCard>`), `<PaginationControls>`.

3.  **`TvShowLibraryPage` (`/tvshows`):**
    *   **Purpose:** Browse all TV shows.
    *   **Elements:** `<FilterControls>`, `<TvShowGrid>` (of `<MediaItemCard>`), `<PaginationControls>`.

4.  **`MovieDetailPage` (`/movie/:id`):**
    *   **Purpose:** Detailed movie information.
    *   **Layout:**
        *   **Hero:** Backdrop, Poster, Title, Tagline, Key Actions (`<PlayButton>`, etc.).
        *   **Metadata:** Overview, Genres, Cast/Crew (`<PersonChip>`), Studio, Rating.
        *   **Related Movies (Optional).**

5.  **`TvShowDetailPage` (`/tvshow/:id`):**
    *   **Purpose:** Detailed TV show information.
    *   **Layout:**
        *   **Hero:** Similar to Movie Detail.
        *   **Season List:** Grid/list of `<SeasonCard>`.
        *   **Cast/Crew.**
        *   **Related Shows (Optional).**

6.  **`SeasonDetailPage` (`/tvshow/:id/season/:seasonNumber`):**
    *   **Purpose:** Episodes for a specific season.
    *   **Layout:** Season Info, `<EpisodeList>` of `<EpisodeListItem>`.

7.  **`VideoPlayerPage` (`/play/:itemId` or Modal Overlay):**
    *   **Purpose:** Video playback.
    *   **Elements:** HTML5 `<video>`, `<PlayerControlsOverlay>` (Play/Pause, Seek, Volume, Fullscreen, Next/Prev Episode), `<SubtitleSelectionMenu>`, `<AudioTrackSelectionMenu>`, `<QualitySelectionMenu>`, `<PlayerTitleBar>`.
    *   **Styling:** Minimalist, auto-hiding controls.

8.  **`SettingsPage` (`/settings`):**
    *   **Purpose:** User-configurable settings.
    *   **Sections:** Playback (audio/subtitle language), Appearance (theme, accent color simulation), Account.
    *   **Styling:** MUI `List`, `Switch`, `Select`.

9.  **`LoginPage` (`/login`):**
    *   **Purpose:** User authentication.
    *   **Elements:** Username, Password inputs, Login button.

10. **`SearchResultsPage` (`/search?query=...`):**
    *   **Purpose:** Display search results.
    *   **Layout:** Tabs/sections for Movies, TV Shows. Grid of `<MediaItemCard>`.

## III. Common Reusable Components

1.  **`<MediaItemCard>`:**
    *   **Props:** Item data (movie/show/episode), onClick.
    *   **Elements:** Poster image (potential gradient overlay on hover), Title, Year, Unplayed/Progress indicator.
    *   **Styling:** MUI `Card` base, rounded corners, hover effects.

2.  **`<PlayButton>` / `<ResumeButton>`:**
    *   **Props:** ItemId, isResume.
    *   **Styling:** Prominent, clear icon, theme accent color.

3.  **`<FilterControls>`:**
    *   **Props:** Filter options, current values, onChange handler.
    *   **Elements:** MUI `Select`, `Slider`, etc.

4.  **`<PaginationControls>`:**
    *   **Props:** Current page, total pages, onChange handler.
    *   **Styling:** MUI `Pagination`.

5.  **`<PersonChip>` / `<PersonCard>` (for Cast/Crew):**
    *   **Props:** Person data (name, role, image).
    *   **Elements:** Small avatar, name, role.
    *   **Styling:** MUI `Chip` or small `Card`.

6.  **`<EpisodeListItem>`:**
    *   **Props:** Episode data.
    *   **Elements:** Thumbnail, episode number & title, play icon, progress indicator.
    *   **Styling:** Clear, actionable.

7.  **`<SeasonCard>`:**
    *   **Props:** Season data (poster, season number, title/summary).
    *   **Elements:** Season poster, season number/name.
