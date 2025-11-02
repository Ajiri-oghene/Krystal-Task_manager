# Task Manager

![Flutter](https://img.shields.io/badge/Flutter-3.6.1-blue?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.6.1-blue?logo=dart)
![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)
![Platform](https://img.shields.io/badge/platform-Android%20%7C%20iOS-lightgrey)

> **A modern, offline-first task manager** with customizable task groups, real-time progress tracking, and a clean, intuitive interface — all powered by **Flutter** and **Hive**.

---

---

## Features

- **Overall Progress Indicator** – See completion % of all tasks at a glance
- **Task Groups** – Organize tasks into named groups with descriptions
- **Search** – Find groups by name or description
- **FAB to Add Group** – Quick dialog with **Name**, **Description**, **Add/Cancel**
- **Group Card** – Circular progress, task count, long-press to delete
- **Task Detail Screen** –
  - Back button + Edit group
  - Stats: Total / Pending / Completed
  - Filter tabs: **All | Pending | Completed**
  - Add new tasks with checkbox + delete
- **Offline-First** – All data stored locally with **Hive**
- **Custom Splash & App Icon** – Professional branding

---

## Tech Stack

| Layer            | Technology                               |
| ---------------- | ---------------------------------------- |
| Framework        | Flutter (3.6.1+)                         |
| Language         | Dart                                     |
| State Management | Provider                                 |
| Local Database   | Hive + hive_flutter                      |
| UI/Animations    | Material 3, flutter_svg, page_transition |
| Fonts            | Montserrat (Custom)                      |
| Splash Screen    | flutter_native_splash                    |
| App Icons        | flutter_launcher_icons                   |

---

## Getting Started

### Prerequisites

- Flutter SDK (>= 3.6.1)
- Dart (>= 3.0.0)
- Android Studio or Xcode (for emulators)

### Installation

```bash
# Clone the repo
git clone https://github.com/Ajiri-oghene/Krystal-Task_manager
cd Task_manager

# Get dependencies
flutter pub get
```
