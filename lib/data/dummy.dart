import '../models/meeting.dart';

// ── User ──────────────────────────────────────────────────────────────────────

class DummyUser {
  final String username;
  final String email;
  final String role;
  const DummyUser({required this.username, required this.email, required this.role});
}

const dummyUser = DummyUser(
  username: 'johndoe',
  email: 'john.doe@deenqtt.com',
  role: 'Admin',
);

// ── Contacts ──────────────────────────────────────────────────────────────────

class DummyContact {
  final int id;
  final String name;
  final String? email;
  final String? departmentName;
  final String? phoneHr;
  final String? authorizationLevel;
  const DummyContact({
    required this.id,
    required this.name,
    this.email,
    this.departmentName,
    this.phoneHr,
    this.authorizationLevel,
  });
}

const dummyContacts = <DummyContact>[
  DummyContact(id: 1,  name: 'Alice Johnson', email: 'alice.j@deenqtt.com',   departmentName: 'Engineering', phoneHr: 'ext. 101', authorizationLevel: 'Manager'),
  DummyContact(id: 2,  name: 'Bob Smith',     email: 'bob.s@deenqtt.com',     departmentName: 'Engineering', phoneHr: 'ext. 102', authorizationLevel: 'Staff'),
  DummyContact(id: 3,  name: 'Clara Lee',     email: 'clara.l@deenqtt.com',   departmentName: 'Product',     phoneHr: 'ext. 201', authorizationLevel: 'Manager'),
  DummyContact(id: 4,  name: 'David Kim',     email: 'david.k@deenqtt.com',   departmentName: 'Product',     phoneHr: null,       authorizationLevel: 'Staff'),
  DummyContact(id: 5,  name: 'Eva Martinez',  email: 'eva.m@deenqtt.com',     departmentName: 'Design',      phoneHr: 'ext. 301', authorizationLevel: 'Lead'),
  DummyContact(id: 6,  name: 'Frank Chen',    email: 'frank.c@deenqtt.com',   departmentName: 'Design',      phoneHr: 'ext. 302', authorizationLevel: 'Staff'),
  DummyContact(id: 7,  name: 'Grace Park',    email: 'grace.p@deenqtt.com',   departmentName: 'Marketing',   phoneHr: 'ext. 401', authorizationLevel: 'Manager'),
  DummyContact(id: 8,  name: 'Henry Wilson',  email: 'henry.w@deenqtt.com',   departmentName: 'Marketing',   phoneHr: null,       authorizationLevel: 'Staff'),
  DummyContact(id: 9,  name: 'Iris Tanaka',   email: 'iris.t@deenqtt.com',    departmentName: 'HR',          phoneHr: 'ext. 501', authorizationLevel: 'Manager'),
  DummyContact(id: 10, name: 'Jack Brown',    email: 'jack.b@deenqtt.com',    departmentName: 'Finance',     phoneHr: 'ext. 601', authorizationLevel: 'Staff'),
  DummyContact(id: 11, name: 'Karen White',   email: 'karen.w@deenqtt.com',   departmentName: 'Finance',     phoneHr: 'ext. 602', authorizationLevel: 'Lead'),
  DummyContact(id: 12, name: 'Leo Garcia',    email: 'leo.g@deenqtt.com',     departmentName: 'Engineering', phoneHr: 'ext. 103', authorizationLevel: 'Staff'),
  DummyContact(id: 13, name: 'Mia Nguyen',    email: 'mia.n@deenqtt.com',     departmentName: 'HR',          phoneHr: 'ext. 502', authorizationLevel: 'Staff'),
  DummyContact(id: 14, name: 'Nathan Reed',   email: 'nathan.r@deenqtt.com',  departmentName: 'Engineering', phoneHr: null,       authorizationLevel: 'Staff'),
  DummyContact(id: 15, name: 'Olivia Stone',  email: 'olivia.s@deenqtt.com',  departmentName: 'Product',     phoneHr: 'ext. 202', authorizationLevel: 'Lead'),
];

// ── Meetings ──────────────────────────────────────────────────────────────────

DateTime _offsetDay(int days) {
  final n = DateTime.now();
  return DateTime(n.year, n.month, n.day + days);
}

MeetingUser _createdBy() =>
    MeetingUser(id: 'user-1', email: 'john.doe@deenqtt.com');

MeetingParticipant _mp(String id, String email) => MeetingParticipant(
      id: id,
      userId: email,
      user: MeetingUser(id: email, email: email),
    );

List<Meeting> buildDummyMeetings() {
  return [
    // ── Today ──
    Meeting(
      id: 'm1',
      title: 'Sprint Planning',
      type: MeetingType.virtual,
      status: MeetingStatus.ongoing,
      meetingLink: 'https://meet.google.com/abc-defg-hij',
      date: _offsetDay(0),
      startTime: '09:00',
      endTime: '10:00',
      agenda: 'Plan tasks for Sprint 12. Review backlog and assign story points.',
      isRecurring: false,
      createdBy: _createdBy(),
      participants: [
        _mp('p1', 'alice.j@deenqtt.com'),
        _mp('p2', 'bob.s@deenqtt.com'),
        _mp('p3', 'clara.l@deenqtt.com'),
      ],
    ),
    Meeting(
      id: 'm2',
      title: 'Design Review',
      type: MeetingType.virtual,
      status: MeetingStatus.upcoming,
      meetingLink: 'https://zoom.us/j/123456789',
      date: _offsetDay(0),
      startTime: '14:00',
      endTime: '15:00',
      agenda: 'Review new dashboard mockups and gather feedback from stakeholders.',
      isRecurring: false,
      createdBy: _createdBy(),
      participants: [
        _mp('p4', 'eva.m@deenqtt.com'),
        _mp('p5', 'clara.l@deenqtt.com'),
      ],
    ),
    Meeting(
      id: 'm3',
      title: 'Product Roadmap Discussion',
      type: MeetingType.physical,
      status: MeetingStatus.upcoming,
      location: 'Conference Room A, 3rd Floor',
      date: _offsetDay(0),
      startTime: '16:00',
      endTime: '17:30',
      agenda: 'Discuss Q2 roadmap priorities and upcoming feature releases.',
      isRecurring: false,
      createdBy: _createdBy(),
      participants: [
        _mp('p6', 'clara.l@deenqtt.com'),
        _mp('p7', 'david.k@deenqtt.com'),
        _mp('p8', 'grace.p@deenqtt.com'),
        _mp('p9', 'olivia.s@deenqtt.com'),
      ],
    ),
    // ── Tomorrow ──
    Meeting(
      id: 'm4',
      title: 'Engineering Standup',
      type: MeetingType.virtual,
      status: MeetingStatus.upcoming,
      meetingLink: 'https://meet.google.com/xyz-uvwx-yz',
      date: _offsetDay(1),
      startTime: '09:00',
      endTime: '09:30',
      isRecurring: true,
      createdBy: _createdBy(),
      participants: [
        _mp('p10', 'alice.j@deenqtt.com'),
        _mp('p11', 'bob.s@deenqtt.com'),
        _mp('p12', 'leo.g@deenqtt.com'),
        _mp('p13', 'nathan.r@deenqtt.com'),
      ],
    ),
    Meeting(
      id: 'm5',
      title: 'UX Workshop',
      type: MeetingType.physical,
      status: MeetingStatus.upcoming,
      location: 'Creative Lab, 4th Floor',
      date: _offsetDay(1),
      startTime: '13:00',
      endTime: '16:00',
      agenda: 'Collaborative session to redesign the onboarding flow.',
      isRecurring: false,
      createdBy: _createdBy(),
      participants: [
        _mp('p14', 'eva.m@deenqtt.com'),
        _mp('p15', 'frank.c@deenqtt.com'),
        _mp('p16', 'clara.l@deenqtt.com'),
      ],
    ),
    // ── D+2 ──
    Meeting(
      id: 'm6',
      title: 'Marketing Campaign Review',
      type: MeetingType.physical,
      status: MeetingStatus.upcoming,
      location: 'Meeting Room B, 2nd Floor',
      date: _offsetDay(2),
      startTime: '10:00',
      endTime: '11:00',
      isRecurring: false,
      createdBy: _createdBy(),
      participants: [
        _mp('p17', 'grace.p@deenqtt.com'),
        _mp('p18', 'henry.w@deenqtt.com'),
      ],
    ),
    // ── D+4 ──
    Meeting(
      id: 'm7',
      title: 'Quarterly Budget Review',
      type: MeetingType.virtual,
      status: MeetingStatus.upcoming,
      meetingLink: 'https://teams.microsoft.com/l/meetup/q1review',
      date: _offsetDay(4),
      startTime: '13:00',
      endTime: '15:00',
      agenda: 'Q1 actual vs. budget analysis and Q2 financial forecast.',
      isRecurring: false,
      createdBy: _createdBy(),
      participants: [
        _mp('p19', 'jack.b@deenqtt.com'),
        _mp('p20', 'karen.w@deenqtt.com'),
        _mp('p21', 'iris.t@deenqtt.com'),
      ],
    ),
    // ── D+5 ──
    Meeting(
      id: 'm8',
      title: '1-on-1: Alice & John',
      type: MeetingType.virtual,
      status: MeetingStatus.upcoming,
      meetingLink: 'https://meet.google.com/1on1-alice',
      date: _offsetDay(5),
      startTime: '10:00',
      endTime: '10:30',
      isRecurring: true,
      createdBy: _createdBy(),
      participants: [
        _mp('p22', 'alice.j@deenqtt.com'),
      ],
    ),
    // ── D+7 ──
    Meeting(
      id: 'm9',
      title: 'HR Town Hall',
      type: MeetingType.physical,
      status: MeetingStatus.upcoming,
      location: 'Main Auditorium, Ground Floor',
      date: _offsetDay(7),
      startTime: '10:00',
      endTime: '12:00',
      agenda: 'Company-wide updates, policy changes, and open Q&A session.',
      isRecurring: false,
      createdBy: _createdBy(),
      participants: [
        _mp('p23', 'iris.t@deenqtt.com'),
        _mp('p24', 'mia.n@deenqtt.com'),
      ],
    ),
    // ── D+9 ──
    Meeting(
      id: 'm10',
      title: 'Client Demo — Q2 Features',
      type: MeetingType.virtual,
      status: MeetingStatus.upcoming,
      meetingLink: 'https://zoom.us/j/987654321',
      date: _offsetDay(9),
      startTime: '14:00',
      endTime: '15:00',
      agenda: 'Live demo of new features for external client stakeholders.',
      isRecurring: false,
      createdBy: _createdBy(),
      participants: [
        _mp('p25', 'clara.l@deenqtt.com'),
        _mp('p26', 'eva.m@deenqtt.com'),
        _mp('p27', 'alice.j@deenqtt.com'),
      ],
    ),
  ];
}

TodayDashboard buildDummyToday() {
  final meetings = buildDummyMeetings();
  final todayKey = _dateKey(DateTime.now());
  final todayMeetings =
      meetings.where((m) => _dateKey(m.date) == todayKey).toList();
  final upcomingToday = todayMeetings.where((m) => m.isUpcoming).toList();
  return TodayDashboard(
    total: todayMeetings.length,
    meetings: todayMeetings,
    nextMeeting: upcomingToday.isEmpty ? null : upcomingToday.first,
  );
}

String _dateKey(DateTime d) =>
    '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
