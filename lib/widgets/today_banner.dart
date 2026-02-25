import 'package:flutter/material.dart';
import '../models/meeting.dart';

class TodayBanner extends StatelessWidget {
  final TodayDashboard data;
  final VoidCallback? onViewSchedule;

  const TodayBanner({super.key, required this.data, this.onViewSchedule});

  String _nextInfo() {
    final next = data.nextMeeting;
    if (next == null) return '';
    final parts = next.startTime.split(':');
    final now = DateTime.now();
    final meetingTime = DateTime(now.year, now.month, now.day, int.parse(parts[0]), int.parse(parts[1]));
    final diff = meetingTime.difference(now).inMinutes;
    if (diff <= 0) return '${next.title} is happening now.';
    if (diff < 60) return '${next.title} starts in ${diff}m.';
    final h = diff ~/ 60;
    return '${next.title} starts in ${h}h ${diff % 60}m.';
  }

  @override
  Widget build(BuildContext context) {
    final nextInfo = _nextInfo();
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1D4ED8), Color(0xFF1E40AF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1D4ED8).withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.calendar_today_outlined, size: 14, color: Color(0xFF93C5FD)),
              SizedBox(width: 6),
              Text(
                "TODAY'S SCHEDULE",
                style: TextStyle(fontSize: 11, color: Color(0xFF93C5FD), fontWeight: FontWeight.w700, letterSpacing: 0.8),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            data.total == 0
                ? 'No Meetings Today'
                : '${data.total} Meeting${data.total > 1 ? 's' : ''} Today',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          if (nextInfo.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              nextInfo,
              style: const TextStyle(fontSize: 13, color: Color(0xFFBFDBFE)),
            ),
          ],
          if (data.total == 0)
            const Padding(
              padding: EdgeInsets.only(top: 4),
              child: Text('Enjoy your free day!', style: TextStyle(fontSize: 13, color: Color(0xFFBFDBFE))),
            ),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: onViewSchedule,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text('View Schedule', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward, size: 14, color: Colors.white),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
