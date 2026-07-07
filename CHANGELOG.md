# Changelog

All notable changes to this project will be documented in this file.

## 2.2.0+17

### ✨ Features
- **Global Settings Management:** Introduced a comprehensive settings architecture to manage reading preferences (theme, font size, font style, and push notifications) globally across the app.
- **Offline Kannada Typography:** Bundled and integrated premium offline fonts (`Noto Sans Kannada` and `Noto Serif Kannada`), bypassing network dependencies for faster rendering.
- **Astottaras Local Caching:** Implemented a robust local caching layer for Astottaras using Hive, synchronized seamlessly with Firestore timestamps to ensure data consistency.
- **UPI & Donation Functionality:** Enhanced the Contact and Social Media pages with integrated donation options and UPI support.

### 🏗️ Architecture & Refactoring
- **Android Target SDK Upgrade:** Upgraded the Android Target SDK to Version 36 to comply with the latest platform standards and optimizations.
- **Clean Architecture Migration:** Successfully decoupled the Presentation layer from the Data layer across major features (Notifications, Settings, Books).
- **Books Schema Upgrade:** Transitioned the Books feature to use dedicated local data sources and strong schema separation.
- **Error Handling Optimization:** Overhauled the application's global error handling and Freezed models logic to be more resilient and predictable.

### 🐛 Bug Fixes & UI Polish
- **Unified Reading Experience:** Centralized font size, style, and theme toggles in a beautiful new `SettingsPage`, cleaning up the UI in individual reading views (Books, Astottaras, Lyrics).
- **Dynamic Versioning:** The `SettingsPage` now dynamically displays the accurate app version utilizing `package_info_plus`.
- **Global Connectivity Overlays:** Fixed critical crashes related to the global internet connectivity listener and injected user-friendly non-intrusive snackbar alerts.
- **Downloads & Grids:** Improved the UI state management for downloading Books, balanced the Social Media links grid spacing, and refined Event list states.
