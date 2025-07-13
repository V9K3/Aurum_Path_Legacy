import 'package:flutter/material.dart';
import '../config/avatar_config.dart';

class AvatarService {
  static Widget getAvatarWidget(String avatarName, {double size = 24, Color? color}) {
    final iconColor = color ?? Colors.white70;
    
    // Try to load PNG file first
    try {
      return Image.asset(
        'assets/images/icons/$avatarName.png',
        width: size,
        height: size,
        color: iconColor,
        errorBuilder: (context, error, stackTrace) {
          // If PNG doesn't exist, use fallback icon
          return Icon(
            _getFallbackIcon(avatarName),
            color: iconColor,
            size: size,
          );
        },
      );
    } catch (e) {
      // If any error occurs, use fallback icon
      return Icon(
        _getFallbackIcon(avatarName),
        color: iconColor,
        size: size,
      );
    }
  }

  static IconData _getFallbackIcon(String avatarName) {
    final fallbackIconName = AvatarConfig.fallbackIcons[avatarName];
    if (fallbackIconName == null) return Icons.person;
    
    // Map string names to IconData
    switch (fallbackIconName) {
      case 'flight_takeoff': return Icons.flight_takeoff;
      case 'flash_on': return Icons.flash_on;
      case 'emoji_flags': return Icons.emoji_flags;
      case 'landscape': return Icons.landscape;
      case 'event_note': return Icons.event_note;
      case 'directions_run': return Icons.directions_run;
      case 'lightbulb': return Icons.lightbulb;
      case 'account_tree': return Icons.account_tree;
      case 'visibility': return Icons.visibility;
      case 'play_arrow': return Icons.play_arrow;
      case 'analytics': return Icons.analytics;
      case 'create': return Icons.create;
      case 'star': return Icons.star;
      case 'explore': return Icons.explore;
      case 'build': return Icons.build;
      case 'psychology': return Icons.psychology;
      default: return Icons.person;
    }
  }
} 