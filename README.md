# Convene — Mobile

> Meeting management mobile application built with Flutter.

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=flat-square&logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?style=flat-square&logo=dart)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-lightgrey?style=flat-square)

---

## Overview

Convene is a sleek, dark-themed meeting management app for mobile. It mirrors the feature set of the Convene web app in a native mobile experience — complete with a glassmorphism bottom navigation bar, smooth animations, and a participant picker for scheduling meetings on the go.

This project was built as a mobile UI prototype / portfolio showcase. A dummy data layer is used in place of live API calls, making the app fully runnable without any backend setup.

---

## Features

- **Login Screen** — Username/password form with the Convene logo, password visibility toggle, and dummy auth flow
- **Dashboard (Home)** — Today's meeting summary banner, upcoming meetings list (next 7 days), live search, and pull-to-refresh
- **Calendar** — Month grid with dot indicators on days that have meetings; tap a day to see its schedule
- **Contacts** — 15-person team directory grouped by department, expandable contact cards with email, phone extension, and a "Schedule Meeting" shortcut
- **Create Meeting** — Full form: Virtual/Physical toggle, date picker, start/end time picker, **searchable participant picker** (from contacts), and agenda editor
- **Quick Add** — Minimal form: title, date preset (Today / Tomorrow / Next Mon), duration (30m / 1h), recurring toggle, and live summary preview
- **Settings** — Profile card, appearance/account sections, and sign-out
- **Glassmorphism Nav Bar** — Frosted-glass bottom navigation with animated active indicator
- **Dark Theme** — Consistent dark UI throughout

---

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter 3.x |
| Language | Dart 3.x |
| Navigation | go_router 14.x |
| Date formatting | intl |
| SVG rendering | flutter_svg |
| Local storage | shared_preferences |
| State management | StatefulWidget (built-in) |

---

## Project Structure

```
lib/
├── main.dart                           # App entry, GoRouter config, shell layout
├── core/
│   ├── api_client.dart                 # HTTP client (Bearer token auth)
│   └── theme.dart                      # AppColors, MaterialTheme, navBarBottom()
├── data/
│   └── dummy.dart                      # DummyUser, DummyContact (15), buildDummyMeetings() (10)
├── models/
│   └── meeting.dart                    # Meeting, MeetingParticipant, MeetingUser, TodayDashboard
├── services/
│   └── meeting_service.dart            # Data layer — returns dummy data via Future.value()
├── screens/
│   ├── login/
│   │   └── login_screen.dart           # Login screen with SVG logo
│   ├── home/
│   │   └── home_screen.dart            # Dashboard with FAB menu
│   ├── calendar/
│   │   └── calendar_screen.dart        # Monthly calendar view
│   ├── contacts/
│   │   └── contacts_screen.dart        # Dept-grouped contact directory
│   ├── meetings/
│   │   ├── create_meeting_screen.dart  # Full meeting creation form
│   │   └── quick_add_screen.dart       # Quick meeting creation
│   └── settings/
│       └── settings_screen.dart        # User settings
└── widgets/
    ├── avatar_widget.dart              # Circular avatar with initials fallback
    ├── glass_nav_bar.dart              # Glassmorphism bottom nav bar
    ├── meeting_card.dart               # Meeting list item
    ├── participant_picker.dart         # Searchable contact picker with selected list
    └── today_banner.dart               # Today's schedule summary card

assets/
└── icon/
    ├── icon_light.svg                  # App logo (light variant)
    └── icon.png                        # Launcher icon
```

---

## Getting Started

### Prerequisites

- Flutter SDK 3.10+
- Dart SDK 3.x
- Android Studio / Xcode (for device/emulator)

### Installation

```bash
# Clone the repository
git clone <repo-url>
cd mobile

# Install dependencies
flutter pub get
```

### Run

```bash
# Run on connected device or emulator
flutter run

# Build APK
flutter build apk --release

# Build iOS
flutter build ios --release
```

---

## Architecture Notes

### Navigation
Uses **GoRouter** with a `ShellRoute` that wraps the four main tabs (Home, Calendar, Contacts, Settings) with the persistent glass nav bar. Modal routes (`/meetings/new`, `/meetings/quick`, `/login`) sit outside the shell and render full-screen without the bottom nav.

```
/login                  → LoginScreen (no nav bar)
/ (shell)
  ├── /                 → HomeScreen
  ├── /calendar         → CalendarScreen
  ├── /contacts         → ContactsScreen
  └── /settings         → SettingsScreen
/meetings/new           → CreateMeetingScreen (no nav bar)
/meetings/quick         → QuickAddScreen (no nav bar)
```

### Data Layer
`MeetingService` methods all return `Future.value(DUMMY_DATA)` — the same pattern as the web's `api.ts`. Switching to real API calls requires only updating `lib/services/meeting_service.dart` and restoring the `ApiClient` calls.

### Theme
All colors are defined as constants in `lib/core/theme.dart` under `AppColors`. The UI uses a single dark theme throughout — no light/dark switching on mobile.

---

## Screenshots

> _Coming soon — add screenshots or a screen recording of the app here._

---

## Author

Built by **deenqtt**
# Convene-Mobile-App
