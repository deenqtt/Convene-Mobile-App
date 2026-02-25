import 'package:flutter/material.dart';

const _colors = [
  Color(0xFF3B82F6), Color(0xFF8B5CF6), Color(0xFF22C55E),
  Color(0xFFF97316), Color(0xFFEC4899), Color(0xFF14B8A6),
];

class AvatarWidget extends StatelessWidget {
  final String email;
  final String? avatarUrl;
  final double size;

  const AvatarWidget({
    super.key,
    required this.email,
    this.avatarUrl,
    this.size = 32,
  });

  @override
  Widget build(BuildContext context) {
    if (avatarUrl != null) {
      return CircleAvatar(
        radius: size / 2,
        backgroundImage: NetworkImage(avatarUrl!),
      );
    }
    final colorIdx = email.codeUnitAt(0) % _colors.length;
    final initials = email.substring(0, 2).toUpperCase();
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: _colors[colorIdx],
      child: Text(
        initials,
        style: TextStyle(
          color: Colors.white,
          fontSize: size * 0.35,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
