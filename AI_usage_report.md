# AI Usage Report

## Tools Used

- **Perplexity AI** — primary AI assistant used throughout the lab exam

## What AI Helped Generate

- **PRD structure** — AI helped draft the Product Requirement Document
  including problem statement, user flow, data fields, and tech stack table
- **Landing page UI** — full responsive landing page with mobile/desktop
  layouts, feature cards, and header (`landing_page.dart`)
- **Router setup** — `go_router` configuration with named routes for
  `/`, `/landing`, `/checkin`, `/finish`
- **`location_helper.dart`** — Geolocator helper function with
  permission handling
- **Firebase Hosting config** — `firebase.json` hosting section with
  SPA rewrite rules
- **README** — project description, setup instructions, and
  Firebase configuration notes

## What I Implemented / Modified Myself

- Resolved version conflicts with the `geolocator` package to ensure
  compatibility with Flutter 3.24.3
- Set up the Firebase project and populated the Firestore `classes`
  collection with real class data
- Diagnosed and fixed the initial routing error where the app always
  loaded at `/` instead of the intended route
- Redesigned the Home Screen layout and refined the overall app flow
- Fixed button text visibility issues and updated the primary button
  style across the app
