# AtomePet

A modern Flutter application for pet adoption and management, built with Material Design 3 and powered by the Petstore API.

## Overview

AtomePet is a cross-platform mobile application that enables users to browse, adopt, and manage pets. The app features a clean, modern UI with authentication, offline-first architecture, and comprehensive pet management capabilities.

## Features

### Authentication
- User registration and login system
- Secure authentication flow
- Protected routes with middleware
- Session persistence

### Pet Management
- Browse available pets with advanced filtering
- View detailed pet information with image galleries
- Search pets by name, status, or category
- Hero animations for smooth transitions
- Offline-first data caching

### Store & Orders
- Place orders for pet adoption
- Track order history and status
- Manage pending and completed orders
- Offline order queueing

### User Profile
- View and edit user information
- Manage account settings
- Logout functionality

### UI/UX
- Material Design 3 theming
- Dark and light mode support
- Smooth page transitions and animations
- Staggered list animations
- Shimmer loading states
- Connectivity status banner

## Technology Stack

### Framework & Language
- Flutter 3.9.2
- Dart 3.9.0

### State Management
- GetX 4.6.6 for reactive state management
- GetX navigation and routing
- Dependency injection with GetX bindings

### API & Networking
- Dio 5.7.0 for HTTP requests
- Petstore3 Swagger API integration
- Pretty Dio Logger for debugging

### Local Storage
- Hive 2.2.3 for NoSQL database
- Flutter Secure Storage for sensitive data
- Offline-first architecture with sync

### UI Components
- Cached Network Image for efficient image loading
- Connectivity Plus for network monitoring
- Custom reusable widgets and animations

### Code Generation
- JSON Serializable for model serialization
- Build Runner for code generation
- Freezed patterns for immutable models

### Testing
- Flutter Test for unit and widget tests
- 47 comprehensive tests with full coverage
- Model and widget testing

## Project Structure

```
lib/
├── bindings/           # Dependency injection bindings
├── config/            # App configuration and themes
├── controllers/       # GetX controllers for state management
├── middlewares/       # Route protection middleware
├── models/            # Data models with JSON serialization
├── repositories/      # Data repositories with caching
├── routes/            # App routing configuration
├── services/          # API and database services
└── views/             # UI screens and widgets
    ├── screens/       # App screens
    └── widgets/       # Reusable components

test/
├── models/            # Model unit tests
└── widgets/           # Widget tests
```

## Getting Started

### Prerequisites
- Flutter SDK 3.9.2 or higher
- Dart SDK 3.9.0 or higher
- iOS Simulator / Android Emulator / Physical Device

### Installation

1. Clone the repository
```bash
git clone https://github.com/nerufuyo/atomepet.git
cd atomepet
```

2. Install dependencies
```bash
flutter pub get
```

3. Generate code
```bash
dart run build_runner build --delete-conflicting-outputs
```

4. Run the app
```bash
flutter run
```

### Testing

Run all tests:
```bash
flutter test
```

Run tests with coverage:
```bash
flutter test --coverage
```

## API Configuration

The app connects to the Petstore3 Swagger API:
```
Base URL: https://petstore3.swagger.io/api/v3
```

API endpoints include:
- `/user` - User authentication and management
- `/pet` - Pet CRUD operations
- `/store/order` - Order management

## App Flow

1. Splash Screen - Shows app branding and checks authentication
2. Authentication - Login or register if not authenticated
3. Home Screen - Main dashboard with navigation tabs
4. Pet List - Browse and filter available pets
5. Pet Detail - View detailed pet information
6. Store - Place orders and manage cart
7. Profile - Manage user account

## Architecture

The app follows Clean Architecture principles with:

- **Presentation Layer**: Views and Controllers
- **Domain Layer**: Models and Use Cases
- **Data Layer**: Repositories and Services

Key patterns:
- Repository pattern for data access
- Service layer for API communication
- Controller pattern for business logic
- Dependency injection for loose coupling

## Offline Capabilities

- Local caching with Hive database
- Offline data access
- Pending changes queue
- Automatic sync when online
- Connectivity monitoring

## Testing Coverage

- 47 unit and widget tests
- Model serialization tests
- Widget interaction tests
- Form validation tests
- Complete test coverage for critical paths

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run tests and ensure they pass
5. Submit a pull request

## License

This project is part of a learning exercise based on the Swagger Petstore API specification.

## Acknowledgments

- Swagger Petstore API for backend services
- Flutter team for the amazing framework
- GetX community for state management solution
