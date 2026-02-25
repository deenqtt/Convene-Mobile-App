import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme.dart';
import '../../data/dummy.dart';

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

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});
  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  String _search = '';
  int? _selectedId;

  List<DummyContact> get _filtered {
    final q = _search.trim().toLowerCase();
    if (q.isEmpty) return dummyContacts;
    return dummyContacts.where((c) =>
        (c.name.toLowerCase().contains(q)) ||
        (c.email?.toLowerCase().contains(q) ?? false) ||
        (c.departmentName?.toLowerCase().contains(q) ?? false) ||
        (c.authorizationLevel?.toLowerCase().contains(q) ?? false)).toList();
  }

  Map<String, List<DummyContact>> get _grouped {
    final map = <String, List<DummyContact>>{};
    for (final c in dummyContacts) {
      (map[c.departmentName ?? 'Other'] ??= []).add(c);
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    final isSearching = _search.trim().isNotEmpty;
    final filtered = _filtered;
    final grouped = _grouped;
    final departments = grouped.keys.toList()..sort();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Contacts'),
            Text(
              '${dummyContacts.length} people',
              style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: TextField(
                onChanged: (v) => setState(() {
                  _search = v;
                  _selectedId = null;
                }),
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Search by name, email, or department...',
                  prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary, size: 20),
                  suffixIcon: _search.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close, color: AppColors.textSecondary, size: 18),
                          onPressed: () => setState(() { _search = ''; _selectedId = null; }),
                        )
                      : null,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
            ),
          ),

          Expanded(
            child: isSearching
                // ── Flat search results ──
                ? filtered.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.people_outline, size: 48, color: AppColors.textMuted),
                            const SizedBox(height: 12),
                            Text(
                              'No contacts found for "$_search"',
                              style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        padding: EdgeInsets.fromLTRB(16, 4, 16,
                            navBarBottom(MediaQuery.of(context).padding.bottom)),
                        itemCount: filtered.length + 1,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (_, i) {
                          if (i == 0) {
                            return Padding(
                              padding: const EdgeInsets.only(left: 4, bottom: 4),
                              child: Text(
                                '${filtered.length} RESULT${filtered.length > 1 ? 'S' : ''}',
                                style: const TextStyle(
                                  fontSize: 11, color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w700, letterSpacing: 0.5,
                                ),
                              ),
                            );
                          }
                          return _ContactCard(
                            contact: filtered[i - 1],
                            isSelected: _selectedId == filtered[i - 1].id,
                            onTap: () => setState(() =>
                                _selectedId = _selectedId == filtered[i - 1].id
                                    ? null
                                    : filtered[i - 1].id),
                            onSchedule: () => context.push('/meetings/new'),
                          );
                        },
                      )

                // ── Grouped by department ──
                : ListView.builder(
                    padding: EdgeInsets.fromLTRB(16, 4, 16,
                        navBarBottom(MediaQuery.of(context).padding.bottom)),
                    itemCount: departments.length,
                    itemBuilder: (_, di) {
                      final dept = departments[di];
                      final contacts = grouped[dept]!
                        ..sort((a, b) => a.name.compareTo(b.name));
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Department header
                            Padding(
                              padding: const EdgeInsets.only(left: 4, bottom: 8),
                              child: Row(
                                children: [
                                  const Icon(Icons.business_outlined,
                                      size: 13, color: AppColors.textSecondary),
                                  const SizedBox(width: 6),
                                  Text(
                                    dept.toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 11, color: AppColors.textSecondary,
                                      fontWeight: FontWeight.w700, letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '(${contacts.length})',
                                    style: const TextStyle(
                                      fontSize: 11, color: AppColors.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Contacts in this dept
                            ...contacts.asMap().entries.map((e) => Padding(
                                  padding: EdgeInsets.only(
                                      bottom: e.key < contacts.length - 1 ? 8 : 0),
                                  child: _ContactCard(
                                    contact: e.value,
                                    isSelected: _selectedId == e.value.id,
                                    onTap: () => setState(() =>
                                        _selectedId = _selectedId == e.value.id
                                            ? null
                                            : e.value.id),
                                    onSchedule: () => context.push('/meetings/new'),
                                  ),
                                )),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  final DummyContact contact;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onSchedule;

  const _ContactCard({
    required this.contact,
    required this.isSelected,
    required this.onTap,
    required this.onSchedule,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected
                ? AppColors.blue.withValues(alpha: 0.5)
                : AppColors.border,
          ),
        ),
        child: Column(
          children: [
            // ── Main row ──
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: _colorFor(contact.name),
                  child: Text(
                    _initials(contact.name),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
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
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        contact.departmentName ?? '',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                if (contact.authorizationLevel != null)
                  Text(
                    contact.authorizationLevel!,
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 11,
                    ),
                  ),
              ],
            ),

            // ── Expanded detail ──
            if (isSelected) ...[
              const SizedBox(height: 12),
              Divider(color: AppColors.border, height: 1),
              const SizedBox(height: 12),
              if (contact.email != null)
                _detailRow(Icons.mail_outline, contact.email!),
              if (contact.phoneHr != null) ...[
                const SizedBox(height: 6),
                _detailRow(Icons.phone_outlined, contact.phoneHr!),
              ],
              const SizedBox(height: 6),
              _detailRow(Icons.business_outlined, contact.departmentName ?? ''),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: onSchedule,
                  icon: const Icon(Icons.calendar_today_outlined, size: 14),
                  label: const Text('Schedule Meeting'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.blueLight,
                    side: BorderSide(
                        color: AppColors.blue.withValues(alpha: 0.4)),
                    backgroundColor: AppColors.blue.withValues(alpha: 0.08),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String text) => Row(
        children: [
          Icon(icon, size: 14, color: AppColors.textSecondary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );
}
