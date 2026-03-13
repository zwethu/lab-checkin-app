# Smart Class Check-in & Learning Reflection App – PRD

## Problem Statement

In university classes, it is difficult to confirm that students are physically
present and engaged. Traditional attendance methods (paper sign-in, manual
lists) only record presence and do not capture how students feel before class
or what they learned after class. A simple cross-platform application is needed
to record attendance with location, collect short learning reflections at the
beginning and end of each class, and let students review their own recent
check-in history.

## Target User

- **Primary user:** University students attending a specific course
  (e.g., Mobile Application Development).
- **Secondary user (indirect, out of scope for this lab):** Instructors who
  may later analyse attendance and reflection data.

## Feature List

1. **Class List**
    - Classes are fetched in real time from Firestore (`classes` collection).
    - Each class card shows name, time, and room.
    - Button state changes based on check-in status:
      **Check-in → Finish Class → Completed ✓**

2. **Class Check-in (Before Class)**
    - Student taps **"Check-in"** on a class card.
    - App records current timestamp and GPS location (via Geolocator).
    - Student fills in a short form:
        - Student ID (text field)
        - Topic covered in the previous class
        - Topic expected to learn today
        - Mood before class (1–5 scale with emoji labels)
    - On submit: record is created in Firestore `checkins` collection and
      cached in Hive (native) or Firestore state (web).

3. **Class Completion (After Class)**
    - Student taps **"Finish Class"** on the same class card.
    - App records current timestamp and GPS location again.
    - Student fills in:
        - What they learned today (required)
        - Feedback about the class or instructor (optional)
    - On submit: existing Firestore document is updated with finish data.

4. **History View**
    - Home screen shows a scrollable history list below the class cards.
    - Each history item shows: class name, date, mood score, student ID,
      and what was learned.
    - On **web**: history is loaded from Firestore via `syncFromFirestore()`
      on app startup (Firestore is the source of truth).
    - On **native**: history is cached in Hive for offline access and synced
      from Firestore on startup.

5. **Landing Page**
    - A standalone marketing/info page accessible at `/landing`.
    - Describes the app features with a responsive desktop/mobile layout.
    - "Get Started" button navigates to the main app at `/`.

## User Flow

1. Student opens the app — lands on **Home Screen** (`/`).
2. Home screen loads today's classes from Firestore.
3. **Before class:**
    - Student taps **"Check-in"** on a class card → navigates to `/checkin`.
    - App fetches GPS location and current timestamp.
    - Student fills in the Check-in Form and submits.
    - App saves to Firestore + Hive (native) and returns to Home.
    - Class card button changes to **"Finish Class"**.
4. **After class:**
    - Student taps **"Finish Class"** → navigates to `/finish`.
    - App fetches GPS location and timestamp.
    - Student fills in the Finish Class Form and submits.
    - App updates the Firestore document and returns to Home.
    - Class card button changes to **"Completed ✓"** (disabled).
5. **History:**
    - Visible on Home Screen below class cards.
    - Loaded from Firestore on startup; cached in Hive on native.

## Data Fields

### Firestore collection: `classes`

| Field | Type | Description |
|---|---|---|
| `name` | string | Class name |
| `time` | string | Class time (e.g. "09:00–12:00") |
| `room` | string | Room number |

### Firestore collection: `checkins`

Each document (one per student per class per session):

| Field | Type | Description |
|---|---|---|
| `classId` | string | Reference to class document ID |
| `className` | string | Class name |
| `studentId` | string | Student ID entered by user |
| `classDate` | string (ISO 8601) | Date of the session |
| `checkinTime` | string (ISO 8601) | Timestamp of check-in |
| `checkinLat` | double | GPS latitude at check-in |
| `checkinLng` | double | GPS longitude at check-in |
| `previousTopic` | string | Topic from previous class |
| `expectedTopic` | string | Expected topic today |
| `moodBefore` | int (1–5) | Mood before class |
| `finishTime` | string / null | Timestamp of finish |
| `finishLat` | double / null | GPS latitude at finish |
| `finishLng` | double / null | GPS longitude at finish |
| `learnedToday` | string / null | What the student learned |
| `classFeedback` | string / null | Optional feedback |

### Hive local box: `checkin_history` (native only)

| Field | Type |
|---|---|
| `classId` | string |
| `className` | string |
| `classDate` | string |
| `studentId` | string |
| `moodBefore` | int |
| `checkinTime` | string |
| `firestoreDocId` | string |
| `learnedToday` | string / null |

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter 3.24.3 |
| Platforms | Android, Web |
| State Management | Provider |
| Routing | go_router |
| Backend / BaaS | Firebase Firestore |
| Local Cache | Hive (native only) |
| Location | Geolocator 10.x |
| Hosting | Firebase Hosting |

## Deployment

| URL | Description |
|---|---|
| `https://my-lab-checkin-app-79.web.app/` | Main app |
| `https://my-lab-checkin-app-79.web.app/landing` | Landing page |
