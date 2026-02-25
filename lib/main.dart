import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'core/theme.dart';
import 'widgets/glass_nav_bar.dart';
import 'screens/login/login_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/meetings/create_meeting_screen.dart';
import 'screens/meetings/quick_add_screen.dart';
import 'screens/calendar/calendar_screen.dart';
import 'screens/contacts/contacts_screen.dart';
import 'screens/settings/settings_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarContrastEnforced: false,
  ));
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  runApp(const MeetingApp());
}

final _navItems = const [
  GlassNavItem(icon: Icons.home_outlined,           activeIcon: Icons.home_rounded,        label: 'Home'),
  GlassNavItem(icon: Icons.calendar_month_outlined, activeIcon: Icons.calendar_month,       label: 'Calendar'),
  GlassNavItem(icon: Icons.people_outline,          activeIcon: Icons.people_rounded,       label: 'Contacts'),
  GlassNavItem(icon: Icons.settings_outlined,       activeIcon: Icons.settings_rounded,     label: 'Settings'),
];

final _router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
    ShellRoute(
      builder: (context, state, child) =>
          _Shell(child: child, location: state.uri.path),
      routes: [
        GoRoute(path: '/',         builder: (_, __) => const HomeScreen()),
        GoRoute(path: '/calendar', builder: (_, __) => const CalendarScreen()),
        GoRoute(path: '/contacts', builder: (_, __) => const ContactsScreen()),
        GoRoute(path: '/settings', builder: (_, __) => const SettingsScreen()),
      ],
    ),
    GoRoute(path: '/meetings/new',   builder: (_, __) => const CreateMeetingScreen()),
    GoRoute(path: '/meetings/quick', builder: (_, __) => const QuickAddScreen()),
  ],
);

class MeetingApp extends StatelessWidget {
  const MeetingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Meeting — by deenqtt',
      theme: appTheme,
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}

class _Shell extends StatelessWidget {
  final Widget child;
  final String location;
  const _Shell({required this.child, required this.location});

  int get _index {
    switch (location) {
      case '/calendar': return 1;
      case '/contacts': return 2;
      case '/settings': return 3;
      default:          return 0;
    }
  }

  void _onTap(BuildContext context, int i) {
    switch (i) {
      case 0: context.go('/');
      case 1: context.go('/calendar');
      case 2: context.go('/contacts');
      case 3: context.go('/settings');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,              // content renders behind the glass nav
      backgroundColor: AppColors.background,
      body: child,
      bottomNavigationBar: GlassNavBar(
        currentIndex: _index,
        onTap: (i) => _onTap(context, i),
        items: _navItems,
      ),
    );
  }
}
