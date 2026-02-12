# Leo's POS - Application & Design Specification

## 📱 Application Overview
**Name:** Queen's Cafe (Internal Project Name: Leos POS)
**Type:** Tablet-first Point of Sale (POS) System
**Platforms:** Android, iOS, Web (Responsive)
**Core Tech:** Flutter, Provider, GoRouter

## 🎨 Design System

### Color Palette
The app uses a professional, high-trust palette inspired by a Steel Blue and Gold theme.

*   **Primary**: `#27537A` (Dark Steel Blue) - Used for primary actions, headers, and branding.
*   **Secondary**: `#9BC4DB` (Light Blue) - Used for backgrounds, secondary buttons, and accents.
*   **Accent**: `#F2C905` (Gold/Yellow) - Used for highlights, call-to-actions, and warnings.
*   **Backgrounds**:
    *   Light: `#FFFFFF` (White)
    *   Dark: `#6B6C6E` (Neutral Grey)
*   **Typography / Text**:
    *   Heading: `#27537A` (Dark Steel Blue)
    *   Body: `#6B6C6E` (Dark Grey)
    *   Muted: `#94A3B8` (Slate 400)

### 📐 Layout & Responsiveness
The UI is built to be responsive using a custom `AppDimensions` utility.

*   **Breakpoints**:
    *   **Mobile**: < 600px width
    *   **Tablet**: 600px - 1199px width
    *   **Desktop**: >= 1200px width
*   **Orientation**: Optimized for Landscape (Tablet/Desktop) but supports Portrait (Login/Mobile).

### 🧩 UI Components & Styling

#### Cards & Containers
*   **Border Radius**:
    *   Small: 8px
    *   Medium: 12px
    *   Large: 16px
*   **Shadows**: Soft, diffused shadows for depth.
    *   *Example*: `BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 50, offset: Offset(0, 25))`
*   **Borders**: Subtle borders using Slate 100/200 (`#F1F5F9` / `#E2E8F0`).

#### Inputs
*   **Background**: `#F8FAFC` (Slate 50)
*   **Border**: `#E2E8F0` (Slate 200) default, Primary Color on focus.
*   **Height**: Generous padding (16px vertical).

#### Buttons
*   **Primary**: Solid background (`#330DF2`), White text, Medium Radius (12px).
*   **Outlined**: White background, Slate Text, Slate 200 Border.

## 🖼️ Key Screens

### Login Screen
*   **Background**: Full-screen image with a Blur Filter (`sigmaX: 2.0`, `sigmaY: 2.0`) and White overlay (80% opacity).
*   **Center Card**:
    *   Floating white card with deep shadow.
    *   **Logo**: 48x48px container, Primary color, white icon (`storefront`).
    *   **Fields**: Email, Password (with visibility toggle).
    *   **Actions**: "Remember me" checkbox, "Forgot Password?" link.
    *   **Social**: "Sign in with Google" (Outlined button).
*   **Decorative**: Bottom gradient strip (Primary -> Indigo 500 -> Primary).

### Dashboard (Planned)
*   **Layout**: Sidebar navigation (collapsible on mobile) + Main Content Area.
*   **Header**: Search bar, User profile, Notifications.
*   **Grid**: Responsive grid for stats cards and menu items.
