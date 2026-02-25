import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../core/theme.dart';
import '../../data/dummy.dart';
import '../../services/meeting_service.dart';
import '../../widgets/participant_picker.dart';

class CreateMeetingScreen extends StatefulWidget {
  const CreateMeetingScreen({super.key});

  @override
  State<CreateMeetingScreen> createState() => _CreateMeetingScreenState();
}

class _CreateMeetingScreenState extends State<CreateMeetingScreen> {
  final _titleCtrl = TextEditingController();
  final _linkCtrl  = TextEditingController();
  final _locCtrl   = TextEditingController();
  final _agendaCtrl = TextEditingController();

  String _type = 'VIRTUAL';
  DateTime _date = DateTime.now();
  TimeOfDay _startTime = const TimeOfDay(hour: 10, minute: 0);
  TimeOfDay _endTime   = const TimeOfDay(hour: 11, minute: 0);
  List<DummyContact> _participants = [];
  bool _loading = false;
  String? _error;

  String _fmt(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (_, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(primary: AppColors.blue),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickTime(bool isStart) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isStart ? _startTime : _endTime,
      builder: (_, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(primary: AppColors.blue),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => isStart ? _startTime = picked : _endTime = picked);
  }

  Future<void> _submit() async {
    if (_titleCtrl.text.trim().isEmpty) {
      setState(() => _error = 'Meeting title is required');
      return;
    }
    setState(() { _loading = true; _error = null; });
    try {
      await MeetingService.create(
        title: _titleCtrl.text.trim(),
        type: _type,
        date: DateFormat('yyyy-MM-dd').format(_date),
        startTime: _fmt(_startTime),
        endTime: _fmt(_endTime),
        meetingLink: _type == 'VIRTUAL' ? _linkCtrl.text.trim() : null,
        location: _type == 'PHYSICAL' ? _locCtrl.text.trim() : null,
        agenda: _agendaCtrl.text.trim().isEmpty ? null : _agendaCtrl.text.trim(),
        participantIds: _participants.map((c) => c.id.toString()).toList(),
      );
      if (mounted) context.go('/');
    } catch (e) {
      setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: TextButton(
          onPressed: () => context.pop(),
          child: const Text('Cancel', style: TextStyle(color: AppColors.blueLight, fontWeight: FontWeight.w600)),
        ),
        leadingWidth: 80,
        title: const Text('Create New Meeting'),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.border),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _label('MEETING TITLE'),
            const SizedBox(height: 8),
            _inputField(controller: _titleCtrl, hint: 'e.g., Weekly Sync'),
            const SizedBox(height: 16),

            // Type toggle
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: ['VIRTUAL', 'PHYSICAL'].map((t) {
                  final active = _type == t;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _type = t),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: active ? const Color(0xFF2A3A5C) : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              t == 'VIRTUAL' ? Icons.videocam_outlined : Icons.location_on_outlined,
                              size: 16,
                              color: active ? Colors.white : AppColors.textSecondary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              t == 'VIRTUAL' ? 'Virtual' : 'Physical',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                                color: active ? Colors.white : AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 12),

            // Link or Location
            _type == 'VIRTUAL'
                ? _iconField(controller: _linkCtrl, hint: 'Add Video Call Link', icon: Icons.link)
                : _iconField(controller: _locCtrl, hint: 'Location / Room', icon: Icons.location_on_outlined),
            const SizedBox(height: 12),

            // Date
            _tappableField(
              onTap: _pickDate,
              child: Row(
                children: [
                  const Icon(Icons.calendar_today_outlined, size: 16, color: AppColors.blueLight),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('DATE', style: TextStyle(fontSize: 10, color: AppColors.textSecondary, fontWeight: FontWeight.w700)),
                      Text(
                        DateFormat('EEE, MMM d, yyyy').format(_date),
                        style: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Icon(Icons.chevron_right, color: AppColors.textSecondary, size: 18),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Start / End time
            Row(
              children: [
                Expanded(
                  child: _tappableField(
                    onTap: () => _pickTime(true),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: const [
                          Icon(Icons.access_time, size: 14, color: AppColors.blueLight),
                          SizedBox(width: 6),
                          Text('START', style: TextStyle(fontSize: 10, color: AppColors.textSecondary, fontWeight: FontWeight.w700)),
                        ]),
                        const SizedBox(height: 2),
                        Text(_startTime.format(context),
                            style: const TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _tappableField(
                    onTap: () => _pickTime(false),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: const [
                          Icon(Icons.access_time_filled, size: 14, color: AppColors.blueLight),
                          SizedBox(width: 6),
                          Text('END', style: TextStyle(fontSize: 10, color: AppColors.textSecondary, fontWeight: FontWeight.w700)),
                        ]),
                        const SizedBox(height: 2),
                        Text(_endTime.format(context),
                            style: const TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Participants
            Row(
              children: [
                _label('PARTICIPANTS'),
                if (_participants.isNotEmpty) ...[
                  const SizedBox(width: 8),
                  Text(
                    '(${_participants.length} selected)',
                    style: const TextStyle(fontSize: 11, color: AppColors.blueLight, fontWeight: FontWeight.w600),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 8),
            ParticipantPicker(
              selected: _participants,
              onChanged: (list) => setState(() => _participants = list),
            ),
            const SizedBox(height: 16),

            // Agenda
            _label('AGENDA & NOTES'),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    child: Row(
                      children: [Icons.format_bold, Icons.format_italic, Icons.format_list_bulleted, Icons.attach_file].map((ic) =>
                        Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: Icon(ic, size: 18, color: AppColors.textSecondary),
                        ),
                      ).toList(),
                    ),
                  ),
                  const Divider(color: AppColors.border, height: 1),
                  TextField(
                    controller: _agendaCtrl,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    maxLines: 5,
                    decoration: const InputDecoration(
                      hintText: 'What is this meeting about?',
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: EdgeInsets.all(16),
                    ),
                  ),
                ],
              ),
            ),

            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(_error!, style: const TextStyle(color: AppColors.red, fontSize: 13), textAlign: TextAlign.center),
            ],
            const SizedBox(height: 24),

            ElevatedButton.icon(
              onPressed: _loading ? null : _submit,
              icon: const Icon(Icons.calendar_today_outlined, size: 18),
              label: Text(_loading ? 'Scheduling...' : 'Schedule Meeting'),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Text(
    text,
    style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w700, letterSpacing: 0.6),
  );

  Widget _inputField({TextEditingController? controller, required String hint, int maxLines = 1}) =>
      TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        maxLines: maxLines,
        decoration: InputDecoration(hintText: hint),
      );

  Widget _iconField({required TextEditingController controller, required String hint, required IconData icon}) =>
      Container(
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: AppColors.textSecondary, size: 18),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
        ),
      );

  Widget _tappableField({required VoidCallback onTap, required Widget child}) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: child,
        ),
      );
}
