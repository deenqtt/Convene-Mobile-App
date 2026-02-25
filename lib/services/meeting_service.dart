import '../data/dummy.dart';
import '../models/meeting.dart';

class MeetingService {
  static Future<TodayDashboard> getToday() =>
      Future.value(buildDummyToday());

  static Future<List<Meeting>> getUpcoming({int days = 7, int limit = 10}) {
    final todayKey = _dateKey(DateTime.now());
    final cutoffKey = _dateKey(DateTime.now().add(Duration(days: days)));
    final result = buildDummyMeetings()
        .where((m) {
          final k = _dateKey(m.date);
          return k.compareTo(todayKey) >= 0 && k.compareTo(cutoffKey) <= 0;
        })
        .take(limit)
        .toList();
    return Future.value(result);
  }

  static Future<List<Meeting>> list({
    String? status,
    String? date,
    String? search,
  }) {
    var result = buildDummyMeetings();
    if (status != null) {
      final s = meetingStatusFromString(status);
      result = result.where((m) => m.status == s).toList();
    }
    if (date != null) {
      result = result.where((m) => _dateKey(m.date) == date).toList();
    }
    if (search != null) {
      final q = search.toLowerCase();
      result =
          result.where((m) => m.title.toLowerCase().contains(q)).toList();
    }
    return Future.value(result);
  }

  static Future<Meeting> create({
    required String title,
    required String type,
    required String date,
    required String startTime,
    required String endTime,
    String? meetingLink,
    String? location,
    String? agenda,
    bool isRecurring = false,
    List<String> participantIds = const [],
  }) {
    final now = DateTime.now();
    final meeting = Meeting(
      id: 'm-${now.millisecondsSinceEpoch}',
      title: title,
      type: type == 'PHYSICAL' ? MeetingType.physical : MeetingType.virtual,
      status: MeetingStatus.upcoming,
      meetingLink: meetingLink,
      location: location,
      date: DateTime.parse(date),
      startTime: startTime,
      endTime: endTime,
      agenda: agenda,
      isRecurring: isRecurring,
      createdBy: MeetingUser(id: 'user-1', email: dummyUser.email),
      participants: [],
    );
    return Future.value(meeting);
  }

  static Future<void> cancel(String id) => Future.value();

  static String _dateKey(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
