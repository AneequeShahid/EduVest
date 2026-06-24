# 📱 EduVest — Student Money Manager Application

EduVest is a cross-platform mobile application engineered specifically for students to securely track their personal finance, manage budgets, log daily expenses, and plan savings goals. Built with Flutter and Dart, the app features dynamic visualization components that turn raw financial transactions into actionable budget insights.

---

## 🚀 Key Features

* **Student Expense Tracking**: Quickly log daily expenditures categorized by food, books, transport, entertainment, and utilities.
* **Smart Budget Planning**: Set monthly or weekly budget targets, receiving real-time warning indicators when spending approaches set limits.
* **Savings Goal Manager**: Create and track specific savings milestones (e.g., buying a laptop, exam fees) with progress bars.
* **Data Visualization**: Dynamic circular charts and bar graphs mapping spending categories and transaction histories to help students understand their financial trends.
* **Offline Database Security**: Utilizes local file streams or secure SQFlite databases to persist student transactions on-device.

---

## 🛠️ Technology Stack

* **Frontend Framework**: Flutter (v3.0+)
* **Programming Language**: Dart
* **State Management**: Dynamic state structures (Tailored component state wrappers)
* **Icons & Fonts**: Google Fonts (Gilroy/Inter) & Cupertino Icons

---

## 📂 Mobile Application Structure

The application's core presentation layer is decoupled from transaction logic:
```
eduvest/
├── lib/
│   ├── main.dart       # App entry point, theme declaration, routes
│   ├── theme/          # Custom color systems and styles
│   ├── widgets/        # Reusable components (goal cards, transaction items)
│   └── screens/        # Main app modules:
│       ├── home_screen.dart          # Wallet dashboard & recent events
│       ├── add_expense_screen.dart   # Transaction intake form
│       ├── budget_screen.dart        # Category thresholds and gauges
│       ├── goals_screen.dart         # Savings targets tracker
│       ├── insights_screen.dart      # Spending charts & category analytics
│       └── settings_screen.dart      # User preferences and profile details
└── assets/             # Vector icons and custom design fonts
```

---

## ⚙️ Setup & Installation

To run EduVest locally on a mobile emulator (Android/iOS) or web browser:

1. **Prerequisites**: Ensure the **Flutter SDK** is installed and configured in your environment path.
2. **Clone and Install**:
   ```bash
   git clone https://github.com/AneequeShahid/EduVest.git
   cd EduVest
   flutter pub get
   ```
3. **Check Flutter Environment**:
   ```bash
   flutter doctor
   ```
4. **Run the Application**:
   Ensure an emulator is active or a device is plugged in, then execute:
   ```bash
   flutter run
   ```

---

## 🎓 Academic Credit
Developed as a project for the Mobile Application Development course at **Beaconhouse National University (BNU)**.
