import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../data/dummy.dart';

const _avatarColors = [
  Color(0xFF3B82F6), Color(0xFF8B5CF6), Color(0xFF22C55E),
  Color(0xFFF97316), Color(0xFFEC4899), Color(0xFF14B8A6),
  Color(0xFFF59E0B), Color(0xFFEC4899),
];

Color _colorFor(String name) {
  final code = name.codeUnits.fold(0, (a, b) => a + b);
  return _avatarColors[code % _avatarColors.length];
}

String _initials(String name) {
  final parts = name.trim().split(RegExp(r'\s+'));
  if (parts.length == 1) return parts[0].substring(0, 1).toUpperCase();
  return (parts.first.substring(0, 1) + parts.last.substring(0, 1)).toUpperCase();
}

class ParticipantPicker extends StatefulWidget {
  final List<DummyContact> selected;
  final ValueChanged<List<DummyContact>> onChanged;

  const ParticipantPicker({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  State<ParticipantPicker> createState() => _ParticipantPickerState();
}

class _ParticipantPickerState extends State<ParticipantPicker> {
  final _ctrl = TextEditingController();
  String _query = '';

  static const _maxVisible = 8;

  List<DummyContact> get _filtered {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return [];
    final selectedIds = widget.selected.map((c) => c.id).toSet();
    return dummyContacts
        .where((c) =>
            !selectedIds.contains(c.id) &&
            (c.name.toLowerCase().contains(q) ||
                (c.email?.toLowerCase().contains(q) ?? false) ||
                (c.departmentName?.toLowerCase().contains(q) ?? false)))
        .take(_maxVisible)
        .toList();
  }

  int get _totalMatches {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return 0;
    final selectedIds = widget.selected.map((c) => c.id).toSet();
    return dummyContacts
        .where((c) =>
            !selectedIds.contains(c.id) &&
            (c.name.toLowerCase().contains(q) ||
                (c.email?.toLowerCase().contains(q) ?? false) ||
                (c.departmentName?.toLowerCase().contains(q) ?? false)))
        .length;
  }

  void _add(DummyContact contact) {
    widget.onChanged([...widget.selected, contact]);
    _ctrl.clear();
    setState(() => _query = '');
  }

  void _remove(int id) {
    widget.onChanged(widget.selected.where((c) => c.id != id).toList());
  }

  void _clearAll() => widget.onChanged([]);

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    final showDropdown = _query.trim().isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Search input ──
        Container(
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: TextField(
            controller: _ctrl,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            onChanged: (v) => setState(() => _query = v),
            decoration: const InputDecoration(
              hintText: 'Search by name, email, or department...',
              prefixIcon: Icon(Icons.search, color: AppColors.textSecondary, size: 18),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
          ),
        ),

        // ── Dropdown results ──
        if (showDropdown) ...[
          const SizedBox(height: 4),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: filtered.isEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: Text(
                      'No users found for "$_query"',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                : Column(
                    children: [
                      ...filtered.asMap().entries.map((e) {
                        final i = e.key;
                        final c = e.value;
                        return Column(
                          children: [
                            if (i > 0)
                              Divider(color: AppColors.border, height: 1, indent: 16),
                            _dropdownItem(c),
                          ],
                        );
                      }),
                      if (_totalMatches > _maxVisible) ...[
                        Divider(color: AppColors.border, height: 1),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            'Showing $_maxVisible of $_totalMatches — type more to narrow down',
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ],
                  ),
          ),
        ],

        // ── Selected participants ──
        if (widget.selected.isNotEmpty) ...[
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 12, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${widget.selected.length} PARTICIPANT${widget.selected.length > 1 ? 'S' : ''} ADDED',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                      GestureDetector(
                        onTap: _clearAll,
                        child: const Text(
                          'Clear all',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.red,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(color: AppColors.border, height: 1),
                // List
                ...widget.selected.asMap().entries.map((e) {
                  final i = e.key;
                  final c = e.value;
                  return Column(
                    children: [
                      if (i > 0)
                        Divider(color: AppColors.border, height: 1, indent: 16),
                      _selectedItem(c),
                    ],
                  );
                }),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _dropdownItem(DummyContact contact) => InkWell(
        onTap: () => _add(contact),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: _colorFor(contact.name),
                child: Text(
                  _initials(contact.name),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contact.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${contact.departmentName ?? ''} · ${contact.email ?? ''}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.person_add_outlined,
                  color: AppColors.blueLight, size: 16),
            ],
          ),
        ),
      );

  Widget _selectedItem(DummyContact contact) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: _colorFor(contact.name),
              child: Text(
                _initials(contact.name),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contact.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    contact.departmentName ?? '',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => _remove(contact.id),
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.red.withValues(alpha: 0.08),
                ),
                child: const Icon(Icons.close,
                    color: AppColors.red, size: 14),
              ),
            ),
          ],
        ),
      );
}
