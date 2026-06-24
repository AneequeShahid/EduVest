import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';
import 'screens/insights_screen.dart';
import 'screens/budget_screen.dart';
import 'screens/goals_screen.dart';
import 'screens/add_expense_screen.dart';
import 'screens/settings_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const EduVestApp());
}

class EduVestApp extends StatelessWidget {
  const EduVestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EduVest',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/home',
      routes: {
        '/home': (context) => const HomeScreen(),
        '/insights': (context) => const InsightsScreen(),
        '/add': (context) => const AddExpenseScreen(),
        '/budget': (context) => const BudgetScreen(),
        '/goals': (context) => const GoalsScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}
