# Frontend Strategy: 01 - Architecture and Technology Stack

This document outlines the recommended architecture and technology stack for the new lightweight Jellyfin frontend, designed for a modern Movie/TV focused experience.

## 1. JavaScript Framework: React

*   **Reasoning:**
    *   **Popularity & Ecosystem:** Vast ecosystem, extensive libraries (e.g., for UI components, state management, data fetching), and a large community.
    *   **Component-Based Architecture:** Ideal for building modular and maintainable user interfaces.
    *   **Performance:** Offers good performance with its virtual DOM and optimization capabilities.
    *   **Suitability for "Google Material You / Apple Inspired" UI:**
        *   Can be paired with component libraries like Material UI (MUI) for a Material You look.
        *   Allows flexible custom styling (e.g., with Tailwind CSS or CSS-in-JS) for bespoke designs.
*   **Build Tool: Vite**
    *   **Reasoning:** Extremely fast Hot Module Replacement (HMR) for development, optimized builds for production, and a modern, streamlined developer experience.

## 2. UI Component Library / Styling Approach

*   **Primary Recommendation (for Google Material You): Material UI (MUI) v5+**
    *   Provides a comprehensive suite of React components implementing Material Design.
    *   Supports Material You theming principles (dynamic color concepts, updated component styles).
    *   Handles accessibility and theming for many components.
    *   Styling customization via `sx` prop, `styled()` API, and global theme overrides.
*   **Alternative (for Apple-Inspired or Highly Custom): Tailwind CSS or CSS-in-JS (e.g., Styled Components, Emotion)**
    *   **Tailwind CSS:** Utility-first approach for rapid custom UI development.
    *   **Styled Components/Emotion:** Component-scoped styles, good for theming and complex styling logic.

## 3. Routing: React Router

*   **Reasoning:** The de-facto standard for client-side routing in React applications. Mature, feature-rich, and well-documented. Supports declarative routing, nested routes, and route protection.

## 4. State Management: Zustand

*   **Reasoning:**
    *   **Simplicity:** Minimal boilerplate compared to traditional Redux.
    *   **Hooks-based:** Modern and aligns well with React's functional component paradigm.
    *   **Flexibility:** Suitable for managing both global application state (e.g., user authentication, theme) and local feature state.
*   **Alternative:** Redux Toolkit (if the team prefers it or anticipates extremely complex global state).

## 5. Data Fetching & Server State Management: React Query (TanStack Query)

*   **Reasoning:**
    *   Manages server state effectively: caching, background updates, stale-while-revalidate.
    *   Simplifies data fetching logic, reducing boilerplate for loading/error states.
    *   Supports features like pagination, infinite scrolling, and optimistic updates.
*   **Alternative:** RTK Query (if using Redux Toolkit for global state). Basic `fetch` or `axios` can be used but requires manual management of server state.

## 6. Conceptual Folder Structure (Example)

```
/public
  /assets
    /fonts
    /icons
    /images
  index.html
/src
  /api                # API client, request functions, TypeScript types for DTOs
  /app                # Global app setup, routing, state management store (Zustand)
    store.js          # Zustand store definition
    App.jsx           # Main application component with Router setup
    main.jsx          # Entry point, renders App
  /assets             # Static assets imported directly by components
  /components
    /common           # Reusable UI components (Button, Card, Modal, InputField, etc.)
    /layout           # Layout components (Navbar, Sidebar, Footer, PageWrapper, etc.)
    /features         # Components specific to features/modules
      /dashboard      # Components for the dashboard page
      /movies         # Components for movie library & details
      /tvshows        # Components for TV show library & details
      /player         # Components for the video player
      /settings       # Components for the settings page
      /search         # Components for search functionality
  /config             # Application configuration (API base URL, theme defaults, etc.)
  /hooks              # Custom React hooks (e.g., useAuth, useDebounce)
  /pages              # Top-level view components corresponding to routes
  /services           # Non-UI logic (e.g., authService, playbackService utilities)
  /styles             # Global styles, theme definitions (MUI theme overrides)
  /utils              # General utility functions
```

This structure promotes modularity and separation of concerns, facilitating easier development and maintenance.
