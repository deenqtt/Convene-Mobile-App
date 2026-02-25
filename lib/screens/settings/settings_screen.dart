import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme.dart';
import '../../data/dummy.dart';
import '../../widgets/avatar_widget.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final safeBottom = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: EdgeInsets.fromLTRB(16, 16, 16, navBarBottom(safeBottom)),
        children: [
          // Profile card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColors.border),
            ),
            child: Row(children: [
              AvatarWidget(email: dummyUser.email, size: 48),
              const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(dummyUser.username, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                Text(dummyUser.email, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.blue.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.blue.withValues(alpha: 0.3)),
                  ),
                  child: Text(dummyUser.role, style: const TextStyle(fontSize: 10, color: AppColors.blueLight, fontWeight: FontWeight.bold)),
                ),
              ])),
              const Icon(Icons.chevron_right, color: AppColors.textSecondary),
            ]),
          ),
          const SizedBox(height: 20),

          _section('ACCOUNT', [
            _tile(Icons.person_outline,     'Profile',       'Edit your name and avatar'),
            _tile(Icons.lock_outline,       'Security',      'Password & 2FA'),
          ]),
          const SizedBox(height: 16),
          _section('PREFERENCES', [
            _tile(Icons.notifications_none, 'Notifications', 'Meeting reminders & alerts'),
            _tile(Icons.dark_mode_outlined, 'Appearance',    'Dark mode (active)'),
            _tile(Icons.language,           'Language',      'English'),
          ]),
          const SizedBox(height: 16),
          _section('APP', [
            _tile(Icons.smartphone,         'Mobile App',    'v1.0.0'),
          ]),
          const SizedBox(height: 24),

          const Text('Meeting App v1.0.0 · by deenqtt',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
          const SizedBox(height: 12),

          // Sign out
          GestureDetector(
            onTap: () => context.go('/login'),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.red.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.red.withValues(alpha: 0.2)),
              ),
              child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.logout, color: AppColors.red, size: 18),
                SizedBox(width: 8),
                Text('Sign Out', style: TextStyle(color: AppColors.red, fontWeight: FontWeight.bold)),
              ]),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _section(String title, List<Widget> items) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 4, bottom: 8),
        child: Text(title, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w700, letterSpacing: 0.6)),
      ),
      Container(
        decoration: BoxDecoration(
          color: AppColors.surface, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColors.border),
        ),
        child: Column(children: [
          for (int i = 0; i < items.length; i++) ...[
            if (i > 0) Divider(color: AppColors.border, height: 1, indent: 16),
            items[i],
          ],
        ]),
      ),
    ],
  );

  Widget _tile(IconData icon, String label, String desc) => ListTile(
    leading: Container(
      width: 36, height: 36,
      decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(10)),
      child: Icon(icon, color: AppColors.blueLight, size: 18),
    ),
    title: Text(label, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
    subtitle: Text(desc, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
    trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary, size: 18),
    onTap: () {},
  );
}
