# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Flutter-based mobile application called "Diceware" that generates cryptographically secure passphrases using the Diceware method. The app supports multiple platforms (Android, iOS, Web) and offers various output types including words in multiple languages, ASCII characters, alphanumeric strings, and numbers.

## Key Commands

### Development
- `flutter pub get` - Install dependencies
- `flutter run` - Run the app in development mode
- `flutter test` - Run all tests
- `flutter build appbundle` - Build Android App Bundle for release
- `flutter build apk` - Build APK for Android
- `flutter build ios` - Build for iOS
- `flutter build web` - Build for web

### Android-specific (Fastlane)
- `cd android && fastlane test` - Run tests using fastlane
- `cd android && fastlane deploy` - Deploy to Google Play
- `cd android && fastlane internal` - Deploy to internal testing track

### Version Management
- `python increment_version.py` - Increment version number automatically

## Architecture

### Core Components
- **main.dart**: Main application entry point containing the UI and state management
  - `Diceware` - Root MaterialApp widget
  - `StatefulHome` - Main screen with all functionality
  - `ClipButton` - Reusable clipboard copy component
  
- **roll_types.dart**: Contains Roll class hierarchy for different output types
  - `Roll` - Base class for all roll types
  - `WordRoll` - For word-based passphrases
  - `ASCIIRoll` - For ASCII character output
  - `AlphaNumRoll` - For alphanumeric output
  - `NumberRoll` - For numeric output

### Key Features
- Dice-based random number generation (manual entry via UI buttons)
- Local PRNG using Dart's `Random.secure()`
- Remote randomness via Random.org API
- Multiple dictionary support (12 languages)
- Compressed dictionary storage (gzip JSON files in assets/)
- Clipboard integration for easy copying
- Cross-platform support

### Dictionary System
Dictionaries are stored as compressed JSON files in `assets/dictionaries/`:
- `std_english.json.gz` - Standard English wordlist
- `alt_english.json.gz` - Alternative English wordlist
- Language-specific dictionaries (catalan, dutch, german, etc.)
- Specialized character sets (ascii, alphanumeric)

The app loads dictionaries dynamically based on user selection and decompresses them using GZipCodec.

### Testing
- Widget tests in `test/widget_test.dart`
- Tests UI rendering and basic functionality
- One test is commented out due to asset loading issues in test environment

### Build & Deployment
- GitHub Actions workflow for CI/CD (`.github/workflows/main.yml`)
- Automated version increment and Play Store deployment
- Fastlane integration for Android deployment
- Supports both APK and App Bundle builds