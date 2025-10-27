  Offline Learning Progress Tracker

A Flutter mobile app that demonstrates offline-first architecture with automatic cloud sync. Built as a technical assessment for an Offline Functionality Developer position.

   What It Does

This app lets students:
- Create and manage multiple user profiles
- Answer quiz questions (currently 3 math problems)
- Save all progress locally without internet
- Automatically sync data to Firebase when connection is available

The main goal was to show how offline-first architecture works in a real mobile application.

 Screenshots

User Selection

<img width="591" height="1280" alt="image" src="https://github.com/user-attachments/assets/f9c652bc-eab5-49a7-8204-07fcc9b291cc" />

Quiz Activity

<img width="591" height="1280" alt="image" src="https://github.com/user-attachments/assets/db285440-27e6-45f0-adae-f4155b561f89" />

Results

<img width="591" height="1280" alt="image" src="https://github.com/user-attachments/assets/57ad71e5-4303-4895-8388-6f00c24e68a6" />
<img width="591" height="1280" alt="image" src="https://github.com/user-attachments/assets/cccf194c-2180-4e2b-a8e4-42df85ee6308" />





 Tech Stack

  Frontend:
- Flutter 3.x
- Dart 3.x

Local Storage:
- Hive (NoSQL embedded database)

State Management:
- Provider pattern

Cloud Sync:
- Firebase Firestore

Network Detection:
- connectivity_plus package

 Key Features

Core Functionality:
- Complete offline support - app works with zero internet
- Multi-user profiles with independent progress tracking
- Automatic background sync when online
- Real-time sync status updates

User Experience:
- Swipe left to delete profiles
- Answer validation before moving to next question
- Progress tracking and score calculation
- Clean, simple interface

 How It Works

The app follows an offline-first approach. Here's the data flow:

1. User action happens (create profile, answer question)
2. Data immediately saved to local Hive database
3. App checks network status
4. If online: data syncs to Firebase in background
5. If offline: data queued for later sync
6. When connection restored: automatic batch upload

All features work without internet. Cloud sync is just a backup.
