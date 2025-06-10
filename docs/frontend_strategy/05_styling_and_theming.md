# Frontend Strategy: 05 - Styling & Theming Guidance

This document provides styling and theming guidance for the new lightweight Jellyfin frontend, aiming for a "Google Material You (UI3)" or "Apple inspired" aesthetic, incorporating gradients tastefully. The primary technology stack considered is React with Material UI (MUI), but advice for custom approaches (e.g., using Tailwind CSS) is also included.

## I. Google Material You (UI3) Inspired Look (with React & MUI)

1.  **MUI v5+ Theming (`createTheme`, `ThemeProvider`):**
    *   **Dynamic Color Simulation:** Offer user-selectable, pre-defined harmonious color palettes based on Material Design 3 principles (primary, secondary, tertiary, surface, on-surface, error, warning, info, success, background).
    *   **Baseline:** Start with MUI's default Material Design 3 palette.

2.  **Component Styling:**
    *   **Shape & Rounded Corners:** Increase `theme.shape.borderRadius` globally (e.g., 8-16px). Apply more pronounced rounding to specific components (Buttons, Cards, Inputs) via `sx` prop or `styled()`.
    *   **Elevation & Shadows:** Utilize subtle, layered elevations (MUI `Paper`, `Card`).
    *   **Buttons:** Employ filled tonal, filled, and outlined buttons as per Material You guidelines. Ensure ample padding.
    *   **Cards (`<MediaItemCard>`):** Rounded corners, clear image/text separation, subtle hover/focus states.

3.  **Typography:**
    *   **Fonts:** Roboto Flex or Roboto.
    *   **Hierarchy:** Clear typographic scale (Display, Headline, Title, Body, Label - each with Large, Medium, Small variants).
    *   **Spacing:** Generous line height and letter spacing.

4.  **Iconography:**
    *   Material Symbols (via `@mui/icons-material`). Ensure clarity and intuitiveness.

5.  **Layout & Spacing:**
    *   **Whitespace:** Ample use to reduce clutter.
    *   **Responsive Grid:** MUI `Grid` or CSS Flexbox/Grid.
    *   **Consistent Spacing:** Use `theme.spacing()` for margins/paddings.

6.  **Gradients (Material You Context):**
    *   **Style:** Subtle, tonal, or occasionally vibrant for highlights.
    *   **Usage:**
        *   Soft backgrounds (hero sections, cards).
        *   Small accents (active indicators, button hovers, progress bars).
        *   Image overlays (e.g., dark gradient on `<MediaItemCard>` images for text legibility).
    *   **Implementation:** CSS `linear-gradient()`, `radial-gradient()` via MUI's `sx` prop or `styled()`.
    *   **Caution:** Avoid overuse of strong gradients to prevent a dated look.

## II. Apple-Inspired Look (with React & Tailwind CSS or Custom CSS/CSS-in-JS)

1.  **Core Principles:** Clarity, Deference (UI doesn't overpower content), Depth (visual layers, realistic motion).

2.  **Color Palette:**
    *   Neutral base (grays, whites, blacks) with a single vibrant accent color.
    *   Prioritize Dark Mode support.
    *   **Gradients:** Used for app icons (if any), subtle UI backgrounds, and sometimes on controls for a slight 3D effect.

3.  **Typography:**
    *   **Fonts:** Web alternatives to San Francisco (e.g., Inter, system font stacks).
    *   **Hierarchy:** Strong, clear, legible.

4.  **Layout & Materials:**
    *   **Frosted Glass / Translucency:** Use CSS `backdrop-filter: blur(Xpx);` with a semi-transparent `rgba()` background for sidebars, modals, etc.
    *   **Layering:** Convey hierarchy with layers, shadows, and blur.
    *   **Padding & Spacing:** Generous, consistent (e.g., multiples of 8px).
    *   **Alignment:** Strong emphasis on grid systems.

5.  **Iconography:**
    *   Clean, precise, often outlined glyphs (e.g., Heroicons, Feather Icons, or custom SVGs).

6.  **Interactions & Animations:**
    *   Fluid, physics-based animations. Natural and responsive transitions.

## III. General Styling Advice

*   **Consistency:** Maintain uniformity in color, typography, spacing, and component design.
*   **Accessibility (A11y):** Prioritize color contrast, keyboard navigation, focus states, and ARIA attributes.
*   **Performance:** Optimize images. Use CSS transitions/animations efficiently. Be mindful of rendering costs (blurs, shadows).
*   **Prototyping:** Use design tools (Figma, Adobe XD) to prototype and iterate on styles before coding.
*   **User Customization (Simple):** Consider allowing users to choose between a light and dark mode. If implementing Material You concepts, a few pre-set accent color palettes could enhance personalization.
