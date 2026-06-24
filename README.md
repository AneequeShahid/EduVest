# EduVest 🎓💰
> **Student Personal Finance App** — Track expenses, set savings goals, and manage your education budget — all in one place.

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Enabled-FFCA28?logo=firebase)](https://firebase.google.com)
[![Riverpod](https://img.shields.io/badge/State-Riverpod-00B0FF)](https://riverpod.dev)
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)

---

## 📱 Features

| Feature | Description |
|---------|-------------|
| 🔐 **Authentication** | Email/password sign-up & login with Firebase Auth |
| 💸 **Expense Tracking** | Add, edit, and categorise expenses with optional receipt photos |
| 📊 **Budget Manager** | Set monthly limits and per-category budgets with live usage meters |
| 🎯 **Savings Goals** | Create goals, add funds, and celebrate completions with animation |
| 📈 **Insights** | Visual spending breakdown with `fl_chart` pie and bar charts |
| 🔔 **Smart Alerts** | Budget-overspend and goal-achievement notifications |
| 🌙 **Dark Mode** | Full light/dark theme with user preference persisted to Firestore |
| 🔒 **Secure Screen** | Flutter Window Manager hides sensitive data from recent-apps preview |
| 📶 **Offline First** | Firestore offline persistence — works without internet |
| 📱 **Responsive** | Single codebase scales from mobile → tablet → web (max 600 px content column) |

---

## 🏗 Architecture

The project follows **Clean Architecture** with strict layer separation:

```
lib/
├── core/
│   ├── constants/        # AppColors, AppSizes (with breakpoints), AppStrings, AppTextStyles
│   ├── routes/           # go_router config + named routes
│   ├── theme/            # Light theme, Dark theme, ThemeNotifier
│   ├── utils/            # Date, currency, validators
│   └── widgets/          # Shared: AppButton, AppTextField, EmptyState, ErrorState, LoadingOverlay …
│
└── features/
    ├── authentication/   # Email/password auth — login, signup, session observer
    ├── expense/          # Add/edit expense, receipt upload to Firebase Storage
    ├── budget/           # Monthly + category budgets, smart insight cards
    ├── goals/            # Savings goals CRUD, add-funds, completion animation
    ├── insights/         # Monthly spending charts from Firestore aggregation
    ├── home/             # Dashboard — balance card, recent transactions stream
    ├── settings/         # Profile, notifications, theme, biometric, change password
    └── splash/           # Branded splash while auth state resolves
```

Each feature contains:
- `domain/entities` → Pure Dart models
- `domain/repositories` → Abstract interfaces
- `domain/usecases` → Single-responsibility use cases
- `data/datasources` → Firebase datasource implementations
- `data/models` → Firestore serialization (`fromJson` / `toJson`)
- `presentation/providers` → Riverpod state notifiers
- `presentation/pages` → UI screens
- `presentation/widgets` → Feature-specific widgets

---

## 🔧 Tech Stack

| Layer | Library |
|-------|---------|
| UI Framework | Flutter 3.x |
| State Management | `flutter_riverpod` ^2.5 |
| Navigation | `go_router` ^14 |
| Backend | Firebase (Auth, Firestore, Storage, Analytics, Crashlytics) |
| Charts | `fl_chart` |
| Fonts | `google_fonts` |
| Image Picker | `image_picker` |
| Local Storage | `shared_preferences` + `flutter_secure_storage` |
| Connectivity | `connectivity_plus` |
| Biometric | `local_auth` |
| Code Gen | `build_runner`, `freezed`, `riverpod_generator` |

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK ≥ 3.0
- Firebase CLI (`npm install -g firebase-tools`)
- FlutterFire CLI (`dart pub global activate flutterfire_cli`)

### 1. Clone the repo
```bash
git clone https://github.com/AneequeShahid/EduVest.git
cd EduVest
```

### 2. Create Firebase project
Go to [console.firebase.google.com](https://console.firebase.google.com) → **New Project** → enable:
- ✅ Email/Password Authentication
- ✅ Cloud Firestore (production mode)
- ✅ Firebase Storage
- ✅ Firebase Analytics
- ✅ Firebase Crashlytics

### 3. Connect Firebase to Flutter
```bash
flutterfire configure
```
This auto-generates `lib/firebase_options.dart`. **Replace the placeholder file.**

### 4. Install dependencies
```bash
flutter pub get
```

### 5. Deploy Firestore & Storage rules
```bash
firebase deploy --only firestore:rules,storage:rules
```

### 6. Run the app
```bash
# Development
flutter run

# Release build
flutter build apk --release
flutter build ios --release
```

---

## 🔒 Security Rules

### Firestore (`firestore.rules`)
```
match /databases/{database}/documents {
  match /users/{userId}/{document=**} {
    allow read, write: if request.auth != null && request.auth.uid == userId;
  }
}
```

### Storage (`storage.rules`)
```
match /b/{bucket}/o {
  match /receipts/{userId}/{allPaths=**} {
    allow read, write: if request.auth != null
      && request.auth.uid == userId
      && request.resource.size < 5 * 1024 * 1024
      && request.resource.contentType.matches('image/.*');
  }
}
```

---

## 📂 Firestore Data Model

```
users/{uid}/
├── profile          → { name, email, displayName }
├── settings/prefs   → { budgetAlerts, goalAchievements, selectedTheme, biometricEnabled … }
├── expenses/{id}    → { amount, description, category, date, isIncome, receiptUrl }
├── budget/current   → { totalLimit, totalSpent, categories: [...] }
├── goals/{id}       → { title, targetAmount, savedAmount, deadline, emoji }
├── transactions/{id}→ { amount, category, description, date, type }
└── insights/{yyyy-MM} → { totalSpent, categoryBreakdown, financialScore }
```

---

## 🧪 Testing

```bash
# Unit & widget tests
flutter test

# Integration tests
flutter test integration_test/
```

Test utilities included:
- `fake_cloud_firestore` for Firestore mocking
- `firebase_auth_mocks` for Auth mocking
- `mockito` for use-case mocking

---

## 📋 Key Architecture Decisions

| Decision | Reason |
|----------|--------|
| **Riverpod over Bloc** | Less boilerplate, better DI, `ref.watch` auto-disposes |
| **go_router** | Declarative routing with redirect guards for auth state |
| **ConstrainedBox (600 px)** | Mobile-first layout that gracefully scales to tablet/web |
| **Firestore streams** | Real-time updates via `.snapshots()` without polling |
| **SecureScreen widget** | Wraps sensitive pages to hide content in recent-apps |
| **Offline persistence** | `persistenceEnabled: true` lets app work without internet |
| **`AppSizes.kMaxContentWidth`** | Single constant drives all responsive constraints |

---

## 📁 Project Structure

```
eduvest/
├── android/
├── ios/
├── lib/
│   ├── core/
│   └── features/
├── test/
├── integration_test/
├── firestore.rules
├── storage.rules
├── functions/
│   ├── index.js          # aggregateMonthlyInsights + onExpenseCreated
│   └── package.json
└── pubspec.yaml
```

---

## 👤 Developer

**Aneeque Shahid**
- GitHub: [@AneequeShahid](https://github.com/AneequeShahid)

---

*Built with ❤️ using Flutter & Firebase*
