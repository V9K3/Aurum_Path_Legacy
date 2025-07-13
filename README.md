# Aurum Path Legacy - Financial Empire Game

A Flutter-based financial literacy game that teaches business and economics through interactive gameplay. Players build their financial empire from seed capital to become business tycoons.

## 🎮 Game Overview

**Aurum Path Legacy** is a turn-based financial simulation game where players:
- Start with seed capital and build their business empire
- Make strategic investment decisions
- Learn real-world business and economics concepts
- Progress through different financial scenarios
- Compete to become the ultimate financial tycoon

## 🚀 Features Implemented

### Core Game Structure
- **Loading Page**: Animated loading screen with progress bar and tips
- **Main Menu**: Clean interface with game options
- **Game Page**: Turn-based gameplay interface (placeholder)
- **Responsive Design**: Optimized for both mobile and desktop

### UI/UX Design
- **Modern Design**: Clean, professional interface with golden accents
- **Background Images**: Full-screen background with semi-transparent overlays
- **Custom Buttons**: Teal-colored buttons (#A59D84) with shine effects and press animations
- **Typography**: Consistent font hierarchy with proper shadows and spacing
- **Animations**: Smooth fade and slide transitions between pages

### Branding & Visual Identity
- **Logo**: Currency icon from assets with "Aurum Path" branding
- **Color Scheme**: 
  - Primary: Golden yellow (#FFD700)
  - Buttons: Teal (#A59D84) with 80% opacity
  - Text: White with dark shadows for readability
- **Layout**: Horizontal logo + title layout with "Legacy" on separate line

### Technical Implementation
- **Custom Button Widget**: Reusable component with consistent styling
- **Responsive Breakpoints**: Mobile (<600px) and desktop layouts
- **Asset Management**: Properly configured pubspec.yaml for images
- **Navigation**: Smooth page transitions with fade effects

## 📁 Project Structure

```
Aurum_Path_Legacy/
├── lib/
│   ├── main.dart                 # App entry point + CustomButton widget
│   └── pages/
│       ├── loading_page.dart     # Animated loading screen
│       ├── main_menu_page.dart   # Main menu with game options
│       └── game_page.dart        # Game interface (placeholder)
├── assets/
│   └── images/
│       ├── backgrounds/
│       │   └── Login_BG.png      # Main background image
│       └── icons/
│           └── currency.png      # Game logo/icon
├── pubspec.yaml                  # Dependencies and asset configuration
└── .gitignore                   # Comprehensive ignore rules
```

## 🎨 UI Components

### CustomButton Widget
- **Size**: Fixed 250x50 pixels across all screen sizes
- **Colors**: #A59D84 (teal) with 80% opacity
- **Effects**: Shine animation on press, color change to bright cyan
- **Text**: White, bold, 17px font size
- **Icons**: 22px white icons with 10px spacing

### Typography System
- **"Aurum Path"**: 30-40px, bold, golden yellow with dark shadows
- **"Legacy"**: 30-45px, bold, golden yellow with layered shadows
- **Subtitle**: 13-15px, light weight, white with low opacity
- **Buttons**: 17px, bold, white text

### Layout Structure
- **Loading Page**: Centered content with progress bar and tips
- **Main Menu**: 
  - Logo + "Aurum Path" in horizontal row
  - "Legacy" on separate line below
  - Menu buttons with consistent spacing
  - Footer with copyright information
- **Game Page**: Header with branding, placeholder content

## 🔧 Technical Decisions

### State Management
- **Simple StatefulWidget**: Used for page-level state management
- **Animation Controllers**: For smooth transitions and loading animations
- **Local State**: Each page manages its own state independently

### Asset Strategy
- **Background Images**: Single high-quality image for consistency
- **Icons**: Custom currency icon for branding
- **Responsive Assets**: Proper sizing for different screen sizes

### Code Organization
- **Separate Page Files**: Each major screen in its own file
- **Reusable Components**: CustomButton widget for consistency
- **Clean Imports**: Proper import statements with show clauses

## 🎯 Game Features (Planned)

### Current Implementation
- ✅ Loading screen with progress simulation
- ✅ Main menu with game options
- ✅ Basic game page structure
- ✅ Responsive design
- ✅ Custom UI components

### Future Development
- [ ] Turn-based gameplay mechanics
- [ ] Financial simulation engine
- [ ] Save/load game functionality
- [ ] Tutorial system
- [ ] Settings and preferences
- [ ] Multiple game scenarios
- [ ] Achievement system

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (^3.8.1)
- Dart SDK
- IDE (VS Code, Android Studio, etc.)

### Installation
1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Run `flutter run` to start the development server

### Development Commands
```bash
# Install dependencies
flutter pub get

# Run on Chrome
flutter run -d chrome

# Run on mobile device
flutter run

# Build for production
flutter build web
```

## 🎨 Design Decisions

### Color Palette
- **Primary Gold**: #FFD700 (Aurum Path branding)
- **Button Teal**: #A59D84 (80% opacity for subtlety)
- **Text White**: #FFFFFF with dark shadows for readability
- **Background Overlay**: Black with 30% opacity

### Typography Hierarchy
1. **"Legacy"**: Largest, most prominent text
2. **"Aurum Path"**: Secondary branding text
3. **Button Text**: Clear, readable action text
4. **Subtitle**: Supporting information

### Layout Principles
- **Mobile-First**: Responsive design starting with mobile
- **Consistent Spacing**: 12-16px between elements
- **Visual Hierarchy**: Clear information architecture
- **Touch-Friendly**: 250x50px buttons for easy interaction

## 📱 Responsive Design

### Breakpoints
- **Mobile**: < 600px width
- **Desktop/Tablet**: ≥ 600px width
- **Small Mobile**: < 400px width (additional optimizations)

### Adaptive Features
- **Font Sizes**: Scale appropriately for screen size
- **Button Sizes**: Fixed 250x50px across all devices
- **Spacing**: Adjusted margins and padding
- **Layout**: Single column on mobile, optimized for desktop

## 🔒 Git Configuration

### .gitignore Strategy
- **Build Artifacts**: Generated files and build outputs
- **IDE Files**: Editor-specific configurations
- **Environment Files**: Sensitive configuration files
- **Temporary Files**: Cache and temporary data

### Version Control
- **Clean History**: Focused on source code and assets
- **Platform Independence**: No platform-specific generated files
- **Collaboration Ready**: Proper ignore rules for team development

## 🎮 Game Mechanics (Conceptual)

### Core Loop
1. **Start New Game**: Begin with seed capital
2. **Make Decisions**: Invest, trade, or expand business
3. **Progress Turns**: Advance through game timeline
4. **Build Empire**: Accumulate wealth and assets
5. **Achieve Goals**: Complete financial objectives

### Learning Objectives
- **Investment Strategies**: Diversification and risk management
- **Business Operations**: Company management and growth
- **Market Dynamics**: Supply, demand, and competition
- **Financial Literacy**: Understanding money and economics

## 🚀 Future Roadmap

### Phase 1: Core Gameplay
- [ ] Implement turn-based mechanics
- [ ] Add financial simulation engine
- [ ] Create basic investment scenarios

### Phase 2: Enhanced Features
- [ ] Save/load system
- [ ] Tutorial and onboarding
- [ ] Multiple difficulty levels

### Phase 3: Advanced Features
- [ ] Multiplayer capabilities
- [ ] Advanced scenarios
- [ ] Achievement system

## 📝 Development Notes

### Key Decisions Made
1. **Removed Login System**: Simplified to focus on core gameplay
2. **Fixed Button Sizes**: Consistent 250x50px for better UX
3. **Custom Color Scheme**: Teal buttons with golden branding
4. **Responsive Design**: Mobile-first approach with desktop optimization
5. **Asset Management**: Proper Flutter asset configuration

### Technical Challenges Solved
1. **Background Image Display**: Fixed full-screen coverage issues
2. **Button Styling**: Created reusable CustomButton widget
3. **Layout Structure**: Implemented proper responsive design
4. **Asset Loading**: Configured pubspec.yaml for proper asset handling
5. **Git Management**: Comprehensive .gitignore for clean repository

### Performance Considerations
- **Image Optimization**: Single background image for consistency
- **Animation Efficiency**: Proper disposal of animation controllers
- **Responsive Design**: Efficient breakpoint system
- **Asset Loading**: Optimized asset configuration

---

**Aurum Path Legacy** - Learn Business & Economics Through Play

© 2024 Aurum Path - From Seed Capital to Financial Empire
