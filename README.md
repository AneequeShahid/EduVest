# EduVest — Firebase Backend Integration Guide

## What Was Added

All 12 Firebase requirements from the architecture prompt have been implemented. Here is a summary of every new file and what changed.

---

## New Files Created

### Auth Feature (`lib/features/auth/`)
| File | Purpose |
|------|---------|
| `data/datasources/auth_firebase_datasource.dart` | Calls `FirebaseAuth.instance.signInAnonymously()` |
| `data/datasources/auth_repository_impl.dart` | Implements `AuthRepository` via datasource |
| `domain/repositories/auth_repository.dart` | Abstract interface |
| `domain/usecases/sign_in_anonymously_usecase.dart` | Called once in `main.dart` before `runApp()` |
| `domain/usecases/get_current_uid_usecase.dart` | Exposes uid after sign-in |

### Expense Feature — updated files
| File | What Changed |
|------|-------------|
| `data/datasources/expense_firebase_datasource.dart` | **New** — replaces `expense_local_datasource.dart`. Writes to `users/{uid}/expenses`, uploads receipts to Storage |
| `data/datasources/expense_repository_impl.dart` | Updated to use `ExpenseFirebaseDataSource` |
| `data/models/expense_model.dart` | Updated — `toJson()`/`fromJson()` now uses Firestore `Timestamp`, added `receiptUrl` field |
| `domain/repositories/expense_repository.dart` | Added `uploadReceipt()` method |
| `domain/usecases/upload_receipt_usecase.dart` | **New** |
| `presentation/providers/expense_provider.dart` | Updated — now orchestrates 4 usecases: add expense → upload receipt → add transaction → update budget |

### Transaction Feature — all new (`lib/features/transaction/`)
| File | Purpose |
|------|---------|
| `domain/entities/transaction.dart` | Pure Dart entity with `date` field |
| `domain/repositories/transaction_repository.dart` | Abstract interface |
| `domain/usecases/add_transaction_usecase.dart` | Writes one transaction doc |
| `domain/usecases/watch_transactions_usecase.dart` | Returns live `Stream<List<Transaction>>` |
| `data/models/transaction_model.dart` | Firestore serialization |
| `data/datasources/transaction_firebase_datasource.dart` | `.snapshots()` stream, ordered by date desc, limit 10 |
| `data/datasources/transaction_repository_impl.dart` | Implements interface via datasource |

### Budget Feature — all new (`lib/features/budget/`)
| File | Purpose |
|------|---------|
| `domain/entities/budget.dart` | `monthlyLimit`, `monthlySpent`, `categoryLimits`, `categorySpending` |
| `domain/repositories/budget_repository.dart` | Abstract interface |
| `domain/usecases/get_budget_usecase.dart` | One-time fetch |
| `domain/usecases/update_category_spending_usecase.dart` | Called by `ExpenseProvider` after adding an expense |
| `data/models/budget_model.dart` | Firestore serialization |
| `data/datasources/budget_firebase_datasource.dart` | Uses `FieldValue.increment` for atomic updates |
| `data/datasources/budget_repository_impl.dart` | Implements interface via datasource |
| `presentation/providers/budget_provider.dart` | Calls `GetBudgetUseCase` on `loadBudget()` |

### Goals Feature — all new (`lib/features/goals/`)
| File | Purpose |
|------|---------|
| `domain/entities/goal.dart` | Full Goal entity with progress helpers |
| `domain/repositories/goals_repository.dart` | Abstract interface |
| `domain/usecases/get_goals_usecase.dart` | Fetch all goals |
| `domain/usecases/add_goal_usecase.dart` | Create a goal |
| `domain/usecases/add_funds_usecase.dart` | Increments `savedAmount` via `FieldValue.increment` |
| `domain/usecases/delete_goal_usecase.dart` | Deletes a goal doc |
| `data/models/goal_model.dart` | Firestore serialization |
| `data/datasources/goals_firebase_datasource.dart` | CRUD on `users/{uid}/goals` |
| `data/datasources/goals_repository_impl.dart` | Implements interface via datasource |
| `presentation/providers/goals_provider.dart` | All four usecases injected |

### Insights Feature — all new (`lib/features/insights/`)
| File | Purpose |
|------|---------|
| `domain/entities/insights.dart` | `totalSpent`, `categoryBreakdown`, `financialScore`, etc. |
| `domain/repositories/insights_repository.dart` | Abstract interface |
| `domain/usecases/get_insights_usecase.dart` | Fetch current month's insights |
| `data/models/insights_model.dart` | Firestore deserialization |
| `data/datasources/insights_firebase_datasource.dart` | Reads `users/{uid}/insights/{yyyy-MM}` |
| `data/datasources/insights_repository_impl.dart` | Implements interface via datasource |
| `presentation/providers/insights_provider.dart` | Calls `GetInsightsUseCase` on `loadInsights()` |

### Settings Feature — updated files
| File | What Changed |
|------|-------------|
| `data/datasources/settings_firebase_datasource.dart` | **New** — replaces `settings_local_datasource.dart`. Reads/writes `users/{uid}/settings/prefs` |
| `data/datasources/settings_repository_impl.dart` | Updated to inject `SettingsFirebaseDataSource` |

### Root files
| File | What Changed |
|------|-------------|
| `lib/main.dart` | Full rewrite: Firebase init, anonymous auth, uid injection, all 6 providers wired |
| `lib/firebase_options.dart` | Placeholder — **you must run `flutterfire configure`** |
| `pubspec.yaml` | Added: `firebase_core`, `firebase_auth`, `cloud_firestore`, `firebase_storage`, `cloud_functions`, `image_picker`, `uuid` |
| `firestore.rules` | Deny-all default; allow `users/{userId}/**` for matching uid |
| `storage.rules` | Deny-all default; allow `receipts/{userId}/**` with size + MIME checks |
| `functions/index.js` | Two Cloud Functions: `aggregateMonthlyInsights` and `onExpenseCreated` |
| `functions/package.json` | Node 18, firebase-admin + firebase-functions dependencies |

---

## Setup Steps (in order)

### 1. Create Firebase Project
Go to [console.firebase.google.com](https://console.firebase.google.com) → New Project → enable **Anonymous Auth**, **Firestore**, **Storage**, and **Functions**.

### 2. Configure Flutter with Firebase
```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# In your project root
flutterfire configure
```
This auto-generates `lib/firebase_options.dart` — **replace the placeholder file**.

### 3. Install Flutter dependencies
```bash
flutter pub get
```

### 4. Deploy Security Rules
```bash
firebase deploy --only firestore:rules,storage:rules
```

### 5. Deploy Cloud Functions
```bash
cd functions
npm install
cd ..
firebase deploy --only functions
```

### 6. Run the app
```bash
flutter run
```
The app will silently sign in anonymously, get a uid, and inject it into all datasources before `runApp()` is called.

---

## Architecture Compliance Notes

- **uid rule**: `uid` is obtained once in `main.dart` via `SignInAnonymouslyUseCase` and injected into every datasource constructor. No datasource fetches it itself.
- **Cross-feature rule**: `ExpenseProvider` calls `UpdateCategorySpendingUseCase` (budget) and `AddTransactionUseCase` (transaction) directly — the expense datasource never touches budget or transaction collections.
- **Stream rule**: `TransactionFirebaseDataSource` creates the `.snapshots()` stream. It flows through `WatchTransactionsUseCase` → `HomeProvider.init()` → `StreamSubscription`. `HomeProvider` cancels in `dispose()`.
- **DO NOT TOUCH files**: All files marked DO NOT TOUCH in the prompt were copied verbatim and not modified.
