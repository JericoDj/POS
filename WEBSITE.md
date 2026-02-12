# Leo's POS – Application & Design Specification

## 📱 Application Overview

*   **Name:** Queen’s Cafe (Internal: Leo’s POS)
*   **Type:** Tablet-first Point of Sale (POS) System
*   **Platforms:** Android, iOS, Web (Responsive)
*   **Core Tech:** Flutter, Provider, GoRouter

---

# 🎨 Design System

## 🎨 Color Palette

A calm, professional palette using neutral greys, muted teal, deep steel blue, and warm mustard gold.

### Primary Colors

| Role      | Color           | Hex       | Usage                                                          |
| :-------- | :-------------- | :-------- | :------------------------------------------------------------- |
| Primary   | Deep Steel Blue | `#376184` | Primary buttons, navigation highlights, active states, headers |
| Secondary | Muted Teal      | `#81ADBC` | Secondary backgrounds, info cards, charts                      |
| Accent    | Mustard Gold    | `#E3B23C` | CTAs, warnings, revenue highlights, badges                     |

### Neutral Colors

| Role          | Hex       | Usage             |
| :------------ | :-------- | :---------------- |
| Dark Neutral  | `#6B6C6E` | Body text         |
| Light Neutral | `#D0D0D0` | Borders, dividers |
| White         | `#FFFFFF` | Surfaces          |
| Border Light  | `#E5E7EB` | Card borders      |
| Muted Text    | `#9CA3AF` | Secondary text    |

### Status Colors

| Status  | Color     |
| :------ | :-------- |
| Success | `#16A34A` |
| Warning | `#E3B23C` |
| Error   | `#DC2626` |
| Info    | `#81ADBC` |

---

## 🖋 Typography

| Element             | Color     |
| :------------------ | :-------- |
| Headings            | `#376184` |
| Body Text           | `#6B6C6E` |
| Muted Text          | `#9CA3AF` |
| Accent Text on Gold | `#1F2937` |

---

# 📐 Layout & Responsiveness

### Breakpoints

| Device  | Width            |
| :------ | :--------------- |
| Mobile  | < 600px          |
| Tablet  | 600px – 1199px   |
| Desktop | ≥ 1200px         |

**Optimized primarily for:**
*   Landscape tablet POS
*   Desktop admin usage
*   Mobile login & quick access

---

# 🧩 UI Components

## 🪟 Cards & Containers

### Border Radius
*   Small: 8px
*   Medium: 12px
*   Large: 16px

### Shadows

Soft, diffused elevation used for cards and floating containers.

**Shadow Spec:**

- Color: Black at 8% opacity
- Blur Radius: 30
- Offset: 0px horizontal, 10px vertical

### Backgrounds
| Component       | Color                  |
| :-------------- | :--------------------- |
| Primary Surface | `#FFFFFF`              |
| Secondary Panel | `#F8FAFB`              |
| Highlight Panel | Light tint of `#81ADBC`|

## 🔤 Inputs

| Property       | Value             |
| :------------- | :---------------- |
| Background     | `#F8FAFB`         |
| Border Default | `#D0D0D0`         |
| Border Focus   | `#376184`         |
| Radius         | 12px              |
| Padding        | 16px vertical     |

## 🔘 Buttons

### Primary Button
*   **Background:** `#376184`
*   **Text:** `#FFFFFF`
*   **Radius:** 12px
*   **Hover:** Slightly darker blue
*   **Disabled:** 40% opacity

### Secondary Button
*   **Background:** `#81ADBC`
*   **Text:** `#1F2937`

### Accent Button (CTA)
*   **Background:** `#E3B23C`
*   **Text:** `#1F2937`
*   **Usage:** Upgrade, Subscribe, Key Actions

### Outlined Button
*   **Background:** `#FFFFFF`
*   **Border:** `#D0D0D0`
*   **Text:** `#376184`

---

# 🖼 Key Screens

## 🔐 Login Screen

### Background
*   Full-screen image with Blur effect.
*   White overlay (85% opacity).
*   Optional subtle blue tint overlay.

### Center Card
*   White background, 16px border radius, Soft shadow.
*   Centered layout.

### Logo Container
*   Background: `#376184`
*   Icon: White
*   Size: 48x48px, Radius: 12px

### Decorative Elements
*   Subtle bottom divider in muted teal.
*   No heavy gradients.

## 📊 Dashboard

### Layout
*   Sidebar navigation (collapsible on mobile).
*   Header bar with search & profile.
*   Main grid layout.

### Sidebar
*   **Background:** White
*   **Active Item:** Light tint of `#81ADBC`
*   **Active Icon/Text:** `#376184`
*   **Hover:** Light grey background

### Charts
*   **Primary Data:** `#376184`
*   **Secondary Data:** `#81ADBC`
*   **Highlight:** `#E3B23C`
*   **Gridlines:** `#E5E7EB`

---

# 🎯 Visual Tone

The design system emphasizes:
*   **Calm professionalism**
*   **Retail & café friendliness**
*   **Modern SaaS clarity**
*   **Soft shadows & subtle depth**
*   **Trust-focused visual hierarchy**

*This palette removes heavy indigo tones and replaces them with a balanced blue–teal–gold system suitable for commercial POS environments.*