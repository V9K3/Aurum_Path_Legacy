# Aurum Path Legacy - Project Context & Documentation

## Project Overview
**Aurum Path Legacy** is a Flutter-based financial literacy game app that simulates building a business empire from seed capital. The app focuses on teaching business and economics concepts through interactive gameplay.

## Project Structure

### Core Files
- `lib/main.dart` - Main app entry point with routing and CustomButton widget
- `lib/pages/loading_page.dart` - Initial loading screen with progress animation
- `lib/pages/main_menu_page.dart` - Main menu with game options
- `lib/pages/game_page.dart` - Game interface (placeholder)
- `lib/pages/settings_page.dart` - User settings and character customization
- `lib/services/audio_service.dart` - Background music management
- `lib/services/database_service.dart` - SQLite database management
- `lib/services/user_service.dart` - User session and settings management
- `pubspec.yaml` - Dependencies and asset configuration

### Assets
- `assets/images/backgrounds/MainBG.png` - Main background image
- `assets/images/backgrounds/Login_BG.png` - Alternative background image
- `assets/images/icons/currency.png` - Currency icon for branding
- `assets/music/background/Main_Pg.mp3` - Background music

## Key Features Implemented

### 1. Loading Page (`loading_page.dart`)
- **Background Music**: Continuous playback with web autoplay compliance
- **Progress Animation**: Simulated loading with percentage and step descriptions
- **Responsive Design**: 
  - Mobile (< 600px): Full screen background image
  - Desktop/Tablet (≥ 600px): Fixed 600px width container with pink background fill (#F1F5D8)
- **Branding**: "Aurum Path: Legacy" title with currency icon
- **Color Scheme**: Gold (#FFD700) text, dark purple (#332D56) accents
- **Animations**: Fade and scale transitions

### 2. Main Menu Page (`main_menu_page.dart`)
- **Background Music**: Continuous playback from loading page
- **Responsive Design**: Same mobile/desktop pattern as loading page
- **Menu Options**:
  - New Game (functional - navigates to game page)
  - Load Game (placeholder - shows "coming soon" message)
  - Tutorial (placeholder - shows "coming soon" message)
  - Settings (placeholder - shows "coming soon" message)
- **Branding**: "Aurum Path" header with "Legacy" subtitle
- **Footer**: Copyright information

### 3. Game Page (`game_page.dart`)
- **Placeholder Implementation**: Basic structure with header and content area
- **Navigation**: Back button to return to main menu
- **Responsive Design**: Mobile-optimized layout

### 4. Audio Service (`audio_service.dart`)
- **Singleton Pattern**: Global audio management
- **Background Music**: Continuous playback across pages
- **Web Compliance**: User interaction detection for autoplay policies
- **Error Handling**: Graceful fallbacks for audio failures

### 5. Custom Button Widget (`main.dart`)
- **Teal Color Scheme**: rgb(0,128,128) with black bold text
- **Shine Effect**: Bright cyan (rgb(51,255,255)) on click
- **Shadow Effects**: Drop shadows for depth
- **Responsive Sizing**: Mobile-optimized touch targets

### 6. Database System (`database_service.dart`, `user_service.dart`)
- **SQLite Database**: Local data persistence with 4 tables
- **User Management**: Account creation and session handling
- **Settings Storage**: JSON-based user preferences
- **Game Saves**: Manual and auto-save functionality
- **Statistics Tracking**: Player performance metrics

### 7. Settings Page (`settings_page.dart`)
- **Character Customization**: Name input and avatar selection
- **Volume Controls**: Sound and music volume sliders (0-100%)
- **Game Settings**: Toggles for sound effects and auto-save
- **Save File Management**: View and delete game saves
- **Database Actions**: Refresh data and clear all data options
- **8 Avatar Types**: Maverick, Disruptor, Trailblazer, Pioneer, Planner, Hustler, Innovator, Strategist

## Technical Implementation Details

### Responsive Design Strategy
```dart
final isMobile = screenSize.width < 600;
final isSmallMobile = screenSize.width < 400;
```

**Mobile (< 600px)**:
- Full screen background image
- Responsive font sizes and spacing
- Touch-friendly button sizes

**Desktop/Tablet (≥ 600px)**:
- Fixed 600px width container centered on screen
- Background image contained within container
- Pink background (#F1F5D8) filling remaining space
- Fixed desktop sizing for consistency

### Color Palette
- **Primary Gold**: #FFD700 (Aurum Path branding)
- **Background Pink**: #F1F5D8 (Desktop background fill)
- **Dark Purple**: #332D56 (Accent color for shadows and containers)
- **Teal**: rgb(0,128,128) (Button color)
- **Bright Cyan**: rgb(51,255,255) (Button click effect)

### Animation System
- **Fade Transitions**: Smooth opacity animations
- **Scale Transitions**: Elastic bounce effects
- **Slide Transitions**: Vertical slide animations
- **Progress Animations**: Loading bar with percentage updates

### Audio Implementation
- **audioplayers** package for cross-platform audio
- **User Interaction Detection**: GestureDetector wrappers for web compliance
- **Continuous Playback**: Music continues across page transitions
- **Error Handling**: Graceful degradation when audio fails

## Recent Changes & Fixes

### Syntax Error Resolution
- **Loading Page**: Fixed unmatched parentheses in widget tree
- **Main Menu Page**: Fixed missing semicolons and bracket mismatches
- **Widget Structure**: Properly closed all GestureDetector, Scaffold, and Container widgets

### Background Image Updates
- **Loading Page**: Updated to use MainBG.png and match main menu layout
- **Responsive Behavior**: Consistent mobile/desktop handling across pages
- **Color Fill**: Pink background for desktop remaining space

### Branding Updates
- **Title Changes**: "Aurum Path: Legacy" on loading page
- **Color Consistency**: Updated text colors to gold (#FFD700)
- **Shadow Effects**: Dark purple (#332D56) shadows for depth

## Dependencies (pubspec.yaml)
```yaml
dependencies:
  flutter:
    sdk: flutter
  audioplayers: ^5.2.1  # Background music support
  sqflite: ^2.3.0       # SQLite database
  sqflite_common_ffi: ^2.3.2  # SQLite for desktop platforms
  path: ^1.8.3          # File path utilities
```

## Asset Configuration
```yaml
flutter:
  assets:
    - assets/images/backgrounds/
    - assets/images/icons/
    - assets/music/background/
```

## Development Notes

### Compilation Issues Resolved
1. **Bracket Matching**: Fixed unmatched parentheses in widget trees
2. **Widget Closure**: Ensured proper closing of all widgets
3. **Syntax Errors**: Resolved missing semicolons and syntax issues

### Web Compatibility
- **Audio Autoplay**: Implemented user interaction detection
- **Responsive Design**: Mobile-first approach with desktop optimization
- **Asset Loading**: Proper asset paths and error handling

### Performance Considerations
- **Animation Controllers**: Proper disposal in dispose() methods
- **Memory Management**: Efficient widget tree structure
- **Asset Optimization**: Appropriate image sizes and formats

## Future Development Areas

### Game Implementation
- **Core Gameplay**: Business simulation mechanics
- **Save System**: Game state persistence
- **Tutorial System**: Interactive learning modules
- **Settings**: User preferences and configuration

### UI/UX Enhancements
- **Animations**: More sophisticated transition effects
- **Accessibility**: Screen reader support and keyboard navigation
- **Localization**: Multi-language support
- **Theme System**: Dark/light mode support

### Technical Improvements
- **State Management**: Consider Provider/Riverpod for complex state
- **Testing**: Unit and widget tests
- **Performance**: Asset optimization and lazy loading
- **Analytics**: User behavior tracking

## Project Status
- **Loading Page**: ✅ Complete with animations and responsive design
- **Main Menu**: ✅ Complete with navigation and responsive design
- **Game Page**: 🔄 Basic structure, needs core gameplay implementation
- **Audio System**: ✅ Complete with web compliance
- **Responsive Design**: ✅ Complete across all pages
- **Branding**: ✅ Complete with consistent visual identity

## File Structure Summary
```
lib/
├── main.dart                 # App entry point, CustomButton widget
├── pages/
│   ├── loading_page.dart     # Loading screen with progress
│   ├── main_menu_page.dart   # Main menu with game options
│   └── game_page.dart        # Game interface (placeholder)
└── services/
    └── audio_service.dart    # Background music management

assets/
├── images/
│   ├── backgrounds/
│   │   ├── MainBG.png
│   │   └── Login_BG.png
│   └── icons/
│       └── currency.png
└── music/
    └── background/
        └── Main_Pg.mp3
```

This documentation serves as a comprehensive reference for understanding the current state, architecture, and implementation details of the Aurum Path Legacy Flutter project. 