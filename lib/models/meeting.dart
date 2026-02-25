class MeetingUser {
  final String id;
  final String email;
  final String? avatar;

  MeetingUser({required this.id, required this.email, this.avatar});

  factory MeetingUser.fromJson(Map<String, dynamic> j) => MeetingUser(
        id: j['id'] as String,
        email: j['email'] as String,
        avatar: j['avatar'] as String?,
      );
}

class MeetingParticipant {
  final String id;
  final String userId;
  final MeetingUser user;

  MeetingParticipant({required this.id, required this.userId, required this.user});

  factory MeetingParticipant.fromJson(Map<String, dynamic> j) =>
      MeetingParticipant(
        id: j['id'] as String,
        userId: j['userId'] as String,
        user: MeetingUser.fromJson(j['user'] as Map<String, dynamic>),
      );
}

enum MeetingType { virtual, physical }
enum MeetingStatus { upcoming, ongoing, completed, cancelled }

MeetingType meetingTypeFromString(String s) =>
    s == 'PHYSICAL' ? MeetingType.physical : MeetingType.virtual;

MeetingStatus meetingStatusFromString(String s) {
  switch (s) {
    case 'ONGOING':   return MeetingStatus.ongoing;
    case 'COMPLETED': return MeetingStatus.completed;
    case 'CANCELLED': return MeetingStatus.cancelled;
    default:          return MeetingStatus.upcoming;
  }
}

class Meeting {
  final String id;
  final String title;
  final MeetingType type;
  final MeetingStatus status;
  final String? meetingLink;
  final String? location;
  final DateTime date;
  final String startTime;
  final String endTime;
  final String? agenda;
  final bool isRecurring;
  final MeetingUser createdBy;
  final List<MeetingParticipant> participants;

  Meeting({
    required this.id,
    required this.title,
    required this.type,
    required this.status,
    this.meetingLink,
    this.location,
    required this.date,
    required this.startTime,
    required this.endTime,
    this.agenda,
    required this.isRecurring,
    required this.createdBy,
    required this.participants,
  });

  factory Meeting.fromJson(Map<String, dynamic> j) => Meeting(
        id: j['id'] as String,
        title: j['title'] as String,
        type: meetingTypeFromString(j['type'] as String),
        status: meetingStatusFromString(j['status'] as String),
        meetingLink: j['meetingLink'] as String?,
        location: j['location'] as String?,
        date: DateTime.parse(j['date'] as String),
        startTime: j['startTime'] as String,
        endTime: j['endTime'] as String,
        agenda: j['agenda'] as String?,
        isRecurring: j['isRecurring'] as bool? ?? false,
        createdBy: MeetingUser.fromJson(j['createdBy'] as Map<String, dynamic>),
        participants: (j['participants'] as List<dynamic>)
            .map((p) => MeetingParticipant.fromJson(p as Map<String, dynamic>))
            .toList(),
      );

  bool get isCancelled => status == MeetingStatus.cancelled;
  bool get isOngoing   => status == MeetingStatus.ongoing;
  bool get isUpcoming  => status == MeetingStatus.upcoming;

  String get displayLocation =>
      type == MeetingType.virtual ? (meetingLink ?? 'Virtual Meeting') : (location ?? '');
}

class TodayDashboard {
  final int total;
  final List<Meeting> meetings;
  final Meeting? nextMeeting;

  TodayDashboard({required this.total, required this.meetings, this.nextMeeting});

  factory TodayDashboard.fromJson(Map<String, dynamic> j) => TodayDashboard(
        total: j['total'] as int,
        meetings: (j['meetings'] as List<dynamic>)
            .map((m) => Meeting.fromJson(m as Map<String, dynamic>))
            .toList(),
        nextMeeting: j['nextMeeting'] != null
            ? Meeting.fromJson(j['nextMeeting'] as Map<String, dynamic>)
            : null,
      );
}
