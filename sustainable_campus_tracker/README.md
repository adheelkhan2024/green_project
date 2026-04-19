# Sustainable Campus Projects Tracker

Flutter mobile application for tracking campus sustainability projects, coordinating teams, monitoring progress, storing supporting document references, sending in-app notifications, and generating AI-based project insights.

## Features

- Login and registration with role-based access for Admin and Student/User
- Create, update, and delete sustainability projects
- Dashboard with project status and progress overview
- Project details with progress, team, documents, and AI summary
- Team member assignment with roles and contribution notes
- Document upload using device file picker
- In-app notifications for deadlines and project changes
- AI progress analysis, delay prediction, completion success score, and sustainability impact estimation
- Local SQLite storage for offline-friendly academic demonstration

## Run in Android Studio or VS Code

1. Install Flutter SDK from `https://flutter.dev`.
2. Open this folder: `sustainable_campus_tracker`.
3. Run:

```bash
flutter pub get
flutter run
```

For Android Studio, open the folder, choose an Android emulator or connected device, then click Run.

## Demo Accounts

The app creates two accounts on first launch:

- Admin: `admin@campus.edu` / `Admin123!`
- Student: `student@campus.edu` / `Student123!`

## Scrum Delivery Summary

### Product Backlog

- User authentication and roles
- Sustainability project CRUD
- Progress monitoring
- Team collaboration
- Supporting document upload
- In-app notifications
- AI insights and prediction
- Security and input validation

### Sprint 1

- Authentication
- Dashboard
- Project list and details
- SQLite storage foundation

### Sprint 2

- Create/edit/delete projects
- Team roles and contributions
- Document upload metadata
- Notifications

### Sprint 3

- AI progress analysis
- Sustainability impact scoring
- Charts and polish
- Review, security checks, and final documentation

### Review and Retrospective

The final increment centralizes sustainability tracking, supports collaboration, provides real project progress monitoring, and includes a real rule-based AI analysis service suitable for academic evaluation without requiring paid APIs.