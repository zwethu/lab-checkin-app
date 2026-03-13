
# Smart Class Check-in & Learning Reflection App – PRD

## Problem Statement

In university classes, it is difficult to confirm that students are physically present and engaged. Traditional attendance methods (paper sign-in, manual lists) only record presence and do not capture how students feel before class or what they learned after class. A simple cross-platform application is needed to record attendance with location, collect short learning reflections at the beginning and end of each class, and let students review their own recent check-in history.

## Target User

- **Primary user:** University students attending a specific course (e.g., Mobile Application Development).
- **Secondary user (indirect, out of scope for this lab):** Instructors who may later analyse attendance and reflection data.

## Feature List

1. **Student Identification**
   - Student enters their Student ID in a text field.
   - Student selects a class from a simple predefined list (mock classes).

2. **Class Check-in (Before Class)**
   - Student taps a “Check-in Before Class” button.
   - App records current timestamp and GPS location.
   - App displays a short form:
     - Topic covered in the previous class (short text).
     - Topic the student expects to learn today (short text).
     - Mood before class (1–5 scale with emoji labels).

3. **Class Completion (After Class)**
   - Student taps a “Finish Class” button.
   - App records current timestamp and GPS location again.
   - App displays a short form:
     - What the student learned today (short text).
     - Feedback about the class or instructor (short text).

4. **History (Local View)**
   - The app stores a list of the student’s recent check-ins locally on the device using Hive (or similar local storage).
   - A simple “History” page shows recent sessions for the current Student ID: class name, date, mood before class, and a short summary of what was learned.
   - This history is read from local storage for quick access and works even when offline.

5. **Data Storage**
   - All official data is stored in Cloud Firestore.
   - One Firestore record links both the before-class check-in and the after-class completion for a student, class, and date/session.
   - Selected fields (e.g., studentId, className, classDate, moodBefore, learnedToday) are cached locally in Hive for the history view. [web:52][web:58][web:62]

## User Flow

1. Student opens the app on web or Android.
2. Student enters **Student ID** and selects a **Class** from a dropdown.
3. **Before class:**
   - Student taps **“Check-in Before Class”**.
   - App fetches GPS location and current time.
   - App shows the **Check-in Form** (previous topic, expected topic, mood).
   - Student submits the form; the app creates a new record in Firestore and optionally adds a summary entry to local Hive history.
4. **After class:**
   - Student (with the same Student ID and Class) taps **“Finish Class”**.
   - App fetches GPS location and time again.
   - App shows the **Finish Class Form** (what I learned, feedback).
   - Student submits the form; the app updates the existing Firestore record and updates the corresponding local history entry.
5. **History view (optional for student):**
   - Student taps a **“History”** button.
   - App reads recent session summaries from Hive and displays them in a simple list.

(For this lab, we assume simple mock classes and a single active session per class per day.)

## Data Fields

Firestore collection: `checkins`

Each document (one per student per class per session) contains:

- `id` (auto-generated)
- `studentId` (string)
- `className` (string, e.g. `"Mobile Application Development"`)
- `classDate` (timestamp or date-only)

**Before class (check-in):**
- `checkinTime` (timestamp)
- `checkinLat` (double)
- `checkinLng` (double)
- `previousTopic` (string)
- `expectedTopic` (string)
- `moodBefore` (int, 1–5)

**After class (completion):**
- `finishTime` (timestamp, optional until submitted)
- `finishLat` (double, optional)
- `finishLng` (double, optional)
- `learnedToday` (string, optional)
- `classFeedback` (string, optional)

Hive local storage (example box: `historyBox`):

Each item (simplified summary):

- `studentId` (string)
- `className` (string)
- `classDate` (string or DateTime)
- `moodBefore` (int)
- `learnedToday` (string, short)
- (optional) `checkinTime` (string), `finishTime` (string)

## Tech Stack

- **Framework:** Flutter
- **Platforms:** Android, Web
- **Backend / BaaS:** Firebase
  - Cloud Firestore for main data storage
- **Local storage:** Hive for simple history caching and preferences 
- **Location:** Geolocator (or equivalent) for GPS location

