import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../core/theme.dart';
import '../../services/meeting_service.dart';

enum _DateOpt { today, tomorrow, nextMonday }

class QuickAddScreen extends StatefulWidget {
  const QuickAddScreen({super.key});

  @override
  State<QuickAddScreen> createState() => _QuickAddScreenState();
}

class _QuickAddScreenState extends State<QuickAddScreen> {
  final _titleCtrl = TextEditingController();
  _DateOpt _dateOpt = _DateOpt.today;
  TimeOfDay _time = const TimeOfDay(hour: 10, minute: 30);
  int _duration = 30;
  bool _recurring = false;
  bool _loading = false;
  String? _error;

  DateTime get _resolvedDate {
    final now = DateTime.now();
    switch (_dateOpt) {
      case _DateOpt.today:    return now;
      case _DateOpt.tomorrow: return now.add(const Duration(days: 1));
      case _DateOpt.nextMonday:
        int daysUntil = DateTime.monday - now.weekday;
        if (daysUntil <= 0) daysUntil += 7;
        return now.add(Duration(days: daysUntil));
    }
  }

  String get _dateLabel {
    switch (_dateOpt) {
      case _DateOpt.today:    return 'Today';
      case _DateOpt.tomorrow: return 'Tomorrow';
      case _DateOpt.nextMonday: return 'Next Mon';
    }
  }

  String _addMins(TimeOfDay t, int mins) {
    final total = t.hour * 60 + t.minute + mins;
    final h = (total ~/ 60) % 24;
    final m = total % 60;
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
  }

  String _fmtTime(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  String get _timeLabel {
    final h = _time.hour;
    final m = _time.minute.toString().padLeft(2, '0');
    final period = h >= 12 ? 'PM' : 'AM';
    final hour = h % 12 == 0 ? 12 : h % 12;
    return '$hour:$m $period';
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _time,
      builder: (_, child) => Theme(
        data: ThemeData.dark().copyWith(colorScheme: const ColorScheme.dark(primary: AppColors.blue)),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _time = picked);
  }

  Future<void> _create() async {
    if (_titleCtrl.text.trim().isEmpty) {
      setState(() => _error = 'Please describe the meeting');
      return;
    }
    setState(() { _loading = true; _error = null; });
    try {
      await MeetingService.create(
        title: _titleCtrl.text.trim(),
        type: 'VIRTUAL',
        date: DateFormat('yyyy-MM-dd').format(_resolvedDate),
        startTime: _fmtTime(_time),
        endTime: _addMins(_time, _duration),
        isRecurring: _recurring,
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
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white70),
          onPressed: () => context.pop(),
        ),
        title: const Text('Quick Add Meeting'),
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
            _label('MEETING DETAILS'),
            const SizedBox(height: 8),
            TextField(
              controller: _titleCtrl,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: const InputDecoration(hintText: "What's the meeting about?"),
            ),
            const SizedBox(height: 20),

            // Date
            _label('DATE'),
            const SizedBox(height: 8),
            Row(
              children: _DateOpt.values.map((opt) {
                final active = _dateOpt == opt;
                final labels = ['Today', 'Tomorrow', 'Next Mon'];
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: opt != _DateOpt.nextMonday ? 8 : 0),
                    child: GestureDetector(
                      onTap: () => setState(() => _dateOpt = opt),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: active ? AppColors.blue : AppColors.card,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: active ? AppColors.blue : AppColors.border,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          labels[opt.index],
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: active ? Colors.white : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Time + Duration
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label('TIME'),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: _pickTime,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: AppColors.card,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            children: [
                              Text(_timeLabel, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                              const Spacer(),
                              const Icon(Icons.access_time, size: 16, color: AppColors.blueLight),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label('DURATION'),
                    const SizedBox(height: 8),
                    Row(
                      children: [30, 60].map((d) {
                        final active = _duration == d;
                        return Padding(
                          padding: EdgeInsets.only(right: d == 30 ? 8 : 0),
                          child: GestureDetector(
                            onTap: () => setState(() => _duration = d),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                              decoration: BoxDecoration(
                                color: active ? const Color(0xFF2A3A5C) : AppColors.card,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: active ? AppColors.blue.withValues(alpha: 0.5) : AppColors.border,
                                ),
                              ),
                              child: Text(
                                d == 30 ? '30m' : '1h',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: active ? Colors.white : AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Participants
            _label('INVITE PARTICIPANTS'),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: const TextField(
                style: TextStyle(color: Colors.white, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Search name or email...',
                  prefixIcon: Icon(Icons.search, color: AppColors.textSecondary, size: 18),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Recurring toggle
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  const Icon(Icons.refresh, color: AppColors.textSecondary, size: 18),
                  const SizedBox(width: 12),
                  const Text('Recurring Meeting', style: TextStyle(color: Colors.white, fontSize: 14)),
                  const Spacer(),
                  Switch(
                    value: _recurring,
                    onChanged: (v) => setState(() => _recurring = v),
                    activeThumbColor: AppColors.blue,
                    trackColor: WidgetStateProperty.resolveWith(
                      (s) => s.contains(WidgetState.selected) ? AppColors.blue : AppColors.border,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Summary
            Text(
              'Scheduled for $_dateLabel at $_timeLabel for ${_duration == 30 ? '30m' : '1h'}.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),

            if (_error != null) ...[
              const SizedBox(height: 10),
              Text(_error!, style: const TextStyle(color: AppColors.red, fontSize: 13), textAlign: TextAlign.center),
            ],
            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: _loading ? null : _create,
              icon: const Icon(Icons.add_circle_outline, size: 18),
              label: Text(_loading ? 'Creating...' : 'Create Meeting'),
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
}
