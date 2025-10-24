# 🏪 AtomePet - Flutter Pet Store Application

A complete pet store management system built with Flutter, featuring both mobile and web support with clean architecture implementation.

## 🌟 Live Demo

**Web App:** [https://nerufuyo.github.io/atomepet/](https://nerufuyo.github.io/atomepet/)

## 📱 Features

### Web App (Backoffice)
- ✅ **Create pets** - Pet form with validation
- ✅ **Update pets** - Edit existing pet information
- ✅ **Delete pets** - Remove pets from inventory
- ✅ **List pets** - Grid view with sorting and filtering
- ✅ **Admin dashboard** - Management interface

### Mobile App
- ✅ **Browse pet listings** - Grid view with filtering and search
- ✅ **Simulate purchase** - Full cart functionality with quantity controls
- ✅ **Category filtering** - Dogs, Cats, Birds, Fish, Other
- ✅ **Search functionality** - Real-time search with debouncing
- ✅ **Pet details** - Detailed view with expandable sections
- ✅ **User authentication** - Login/register with persistent sessions
- ✅ **Profile management** - User data with refresh capability

## 🌐 API Integration

- **Petstore3 Swagger API** - Integrated with https://petstore3.swagger.io
- **CRUD Operations** - Create, Read, Update, Delete pets
- **Error handling** - Graceful error management
- **Offline support** - Local storage fallback

## 🏗️ Clean Architecture

The application follows **Clean Architecture** principles:

```
lib/
├── controllers/          # GetX Controllers (Business Logic)
│   ├── pet_controller.dart
│   ├── cart_controller.dart
│   ├── user_controller.dart
│   └── theme_controller.dart
├── models/              # Data Models
│   ├── pet.dart
│   ├── user.dart
│   ├── cart_item.dart
│   └── category.dart
├── repositories/        # Data Access Layer
│   ├── pet_repository.dart
│   └── user_repository.dart
├── services/           # External Services
│   ├── api_service.dart
│   └── storage_service.dart
├── views/              # UI Layer
│   ├── screens/        # Screen Components
│   └── widgets/        # Reusable Widgets
├── routes/             # Navigation
├── config/            # App Configuration
│   ├── themes/
│   └── translations/
└── bindings/          # Dependency Injection
```

## 🛠️ Tech Stack

- **Framework:** Flutter 3.x
- **State Management:** GetX
- **Storage:** SharedPreferences
- **Network:** HTTP with Dio
- **Caching:** CachedNetworkImage
- **UI:** Material Design 3
- **Icons:** Cupertino Icons, Material Icons
- **Architecture:** Clean Architecture with Repository Pattern

## Getting Started

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Android Studio / VS Code
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/nerufuyo/atomepet.git
   cd atomepet
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the application**
   ```bash
   # Web
   flutter run -d web-server --web-port 8080
   
   # Android
   flutter run -d android
   
   # iOS (macOS only)
   flutter run -d ios
   ```

## 📦 Build & Deploy

### Web Build (GitHub Pages)
```bash
flutter build web --release --base-href "/atomepet/"
cp -r build/web/* docs/
touch docs/.nojekyll
git add docs/
git commit -m "deploy: update web build"
git push origin main
```

### Android Build
```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk (54.7MB)
```

### iOS Build
```bash
flutter build ios --release --no-codesign
# Requires macOS and Xcode
```

## 🔧 Configuration

### API Configuration
The app uses the Petstore3 Swagger API. You can modify the base URL in:
```dart
// lib/services/api_service.dart
static const String baseUrl = 'https://petstore3.swagger.io/api/v3';
```

### Theme Configuration
Light mode theme is configured in:
```dart
// lib/config/themes/app_theme.dart
// Primary color: #6B4EFF (Purple)
```

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 👨‍💻 Author

**nerufuyo**
- GitHub: [@nerufuyo](https://github.com/nerufuyo)

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Petstore3 API for the sample backend
- Material Design for UI guidelines
- GetX package for state management

---

⭐ **Star this repository if you found it helpful!**

---

