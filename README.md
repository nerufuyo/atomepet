# AtomePet - Pet Store Management System

A full-stack Flutter application for pet store management with web admin dashboard and mobile client, built for Atome Frontend Engineer position.

## Project Overview

AtomePet is a comprehensive pet store management system featuring:
- **Web Admin Dashboard** - Complete backoffice for CRUD operations with responsive design
- **Mobile Application** - Browse pets and simulate purchases with offline support
- **Clean Architecture** - Scalable, maintainable, and testable codebase
- **Production-Ready** - 86+ tests, proper error handling, and optimized performance

**API Integration:** [Petstore3 Swagger API](https://petstore3.swagger.io)

**Repository:** [github.com/nerufuyo/atomepet](https://github.com/nerufuyo/atomepet)

## Requirements Fulfillment

This project fulfills all requirements for the Atome Frontend Engineer position:

### ✅ 1. Web and Mobile App Client with Flutter
- **Web Application:** Responsive admin dashboard optimized for desktop, tablet, and mobile
- **Mobile Application:** Full-featured iOS and Android app
- **API Integration:** Complete integration with https://petstore3.swagger.io

### ✅ 2. Complete CRUD Operations for Pets
- **Create:** Form-based pet creation with validation (web & mobile)
- **Read/Browse:** List view with search, filter, sort, and pagination
- **Update:** Edit existing pets with pre-populated data
- **Delete:** Confirmation dialogs with proper error handling

### ✅ 3. Deployment & Demo
- **Web Deployment:** Can be deployed to GitHub Pages, Netlify, or Firebase Hosting
- **Local Deployment:** Run with `flutter run -d chrome`
- **Demo Video:** Script and checklist provided in documentation

### ✅ 4. Clean Architecture
- **Presentation Layer:** Views, Screens, Widgets
- **Domain Layer:** Models, Controllers, Use Cases
- **Data Layer:** Repositories, Services, Data Sources
- **Patterns:** Repository pattern, Dependency Injection, State Management

### ✅ 5. Source Code Repository
- **GitHub:** [nerufuyo/atomepet](https://github.com/nerufuyo/atomepet)
- **Commits:** Clean, atomic commits following conventional commit format
- **Documentation:** Comprehensive README and inline code documentation

### Key Features

### Web Application (Backoffice)
- **Pet Data Table** with search, filter, sort, and pagination
- **CRUD Operations** - Create, update, delete pets with modal forms
- **Responsive Design** - Adapts to desktop, tablet, and mobile screens
- **Statistics Dashboard** - Real-time pet counts by status
- **Navigation System** - Sidebar for desktop, bottom nav for mobile
- **User Management** - Profile menu with settings and logout

### Mobile Application
- **Pet Browsing** - Grid/list view with status filters
- **Pet Details** - Full pet information with image gallery
- **Purchase Simulation** - Order placement and tracking
- **Search & Filter** - Find pets by name, category, or status
- **Offline Support** - Local caching with automatic sync
- **Authentication** - Secure login/register flow

### User Experience
- **Material Design 3** - Modern UI with dynamic theming
- **Dark/Light Mode** - Automatic theme switching
- **Smooth Animations** - Hero transitions, staggered lists
- **Loading States** - Shimmer effects and skeleton screens
- **Error Handling** - User-friendly error messages
- **Connectivity Banner** - Online/offline status indicator

## Technology Stack

### Core Framework
- **Flutter** 3.9.2 - Cross-platform UI framework
- **Dart** 3.9.0 - Programming language

### Architecture & State Management
- **GetX** 4.6.6 - Reactive state management, routing, and DI
- **Clean Architecture** - Separation of concerns with layered design
- **Repository Pattern** - Data access abstraction
- **Dependency Injection** - Loose coupling with GetX bindings

### Backend Integration
- **Dio** 5.7.0 - HTTP client with interceptors
- **Petstore3 API** - RESTful API integration
- **Pretty Dio Logger** - Request/response debugging
- **JSON Serializable** - Type-safe model serialization

### Data & Storage
- **Hive** 2.2.3 - Fast NoSQL local database
- **Flutter Secure Storage** - Encrypted credential storage
- **Offline-First Architecture** - Local caching with sync

### UI/UX Libraries
- **Material Design 3** - Latest design system
- **Cached Network Image** - Optimized image loading
- **Connectivity Plus** - Network status monitoring
- **Custom Animations** - Hero, staggered, and fade transitions

### Code Quality & Testing
- **Build Runner** - Code generation tool
- **Flutter Test** - Unit and widget testing framework
- **86+ Tests** - Comprehensive test coverage
- **Flutter Lints** - Code quality enforcement

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
- **Flutter SDK:** 3.9.2 or higher
- **Dart SDK:** 3.9.0 or higher
- **Development Tools:** 
  - iOS: Xcode 14+ (macOS only)
  - Android: Android Studio with SDK 21+
  - Web: Chrome browser
- **Git:** For cloning the repository

### Quick Start

#### 1. Clone Repository
```bash
git clone https://github.com/nerufuyo/atomepet.git
cd atomepet
```

#### 2. Install Dependencies
```bash
flutter pub get
```

#### 3. Generate Code (Models)
```bash
dart run build_runner build --delete-conflicting-outputs
```

#### 4. Run Application

**Web (Admin Dashboard):**
```bash
flutter run -d chrome
```

**Mobile (Android):**
```bash
flutter run -d android
```

**Mobile (iOS - macOS only):**
```bash
flutter run -d ios
```

**Auto-select device:**
```bash
flutter run
```

### Running Tests

**All tests:**
```bash
flutter test
```

**With coverage report:**
```bash
flutter test --coverage
```

**Specific test file:**
```bash
flutter test test/models/pet_test.dart
```

### Building for Production

**Web:**
```bash
flutter build web --release
# Output: build/web/
```

**Android APK:**
```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

**iOS (macOS only):**
```bash
flutter build ios --release
```

## Deployment

### Web Deployment Options

#### Option 1: GitHub Pages (Free)
```bash
# Build web
flutter build web --release --base-href /atomepet/

# Deploy using gh-pages
# 1. Install gh-pages: npm install -g gh-pages
# 2. Deploy: gh-pages -d build/web
```

#### Option 2: Netlify (Free)
```bash
# Build web
flutter build web --release

# Deploy:
# 1. Drag and drop build/web/ folder to netlify.com
# OR
# 2. Connect GitHub repo and set build command
```

#### Option 3: Firebase Hosting (Free)
```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login and initialize
firebase login
firebase init hosting

# Build and deploy
flutter build web --release
firebase deploy
```

#### Option 4: Local Deployment
```bash
# Build
flutter build web --release

# Serve with Python
cd build/web && python3 -m http.server 8000

# Access at: http://localhost:8000
```

### Mobile Deployment

**Android:**
- Build APK and share file directly
- Upload to Google Play Store (requires developer account)

**iOS:**
- Build with Xcode
- Upload to App Store (requires Apple Developer account)

## API Configuration

**API Base URL:** `https://petstore3.swagger.io/api/v3`

**Endpoints Used:**
- `POST /user` - User registration
- `GET /user/login` - User authentication
- `GET /user/{username}` - Get user details
- `PUT /user/{username}` - Update user
- `GET /pet/findByStatus` - Browse pets by status
- `GET /pet/{petId}` - Get pet details
- `POST /pet` - Create new pet
- `PUT /pet` - Update existing pet
- `DELETE /pet/{petId}` - Delete pet
- `GET /store/inventory` - Get store inventory
- `POST /store/order` - Place order
- `GET /store/order/{orderId}` - Get order details

**Configuration:** `lib/services/api_service.dart`

## Application Flow

### Web Application (Admin)
1. **Login** → Admin authentication
2. **Dashboard** → Statistics and quick actions
3. **Pet Management** → CRUD operations with data table
4. **Orders** → View and manage orders
5. **Users** → User management

### Mobile Application
1. **Splash Screen** → Check authentication status
2. **Authentication** → Login or register
3. **Home Dashboard** → Navigation hub
4. **Browse Pets** → List with filters and search
5. **Pet Details** → Full information with actions
6. **Store** → View inventory
7. **Orders** → Purchase simulation and history
8. **Profile** → User settings

## Architecture

### Clean Architecture Layers

```
┌─────────────────────────────────────────────┐
│         Presentation Layer                  │
│  ┌─────────────┐      ┌─────────────┐      │
│  │   Views     │◄─────┤ Controllers │      │
│  │  Screens    │      │   (GetX)    │      │
│  │  Widgets    │      └──────┬──────┘      │
│  └─────────────┘             │             │
└──────────────────────────────┼─────────────┘
                               │
┌──────────────────────────────┼─────────────┐
│         Domain Layer          │             │
│  ┌─────────────┐      ┌──────▼──────┐      │
│  │   Models    │      │  Use Cases  │      │
│  │  Entities   │      │  Business   │      │
│  │  Enums      │      │  Logic      │      │
│  └─────────────┘      └──────┬──────┘      │
└──────────────────────────────┼─────────────┘
                               │
┌──────────────────────────────┼─────────────┐
│          Data Layer           │             │
│  ┌─────────────┐      ┌──────▼──────┐      │
│  │Repositories │◄─────┤  Services   │      │
│  │  (Cache)    │      │   API/DB    │      │
│  └─────────────┘      └─────────────┘      │
└─────────────────────────────────────────────┘
```

### Design Patterns

- **Repository Pattern** - Abstraction for data sources
- **Dependency Injection** - GetX bindings for loose coupling
- **State Management** - Reactive programming with GetX
- **Observer Pattern** - Event-driven UI updates
- **Singleton Pattern** - Services and controllers
- **Factory Pattern** - Model creation from JSON

### Key Principles

- **Separation of Concerns** - Each layer has single responsibility
- **Dependency Inversion** - High-level modules don't depend on low-level
- **Single Responsibility** - Each class has one reason to change
- **Open/Closed** - Open for extension, closed for modification
- **DRY (Don't Repeat Yourself)** - Reusable components and functions

## Features Implementation

### Offline-First Architecture
- **Local Database:** Hive for fast NoSQL storage
- **Caching Strategy:** Cache-first with network fallback
- **Sync Queue:** Pending operations when offline
- **Auto-sync:** Automatic synchronization when online
- **Connectivity Monitor:** Real-time network status

### Security
- **Secure Storage:** Encrypted credentials with flutter_secure_storage
- **API Key Management:** Environment-based configuration
- **Input Validation:** Form validation and sanitization
- **Error Handling:** Graceful error recovery

### Performance Optimization
- **Image Caching:** Cached network images with lazy loading
- **Lazy Loading:** Pagination for large lists
- **Code Splitting:** Modular architecture
- **Build Optimization:** Release builds with tree shaking

## Testing Strategy

### Test Coverage: 86+ Tests

**Unit Tests (47 tests):**
- Model serialization/deserialization
- Business logic validation
- Data transformation
- Edge case handling

**Widget Tests (39 tests):**
- Screen rendering
- User interactions
- Form validation
- Navigation flows
- State changes

**Test Categories:**
- ✅ Models: Pet, User, Order, Category, Tag
- ✅ Widgets: Buttons, TextFields, DataTable
- ✅ Screens: Forms, Dashboard, Lists
- ✅ Controllers: State management logic

**Testing Tools:**
- Flutter Test framework
- GetX test utilities
- Mock builders
- Widget testers

## Demo Video Checklist

When recording the demo video, cover these points:

### Web Application (3-4 minutes)
1. **Login/Dashboard** - Show authentication and admin dashboard
2. **Create Pet** - Add a new pet with form validation
3. **Browse Pets** - Show data table with search, filter, sort, pagination
4. **Edit Pet** - Update existing pet information
5. **Delete Pet** - Remove pet with confirmation dialog
6. **Responsive Design** - Resize browser to show tablet/mobile layouts
7. **Statistics** - Show real-time pet count updates

### Mobile Application (2-3 minutes)
1. **Splash & Auth** - App launch and login flow
2. **Browse Pets** - List view with filters and search
3. **Pet Details** - View full pet information
4. **Store** - Show inventory and purchase simulation
5. **Orders** - Display order history
6. **Profile** - User profile management
7. **Offline Mode** - Toggle airplane mode and show caching

### Tips for Demo Video
- Use screen recording software (OBS, QuickTime, etc.)
- Show both web browser and mobile simulator side by side
- Highlight key features with annotations
- Keep video under 5-7 minutes
- Include audio narration explaining features
- Show API calls in network inspector (optional)

## Project Highlights

### Technical Excellence
- **86+ Tests** - Comprehensive test coverage
- **Clean Code** - Following Dart style guide
- **Type Safety** - Strong typing with null safety
- **Documentation** - Inline comments and README
- **Error Handling** - Try-catch with user feedback
- **Performance** - Optimized builds and caching

### User Experience
- **Responsive Design** - Works on all screen sizes
- **Loading States** - Shimmer and skeleton screens
- **Empty States** - Helpful messages and actions
- **Error States** - Clear error messages with retry
- **Animations** - Smooth transitions and feedback
- **Accessibility** - Semantic labels and contrasts

### Best Practices
- **Git Workflow** - Atomic commits with clear messages
- **Code Organization** - Modular and scalable structure
- **Naming Conventions** - Descriptive and consistent
- **Constants** - No magic numbers or strings
- **Separation of Concerns** - Single responsibility
- **Reusability** - DRY principle throughout

## Project Timeline

**Total Development Time:** 3 days

- **Day 1:** API integration, authentication, basic CRUD
- **Day 2:** Web admin dashboard, mobile UI enhancement
- **Day 3:** Testing, documentation, polish

## Contact & Submission

**Developer:** LISTYO ADI PAMUNGKAS

**Submission Emails:**
- irfan.suhada@advancegroup.com
- sasanadi.ruka@advancegroup.com
- isnan.franseda@advancegroup.com

**Deadline:** October 24, 2025 at 3 PM

**Repository:** [github.com/nerufuyo/atomepet](https://github.com/nerufuyo/atomepet)

## Troubleshooting

### Common Issues

**Build fails:**
```bash
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

**Tests fail:**
```bash
flutter test --update-goldens
```

**Web not enabled:**
```bash
flutter config --enable-web
```

**iOS build issues:**
```bash
cd ios && pod install && cd ..
```

**Android build issues:**
```bash
flutter clean
flutter pub get
```

## Acknowledgments

- **Atome** - For the opportunity and challenge
- **Swagger Petstore** - For the comprehensive API
- **Flutter Team** - For the excellent framework
- **GetX Community** - For the powerful state management
- **Open Source** - For the amazing packages and tools

---

**Built for Atome Frontend Engineer Position**
