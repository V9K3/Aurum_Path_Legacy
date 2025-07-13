class AvatarConfig {
  static const List<String> availableAvatars = [
    'Maverick',
    'Disruptor', 
    'Trailblazer',
    'Pioneer',
    'Planner',
    'Hustler',
    'Innovator',
    'Strategist',
    'Visionary',
    'Executor',
    'Analyst',
    'Creator',
    'Leader',
    'Explorer',
    'Builder',
    'Thinker',
  ];

  // Fallback icons for when PNG files don't exist
  static const Map<String, String> fallbackIcons = {
    'Maverick': 'flight_takeoff',
    'Disruptor': 'flash_on',
    'Trailblazer': 'emoji_flags',
    'Pioneer': 'landscape',
    'Planner': 'event_note',
    'Hustler': 'directions_run',
    'Innovator': 'lightbulb',
    'Strategist': 'account_tree',
    'Visionary': 'visibility',
    'Executor': 'play_arrow',
    'Analyst': 'analytics',
    'Creator': 'create',
    'Leader': 'star',
    'Explorer': 'explore',
    'Builder': 'build',
    'Thinker': 'psychology',
  };

  static const int maxAvatarsPerRow = 5;
} 