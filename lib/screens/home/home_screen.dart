import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../core/theme.dart';
import '../../data/dummy.dart';
import '../../models/meeting.dart';
import '../../services/meeting_service.dart';
import '../../widgets/today_banner.dart';
import '../../widgets/meeting_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TodayDashboard? _today;
  List<Meeting> _upcoming = [];
  bool _loading = true;
  String _search = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final results = await Future.wait([
        MeetingService.getToday(),
        MeetingService.getUpcoming(),
      ]);
      setState(() {
        _today    = results[0] as TodayDashboard;
        _upcoming = results[1] as List<Meeting>;
      });
    } catch (_) {
      // handle error silently in dummy state
    } finally {
      setState(() => _loading = false);
    }
  }

  List<Meeting> get _filtered => _search.isEmpty
      ? _upcoming
      : _upcoming.where((m) => m.title.toLowerCase().contains(_search.toLowerCase())).toList();

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dateLabel = DateFormat('EEEE, MMM d').format(now).toUpperCase();

    final bottomInset = MediaQuery.of(context).padding.bottom;
    // Glass nav height: 68 + bottom margin (safeArea+8 or 20) + extra gap
    final fabBottom = bottomInset > 0 ? bottomInset + 68 + 8 + 16.0 : 68 + 20 + 16.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            RefreshIndicator(
              onRefresh: _load,
              color: AppColors.blue,
              backgroundColor: AppColors.surface,
              child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Hello, ${dummyUser.username}',
                                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                              Text(dateLabel,
                                  style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
                            ],
                          ),
                          Stack(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppColors.card,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppColors.border),
                                ),
                                child: const Icon(Icons.notifications_none, color: Colors.white70, size: 20),
                              ),
                              Positioned(
                                top: 8, right: 8,
                                child: Container(
                                  width: 8, height: 8,
                                  decoration: const BoxDecoration(color: AppColors.blue, shape: BoxShape.circle),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Search
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: TextField(
                          onChanged: (v) => setState(() => _search = v),
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                          decoration: const InputDecoration(
                            hintText: 'Search meetings, people...',
                            prefixIcon: Icon(Icons.search, color: AppColors.textSecondary, size: 20),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Today banner
                      if (_loading)
                        Container(
                          height: 140,
                          decoration: BoxDecoration(
                            color: AppColors.card,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        )
                      else if (_today != null)
                        TodayBanner(data: _today!),
                      const SizedBox(height: 20),

                      // Upcoming header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Upcoming Meetings',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                          Text('See all', style: TextStyle(fontSize: 13, color: AppColors.blueLight, fontWeight: FontWeight.w500)),
                        ],
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),

              // Meeting list
              if (_loading)
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (_, __) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Container(
                          height: 88,
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      childCount: 3,
                    ),
                  ),
                )
              else if (_filtered.isEmpty)
                SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 48),
                      child: Column(
                        children: const [
                          Icon(Icons.calendar_today_outlined, size: 48, color: AppColors.textMuted),
                          SizedBox(height: 12),
                          Text('No upcoming meetings', style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
                        ],
                      ),
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (_, i) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: MeetingCard(
                          meeting: _filtered[i],
                          onJoin: _filtered[i].meetingLink != null ? () {} : null,
                        ),
                      ),
                      childCount: _filtered.length,
                    ),
                  ),
                ),
            ],
          ),
        ),

            // FAB — Positioned above glass nav
            Positioned(
              right: 20,
              bottom: fabBottom,
              child: FloatingActionButton(
                onPressed: () => _showFabMenu(context),
                backgroundColor: AppColors.blue,
                elevation: 8,
                child: const Icon(Icons.add, color: Colors.white, size: 26),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFabMenu(BuildContext context) {
    final safeBottom = MediaQuery.of(context).padding.bottom;
    final sheetBottom = navBarBottom(safeBottom);

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.fromLTRB(24, 24, 24, sheetBottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 20),
            _fabOption(
              icon: Icons.add_circle_outline,
              label: 'New Meeting',
              desc: 'Full meeting with agenda & participants',
              onTap: () { Navigator.pop(context); context.push('/meetings/new'); },
            ),
            const SizedBox(height: 12),
            _fabOption(
              icon: Icons.flash_on_outlined,
              label: 'Quick Add',
              desc: 'Create a meeting in seconds',
              onTap: () { Navigator.pop(context); context.push('/meetings/quick'); },
            ),
          ],
        ),
      ),
    );
  }

  Widget _fabOption({
    required IconData icon,
    required String label,
    required String desc,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: AppColors.blue.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: AppColors.blueLight, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14)),
                  Text(desc, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, color: AppColors.textSecondary, size: 18),
          ],
        ),
      ),
    );
  }
}
