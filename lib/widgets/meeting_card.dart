import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../models/meeting.dart';
import 'avatar_widget.dart';

class MeetingCard extends StatelessWidget {
  final Meeting meeting;
  final VoidCallback? onJoin;

  const MeetingCard({super.key, required this.meeting, this.onJoin});

  String _formatTime(String time) {
    final parts = time.split(':');
    final h = int.parse(parts[0]);
    final m = parts[1];
    final period = h >= 12 ? 'PM' : 'AM';
    final hour = h % 12 == 0 ? 12 : h % 12;
    return '$hour:$m $period';
  }

  @override
  Widget build(BuildContext context) {
    final isCancelled = meeting.isCancelled;
    final visible = meeting.participants.take(3).toList();
    final extra = meeting.participants.length - 3;

    return Opacity(
      opacity: isCancelled ? 0.5 : 1.0,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Time column
            SizedBox(
              width: 52,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    _formatTime(meeting.startTime).split(' ')[1],
                    style: const TextStyle(
                      fontSize: 10, color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    _formatTime(meeting.startTime).split(' ')[0],
                    style: const TextStyle(
                      fontSize: 15, color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          meeting.title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            decoration: isCancelled ? TextDecoration.lineThrough : null,
                            decorationColor: AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isCancelled)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.red.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.red.withValues(alpha: 0.3)),
                          ),
                          child: const Text(
                            'CANCELLED',
                            style: TextStyle(fontSize: 10, color: AppColors.red, fontWeight: FontWeight.bold),
                          ),
                        )
                      else
                        const Icon(Icons.more_horiz, color: AppColors.textSecondary, size: 18),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        meeting.type == MeetingType.virtual ? Icons.videocam_outlined : Icons.location_on_outlined,
                        size: 12, color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          meeting.displayLocation,
                          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                          maxLines: 1, overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if (!isCancelled) ...[
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        // Avatars
                        if (visible.isNotEmpty)
                          SizedBox(
                            width: visible.length * 18.0 + 8,
                            height: 26,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                for (int i = 0; i < visible.length; i++)
                                  Positioned(
                                    left: i * 18.0,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: AppColors.surface, width: 1.5),
                                        shape: BoxShape.circle,
                                      ),
                                      child: AvatarWidget(
                                        email: visible[i].user.email,
                                        avatarUrl: visible[i].user.avatar,
                                        size: 24,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        if (extra > 0) ...[
                          const SizedBox(width: 4),
                          Text('+$extra', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                        ],
                        const Spacer(),
                        if (onJoin != null && (meeting.isUpcoming || meeting.isOngoing))
                          GestureDetector(
                            onTap: onJoin,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                              decoration: BoxDecoration(
                                color: meeting.isOngoing ? AppColors.blue : Colors.transparent,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: AppColors.blue.withValues(alpha: meeting.isOngoing ? 0 : 0.6),
                                ),
                              ),
                              child: Text(
                                meeting.isOngoing ? 'Join Now' : 'Join',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: meeting.isOngoing ? Colors.white : AppColors.blueLight,
                                ),
                              ),
                            ),
                          ),
                        if (!meeting.isOngoing && onJoin == null && meeting.isUpcoming)
                          Row(
                            children: const [
                              Icon(Icons.notifications_none, size: 14, color: AppColors.textSecondary),
                              SizedBox(width: 4),
                              Text('Reminder', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                            ],
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
