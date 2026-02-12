# Leo's POS - Frontend (Flutter)

This is the client-side Flutter application for the Queen's Cafe POS system. It interacts with the Firebase/Express backend to manage sales, inventory, and subscriptions.

## 📱 Overview

A responsive, tablet-first Point of Sale application built with Flutter. It supports multi-tenancy, real-time updates, and offline-first capabilities (planned).

*   **Design System**: Custom Slate-based theme with Deep Indigo branding.
*   **Navigation**: `go_router` for deep linking and navigation management.
*   **State Management**: `Provider` for simple, scalable state injection.

## 🛠️ Tech Stack

*   **Framework**: Flutter (Dart)
*   **Routing**: `go_router`
*   **State Management**: `provider`
*   **Charts**: `fl_chart`
*   **Backend Integration**: HTTP / REST API (Connecting to the [Node.js Backend](./backend))

## 📂 Project Structure

*   `lib/main.dart`: Entry point, Theme configuration.
*   `lib/constants/`: App-wide constants (colors, strings) and Dimensions utility.
*   `lib/providers/`: State management logic.
*   `lib/router/`: App navigation configuration.
*   `lib/screens/`: UI Screens (Login, Dashboard, etc.).
*   `lib/utils/`: Helper functions.

## 🚀 Getting Started

1.  **Prerequisites**:
    *   Flutter SDK (3.10.x or higher)
    *   Cocoapods (for iOS)
    *   Node.js Backend running (see `backend/README.md`)

2.  **Install Dependencies**:
    ```bash
    flutter pub get
    ```

3.  **Run the App**:
    *   **Chrome (Web)**:
        ```bash
        flutter run -d chrome
        ```
    *   **macOS / iOS / Android**:
        ```bash
        flutter run
        ```

## 🎨 Design Reference

For detailed design specifications (Colors, Typography, Layouts) to be used for UI generation or reference, please see **[WEBSITE.md](./WEBSITE.md)**.

## 🔗 Backend Connection

This app expects the backend to be running on `http://localhost:5001` (default) or a deployed URL. Configure your API base URL in `lib/constants/app_constants.dart` (or environment config).
