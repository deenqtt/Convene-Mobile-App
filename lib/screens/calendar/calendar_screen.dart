import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});
  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _month = DateTime.now();
  int _selected = DateTime.now().day;

  final _events = <int, List<String>>{
    3: ['Product Sync'], 7: ['Design Review'], 10: ['Sprint Planning', '1-on-1'],
    15: ['Quarterly Review'], 20: ['Client Presentation'], 24: ['Team Retro'],
  };

  @override
  Widget build(BuildContext context) {
    final firstDay = DateTime(_month.year, _month.month, 1).weekday % 7;
    final daysInMonth = DateTime(_month.year, _month.month + 1, 0).day;
    final now = DateTime.now();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(DateFormat('MMMM yyyy').format(_month)),
        actions: [
          IconButton(icon: const Icon(Icons.chevron_left), onPressed: () => setState(() => _month = DateTime(_month.year, _month.month - 1))),
          IconButton(icon: const Icon(Icons.chevron_right), onPressed: () => setState(() => _month = DateTime(_month.year, _month.month + 1))),
        ],
      ),
      body: Column(
        children: [
          // Day headers
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: ['Sun','Mon','Tue','Wed','Thu','Fri','Sat'].map((d) =>
                Expanded(child: Text(d, textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w600))),
              ).toList(),
            ),
          ),
          // Grid
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, childAspectRatio: 1),
              itemCount: firstDay + daysInMonth,
              itemBuilder: (_, i) {
                if (i < firstDay) return const SizedBox();
                final day = i - firstDay + 1;
                final isToday = day == now.day && _month.month == now.month && _month.year == now.year;
                final isSel = day == _selected;
                final hasEvent = _events.containsKey(day);
                return GestureDetector(
                  onTap: () => setState(() => _selected = day),
                  child: Stack(alignment: Alignment.center, children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: isSel ? AppColors.blue : (isToday ? AppColors.blue.withOpacity(0.15) : Colors.transparent),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text('$day', style: TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600,
                        color: isSel ? Colors.white : (isToday ? AppColors.blueLight : Colors.white70),
                      )),
                    ),
                    if (hasEvent && !isSel)
                      Positioned(bottom: 4, child: Container(width: 4, height: 4,
                        decoration: const BoxDecoration(color: AppColors.blueLight, shape: BoxShape.circle))),
                  ]),
                );
              },
            ),
          ),
          const Divider(color: AppColors.border, height: 24),
          // Events
          Expanded(
            child: _events[_selected] == null
              ? const Center(child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.calendar_today_outlined, color: AppColors.textMuted, size: 40),
                    SizedBox(height: 10),
                    Text('No meetings this day', style: TextStyle(color: AppColors.textSecondary)),
                  ],
                ))
              : ListView(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, navBarBottom(MediaQuery.of(context).padding.bottom)),
                  children: _events[_selected]!.map((title) =>
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(children: [
                        const Icon(Icons.videocam_outlined, color: AppColors.blueLight, size: 18),
                        const SizedBox(width: 12),
                        Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                      ]),
                    ),
                  ).toList(),
                ),
          ),
        ],
      ),
    );
  }
}
