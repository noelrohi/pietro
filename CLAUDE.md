# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build Commands

Build, run, and test using Xcode:
```bash
# Build the project
xcodebuild -project pietro.xcodeproj -scheme pietro -configuration Debug build

# Run unit tests
xcodebuild -project pietro.xcodeproj -scheme pietro -configuration Debug test -destination 'platform=iOS Simulator,name=iPhone 16'

# Run UI tests
xcodebuild -project pietro.xcodeproj -scheme pietroUITests -configuration Debug test -destination 'platform=iOS Simulator,name=iPhone 16'
```

## Architecture

Pietro is an iOS workout tracking app built with SwiftUI and SwiftData.

### Data Layer (`Models/`)
- **SwiftData models**: `Workout`, `Exercise`, `CompletedWorkout` with relationships (Workout has many Exercises via cascade delete rule)
- **WorkoutCategory enum**: Push/Pull/Core categories with associated icons and colors
- **UserStats struct**: Computed helper for streak calculations, weekly progress, and statistics

### Theming (`Theme/`)
- **ColorTheme**: Dark theme with hex color definitions accessed via `Color.theme`
- **LinearGradient extensions**: Pre-defined gradients (`heroGradient`, `cardGradient`, `categoryGradient`)
- **CardStyle ViewModifier**: Apply consistent card styling with `.cardStyle()`
- **Custom fonts**: Space Grotesk font family

### App Structure
- **pietroApp.swift**: Entry point with SwiftData ModelContainer configuration
- **ContentView.swift**: Main navigation using NavigationSplitView (currently scaffolded with Item model)
- **Components/**: Reusable UI components (empty, ready for new components)
- **Views/**: Screen-level views (empty, ready for new views)

### Key Patterns
- SwiftData `@Model` classes store raw strings for enums (e.g., `categoryRaw`) with computed properties for type-safe access
- Color hex values defined in Theme.swift with `Color(hex:)` initializer
- Category-specific styling retrieved via `WorkoutCategory` extensions
