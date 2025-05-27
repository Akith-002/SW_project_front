# Land Asset Valuation System

A comprehensive Flutter application for the Valuation Department, designed to handle land asset valuation, mapping, and property management operations.

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Architecture](#architecture)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Running the Application](#running-the-application)
- [Project Structure](#project-structure)
- [Dependencies](#dependencies)
- [Internationalization](#internationalization)
- [Development](#development)
- [Build Flavors](#build-flavors)
- [Contributing](#contributing)

## Overview

The Land Asset Valuation System is a sophisticated Flutter application built for government valuation departments. It provides tools for property assessment, land mapping, asset management, and comprehensive reporting functionality.

### Key Capabilities

- **Land Acquisition Management**: Complete workflow for land acquisition processes
- **Mass Rating Operations**: Bulk property rating and assessment tools
- **Rating Assessment**: Individual property valuation and rating
- **Interactive Mapping**: Mapbox-powered mapping with drawing and sketching tools
- **Asset Division**: Advanced tools for dividing properties into multiple assets
- **Evidence Management**: Sales and rental evidence collection and analysis
- **Multi-language Support**: English, Sinhala, and Tamil localization

## Features

### Core Modules

#### 📊 Dashboard

- Real-time statistics and analytics
- Interactive charts and visualizations
- Quick access to all major functions

#### 🗺️ Interactive Mapping

- Mapbox-powered mapping interface
- Polygon drawing and area calculations
- Floor management for multi-story buildings
- GPS coordinate integration
- Asset visualization and selection

#### 📋 Asset Management

- **Land Acquisition (LA)**: Manage land acquisition processes
- **Mass Rating (MR)**: Bulk property rating operations
- **Rating Assessment (RA)**: Individual property assessments
- **Rating Building (RB)**: Building-specific ratings
- **Rating Object (RO)**: Object-specific valuations
- **Land Miscellaneous (LM)**: General land management

#### 📄 Evidence Collection

- Sales evidence documentation
- Rental evidence management
- Building rates database
- Image upload and management

#### 🔧 Advanced Tools

- Asset division functionality
- Condition reporting
- Rating card management
- Signature collection
- Document management

## Architecture

The application follows **Clean Architecture** principles with clear separation of concerns:

```
lib/
├── app/                    # Base application layer
├── application/            # UI Layer (Presentation)
│   ├── pages/             # Screen implementations
│   ├── core/              # Shared UI components
│   └── base_app.dart      # Main application setup
├── data/                   # Data Layer
│   ├── models/            # Data models
│   ├── datasource/        # Data sources (API, local)
│   └── repositories/      # Repository implementations
├── domain/                 # Business Logic Layer
│   ├── entities/          # Domain entities
│   ├── repositories/      # Repository interfaces
│   └── usecases/          # Business use cases
├── flavors/               # Build configurations
└── injection.dart         # Dependency injection setup
```

### State Management

- **BLoC Pattern** for complex state management
- **Riverpod** for dependency injection and state
- **Cubit** for simpler state scenarios

### Key Patterns

- Repository Pattern for data abstraction
- Dependency Injection with GetIt
- Clean Architecture layers
- MVVM with BLoC

## Prerequisites

- **Flutter SDK**: Version 3.2.5 or higher
- **Dart SDK**: Version 3.0+
- **Android Studio** / **VS Code** with Flutter plugins
- **Mapbox Account**: For mapping functionality
- **API Access**: Backend API credentials

### Platform Requirements

- **Android**: API level 21+ (Android 5.0)
- **iOS**: iOS 11.0+

## Installation

1. **Clone the repository**

   ```bash
   git clone <repository-url>
   cd valuation_frontend
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Configure environment variables**

   ```bash
   # Create .env file in project root
   cp .env.example .env
   # Edit .env with your configuration
   ```

4. **Configure Mapbox**

   - Add your Mapbox access token to the environment configuration
   - Follow Mapbox Flutter SDK setup guide

5. **Generate code (if needed)**
   ```bash
   flutter packages pub run build_runner build
   ```

## Running the Application

### Development Environment

```bash
flutter run --flavor dev lib/flavors/main_dev.dart
```

### Available Flavors

- **Development**: `--flavor dev lib/flavors/main_dev.dart`
- **SIT**: `--flavor sit lib/flavors/main_sit.dart`
- **UAT**: `--flavor uat lib/flavors/main_uat.dart`
- **QA**: `--flavor qa lib/flavors/main_qa.dart`
- **Production**: `--flavor prod lib/flavors/main_prod.dart`

### Device Orientation

- **Development**: Landscape mode
- **Production**: Portrait mode

## Project Structure

```
valuation_frontend/
├── android/                # Android-specific configuration
├── ios/                    # iOS-specific configuration
├── lib/                    # Main Dart code
├── assets/
│   ├── images/            # Image assets
│   ├── fonts/             # Custom fonts (Roboto, Poppins)
│   └── locales/           # Translation files
├── test/                   # Unit and widget tests
├── docs/                   # Documentation
├── pubspec.yaml           # Project dependencies
└── README.md              # This file
```

## Dependencies

### Core Dependencies

- **flutter**: Framework
- **flutter_bloc**: State management
- **get_it**: Dependency injection
- **go_router**: Navigation
- **dio**: HTTP client
- **mapbox_maps_flutter**: Mapping functionality

### UI Dependencies

- **google_fonts**: Typography
- **phosphor_flutter**: Icons
- **sizer**: Responsive design
- **fl_chart**: Charts and graphs

### Utility Dependencies

- **shared_preferences**: Local storage
- **flutter_secure_storage**: Secure storage
- **image_picker**: Image selection
- **geolocator**: GPS functionality
- **connectivity_plus**: Network status

### Development Dependencies

- **flutter_test**: Testing framework
- **mockito**: Mocking for tests
- **build_runner**: Code generation
- **bloc_test**: BLoC testing utilities

## Internationalization

The application supports three languages:

- **English (en)**: Primary language
- **Sinhala (si)**: Sinhala localization
- **Tamil (ta)**: Tamil localization

### Adding Translations

1. Update translation files in `locales/` directory
2. Add new keys to `app_strings.dart`
3. Use `AppString.key.localize(context)` in widgets

## Development

### Code Generation

Some features require code generation:

```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### Testing

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/path/to/test_file.dart

# Run tests with coverage
flutter test --coverage
```

### Debugging

- Use Flutter DevTools for debugging
- Check logs with `flutter logs`
- Use breakpoints in your IDE

## Build Flavors

The application supports multiple build flavors for different environments:

| Flavor | Purpose                    | Orientation | API Environment |
| ------ | -------------------------- | ----------- | --------------- |
| dev    | Development                | Landscape   | Development API |
| sit    | System Integration Testing | Portrait    | SIT API         |
| uat    | User Acceptance Testing    | Portrait    | UAT API         |
| qa     | Quality Assurance          | Portrait    | QA API          |
| prod   | Production                 | Portrait    | Production API  |

### Building for Release

```bash
# Android
flutter build apk --flavor prod lib/flavors/main_prod.dart

# iOS
flutter build ios --flavor prod lib/flavors/main_prod.dart
```

## Contributing

### Code Style

- Follow Dart/Flutter style guidelines
- Use meaningful variable and function names
- Add documentation for public APIs
- Write tests for new features

### Git Workflow

1. Create feature branch from main
2. Implement changes with tests
3. Create pull request
4. Code review and approval
5. Merge to main

### Commit Messages

Follow conventional commit format:

```
feat: add asset division functionality
fix: resolve mapping coordinate issues
docs: update README with setup instructions
```

---

**Developed for the Valuation Department**  
Version: 1.0.0+1  
Built with Flutter 💙
